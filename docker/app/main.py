"""process flutter app request and send generated
   questions along with it's answer to user's
   firestore document
"""
import random

# pylint: disable=no-name-in-module
from pydantic import BaseModel
from fastapi import FastAPI, BackgroundTasks

from src.models.question_gen_model import SummarizeModel, QuestionGenModel
from src.firebase_service import FirebaseService
from src.models.ans_gen_model import AnsGenModel
from src.preprocess import split_text


# initialize fireabse client
fs = FirebaseService()

# initialize question and ans models
ans_model = AnsGenModel()
# sum_model = SummarizeModel()
que_model = QuestionGenModel()


def generate_que_n_ans(context):
    """generate question from given context.

    Args:
        context (str): input corpus needed to generate question.

    Returns:
        tuple[list[str], list[str], list[list[str]]]: tuple of lists of all
        generated questions n' answers.
    """
    splitted_text = split_text(context)

    summary = []
    filtered_kw = []
    questions = []
    crct_ans = []
    all_answers = []

    # summarize and find keywords for each splitted text
    for idx, txt in enumerate(splitted_text):
        # summary.append(sum_model.summarize(txt))
        filtered_kw.append(ans_model.filter_keywords(txt, summary[idx]))

    # generate questions and false answers for each keywords
    for idx, kws in enumerate(filtered_kw):
        for kwx in kws:
            results = ans_model.false_answers(kwx)
            if results is not None:
                questions.append(que_model.gen_question(summary[idx], kwx))
                crct_ans.append(kwx)
                random.shuffle(results)
                all_answers.append(results)
    # squeezing the 2d list to 1d for API response ## 2d nested list give error --
    all_answers = sum(all_answers, [])
    return questions, crct_ans, all_answers


def process_request(request):
    """process user request and return generated questions to their firestore database.

    Args:
        request (ModelInput): request from flutter.
    """
    fs.update_generated_status(request, False)
    questions, crct_ans, all_ans = generate_que_n_ans(request.context)
    fs.update_generated_status(request, True)
    fs.send_results_to_fs(request, questions, crct_ans, all_ans)


# FastAPI setup
app = FastAPI()


# body classes for req n' res
# pylint: disable=too-few-public-methods
class ModelInput(BaseModel):
    """general request model structure for flutter incoming req
    """
    context: str
    uid: str
    name: str


# API
# req -> context and ans-s,
# res -> questions
@ app.post('/get-questions')
async def model_inference(request: ModelInput, bg_task: BackgroundTasks):
    """process user request

    Args:
        request (ModelInput): request model
        bg_task (BackgroundTasks): run process_request() on other thread
        and respond to request

    Returns:
        dict: response
    """
    bg_task.add_task(process_request, request)
    return {'context': 'received'}

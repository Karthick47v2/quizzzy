"""Main python file for flask application.

This module handles all API requests.

@Author: Karthick T. Sharma
"""

# pylint: disable=no-name-in-module
from fastapi import FastAPI, BackgroundTasks
from pydantic import BaseModel

from src.inferencehandler import inference_handler
from src.ansgenerator.false_answer_generator import FalseAnswerGenerator
from src.model.abstractive_summarizer import AbstractiveSummarizer
from src.model.question_generator import QuestionGenerator
from src.model.keyword_extractor import KeywordExtractor
from src.service.firebase_service import FirebaseService


# initialize fireabse client
fs = FirebaseService()

# initialize question and ans models
summarizer = AbstractiveSummarizer()
question_gen = QuestionGenerator()
false_ans_gen = FalseAnswerGenerator()
keyword_extractor = KeywordExtractor()

# FastAPI setup
app = FastAPI()


def generate_que_n_ans(context):
    """Generate question from given context.

    Args:
        context (str): input corpus needed to generate question.

    Returns:
        tuple[list[str], list[str], list[list[str]]]: tuple of lists of all
        generated questions n' answers.
    """
    summary, splitted_text = inference_handler.get_all_summary(
        model=summarizer, context=context)
    filtered_kws = keyword_extractor.get_keywords(
        original_list=splitted_text, summarized_list=summary)

    crct_ans, all_answers = false_ans_gen.get_output(filtered_kws=filtered_kws)
    questions = inference_handler.get_all_questions(
        model=question_gen, context=summary, answer=crct_ans)

    return questions, crct_ans, all_answers


def process_request(request):
    """Process user request and return generated questions to their firestore database.

    Args:
        request (ModelInput): request from flutter.
    """
    fs.update_generated_status(request, True)
    questions, crct_ans, all_ans = generate_que_n_ans(request.context)
    fs.update_generated_status(request, False)
    fs.send_results_to_fs(request, questions, crct_ans, all_ans)


# body classes for req n' res
# pylint: disable=too-few-public-methods
class ModelInput(BaseModel):
    """General request model structure for flutter incoming req."""
    context: str
    uid: str
    name: str


# API
# req -> context and ans-s,
# res -> questions
@ app.post('/get-questions')
async def model_inference(request: ModelInput, bg_task: BackgroundTasks):
    """Process user request

    Args:
        request (ModelInput): request model
        bg_task (BackgroundTasks): run process_request() on other thread
        and respond to request

    Returns:
        dict(str: int): response
    """
    bg_task.add_task(process_request, request)
    return {'status': 200}

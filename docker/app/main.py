from fastapi import FastAPI                             # for creating APIs
from pydantic import BaseModel                          # body for POST 

app = FastAPI()

# body classes for req n' res
class ModelInput(BaseModel):
    context: str
    answer: str
class ModelOutput(BaseModel):
    question: str

model_path = './mcq-model/'
pretrained_model_name = 'tttttttttttttttttttt'

################################################

# debug
@app.get('/')
def index():
    return {'message': 'hello'}

# req -> context and ans-s,
# res -> questions    
#@app.post("/get-questions", response_model=ModelOutput)
@app.post('/get-questions')
def model_inference(request: ModelInput):
    context = request.context
    answer = request.answer
    question = "HI"
    # question = get_question(context, answer, model ,tokenizer)
    return ModelOutput(question)

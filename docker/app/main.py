from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

class QuizzzyRequest(BaseModel):
    context: str
    answer: str
class QuizzzyResponse(BaseModel):
    question: str

model_path = './mcq-model/'
pretrained_model_name = 'tttttttttttttttttttt'


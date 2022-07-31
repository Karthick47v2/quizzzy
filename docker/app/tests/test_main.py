"""unit tests for main.py"""


from fastapi.testclient import TestClient
from main import app

client = TestClient(app)


CORPUS = """NLP enables computers to understand natural language as humans do. Whether
    the language is spoken or written, natural language processing uses artificial
    intelligence to take real-world input, process it, and make sense of it in a way
    a computer can understand. Just as humans have different sensors -- such as ears
    to hear and eyes to see -- computers have programs to read and microphones to
    collect audio. And just as humans have a brain to process that input, computers
    have a program to process their respective inputs. At some point in processing,
    the input is converted to code that the computer can understand."""

REQUEST = {
    'context': CORPUS,
    'uid': 'test_id',
    'name': 'test_doc'
}


@app.get('/')
def root():
    """end point to check flask get api"""
    return {"message": "Hello World"}


def test_root():
    """just to check flask and net connections are ok"""
    res = client.get('/')
    assert res.status_code == 200, "Network error"


def test_model_inference():
    """test wheter post req is working"""
    res = client.post('/get-questions', json=REQUEST)
    assert res.status_code == 200

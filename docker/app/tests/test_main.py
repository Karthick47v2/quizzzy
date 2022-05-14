"""unit tests for main.py"""


from fastapi.testclient import TestClient
from main import app

client = TestClient(app)


@app.get('/')
def root():
    return {"message": "Hello World"}


def test_root():
    res = client.get('/')
    assert res.status_code == 200, "Network error"


corpus = "NLP enables computers to understand natural language as humans do. Whether " +\
            "the language is spoken or written, natural language processing uses artificial " +\
            "intelligence to take real-world input, process it, and make sense of it in a way " +\
            "a computer can understand. Just as humans have different sensors -- such as ears " +\
            "to hear and eyes to see -- computers have programs to read and microphones to " +\
            "collect audio. And just as humans have a brain to process that input, computers " +\
            "have a program to process their respective inputs. At some point in processing, " +\
            "the input is converted to code that the computer can understand."

request = {
    'context': corpus,
    'uid': 'test_id',
    'name': 'test_doc'
}


def test_model_inference():
    res = client.post('/get-questions', json=request)
    assert res.status_code == 200
    assert res.json() == {'context': 'received'}

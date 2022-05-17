"""unit tests for ans_gen_model.py"""

import pytest
# import spacy


from src.models import ans_gen_model
from tests.test_main import CORPUS


# pylint: disable=redefined-outer-name
@pytest.fixture(scope='class')
def model():
    """fixture for loading class obj"""
    return ans_gen_model.AnsGenModel()


# @pytest.fixture(scope='function')
# def nlp():
#     """fixture for loading spacy"""
#     return spacy.load('en_core_web_lg')


@pytest.mark.usefixtures('model', 'nlp')
class TestAnsGenModel:
    """class holding test cases for AnsGenModel class"""
    # pylint: disable=no-self-use

    def test_filter_keywords(self, model):
        """check if generated keyword is on both context and summarized text. Because due to word
           sense disambugiation words in summarize text may not be correct for question generation
        """

        summarized = "Natural language processing uses artificial intelligence to take " +\
            "real-world input and make sense of it. NLP enables computers to understand " +\
            "natural language as humans do. Just as humans have different sensors -- such as " +\
            "ears to hear and eyes to see -- computers have programs to read and microphones to " +\
            "collect audio."

        corpus = CORPUS.lower()
        summarized = summarized.lower()
        result = model.filter_keywords(corpus, summarized)

        assert all(kwx in corpus for kwx in result) and all(
            kwx in summarized for kwx in result), "Keyword(s) missing in corpus/summary"

    # @pytest.mark.parametrize('query', [
    #     ('Ice cream'), ('Natural language processing'), ('RAM')
    # ])
    # def test_false_answers(self, query, model, nlp):
    #     """check if generated answers are diverse and still on same context"""
    #     results = model.false_answers(query)

    #     for result in results:
    #         if result != query:
    #             val = (nlp(
    #                 query).similarity(nlp(result)))
    #             assert 0.2 < val < 0.8, "Similairty error"

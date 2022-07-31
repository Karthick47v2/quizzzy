"""unit tests for ans_gen_model.py"""

import pytest

from src.model.keyword_extractor import KeywordExtractor
from ..test_main import CORPUS


# pylint: disable=redefined-outer-name
@pytest.fixture(scope='class')
def model():
    """fixture for loading class obj"""
    return KeywordExtractor()


# pylint: disable=too-few-public-methods
@pytest.mark.usefixtures('model')
class TestAnsGenModel:
    """class holding test cases for AnsGenModel class"""

    def test_filter_keywords(self, model):
        """check if generated keyword is on both context and summarized text. Because due to word
           sense disambugiation words in summarize text may not be correct for question generation
        """

        summarized = """Manufacturing processes are the steps through which raw materials are
        transformed into a final product. The manufacturing process begins with the use of the
        materials and then modified through manufacturing processes to become the required part.
        The process involves use of machinery, tools, power and labour. During the process, it
        adds greater valve to the final product. Therefore, manufacturing is a value added
        process."""

        corpus = CORPUS.lower()
        summarized = summarized.lower()
        result = model.filter_keywords(corpus, summarized)

        assert all(kwx in corpus for kwx in result) and all(
            kwx in summarized for kwx in result), "Keyword(s) missing in corpus/summary"

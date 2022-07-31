"""unit tests for postprocess.py"""

import pytest
from src.textprocessor import postprocess


class TestPostProcessQuestion:
    """class holding test cases for postprocess_question function"""

    @pytest.mark.parametrize('text, result', [
        ("  What is your name ?     ", "What is your name ?")
    ])
    def test_whitespace(self, text, result):
        """test whether trailing and leading spaces got covered

        Args:
            text (str): test input
            result (str): test result
        """
        assert postprocess.postprocess_question(
            text) == result, "Check whitespace"

    @pytest.mark.parametrize('text, result', [
        ("question: What is your name ?", "What is your name ?")
    ])
    def test_processing_output(self, text, result):
        """test whether model output is interpretted

        Args:
            text (str): test input
            result (str): test result
        """
        assert postprocess.postprocess_question(
            text) == result, "Model output is not in correct format"

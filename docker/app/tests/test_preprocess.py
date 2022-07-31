"""unit tests for preprocess.py"""

import pytest
from src.textprocessor import preprocess


class TestPreprocessBulkText:
    """class holding test cases for filter_text function"""

    @pytest.mark.parametrize('text, result', [
        ("""
        Natural language processing (NLP) is the ability of a computer

        program to        understand human     language as it is spoken and written -- referred


        to as natural language.
         """, "Natural language processing (NLP) is the ability of a computer program to understand"
         + " human language as it is spoken and written -- referred to as natural language."), (
            "ValueError\
        :\
        attempted \
        relative \
        import \
        beyond\
        top-level \
        package",
            "ValueError : attempted relative import beyond top-level package")
    ])
    def test_whitespace(self, text, result):
        """test whether unnecessary whitespaces got covered

        Args:
            text (str): test input
            result (str): test result
        """
        assert preprocess.filter_text(
            text) == result, "Check whitespaces"

    @pytest.mark.parametrize('text, result', [(
        "⁍ ‣ValueError!!!@: attempted relative import" +
        " beyond~top-level package_", " ValueError : " +
        "attempted relative import beyond top-level package "
    )])
    def test_punctuation_marks(self, text, result):
        """test whether unnecessary punctuation marks are avoided

        Args:
            text (str): test input
            result (str): test result
        """
        assert preprocess.filter_text(
            text) == result, "Unwanted punctuation marks"


class TestSplitText:
    """class holding test cases for split_text function"""

    @pytest.mark.parametrize('text, result', [
        ("This test will split correctly at period.",
         ["This test will split correctly at period."]),
        ("This will split before period.",
         ["This will split before period."])
    ])
    def test_split_correctly_at_range(self, text, result):
        """test whether correctly split at period when its the
           threshold

        Args:
            text (str): test input
            result (list[str]): test result
        """
        assert preprocess.split_text(
            text, 41) == result, "Not splitted correctly."
        assert isinstance(preprocess.split_text(text, 42),
                          list), "function must return a list"

    @pytest.mark.parametrize('text, result', [
        ("This is first sentence. Assume this is a long text.",
         ["This is first sentence. Assume this is a long text."])
    ])
    def test_split_tolerance(self, text, result):
        """test whether correctly split at period when threshold
           is passed

           we put threshold as 25.. That passed first sentence but
           it will only split when it encounter a period after threshold passed.
           so whole test corpus will be inside 0th index of splitted text.
        Args:
            text (str): test input
            result (list[str]): test result
        """
        assert preprocess.split_text(
            text, 25)[0] == result[0], "Need to split after period."


@pytest.mark.parametrize('query, result', [
    ([('bat|NOUN', 0.0), ('Karthick|PRONOUN', 0.0)], ['Bat', 'Karthick']),
    ([('natural_language_processing|NOUN', 0.0)], ['Natural language processing'])
])
def test_change_format(query, result):
    """change output from sense2vec to fair readable form

    Args:
        query (list[tuple[str, float]]): test input
        result (list[str]): test result
    """
    assert preprocess.change_format(
        query) == result, "Failed to process s2v format."

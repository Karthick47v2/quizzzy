from src import preprocess
import pytest


class TestPreprocessBulkText:

    @pytest.mark.parametrize('text, result', [
        (""" 
        Natural language processing (NLP) is the ability of a computer 
        
        program to        understand human     language as it is spoken and written -- referred 
        
        
        to as natural language.
         """, "Natural language processing (NLP) is the ability of a computer program to understand human language as it is spoken and written -- referred to as natural language."), (
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
        assert preprocess.preprocess_bulk_text(
            text) == result, "Check whitespaces"

    @pytest.mark.parametrize('text, result', [("""⁍ ‣ValueError!!!@: attempted relative import beyond~top-level package_""",
                                               " ValueError : attempted relative import beyond top-level package ")])
    def test_punctuation_marks(self, text, result):
        assert preprocess.preprocess_bulk_text(
            text) == result, "Unwanted punctuation marks"


class TestSplitText:
    def test_split_correctly_at_range():
        pass

    def test_split_tolerance():
        pass

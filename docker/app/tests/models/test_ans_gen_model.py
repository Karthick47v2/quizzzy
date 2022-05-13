"""unit tests for ans_gen_model.py"""

import pytest
import spacy
from src.models import ans_gen_model


@pytest.mark.skip(reason="This will run when all dependecies are available, skipping this\
                      coz i haven't added large files to git..it needs sense2vec")
class TestAnsGenModel:
    """class holding test cases for AnsGenModel class"""
    # pylint: disable=no-self-use

    _ans_model = ans_gen_model.AnsGenModel()
    _nlp = spacy.load('en_core_web_sm')

    def test_filter_keywords(self):
        """check if generated keyword is on both context and summarized text. Because due to word
           sense disambugiation words in summarize text may not be correct for question generation
        """
        corpus = "NLP enables computers to understand natural language as humans do. Whether " +\
            "the language is spoken or written, natural language processing uses artificial " +\
            "intelligence to take real-world input, process it, and make sense of it in a way " +\
            "a computer can understand. Just as humans have different sensors -- such as ears " +\
            "to hear and eyes to see -- computers have programs to read and microphones to " +\
            "collect audio. And just as humans have a brain to process that input, computers " +\
            "have a program to process their respective inputs. At some point in processing, " +\
            "the input is converted to code that the computer can understand."
        summarized = "Natural language processing uses artificial intelligence to take " +\
            "real-world input and make sense of it. NLP enables computers to understand " +\
            "natural language as humans do. Just as humans have different sensors -- such as " +\
            "ears to hear and eyes to see -- computers have programs to read and microphones to " +\
            "collect audio."

        corpus = corpus.lower()
        summarized = summarized.lower()
        result = TestAnsGenModel._ans_model.filter_keywords(corpus, summarized)

        assert all(kwx in corpus for kwx in result) and all(
            kwx in summarized for kwx in result), "Keyword(s) missing in corpus/summary"

    @pytest.mark.parametrize('query', [
        ('Ice cream'), ('Natural language processing'), ('RAM')
    ])
    def test_false_answers(self, query):
        """check if generated answers are diverse and still on same context"""
        results = TestAnsGenModel._ans_model.false_answers(query)

        for result in results:
            if result != query:
                val = (TestAnsGenModel._nlp(
                    query).similarity(TestAnsGenModel._nlp(result)))
                assert 0.2 < val < 0.8, "Similairty error"

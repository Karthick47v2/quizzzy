"""This module contains all tasks specific to question generation model

@Author: Karthick T. Sharma
"""

from .model import Model
from ..textprocessor import postprocess


class QuestionGenerator(Model):
    """Generate question from context and answer."""

    def __init__(self):
        """Initialize question generator."""
        super().__init__(model_name='t5-question',
                         path_id='1_0dPLdv8WNtSYQdKEWxFc03IR-szs0kB')

    def generate(self, context, answer):
        """Generate abstrative summary of given context.

        Args:
            context (str): input corpus.
            ans (str): ans for question that needs to be generated.

        Returns:
           str: generated question.
        """
        return postprocess.postprocess_question(super().inference(
            num_beams=5, no_repeat_ngram_size=2, model_max_length=72,
            token_max_length=382, context=context, answer=answer))

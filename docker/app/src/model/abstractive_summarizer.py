"""This module contains all tasks specific for summarizer

@Author: Karthick T. Sharma
"""

from .model import Model
from ..textprocessor import postprocess, preprocess


class AbstractiveSummarizer(Model):
    """Summarize input context."""

    def __init__(self):
        """Initialize corpus summarizer."""
        super().__init__(model_name='t5-base', path_id='1-50SZ_WIHX4A6mkpsz-t0EAF_VhtHb-9')

    def preprocess_input(self, model_input):
        """Process model input.

        Args:
            model_input (str): bulk text that needs to be processed.

        Returns:
            list(str): processed text chunks.
        """
        return preprocess.split_text(model_input)

    def summarize(self, context):
        """Generate abstrative summary of given context.

        Args:
            context (str): input corpus.

        Returns:
           str: summarized text.
        """
        return postprocess.postprocess_summary(super().inference(
            num_beams=3, no_repeat_ngram_size=2, model_max_length=512,
            num_return_sequences=1, summarize=context))

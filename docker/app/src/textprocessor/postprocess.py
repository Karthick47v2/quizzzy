"""This module handles all textual postprocessing tasks.

@Author: Karthick T. Sharma
"""

import nltk
from nltk.tokenize import sent_tokenize
nltk.download('punkt')


def postprocess_summary(text):
    """Postprocess the output of summarizer model for fair readable output.

       Capitalize firt word of sentence. Put spaces in required place.

    Args:
        text (str): summarized text to processed.

    Returns:
        str: clean-human readable text.
    """
    output = ""

    for token in sent_tokenize(text):
        token = token.capitalize()
        output += " " + token
    return output


def postprocess_question(text):
    """Postprocess the output of question generation model for fair readable.

    Args:
        text (text): generated question to be processed.

    Returns:
        str: clean readable text.
    """
    output = text.replace("question: ", "")
    output = output.strip()
    return output

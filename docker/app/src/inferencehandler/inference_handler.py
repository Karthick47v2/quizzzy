"""This module handles inference for both Summarizer and question generator models.

@Author: Karthick T. Sharma
"""


def get_all_summary(model, context):
    """Generate summary of input corpus.

    Args:
        context (str): Bunch of unprocessed text.

    Returns:
        tuple(list(str), list(str)): tuple of, list of summarized text chunks and list of
        original text chuncks.
    """
    summary = []
    splitted_text = model.preprocess_input(context)

    for txt in splitted_text:
        summary.append(model.summarize(txt))

    return summary, splitted_text


def get_all_questions(model, context, answer):
    """Return list of generated questions.

    Args:
        context (list(str)): list of context for generating questions.
        answer (list(str)): list of answers for question which will be generated.

    Returns:
        list(str): list of questions within given context
    """
    questions = []

    for cont, ans in zip(context, answer):
        questions.append(model.generate(cont, ans))

    # squeezing the 2d list to 1d
    return questions

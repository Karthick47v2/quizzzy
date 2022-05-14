"""question generation from given context and keyword"""

import os

from fastT5 import get_onnx_runtime_sessions, OnnxT5
from transformers import AutoTokenizer


from src.preprocess import preprocess_summary, preprocess_splitted_text
from src.postprocess import postprocess_question, postprocess_summary


class SummarizeModel:
    """class holding summarization model
    and it's operations
    """
    _SUMMARIZE_MODEL_NAME = 't5-base'

    def __init__(self):
        """initialize corpus summarizer.

           https://github.com/Ki6an/fastT5
        """
        model_path = './pre-downloaded/t5-summarize/'

        if not os.path.isdir(os.getcwd() + 'pre-downloaded'):
            # pylint: disable=import-outside-toplevel
            from google_drive_downloader import GoogleDriveDownloader as gdd
            gdd.download_file_from_google_drive(
                file_id='1_0dPLdv8WNtSYQdKEWxFc03IR-szs0kB', dest_path=os.getcwd(), unzip=True)
            os.system('ls')
            model_path = '/t5-summarize'

        encoder_path = os.path.join(
            model_path, f"{SummarizeModel._SUMMARIZE_MODEL_NAME}-encoder-quantized.onnx")
        decoder_path = os.path.join(
            model_path, f"{SummarizeModel._SUMMARIZE_MODEL_NAME}-decoder-quantized.onnx")
        init_decoder_path = os.path.join(
            model_path, f"{SummarizeModel._SUMMARIZE_MODEL_NAME}-init-decoder-quantized.onnx")

        model_sessions = get_onnx_runtime_sessions(
            (encoder_path, decoder_path, init_decoder_path))
        self._sum_model = OnnxT5(model_path, model_sessions)
        self._sum_tokenizer = AutoTokenizer.from_pretrained(model_path)

    def tokenize_corpus(self, text):
        """tokenize the input corpus.
           "summarize: xxxxxxxx" is the input format for model.

        Args:
            text (str): splitted preprocessed corpus which is going to be tokenized.

        Returns:
            dict: dictionary returned by encode_plus containing tokens and attention mask.
        """
        encode = self._sum_tokenizer.encode_plus(
            "summarize: " + text, return_tensors='pt', pad_to_max_length=False, truncation=True)
        return encode

    def summarize(self, text, num_beams=3, no_repeat_ngram_size=2, max_length=512):
        """summarize corpus and return summarized text in human readable form.

        Args:
            text (str): corpus to be summarized.
            num_beams (int, optional): max 3 prob will get considered for
            each step. Defaults to 3.
            no_repeat_ngram_size (int, optional): no of repeat ngrams. Defaults to 2.
            max_length (int, optional): max output token length. Defaults to 512.

        Returns:
            str : clean-human readable text.
        """
        input_tokens_ids, attention_mask = preprocess_splitted_text(
            text, self)
        # encoded output
        summary_encoded = self._sum_model.generate(input_ids=input_tokens_ids,
                                                   attention_mask=attention_mask,
                                                   num_beams=num_beams,
                                                   num_return_sequences=1,
                                                   no_repeat_ngram_size=no_repeat_ngram_size,
                                                   max_length=max_length,
                                                   early_stopping=True)

        # decode summarized token
        output = self._sum_tokenizer.decode(
            summary_encoded[0], skip_special_tokens=True, clean_up_tokenization_spaces=True)
        return postprocess_summary(output)


class QuestionGenModel:
    """class holding question generation model
    and its operations
    """
    _QUESTION_MODEL_NAME = 't5_question'

    def __init__(self):
        """initialize question generator.
        """
        model_path = './pre-downloaded/t5-question'

        if not os.path.isdir(os.getcwd() + 'pre-downloaded'):
            # pylint: disable=import-outside-toplevel
            from google_drive_downloader import GoogleDriveDownloader as gdd
            gdd.download_file_from_google_drive(
                file_id='1-50SZ_WIHX4A6mkpsz-t0EAF_VhtHb-9', dest_path=os.getcwd(), unzip=True)
            os.system('ls')
            model_path = '/t5-question'

        encoder_path = os.path.join(
            model_path, f"{QuestionGenModel._QUESTION_MODEL_NAME}-encoder-quantized.onnx")
        decoder_path = os.path.join(
            model_path, f"{QuestionGenModel._QUESTION_MODEL_NAME}-decoder-quantized.onnx")
        init_decoder_path = os.path.join(
            model_path, f"{QuestionGenModel._QUESTION_MODEL_NAME}-init-decoder-quantized.onnx")

        model_sessions = get_onnx_runtime_sessions(
            (encoder_path, decoder_path, init_decoder_path))
        self._q_model = OnnxT5(model_path, model_sessions)
        self._q_tokenizer = AutoTokenizer.from_pretrained(model_path)
    # preprocess the summary for question generation

    def tokenize_corpus(self, context, answer):
        """tokenize input corpus
           "context: XXXXXXXXxxxxx answer: XXXXXXXXX" is the required format
           for question generation model.

        Args:
            context (str): corpus to input model context.
            answer (str): input model answer.

        Returns:
            dict: dictionary returned by encode_plus containing tokens and attention mask.
        """
        text = f"context: {context} answer: {answer}"
        encode = self._q_tokenizer.encode_plus(text,
                                               return_tensors='pt',
                                               max_length=382,
                                               pad_to_max_length=False,
                                               truncation=True)
        return encode

    def gen_question(self, context, answer, num_beams=5, no_repeat_ngram=2):
        """generate questions from context-answer pair.

        Args:
            context (str): context to generate question from.
            ans (str): answer to the question which is going to be generated.
            num_beams (int, optional): max 5 prob will get considered
            for each step. Defaults to 5.
            no_repeat_ngram_size (int, optional): no of repeat ngrams. Defaults to 2.
            max_length (int, optional): max output token length. Set to 72 as default
            because its ok for single question.

        Returns:
            str : clean-human readable text.
        """
        input_tokens_ids, attention_mask = preprocess_summary(
            context, answer, self)

        # encoded output
        question_encoded = self._q_model.generate(input_ids=input_tokens_ids,
                                                  attention_mask=attention_mask,
                                                  num_beams=num_beams,
                                                  no_repeat_ngram_size=no_repeat_ngram,
                                                  max_length=72,  # avg trained question length
                                                  early_stopping=True)

        # decode summarized token and post process it before print
        output = self._q_tokenizer.decode(
            question_encoded[0], skip_special_tokens=True, clean_up_tokenization_spaces=True)
        return postprocess_question(output)

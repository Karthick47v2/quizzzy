"""This module contains keyword word extraction using Key-Bert model

https://github.com/MaartenGr/KeyBERT
https://github.com/TimSchopf/KeyphraseVectorizers

@Author: Karthick T. Sharma
"""

from keyphrase_vectorizers import KeyphraseCountVectorizer
from keybert import KeyBERT


class KeywordExtractor:
    """Extract keyword from context."""

    def __init__(self):
        """Initialize keyword extration model (KeyBERT) and keypharse vectorizer
        for meaningful keywords.
        """
        self.__kw_model = KeyBERT()
        self.__vectorizer = KeyphraseCountVectorizer()

    def __extract_keywords(self, text):
        """Extract keywords from corpus using KeyBERT.

        Args:
            text (str): corpus used to extract keywords.

        Returns:
            list[str]: list of keywords extracted from input corpus.
        """
        kwx = self.__kw_model.extract_keywords(
            text, vectorizer=self.__vectorizer)

        kw_ls = []
        for i in kwx:
            # 0 -> keyword, 1-> confidence / probability
            kw_ls.append(i[0])
        return kw_ls

    def filter_keywords(self, original, summarized):
        """Extract keywords from both summary and original text and only return keywords
           which are common.

        Args:
            original (str): original corpus.
            summarized (str): summarized corpus.

        Returns:
            list(str): list of keywords common for both corpus.
        """
        orig_ls = set(self.__extract_keywords(original))
        sum_ls = self.__extract_keywords(summarized)
        return list(orig_ls.intersection(sum_ls))

    def get_keywords(self, original_list, summarized_list):
        """Return keywords from input corpus

        Args:
            original_list (str): list of original corpus.
            summarized_list (str): list of summarized corpus.

        Returns:
            list(list(str)): list of keywords common for both corpus.
        """
        kw_list = []

        for orig, sum_ in zip(original_list, summarized_list):
            kw_list.append(self.filter_keywords(orig, sum_))

        return kw_list

"""This module generates false answers within same context.

@Author: Karthick T. Sharma
"""

import os
import random
import urllib.request
import tarfile

import numpy as np

from sklearn.metrics.pairwise import cosine_similarity
from sentence_transformers import SentenceTransformer
from sense2vec import Sense2Vec

from ..textprocessor import preprocess


class FalseAnswerGenerator:
    """Generate false answers within same context."""

    def __init__(self):
        """Initialize false answer generation models."""
        self.__init_sentence_transformer()
        self.__init_sense2vec()

    def __init_sentence_transformer(self):
        """Initialize sentence embedding.

           https://www.sbert.net/
        """
        self._sentence_model = SentenceTransformer('all-MiniLM-L12-v2')

    def __init_sense2vec(self):
        """Initialize word vectors to get similar words.

           https://github.com/explosion/sense2vec
        """

        if not os.path.isdir(os.getcwd() + '/s2v_old'):
            s2v_url = "https://github.com/explosion/sense2vec/releases/download/"
            s2v_ver_url = s2v_url + "v1.0.0/s2v_reddit_2015_md.tar.gz"
            with urllib.request.urlopen(s2v_ver_url) as req:
                with tarfile.open(fileobj=req, mode='r|gz') as file:
                    file.extractall()

        self._s2v = Sense2Vec().from_disk("s2v_old")

    def __get_embedding(self, answer, distractors):
        """Returns sentence model embedding of answer and distractors.

        Args:
            answer (str): correct answer.
            distractors (list[str]): false answers.

        Returns:
            tuple[list[str], list[str]]: sentence model embedding of answer and distractors.
        """
        return self._sentence_model.encode([answer]), self._sentence_model.encode(distractors)

    def filter_output(self, orig, dummies):
        """Filter out final answers.

        Args:
            orig (str): correct answer.
            dummies (list[str]): false answers list generated from correct answer.

        Returns:
            list[str]: list of final answer which has low similarity.
        """
        ans_embedded, dis_embedded = self.__get_embedding(orig, dummies)
        # filter using MMMR
        dist = self.__mmr(ans_embedded, dis_embedded, dummies)

        filtered_dist = []
        for dis in dist:
            # 0 -> word, 1 -> confidence / probability
            filtered_dist.append(dis[0].capitalize())

        return filtered_dist

    def __mmr(self, doc_embedding, word_embedding, words, diversity=0.9):
        """Word diversity using MMR - Maximal Marginal Relevence.

        Args:
            doc_embedding (list[str]): sentence embedding of correct answer.
            word_embedding (list[str]): sentence embedding of false answer.
            words (list[str]): flase answers.
            diversity (float, optional): diversity coefficient. Defaults to 0.9.

        Returns:
            list[str]: list of final answers.
        """
        # extract similarity between words and docs
        word_doc_similarity = cosine_similarity(word_embedding, doc_embedding)
        word_similarity = cosine_similarity(word_embedding)

        kw_idx = [np.argmax(word_doc_similarity)]
        dist_idx = [i for i in range(len(words)) if i != kw_idx[0]]

        for _ in range(3):
            dist_similarities = word_doc_similarity[dist_idx, :]
            target_similarities = np.max(
                word_similarity[dist_idx][:, kw_idx], axis=1)

            # calculate MMR
            mmr = (1 - diversity) * dist_similarities - \
                diversity * target_similarities.reshape(-1, 1)
            mmr_idx = dist_idx[np.argmax(mmr)]

            # update kw
            kw_idx.append(mmr_idx)
            dist_idx.remove(mmr_idx)

        return [(words[idx], round(float(word_doc_similarity.reshape(1, -1)[0][idx]), 4))
                for idx in kw_idx]

    def __generate_answer(self, query):
        """Generate false answers from correct answer.

        Args:
            query (str): correct answer.

        Returns:
            list(str): list of final answers if input is valid, else None.
        """
        # get the best sense for given word (like NOUN, PRONOUN, VERB...)
        query_al = self._s2v.get_best_sense(query.lower().replace(' ', '_'))

        if query_al is None:
            return None

        try:
            assert query_al in self._s2v
            # get most similar 20 words (if any)
            temp = self._s2v.most_similar(query_al, n=20)
            formatted_string = preprocess.change_format(temp)
            formatted_string.insert(0, query)
            # if answers are numbers then we don't need to filter
            if query_al.split('|')[1] == 'CARDINAL':
                return formatted_string[:4]
            # else filter because sometimes similar words will be US, U.S, USA, AMERICA..
            #  bt all are same no?
            return self.filter_output(query, formatted_string)
        except AssertionError:
            return None

    def get_output(self, filtered_kws):
        """Generate false answers for whole context.

        Filter out keywords that doesn't generate 3 false answers.

        Args:
            filtered_kws (list(str)): list of keywords

        Returns:
            tuple(list(str), list(list(str))): tuple of, list of correct answers and list of
            list of all answers.
        """
        crct_ans = []
        all_answers = []

        for kws in filtered_kws:
            for kwx in kws:
                results = self.__generate_answer(kwx)
                if results is not None:
                    crct_ans.append(kwx)
                    random.shuffle(results)
                    all_answers.append(results)

        return crct_ans, sum(all_answers, [])

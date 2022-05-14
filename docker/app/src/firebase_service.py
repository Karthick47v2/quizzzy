"""Firebase firestore services"""


import firebase_admin

from firebase_admin import firestore
from firebase_admin import credentials


class FirebaseService:
    """class holding all needed firestore operations
    """

    def __init__(self):
        """initialize firebase firestore client.
        """
        try:
            firebase_admin.initialize_app(
                credentials.Certificate("./secret/serviceAccountKey.json"))
        # for unit test only
        except FileNotFoundError:
            firebase_admin.initialize_app(
                credentials.Certificate("docker/app/secret/mock-key.json"))
        self._db = firestore.client()

    def update_generated_status(self, request, status):
        """change status of 'isGenerated' is firestore.

        Args:
            request (ModelInput): request format from flutter.
            status (bool): state whether question generated.
        """
        doc_ref = self._db.collection('users').document(request.uid)
        doc_ref.update({'isGenerated': status})

    def send_results_to_fs(self, request, questions, crct_ans, all_ans):
        """send generated question to appropiate fs doc.

        Args:
            request (ModelInput): request format from flutter.
            questions (list[str]): list of generated questions.
            crct_ans (list[str]): list of correct answers.
            all_ans (list[list[str]]): list of list of all answers.
        """
        doc_ref = self._db.collection('users').document(request.uid)
        for idx, question in enumerate(questions):
            q_dict = {
                'question': question,
                'crct_ans': crct_ans[idx],
                'all_ans': all_ans[idx * 4: 4 + idx * 4]
            }
            doc_ref.collection(request.name).document(str(idx)).set(q_dict)

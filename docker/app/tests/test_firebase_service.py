"""unit tests for firebase_service.py"""


import pytest


from main import ModelInput, fs
from tests.test_main import REQUEST


# pylint: disable=redefined-outer-name
# @pytest.fixture(scope='class')
# def fsx():
#     """fixture for loading class obj"""
#     return firebase_service.FirebaseService("fs_tst")


# @pytest.mark.usefixtures('fsx')
class TestFirebaseService:
    """class holding test cases for AnsGenModel class"""

    def test_update_generated_status_validation(self):
        """validating input for update_generated_status function"""
        with pytest.raises(TypeError, match=r".* bool *."):
            fs.update_generated_status(ModelInput(**REQUEST), "True")

    def test_send_results_to_fs_validation(self):
        """validating input for send_results_to_fs function"""
        with pytest.raises(TypeError, match=r"'questions' *."):
            fs.send_results_to_fs(ModelInput(**REQUEST), "", [], [])
        with pytest.raises(TypeError, match=r"'crct_ans' *."):
            fs.send_results_to_fs(ModelInput(**REQUEST), [], "", [])
        with pytest.raises(TypeError, match=r"'all_ans' *."):
            fs.send_results_to_fs(ModelInput(**REQUEST), [], [], "")

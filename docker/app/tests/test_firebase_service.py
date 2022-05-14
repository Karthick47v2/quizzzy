"""unit tests for firebase_service.py"""


from main import ModelInput
import pytest


from src import firebase_service
from tests.test_main import REQUEST


# pylint: disable=redefined-outer-name
@pytest.fixture(scope='class')
def fs():
    """fixture for loading class obj"""
    return firebase_service.FirebaseService()


@pytest.mark.usefixtures('fs')
class TestFirebaseService:
    """class holding test cases for AnsGenModel class"""
    # pylint: disable=no-self-use

    def test_update_generated_status_validation(self, fs):
        """validating input for update_generated_status function"""
        with pytest.raises(TypeError, match=r".* bool *."):
            fs.update_generated_status(ModelInput(**REQUEST), "True")

    def test_send_results_to_fs_validation(self, fs):
        """validating input for send_results_to_fs function"""
        with pytest.raises(TypeError, match=r"'questions' *."):
            fs.send_results_to_fs(ModelInput(**REQUEST), "", [], [[]])
        with pytest.raises(TypeError, match=r"'crct_ans' *."):
            fs.send_results_to_fs(ModelInput(**REQUEST), [], "", [[]])
        with pytest.raises(TypeError, match=r"'all_ans' *."):
            fs.send_results_to_fs(ModelInput(**REQUEST), [], [], "list")

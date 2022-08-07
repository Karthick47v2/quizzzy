import 'package:get/get.dart';
import 'package:quizzzy/controllers/questionnaire_controller.dart';
import 'package:quizzzy/custom_widgets/custom_snackbar.dart';
import 'package:quizzzy/service/db_model/question_set.dart';
import 'package:quizzzy/service/firestore_db.dart';
import 'package:quizzzy/theme/palette.dart';

/// Delete questions from questionnaire.
///
/// Delete selected questions and update it in local and remote.
wipeQuestions(String qName) async {
  List<String> qID = Get.find<QuestionnaireController>().removalList;

  localStorage.delete(qName);
  Get.back();
  if (!await FirestoreService().deleteQuestions(qName, qID)) {
    customSnackBar("Error", "Please try again", Palette.error);
  } else {
    Get.find<QuestionnaireController>().resetRemovalList();
    customSnackBar("Deleting questions...",
        "Questions will be deleted in few minutes...", Palette.success);
  }
}

import 'package:get/get.dart';

import 'package:quizzzy/controllers/question_list_controller.dart';
import 'package:quizzzy/controllers/user_type_controller.dart';
import 'package:quizzzy/custom_widgets/custom_snackbar.dart';
import 'package:quizzzy/screens/question_bank/question_bank.dart';
import 'package:quizzzy/service/firestore_db.dart';
import 'package:quizzzy/theme/palette.dart';

/// Check if prevoius request got served.
///
/// Returns wheter previous request state is finished or not.
Future<void> checkQuestionBank() async {
  bool isReview = Get.find<UserTypeController>().mode == Mode.review;
  Get.find<QuestionListController>().overwriteList(isReview
      ? Get.find<QuestionListController>().completedList
      : await FirestoreService().getQuestionnaireNameList());

  List<String> data = Get.find<QuestionListController>().questionList;

  Get.back();

  if (data.isNotEmpty) {
    Get.to(() => const QuestionBank());
  } else {
    customSnackBar(
        "No questionnaire found",
        isReview
            ? "You haven't attempt any quizzes from Question Bank"
            : await FirestoreService().getGeneratorStatus()
                ? "Please wait for questions to get generated"
                : "Please upload a document to generate questions",
        Palette.warning);
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzzy/controllers/question_list_controller.dart';
import 'package:quizzzy/custom_widgets/custom_snackbar.dart';
import 'package:quizzzy/service/fs_database.dart';
import 'package:quizzzy/theme/palette.dart';

Future<List<String>> getQuestionList() async {
  Get.find<QuestionListController>()
      .overwriteList(await FirestoreService().getQuestionnaireNameList());

  return Get.find<QuestionListController>().questionList;
}

Future<List<String>> getSavedQuestionList() async {
  return Get.find<QuestionListController>().modifiedList;
}

/// Check if prevoius request got served.
///
/// Returns wheter previous request state is finished or not.
Future<void> checkQuesGenerated(Function getFunc, Widget navWidget,
    String generatorMsg1, String generatorMsg2) async {
  List<String> data = await getFunc();

  Get.back();

  if (data.isNotEmpty) {
    Get.to(() => navWidget);
  } else {
    customSnackBar(
        "No questionnaire found",
        await FirestoreService().getGeneratorStatus()
            ? generatorMsg1
            : generatorMsg2,
        Palette.warning);
  }
}

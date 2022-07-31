import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzzy/controllers/question_list_controller.dart';
import 'package:quizzzy/controllers/questionnaire_controller.dart';
import 'package:quizzzy/controllers/user_type_controller.dart';
import 'package:quizzzy/custom_widgets/custom_button.dart';
import 'package:quizzzy/custom_widgets/custom_popup.dart';
import 'package:quizzzy/screens/questionnaire.dart';

class QuizStartPopup extends StatelessWidget {
  final BuildContext cntxt;
  final List<String> questionList =
      Get.find<QuestionListController>().questionList;
  final int idx;
  QuizStartPopup({Key? key, required this.cntxt, required this.idx})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPopup(size: 150.0, wids: [
      Text(
        "Questionnaire: ${questionList[idx]}",
        style: const TextStyle(
          fontFamily: 'Heebo',
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        textAlign: TextAlign.center,
      ),
      GetBuilder<QuestionnaireController>(builder: (qController) {
        return Text(
          Get.find<UserTypeController>().userType == 'Student'
              ? "Time: ${qController.questionnaire.length} mins"
              : "Questions: ${qController.questionnaire.length}",
          style: const TextStyle(
            fontFamily: 'Heebo',
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        );
      }),
      CustomButton(
        text: Get.find<UserTypeController>().userType == 'Student'
            ? "Start"
            : "View",
        onTap: () {
          Navigator.of(cntxt).pop();
          Get.to(() => const Questionnaire());
        },
      ),
    ]);
  }
}

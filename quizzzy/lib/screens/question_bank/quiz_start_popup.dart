import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzzy/controllers/question_list_controller.dart';
import 'package:quizzzy/controllers/questionnaire_controller.dart';
import 'package:quizzzy/controllers/user_type_controller.dart';
import 'package:quizzzy/custom_widgets/custom_button.dart';
import 'package:quizzzy/custom_widgets/custom_popup.dart';
import 'package:quizzzy/screens/questionnaire/student_view.dart';
import 'package:quizzzy/screens/questionnaire/teacher_view.dart';
import 'package:quizzzy/theme/font.dart';
import 'package:quizzzy/theme/palette.dart';

class QuizStartPopup extends StatelessWidget {
  final List<String> questionList =
      Get.find<QuestionListController>().questionList;
  final int idx;
  QuizStartPopup({Key? key, required this.idx}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPopup(size: 150.0, wids: [
      Text(
        "Questionnaire: ${questionList[idx]}",
        style: TextStyle(
          fontFamily: fontFamily,
          fontSize: 22,
          fontWeight: Font.medium,
          color: Palette.font,
        ),
        textAlign: TextAlign.center,
      ),
      GetBuilder<QuestionnaireController>(builder: (qController) {
        return Text(
          Get.find<UserTypeController>().userType == 'Student'
              ? "Time: ${qController.questionnaire.length} mins"
              : "Questions: ${qController.questionnaire.length}",
          style: TextStyle(
            fontFamily: fontFamily,
            fontSize: 20,
            fontWeight: Font.regular,
            color: Palette.font,
          ),
        );
      }),
      Get.find<UserTypeController>().userType == 'Student'
          ? CustomButton(
              text: "Start",
              onTap: () {
                Get.back();
                Get.to(() => const StudentView());
              },
            )
          : CustomButton(
              text: "View",
              onTap: () {
                Get.back();
                Get.to(() => const TeacherView());
              },
            ),
    ]);
  }
}

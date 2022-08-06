import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzzy/controllers/questionnaire_controller.dart';
import 'package:quizzzy/custom_widgets/custom_button.dart';
import 'package:quizzzy/custom_widgets/custom_popup.dart';
import 'package:quizzzy/custom_widgets/custom_text_input.dart';
import 'package:quizzzy/screens/questionnaire/student_view.dart';

class QuizCodePopup extends StatefulWidget {
  const QuizCodePopup({Key? key}) : super(key: key);

  @override
  State<QuizCodePopup> createState() => _QuizCodePopupState();
}

class _QuizCodePopupState extends State<QuizCodePopup> {
  final codeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return CustomPopup(size: 200.0, wids: [
      Column(
        children: [
          CustomTextInput(
            text: "Enter code",
            controller: codeController,
          ),
          CustomButton(
            text: "Confirm",
            onTap: () async {
              await fetchQuestionnaire();
              Get.back();
              Get.to(() => const StudentView());
            },
          )
        ],
      ),
    ]);
  }

  fetchQuestionnaire() async {
    List<String> quizRef = decode();
    await Get.find<QuestionnaireController>()
        .overwriteList(quizRef[1], userID: quizRef[0]);
    Get.find<QuestionnaireController>().setAuthor(quizRef[0]);
  }

  List<String> decode() {
    return codeController.text.split('-');
  }
}

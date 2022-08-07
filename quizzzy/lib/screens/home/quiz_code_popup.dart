import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:quizzzy/controllers/questionnaire_controller.dart';
import 'package:quizzzy/custom_widgets/custom_button.dart';
import 'package:quizzzy/custom_widgets/custom_popup.dart';
import 'package:quizzzy/custom_widgets/custom_snackbar.dart';
import 'package:quizzzy/custom_widgets/custom_text_input.dart';
import 'package:quizzzy/custom_widgets/render_img.dart';
import 'package:quizzzy/screens/questionnaire/student_view.dart';
import 'package:quizzzy/theme/palette.dart';

/// Render [CustomPopup] when [Attempt Quiz] pressed.
class QuizCodePopup extends StatefulWidget {
  const QuizCodePopup({Key? key}) : super(key: key);

  @override
  State<QuizCodePopup> createState() => _QuizCodePopupState();
}

class _QuizCodePopupState extends State<QuizCodePopup> {
  final codeController = TextEditingController();

  /// Get questionniare from [Firestore].
  Future<bool> fetchQuestionnaire() async {
    List<String> quizRef = decode();

    if (quizRef.length != 2) {
      return false;
    }
    await Get.find<QuestionnaireController>()
        .overwriteList(quizRef[1], userID: quizRef[0]);
    Get.find<QuestionnaireController>().setAuthor(quizRef[0]);

    if (Get.find<QuestionnaireController>().questionnaire.isEmpty) {
      return false;
    }
    return true;
  }

  /// Decode quiz code.
  List<String> decode() {
    return codeController.text.split('-');
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopup(size: 400.0, wids: [
      Column(
        children: [
          const RenderImage(
            path: 'assets/images/wait.svg',
            expaned: false,
            svgHeight: 200,
          ),
          CustomTextInput(
            text: "Enter code",
            controller: codeController,
          ),
          CustomButton(
            text: "Confirm",
            onTap: () async {
              if (!(await fetchQuestionnaire())) {
                customSnackBar("Error", "Invalid code.", Palette.error);
              } else {
                Get.back();
                Get.to(() => const StudentView());
              }
            },
          )
        ],
      ),
    ]);
  }
}

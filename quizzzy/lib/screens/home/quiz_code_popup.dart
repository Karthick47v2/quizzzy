import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzzy/custom_widgets/custom_button.dart';
import 'package:quizzzy/custom_widgets/custom_popup.dart';
import 'package:quizzzy/custom_widgets/custom_text_input.dart';
import 'package:quizzzy/screens/questionnaire/student_view.dart';

class QuizCodePopup extends StatefulWidget {
  final TextEditingController codeController;
  const QuizCodePopup({Key? key, required this.codeController})
      : super(key: key);

  @override
  State<QuizCodePopup> createState() => _QuizCodePopupState();
}

class _QuizCodePopupState extends State<QuizCodePopup> {
  @override
  Widget build(BuildContext context) {
    return CustomPopup(size: 200.0, wids: [
      Column(
        children: [
          CustomTextInput(
            text: "Enter code",
            controller: widget.codeController,
          ),
          CustomButton(
            text: "Confirm",
            onTap: () async {
              Get.back();
              Get.to(() => const StudentView());
            },
          )
        ],
      ),
    ]);
  }
}

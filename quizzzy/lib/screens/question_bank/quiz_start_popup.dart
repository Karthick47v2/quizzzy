import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:quizzzy/controllers/question_list_controller.dart';
import 'package:quizzzy/controllers/questionnaire_controller.dart';
import 'package:quizzzy/controllers/user_type_controller.dart';
import 'package:quizzzy/custom_widgets/custom_button.dart';
import 'package:quizzzy/custom_widgets/custom_popup.dart';
import 'package:quizzzy/custom_widgets/render_img.dart';
import 'package:quizzzy/screens/question_bank/share_quiz_popup.dart';
import 'package:quizzzy/screens/questionnaire/student_view.dart';
import 'package:quizzzy/screens/questionnaire/teacher_view.dart';
import 'package:quizzzy/screens/review/student_review.dart';
import 'package:quizzzy/theme/font.dart';
import 'package:quizzzy/theme/palette.dart';

/// Render [CustomPopup] when questionnaire pressed.
class QuizStartPopup extends StatelessWidget {
  final List<String> questionList =
      Get.find<QuestionListController>().questionList;
  final int idx;
  final bool isStudent =
      Get.find<UserTypeController>().userType == UserType.student;
  final bool isReview = Get.find<UserTypeController>().mode == Mode.review;
  QuizStartPopup({Key? key, required this.idx}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPopup(size: 400.0, wids: [
      RenderImage(
        path:
            'assets/images/${(isStudent && !isReview) ? 'quiz' : 'review'}.svg',
        expaned: false,
        svgHeight: 200,
      ),
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
          (isStudent && !isReview)
              ? "Time: ${qController.questionnaire.length / 2} mins"
              : "Questions: ${qController.questionnaire.length}",
          style: TextStyle(
            fontFamily: fontFamily,
            fontSize: 20,
            fontWeight: Font.regular,
            color: Palette.font,
          ),
        );
      }),
      isStudent
          ? CustomButton(
              key: const Key('btn-quiz-start'),
              text: "Start",
              onTap: () {
                Get.back();
                Get.to(() =>
                    isReview ? const StudentReview() : const StudentView());
              },
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                  key: const Key('btn-quiz-modify'),
                  text: "Modify",
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return const TeacherView();
                        });
                  },
                ),
                CustomButton(
                  key: const Key('btn-quiz-share'),
                  text: "Share",
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return ShareQuizPopup(quizName: questionList[idx]);
                        });
                  },
                )
              ],
            ),
    ]);
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:quizzzy/controllers/questionnaire_controller.dart';
import 'package:quizzzy/custom_widgets/custom_button.dart';
import 'package:quizzzy/custom_widgets/answer_container.dart';
import 'package:quizzzy/screens/questionnaire/questionnaire.dart';
import 'package:quizzzy/screens/questionnaire/stud_finish_popup.dart';
import 'package:quizzzy/screens/questionnaire/top_q_bar.dart';
import 'package:quizzzy/service/db_model/question_set.dart';
import 'package:quizzzy/theme/palette.dart';

/// Renders [StudentReview] screen which consists of all questions and answers.
class StudentReview extends StatefulWidget {
  const StudentReview({Key? key}) : super(key: key);

  @override
  State<StudentReview> createState() => _StudentReviewState();
}

class _StudentReviewState extends State<StudentReview> {
  int currentIdx = 0;
  List<QuestionSet> questionnaire =
      Get.find<QuestionnaireController>().questionnaire;

  Widget renderAnswer(String i) {
    return AnswerContainer(
      ans: i,
      isPicked:
          i.toLowerCase() == questionnaire[currentIdx].crctAns.toLowerCase(),
      onTap: () => {},
    );
  }

  Widget renderNavBtn(String txt) {
    return CustomButton(
      text: txt,
      onTap: () {
        updateQuestion();
      },
    );
  }

  /// Move to next question when [CustomButton] pressed.
  ///
  /// Teacher they can keep/drop current question.
  updateQuestion() {
    setState(() {
      if (currentIdx == questionnaire.length - 1) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return StudFinishPopup();
            });
      } else {
        currentIdx++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Questionnaire(
      topBar: TopQBar(color: Palette.theme, txt: "Review"),
      renderAnswer: renderAnswer,
      bottomNavBtn: CustomButton(
        text: "Next",
        onTap: () => updateQuestion(),
      ),
      currentIdx: currentIdx,
    );
  }
}

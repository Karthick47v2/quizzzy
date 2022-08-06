import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:quizzzy/controllers/questionnaire_controller.dart';
import 'package:quizzzy/custom_widgets/custom_button.dart';
import 'package:quizzzy/custom_widgets/answer_container.dart';
import 'package:quizzzy/screens/questionnaire/questionnaire.dart';
import 'package:quizzzy/screens/questionnaire/stud_finish_popup.dart';
import 'package:quizzzy/service/db_model/question_set.dart';

/// Renders [StudentView] screen which consists of all questions and answers.
class StudentView extends StatefulWidget {
  const StudentView({Key? key}) : super(key: key);

  @override
  State<StudentView> createState() => _StudentViewState();
}

class _StudentViewState extends State<StudentView> {
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

  @override
  Widget build(BuildContext context) {
    return Questionnaire(
      topBar: Container(),
      renderAnswer: renderAnswer,
      bottomNavBtn: CustomButton(
        text: "Next",
        onTap: () => updateQuestion(),
      ),
      currentIdx: currentIdx,
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
}

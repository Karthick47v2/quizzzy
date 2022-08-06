import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:quizzzy/controllers/questionnaire_controller.dart';
import 'package:quizzzy/custom_widgets/custom_button.dart';
import 'package:quizzzy/custom_widgets/answer_container.dart';
import 'package:quizzzy/screens/questionnaire/questionnaire.dart';
import 'package:quizzzy/screens/questionnaire/teach_finish_popup.dart';
import 'package:quizzzy/screens/questionnaire/top_q_bar.dart';
import 'package:quizzzy/service/db_model/question_set.dart';
import 'package:quizzzy/theme/palette.dart';

/// Renders [TeacherView] screen which consists of all questions.
class TeacherView extends StatefulWidget {
  const TeacherView({Key? key}) : super(key: key);

  @override
  State<TeacherView> createState() => _TeacherViewState();
}

class _TeacherViewState extends State<TeacherView> {
  int currentIdx = 0;
  List<QuestionSet> questionnaire =
      Get.find<QuestionnaireController>().questionnaire;

  /// Render answers.
  ///
  /// Indicate correct answer.
  Widget renderAnswer(String i) {
    return AnswerContainer(
      ans: i,
      isPicked:
          i.toLowerCase() == questionnaire[currentIdx].crctAns.toLowerCase(),
      onTap: () => {},
    );
  }

  /// Render customized button.
  Widget renderNavBtn(String txt, bool isRemove) {
    return CustomButton(
      text: txt,
      onTap: () {
        updateQuestion(isRemove);
      },
    );
  }

  /// Move to next question when [CustomButton] pressed.
  ///
  /// Teacher they can keep/drop current question.
  updateQuestion(bool isRemove) {
    setState(() {
      if (isRemove) {
        Get.find<QuestionnaireController>()
            .addToRemovalList(questionnaire[currentIdx].id);
      }
      if (currentIdx == questionnaire.length - 1) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return TeachFinishPopup();
            });
      } else {
        currentIdx++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Questionnaire(
      topBar: TopQBar(color: Palette.theme, txt: "Keep / Drop"),
      renderAnswer: renderAnswer,
      bottomNavBtn: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [renderNavBtn("Drop", true), renderNavBtn("Keep", false)],
      ),
      currentIdx: currentIdx,
    );
  }
}

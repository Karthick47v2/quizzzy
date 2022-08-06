import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:quizzzy/controllers/questionnaire_controller.dart';
import 'package:quizzzy/custom_widgets/custom_button.dart';
import 'package:quizzzy/custom_widgets/answer_container.dart';
import 'package:quizzzy/screens/questionnaire/questionnaire.dart';
import 'package:quizzzy/screens/questionnaire/stud_finish_popup.dart';
import 'package:quizzzy/screens/questionnaire/timesup_popup.dart';
import 'package:quizzzy/screens/questionnaire/top_q_bar.dart';
import 'package:quizzzy/service/db_model/question_set.dart';
import 'package:quizzzy/theme/palette.dart';

/// Renders [StudentView] screen which consists of all questions.
class StudentView extends StatefulWidget {
  const StudentView({Key? key}) : super(key: key);

  @override
  State<StudentView> createState() => _StudentViewState();
}

class _StudentViewState extends State<StudentView> {
  int currentIdx = 0;
  int time = 0;
  late List<bool> qState = List.filled(4, false);
  List<QuestionSet> questionnaire =
      Get.find<QuestionnaireController>().questionnaire;
  late Timer timer;

  /// Setup quiz env.
  @override
  initState() {
    super.initState();
    questionnaire.shuffle();
    time = questionnaire.length * 60;
    startTimer();
  }

  /// Start count down.
  startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (time <= 0) {
        setState(() {
          timer.cancel();
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return TimesupPopup();
              });
        });
      } else {
        setState(() {
          time--;
        });
      }
    });
  }

  /// Stop timer function when navigating to other screen.
  @override
  dispose() {
    timer.cancel();
    super.dispose();
  }

  /// Move to next question when [CustomButton] pressed.
  updateQuestion() {
    // atleast 1 ans should be selected inorder to go to next question
    if (qState.any((e) => e)) {
      setState(() {
        if (checkAns()) {
          Get.find<QuestionnaireController>().scoreInc();
        }

        if (currentIdx == questionnaire.length - 1) {
          timer.cancel();
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return StudFinishPopup();
              });
        } else {
          refreshAns();
          currentIdx++;
        }
      });
    }
  }

  /// Validate answer when next [CustomButton] pressed.
  bool checkAns() {
    return questionnaire[currentIdx]
            .allAns[qState.indexOf(true)]
            .toLowerCase() ==
        questionnaire[currentIdx].crctAns.toLowerCase();
  }

  /// Refresh [CustomButton] pressed state.
  refreshAns() {
    qState.setAll(0, [false, false, false, false]);
  }

  /// Render answers.
  ///
  /// Change color when button pressed.
  Widget renderAnswer(String i) {
    return AnswerContainer(
      ans: i,
      isPicked: qState[questionnaire[currentIdx].allAns.indexOf(i)],
      onTap: () {
        setState(() {
          refreshAns();
          qState[questionnaire[currentIdx].allAns.indexOf(i)] = true;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Questionnaire(
      topBar: TopQBar(
          color: time > 30 ? Palette.timerGreen : Palette.timerRed,
          txt:
              "${"${(time ~/ 60)}".padLeft(2, '0')} : ${"${time % 60}".padLeft(2, '0')}"),
      renderAnswer: renderAnswer,
      bottomNavBtn: CustomButton(
        text: "Next",
        onTap: () => updateQuestion(),
      ),
      currentIdx: currentIdx,
    );
  }
}

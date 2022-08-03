import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:quizzzy/controllers/questionnaire_controller.dart';
import 'package:quizzzy/custom_widgets/custom_button.dart';
import 'package:quizzzy/custom_widgets/custom_snackbar.dart';
import 'package:quizzzy/custom_widgets/answer_container.dart';
import 'package:quizzzy/screens/questionnaire/questionnaire.dart';
import 'package:quizzzy/screens/questionnaire/teach_finish_popup.dart';
import 'package:quizzzy/screens/questionnaire/top_q_bar.dart';
import 'package:quizzzy/service/db_model/question_set.dart';
import 'package:quizzzy/service/fs_database.dart';
import 'package:quizzzy/service/local_database.dart';
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
  String name = Get.find<QuestionnaireController>().questionnaireName;

  Widget renderAnswer(String i) {
    return AnswerContainer(
      ans: i,
      isPicked:
          i.toLowerCase() == questionnaire[currentIdx].crctAns.toLowerCase(),
      onTap: () => {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Questionnaire(
      topBar: TopQBar(color: Palette.theme, txt: "Keep / Drop"),
      renderAnswer: renderAnswer,
      bottomNavBtn: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CustomButton(
            text: "Drop",
            onTap: () {
              updateQuestion(isRemove: true);
            },
          ),
          CustomButton(
            text: "Keep",
            onTap: () => updateQuestion(),
          )
        ],
      ),
      currentIdx: currentIdx,
    );
  }

  /// Move to next question when [CustomButton] pressed.
  ///
  /// Teacher they can keep/drop current question.
  updateQuestion({bool isRemove = false}) {
    setState(() {
      if (currentIdx == questionnaire.length - 1) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return const TeachFinishPopup();
            });
      } else {
        if (isRemove) {
          questionnaire.removeAt(currentIdx);
        } else {
          currentIdx++;
        }
      }
    });
  }

  /// If userType teacher have modified initial questionnaire, then store it to local database.
  modifyQuestionSet(String name, List<QuestionSet> q, bool removeLast) {
    FirestoreService().saveModifiedQuiz(
        q); /////////////////////////////////////////////////////////////////////
  }

  /// Remove [name] from both local and online database once it got modified.
  removeQuestionnaire() async {
    questionSetBox.delete(name);
    if (!await FirestoreService()
        .deleteQuestionnaire('users/${FirestoreService().user!.uid}/$name')) {
      customSnackBar("Error", "Please try again", Palette.error);
    } else {
      var popList = await UserSharedPreferences().getPoppedItems();
      popList ??= [];
      popList.add(name);
      UserSharedPreferences().setPoppedItems(popList);
    }
  }
}

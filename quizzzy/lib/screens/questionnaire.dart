import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:quizzzy/controllers/questionnaire_controller.dart';
import 'package:quizzzy/controllers/user_type_controller.dart';
import 'package:quizzzy/custom_widgets/custom_button.dart';
import 'package:quizzzy/custom_widgets/custom_popup.dart';
import 'package:quizzzy/custom_widgets/custom_snackbar.dart';
import 'package:quizzzy/custom_widgets/custom_template.dart';
import 'package:quizzzy/custom_widgets/answer_container.dart';
import 'package:quizzzy/screens/home/home_page.dart';
import 'package:quizzzy/screens/score.dart';
import 'package:quizzzy/service/db_model/question_set.dart';
import 'package:quizzzy/service/fs_database.dart';
import 'package:quizzzy/service/local_database.dart';
import 'package:quizzzy/theme/font.dart';
import 'package:quizzzy/theme/palette.dart';

/// Renders [Questionnaire] screen which consists of all questions.
///
/// UI and functions will defer according to [userType].
class Questionnaire extends StatefulWidget {
  const Questionnaire({Key? key}) : super(key: key);

  @override
  State<Questionnaire> createState() => _QuestionnaireState();
}

class _QuestionnaireState extends State<Questionnaire> {
  int currentIdx = 0, time = 0;
  late List<bool> qState = List.filled(4, false);
  late List<QuestionSet> quesPrep;
  String userType = Get.find<UserTypeController>().userType;
  List<QuestionSet> questionnaire =
      Get.find<QuestionnaireController>().questionnaire;
  String name = Get.find<QuestionnaireController>().questionnaireName;
  late Timer timer;

  /// Initialize timer if [userType] is Student.
  @override
  initState() {
    super.initState();
    if (userType == 'Student') {
      questionnaire.shuffle();
      time = questionnaire.length * 60;
      startTimer();
    }
  }

  /// Start count down.
  ///
  /// Alert if time's up.
  startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (time <= 0) {
        setState(() {
          timer.cancel();
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext cntxt) {
                return CustomPopup(size: 100.0, wids: [
                  Text(
                    "Time's up",
                    style: TextStyle(
                        fontFamily: fontFamily,
                        fontSize: 22,
                        fontWeight: Font.regular,
                        color: Palette.font),
                    textAlign: TextAlign.center,
                  ),
                  CustomButton(
                    text: "Finish",
                    onTap: () {
                      Navigator.of(cntxt).pop();
                      Get.to(() => Score());
                    },
                  )
                ]);
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
    if (userType == 'Student') {
      timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTemplate(
        body: Column(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              userType == "Student"
                  ? Container(
                      padding: const EdgeInsets.fromLTRB(120, 70, 120, 10),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color:
                              time > 30 ? Palette.timerGreen : Palette.timerRed,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Center(
                          child: Text(
                            "${(time ~/ 60)}".padLeft(2, '0') +
                                " : " +
                                "${time % 60}".padLeft(2, '0'),
                            style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: 19,
                                fontWeight: Font.extraBold,
                                color: Palette.font),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.fromLTRB(120, 70, 120, 10),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Palette.theme,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Center(
                          child: Text(
                            "Keep / Drop",
                            style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: 19,
                                fontWeight: Font.extraBold,
                                color: Palette.font),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 30, 10, 50),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Palette.questionBg,
                    borderRadius: const BorderRadius.all(Radius.circular(24)),
                  ),
                  child: Center(
                    child: Text(
                      questionnaire[currentIdx].question,
                      style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: 22,
                          fontWeight: Font.regular,
                          color: Palette.font),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              for (var i in questionnaire[currentIdx].allAns)
                AnswerContainer(
                  ans: i,
                  isPicked: userType == 'Student'
                      ? qState[questionnaire[currentIdx].allAns.indexOf(i)]
                      : i.toLowerCase() ==
                          questionnaire[currentIdx].crctAns.toLowerCase(),
                  onTap: () {
                    if (userType == 'Student') {
                      setState(() {
                        refreshAns();
                        qState[questionnaire[currentIdx].allAns.indexOf(i)] =
                            true;
                      });
                    }
                  },
                ),
            ],
          ),
        ),
        Container(
          height: 100,
          width: double.maxFinite,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${currentIdx + 1} / ${questionnaire.length}",
                style: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: 18,
                    fontWeight: Font.regular,
                    color: Palette.font),
              ),
              userType == "Student"
                  ? CustomButton(
                      text: "Next",
                      onTap: () => updateQuestion(),
                    )
                  : Row(
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
            ],
          ),
        ),
      ],
    ));
  }

  /// Move to next question when [CustomButton] pressed.
  ///
  /// If [userType] is Teacher then they can keep/drop current question.
  updateQuestion({bool isRemove = false}) {
    if (userType == 'Student') {
      // atleast 1 ans should be selected inorder to go to next question
      if (qState.any((e) => e)) {
        setState(() {
          if (currentIdx < questionnaire.length - 1) {
            if (checkAns()) {
              Get.find<QuestionnaireController>().scoreInc();
            }
            refreshAns();
            currentIdx++;
          } else {
            if (checkAns()) {
              Get.find<QuestionnaireController>().scoreInc();
            }
            timer.cancel();
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext cntxt) {
                  return CustomPopup(size: 150.0, wids: [
                    Text(
                      // "You got ${100 * score / questionnaire.length}",
                      "Press continue to finish the quiz",
                      style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: 22,
                          fontWeight: Font.regular,
                          color: Palette.font),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "You can always review quizzes from main menu",
                      style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: 19,
                          fontWeight: Font.regular,
                          color: Palette.font),
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButton(
                          text: "Continue",
                          onTap: () async {
                            Navigator.pop(cntxt); ///////////////////////
                            Get.to(() => const HomePage());
                          },
                        )
                      ],
                    ),
                  ]);
                });
          }
        });
      }
    } else {
      setState(() {
        if (currentIdx < questionnaire.length - 1) {
          if (isRemove) {
            questionnaire.removeAt(currentIdx);
          } else {
            currentIdx++;
          }
        } else {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext cntxt) {
                return CustomPopup(size: 150.0, wids: [
                  Text(
                    "Press continue to modify changes, cancel to revert",
                    style: TextStyle(
                        fontFamily: fontFamily,
                        fontSize: 22,
                        fontWeight: Font.regular,
                        color: Palette.font),
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomButton(
                        text: "Cancel",
                        onTap: () => Get.to(() => const HomePage()),
                      ),
                      CustomButton(
                        text: "Continue",
                        onTap: () async {
                          // if (isRemove) {
                          //   if (questionnaire.length == 1) {
                          //     // removeQuestionnaire();
                          //   } else {
                          //     modifyQuestionSet(
                          //         name, questionnaire, true);
                          //   }
                          // } else {
                          //   modifyQuestionSet(
                          //       name, questionnaire, false);
                          // }
                          Navigator.pop(cntxt); ///////////////////////
                          Get.to(() => const HomePage());
                        },
                      )
                    ],
                  ),
                ]);
              });
        }
      });
    }
  }

  /// If [userType] is teacher and they have modified initial questionnaire, then store it to
  /// local database.
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
}

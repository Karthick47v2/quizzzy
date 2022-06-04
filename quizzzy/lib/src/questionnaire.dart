import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quizzzy/libs/custom_widgets.dart';
import 'package:quizzzy/src/home_page.dart';
import 'package:quizzzy/src/score.dart';
import 'package:quizzzy/src/service/db_model/question_set.dart';
import 'package:quizzzy/src/service/fs_database.dart';
import 'package:quizzzy/src/service/local_database.dart';

class Questionnaire extends StatefulWidget {
  final List<QuestionSet> questionnaire;
  final String name;

  const Questionnaire(
      {Key? key, required this.questionnaire, required this.name})
      : super(key: key);

  @override
  State<Questionnaire> createState() => _QuestionnaireState();
}

class _QuestionnaireState extends State<Questionnaire> {
  int currentQ = 0, score = 0, time = 0;
  late List<bool> qState = List.filled(4, false);
  late List<QuestionSet> quesPrep;

  late Timer timer;

  @override
  initState() {
    super.initState();
    if (userType == 'Student') {
      widget.questionnaire.shuffle();
      time = widget.questionnaire.length * 60;
      startTimer();
    }
  }

  startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (time <= 0) {
        setState(() {
          timer.cancel();
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext cntxt) {
                return PopupModal(size: 100.0, wids: [
                  const Text(
                    "Time's up",
                    style: TextStyle(
                        fontFamily: 'Heebo',
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  QuizzzyNavigatorBtn(
                    text: "Finish",
                    onTap: () {
                      Navigator.of(cntxt).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => Score(
                                  score: score,
                                  questionnaire: widget.questionnaire))));
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

  @override
  dispose() {
    if (userType == 'Student') {
      timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return QuizzzyTemplate(
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
                          color: time > 30
                              ? const Color.fromARGB(94, 0, 255, 34)
                              : const Color.fromARGB(94, 255, 0, 0),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Center(
                          child: Text(
                            "${(time ~/ 60)}".padLeft(2, '0') +
                                " : " +
                                "${time % 60}".padLeft(2, '0'),
                            style: const TextStyle(
                                fontFamily: 'Heebo',
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.fromLTRB(120, 70, 120, 10),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 93, 0, 155),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: const Center(
                          child: Text(
                            "Keep / Drop",
                            style: TextStyle(
                                fontFamily: 'Heebo',
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 30, 10, 50),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(94, 155, 155, 155),
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                  child: Center(
                    child: Text(
                      widget.questionnaire[currentQ].question,
                      style: const TextStyle(
                          fontFamily: 'Heebo',
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              for (var i in widget.questionnaire[currentQ].allAns)
                QuizzzyAns(
                  ans: i,
                  isPicked: userType == 'Student'
                      ? qState[widget.questionnaire[currentQ].allAns.indexOf(i)]
                      : i.toLowerCase() ==
                          widget.questionnaire[currentQ].crctAns.toLowerCase(),
                  onTap: () {
                    if (userType == 'Student') {
                      setState(() {
                        refreshAns();
                        qState[widget.questionnaire[currentQ].allAns
                            .indexOf(i)] = true;
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
                "${currentQ + 1} / ${widget.questionnaire.length}",
                style: const TextStyle(
                    fontFamily: 'Heebo',
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),
              userType == "Student"
                  ? QuizzzyNavigatorBtn(
                      text: "Next",
                      onTap: () => updateQuestion(),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        QuizzzyNavigatorBtn(
                          text: "Drop",
                          onTap: () {
                            updateQuestion(isRemove: true);
                          },
                        ),
                        QuizzzyNavigatorBtn(
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

  updateQuestion({bool isRemove = false}) {
    if (userType == 'Student') {
      // atleast 1 ans should be selected inorder to go to next question
      if (qState.any((e) => e)) {
        setState(() {
          if (currentQ < widget.questionnaire.length - 1) {
            if (checkAns()) {
              score++;
            }
            refreshAns();
            currentQ++;
          } else {
            // ignore: avoid_print
            print(score);
          }
        });
      }
    } else {
      setState(() {
        if (currentQ < widget.questionnaire.length - 1) {
          if (isRemove) {
            widget.questionnaire.removeAt(currentQ);
          } else {
            currentQ++;
          }
        } else {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext cntxt) {
                return PopupModal(size: 150.0, wids: [
                  const Text(
                    "Press continue to modify changes, cancel to revert",
                    style: TextStyle(
                        fontFamily: 'Heebo',
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      QuizzzyNavigatorBtn(
                        text: "Cancel",
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => const HomePage())));
                        },
                      ),
                      QuizzzyNavigatorBtn(
                        text: "Continue",
                        onTap: () async {
                          if (isRemove) {
                            if (widget.questionnaire.length == 1) {
                              // removeQuestionnaire();
                            } else {
                              modifyQuestionSet(
                                  widget.name, widget.questionnaire, true);
                            }
                          } else {
                            modifyQuestionSet(
                                widget.name, widget.questionnaire, false);
                          }
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

  modifyQuestionSet(String name, List<QuestionSet> q, bool removeLast) {
    fs.saveModifiedQuiz(q);
  }

  removeQuestionnaire() async {
    questionSetBox.delete(widget.name);
    if (!await fs.deleteQuestionnaire('users/${fs.user!.uid}/${widget.name}')) {
      snackBar(context, "Error: Please try again", Colors.red.shade800);
    } else {
      var popList = await sharedPref.getPoppedItems();
      popList ??= [];
      popList.add(widget.name);
      sharedPref.setPoppedItems(popList);
    }
  }

  bool checkAns() {
    return widget.questionnaire[currentQ].allAns[qState.indexOf(true)]
            .toLowerCase() ==
        widget.questionnaire[currentQ].crctAns.toLowerCase();
  }

  refreshAns() {
    qState.setAll(0, [false, false, false, false]);
  }
}

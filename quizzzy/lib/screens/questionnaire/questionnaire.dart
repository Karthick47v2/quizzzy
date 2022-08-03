import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:quizzzy/controllers/questionnaire_controller.dart';
import 'package:quizzzy/custom_widgets/custom_template.dart';
import 'package:quizzzy/service/db_model/question_set.dart';
import 'package:quizzzy/theme/font.dart';
import 'package:quizzzy/theme/palette.dart';

/// Renders [Questionnaire] screen which consists of all questions.
///
/// UI and functions will defer according to [userType].
class Questionnaire extends StatefulWidget {
  final Widget topBar;
  final Widget bottomNavBtn;
  final Widget Function(String) renderAnswer;
  final int currentIdx;
  const Questionnaire(
      {Key? key,
      required this.topBar,
      required this.bottomNavBtn,
      required this.renderAnswer,
      required this.currentIdx})
      : super(key: key);

  @override
  State<Questionnaire> createState() => _QuestionnaireState();
}

class _QuestionnaireState extends State<Questionnaire> {
  List<QuestionSet> questionnaire =
      Get.find<QuestionnaireController>().questionnaire;

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
              widget.topBar,
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
                      questionnaire[widget.currentIdx].question,
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
              for (var i in questionnaire[widget.currentIdx].allAns)
                widget.renderAnswer(i),
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
                "${widget.currentIdx + 1} / ${questionnaire.length}",
                style: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: 18,
                    fontWeight: Font.regular,
                    color: Palette.font),
              ),
              widget.bottomNavBtn,
            ],
          ),
        ),
      ],
    ));
  }
}

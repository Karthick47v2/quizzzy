import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:quizzzy/libs/custom_widgets.dart';
import 'package:quizzzy/src/home_page.dart';
import 'package:quizzzy/src/service/db_model/question_set.dart';
import 'package:quizzzy/controllers/questionnaire_controller.dart';

class Score extends StatelessWidget {
  Score({Key? key}) : super(key: key);

  final List<QuestionSet> questionnaire =
      Get.find<QuestionnaireController>().questionnaire;
  final int score = Get.find<QuestionnaireController>().score;

  @override
  Widget build(BuildContext context) {
    var avg = score / questionnaire.length;
    return QuizzzyTemplate(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "$score / ${questionnaire.length}",
            style: const TextStyle(
                fontFamily: 'Heebo',
                fontSize: 17,
                fontWeight: FontWeight.w400,
                color: Colors.white),
            textAlign: TextAlign.center,
          ),
          Text(
            avg == 1
                ? "Great"
                : (avg >= 0.75
                    ? "You have done well"
                    : (avg >= 0.5
                        ? "Not bad. You can still try again"
                        : "Try again later, you can do it.")),
            style: const TextStyle(
                fontFamily: 'Heebo',
                fontSize: 17,
                fontWeight: FontWeight.w400,
                color: Colors.white),
            textAlign: TextAlign.center,
          ),
          QuizzzyNavigatorBtn(
            text: "Continue",
            onTap: () => Get.to(() => const HomePage()),
          ),
          // QuizzzyNavigatorBtn(
          //   text: "Retake",
          //   onTap: () => Get.to(() => const Questionnaire());
          // ),
        ],
      ),
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:quizzzy/libs/custom_widgets.dart';
import 'package:quizzzy/src/home_page.dart';
import 'package:quizzzy/src/service/db_model/question_set.dart';

class Score extends StatelessWidget {
  final int score;
  final List<QuestionSet> questionnaire;

  const Score({Key? key, required this.score, required this.questionnaire})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var avg = score / questionnaire.length;
    // ignore: avoid_print
    print(avg);
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
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomePage())),
          ),
          // QuizzzyNavigatorBtn(
          //   text: "Retake",
          //   onTap: () => Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) =>
          //               Questionnaire(questionnaire: questionnaire))),
          // ),
        ],
      ),
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:quizzzy/libs/custom_widgets.dart';

class Questionnaire extends StatefulWidget {
  final List<Map<String, dynamic>> questionnaire;
  const Questionnaire({Key? key, required this.questionnaire})
      : super(key: key);

  @override
  State<Questionnaire> createState() => _QuestionnaireState();
}

class _QuestionnaireState extends State<Questionnaire> {
  int currentQ = 0;
  int score = 0;

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
              Container(
                padding: const EdgeInsets.fromLTRB(10, 100, 10, 50),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(94, 153, 0, 255),
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                  child: Center(
                    child: Text(
                      widget.questionnaire[currentQ]['question'],
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
              // since query is in complex form, converting it to list is complex.. so decomposing Widgets
              // TODO: Find out a way reduce code
              QuizzzyAns(
                ans: widget.questionnaire[currentQ]['all_ans'][0],
                func: () {
                  setState(() {
                    if (checkAns(
                        widget.questionnaire[currentQ]['all_ans'][0])) {
                      score++;
                    }
                  });
                  ;
                },
              ),
              QuizzzyAns(
                ans: widget.questionnaire[currentQ]['all_ans'][1],
                func: () {
                  setState(() {
                    if (checkAns(
                        widget.questionnaire[currentQ]['all_ans'][1])) {
                      score++;
                    }
                  });
                  ;
                },
              ),
              QuizzzyAns(
                ans: widget.questionnaire[currentQ]['all_ans'][2],
                func: () {
                  setState(() {
                    if (checkAns(
                        widget.questionnaire[currentQ]['all_ans'][2])) {
                      score++;
                    }
                  });
                  ;
                },
              ),
              QuizzzyAns(
                ans: widget.questionnaire[currentQ]['all_ans'][3],
                func: () {
                  setState(() {
                    if (checkAns(
                        widget.questionnaire[currentQ]['all_ans'][3])) {
                      score++;
                    }
                  });
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
              QuizzzyNavigatorBtn(
                text: "Next",
                func: () {
                  setState(() {
                    if (currentQ < widget.questionnaire.length - 1) {
                      currentQ++;
                    } else {
                      print(score);
                    }
                  });
                },
              ),
            ],
          ),
        )
      ],
    ));
  }

  bool checkAns(String ans) {
    return ans.toLowerCase() ==
        widget.questionnaire[currentQ]['crct_ans'].toString().toLowerCase();
  }
}

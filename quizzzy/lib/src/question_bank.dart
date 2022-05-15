import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:quizzzy/libs/custom_widgets.dart';
import 'package:quizzzy/src/questionnaire.dart';
import 'package:quizzzy/src/service/db_model/question_set.dart';
import 'package:quizzzy/src/service/fs_database.dart';

class QuestionBank extends StatefulWidget {
  final List<Object?> data;
  final String status;
  const QuestionBank({Key? key, required this.data, required this.status})
      : super(key: key);

  @override
  State<QuestionBank> createState() => _QuestionBankState();
}

class _QuestionBankState extends State<QuestionBank> {
  late Box questionSetBox;
  setBox() async {
    questionSetBox = await Hive.openBox((user?.displayName)!);
  }

  @override
  initState() {
    super.initState();
    setBox();
    if (widget.status == "Waiting") {
      snackBar(context, "Your last request is being processed.",
          (Colors.amber.shade400));
    }
  }

  @override
  Widget build(BuildContext context) {
    return QuizzzyTemplate(
        body: Column(
      children: [
        Container(
          height: 100,
          alignment: Alignment.bottomCenter,
          width: double.maxFinite,
          child: const Text(
            "Select Questionnaire",
            style: TextStyle(
              fontFamily: 'Heebo',
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: widget.data.length,
            itemBuilder: (context, idx) {
              return QuizzzyCard(
                  title: widget.data[idx].toString(),
                  onLongPress: () {
                    // dlt from local if... and also from cloud
                    showDialog(
                        context: context,
                        builder: (BuildContext cntxt) {
                          return PopupModal(size: 150.0, wids: [
                            const Text(
                              "Do you want to delete this questionnaire?",
                              style: TextStyle(
                                fontFamily: 'Heebo',
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                QuizzzyNavigatorBtn(
                                  text: "Yes",
                                  cont: context,
                                  onTap: () async {
                                    questionSetBox
                                        .delete(widget.data[idx].toString());
                                    bool isOK = await deleteQuestionnaire(
                                        'users/${user!.uid}/${widget.data[idx].toString()}');
                                    snackBar(
                                        context,
                                        isOK
                                            ? "Questionnaire will be deleted in few minutes"
                                            : "Error: Please try again",
                                        isOK
                                            ? (Colors.amber.shade400)
                                            : Colors.red.shade800);
                                    Navigator.of(cntxt).pop();
                                  },
                                ),
                                QuizzzyNavigatorBtn(
                                  text: "No",
                                  cont: context,
                                  onTap: () {
                                    Navigator.of(cntxt).pop();
                                  },
                                ),
                              ],
                            ),
                          ]);
                        });
                  },
                  onTap: () async {
                    // get from local if there is, or else fetch from net and store for future use
                    var questionnaire =
                        questionSetBox.get(widget.data[idx].toString());
                    if (questionnaire == null) {
                      questionnaire =
                          (await getQuestionnaire(widget.data[idx].toString()))
                              .map((e) => (QuestionSet.fromJson(e)))
                              .toList();
                      questionSetBox.put(
                          widget.data[idx].toString(), questionnaire);
                    } else {
                      questionnaire = questionnaire..cast<QuestionSet>();
                    }
                    showDialog(
                        context: context,
                        builder: (BuildContext cntxt) {
                          return PopupModal(size: 150.0, wids: [
                            Text(
                              "Questionnaire: ${widget.data[idx].toString()}",
                              style: const TextStyle(
                                fontFamily: 'Heebo',
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                            Text(
                              "Time: ${questionnaire.length} mins",
                              style: const TextStyle(
                                fontFamily: 'Heebo',
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                            QuizzzyNavigatorBtn(
                              text: "Start",
                              cont: context,
                              onTap: () {
                                Navigator.of(cntxt).pop();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) => Questionnaire(
                                            questionnaire: questionnaire))));
                              },
                            ),
                          ]);
                        });
                  });
            },
          ),
        )
      ],
    ));
  }
}

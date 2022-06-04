import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:quizzzy/libs/custom_widgets.dart';
import 'package:quizzzy/src/questionnaire.dart';
import 'package:quizzzy/src/service/db_model/question_set.dart';
import 'package:quizzzy/src/service/fs_database.dart';
import 'package:quizzzy/src/service/local_database.dart';

class QuestionBank extends StatefulWidget {
  final List<String> data;
  final String status;
  QuestionBank({Key? key, required objData, required this.status})
      : data = objData.map((val) => val.toString()).toList().cast<String>(),
        super(key: key);

  @override
  State<QuestionBank> createState() => _QuestionBankState();
}

class _QuestionBankState extends State<QuestionBank> {
  late List<String>? popList;
  late List<QuestionSet> qSet;

  filterList() async {
    popList = await sharedPref.getPoppedItems();
    if (popList != null) {
      List<String> newList = [];
      for (int i = 0; i < popList!.length; i++) {
        if (widget.data.contains(popList![i])) {
          widget.data.remove(popList![i]);
          newList.add(popList![i]);
        }
      }
      popList = newList;
      sharedPref.setPoppedItems(popList!);
    } else {
      popList = [];
    }
  }

  Future<bool> getQuestions(int idx) async {
    var questionnaire = questionSetBox.get(widget.data[idx]);
    // ignore: unnecessary_null_comparison
    if (questionnaire == null) {
      questionnaire = (await fs.getQuestionnaire(widget.data[idx]))
          .map((e) => (QuestionSet.fromJson(e)))
          .toList();
      questionSetBox.put(widget.data[idx], questionnaire);
    } else {
      questionnaire = questionnaire..cast<QuestionSet>();
      // fake waiting for future builder to work without break
      await Future.delayed(Duration.zero);
    }
    qSet = questionnaire;
    return true;
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
        body: FutureBuilder(
            future: filterList(),
            builder: (context, snapshot) {
              Widget ret = Container();
              if (snapshot.connectionState == ConnectionState.done) {
                ret = Column(
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
                              title: widget.data[idx],
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
                                            fontSize: 19,
                                            fontWeight: FontWeight.w400,
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            QuizzzyNavigatorBtn(
                                              text: "Yes",
                                              onTap: () async {
                                                questionSetBox
                                                    .delete(widget.data[idx]);
                                                if (!await fs.deleteQuestionnaire(
                                                    'users/${fs.user!.uid}/${widget.data[idx]}')) {
                                                  snackBar(
                                                      context,
                                                      "Error: Please try again",
                                                      Colors.red.shade800);
                                                } else {
                                                  popList!
                                                      .add(widget.data[idx]);
                                                  sharedPref
                                                      .setPoppedItems(popList!);
                                                  setState(() {});
                                                }
                                                Navigator.of(cntxt).pop();
                                              },
                                            ),
                                            QuizzzyNavigatorBtn(
                                              text: "No",
                                              onTap: () =>
                                                  Navigator.of(cntxt).pop(),
                                            ),
                                          ],
                                        ),
                                      ]);
                                    });
                              },
                              onTap: () async {
                                var res = getQuestions(idx);
                                showDialog(
                                    context: context,
                                    builder: (BuildContext cntxt) {
                                      return FutureBuilder(
                                          future: res,
                                          builder: (cntxt, snapshot) {
                                            Widget ret = Container();
                                            if (snapshot.connectionState ==
                                                ConnectionState.done) {
                                              ret = PopupModal(
                                                  size: 150.0,
                                                  wids: [
                                                    Text(
                                                      "Questionnaire: ${widget.data[idx]}",
                                                      style: const TextStyle(
                                                        fontFamily: 'Heebo',
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Color.fromARGB(
                                                            255, 255, 255, 255),
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    Text(
                                                      userType == 'Student'
                                                          ? "Time: ${qSet.length} mins"
                                                          : "Questions: ${qSet.length}",
                                                      style: const TextStyle(
                                                        fontFamily: 'Heebo',
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Color.fromARGB(
                                                            255, 255, 255, 255),
                                                      ),
                                                    ),
                                                    QuizzzyNavigatorBtn(
                                                      text:
                                                          userType == 'Student'
                                                              ? "Start"
                                                              : "View",
                                                      cont: context,
                                                      onTap: () {
                                                        Navigator.of(cntxt)
                                                            .pop();
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: ((context) => Questionnaire(
                                                                    questionnaire:
                                                                        qSet,
                                                                    name: widget
                                                                            .data[
                                                                        idx]))));
                                                      },
                                                    ),
                                                  ]);
                                            } else {
                                              ret = const Loading();
                                            }
                                            return ret;
                                          });
                                    });
                              });
                        },
                      ),
                    )
                  ],
                );
              } else {
                ret = const Loading();
              }
              return ret;
            }));
  }
}

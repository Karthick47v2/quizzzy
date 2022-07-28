import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzzy/controllers/question_list_controller.dart';
import 'package:quizzzy/controllers/questionnaire_controller.dart';
import 'package:quizzzy/controllers/user_type_controller.dart';

import 'package:quizzzy/libs/custom_widgets.dart';
import 'package:quizzzy/src/questionnaire.dart';
import 'package:quizzzy/src/service/db_model/question_set.dart';
import 'package:quizzzy/src/service/fs_database.dart';
import 'package:quizzzy/src/service/local_database.dart';

/// Renders list of questionnaire naems on [QuestionBank] screen
///
/// OnClick functions of [QuizzzyNavigatorBtn] will depend on [userType].
class QuestionBank extends StatefulWidget {
  const QuestionBank({Key? key}) : super(key: key);

  @override
  State<QuestionBank> createState() => _QuestionBankState();
}

class _QuestionBankState extends State<QuestionBank> {
  List<String> questionList = Get.find<QuestionListController>().questionList;

  /// Initialize Hive box
  @override
  initState() {
    super.initState();
    setBox();
  }

  @override
  Widget build(BuildContext context) {
    return QuizzzyTemplate(body: GetBuilder<QuestionListController>(
      builder: (controller) {
        return (FutureBuilder(
            future: controller.filterList(),
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
                        itemCount: questionList.length,
                        itemBuilder: (context, idx) {
                          return QuizzzyCard(
                              title: questionList[idx],
                              onLongPress: () {
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
                                                    .delete(questionList[idx]);
                                                if (!await FirestoreService()
                                                    .deleteQuestionnaire(
                                                        '''users/${FirestoreService().user!.uid}/
                                                          ${questionList[idx]}''')) {
                                                  snackBar(
                                                      "Error",
                                                      "Please try again",
                                                      Colors.red.shade800);
                                                } else {
                                                  controller.poppedList!
                                                      .add(questionList[idx]);
                                                  UserSharedPreferences()
                                                      .setPoppedItems(controller
                                                          .poppedList!);
                                                  // setState(() {});
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
                                var res = Get.find<QuestionnaireController>()
                                    .overwriteList(questionList[idx]);
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
                                                      "Questionnaire: ${questionList[idx]}",
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
                                                    GetBuilder<
                                                            QuestionnaireController>(
                                                        builder: (qController) {
                                                      return Text(
                                                        Get.find<UserTypeController>()
                                                                    .userType ==
                                                                'Student'
                                                            ? "Time: ${qController.questionnaire.length} mins"
                                                            : "Questions: ${qController.questionnaire.length}",
                                                        style: const TextStyle(
                                                          fontFamily: 'Heebo',
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Color.fromARGB(
                                                              255,
                                                              255,
                                                              255,
                                                              255),
                                                        ),
                                                      );
                                                    }),
                                                    QuizzzyNavigatorBtn(
                                                      text: Get.find<UserTypeController>()
                                                                  .userType ==
                                                              'Student'
                                                          ? "Start"
                                                          : "View",
                                                      onTap: () {
                                                        Navigator.of(cntxt)
                                                            .pop();
                                                        Get.to(() =>
                                                            const Questionnaire());
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
      },
    ));
  }
}

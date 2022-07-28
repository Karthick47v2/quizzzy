import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:quizzzy/controllers/question_list_controller.dart';
import 'package:quizzzy/controllers/user_type_controller.dart';

import 'package:quizzzy/libs/custom_widgets.dart';
import 'package:quizzzy/src/auth/login.dart';
import 'package:quizzzy/src/import.dart';
import 'package:quizzzy/src/questionnaire.dart';
import 'package:quizzzy/src/service/db_model/question_set.dart';
import 'package:quizzzy/src/service/fbase_auth.dart';
import 'package:quizzzy/src/service/fs_database.dart';
import 'package:quizzzy/src/service/local_database.dart';
import 'package:quizzzy/src/question_bank.dart';
import 'package:quizzzy/src/service/local_notification_service.dart';

/// Renders [HomePage] screen
/// If [firstTime] render user details form, or else show menu. Navigates to appropiate screens
/// repective to [QuizzzyNavigatorBtn] click.
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<String?> userFuture;
  bool firstTime = true;
  final nameController = TextEditingController();
  final codeController = TextEditingController();

  Future<void> pushToken() async {
    questionSetBox = await setBox();
    String? token = await fm.getToken();
    String? oldToken = await UserSharedPreferences().getToken();
    if (oldToken != token) {
      await UserSharedPreferences().setToken(token!);
      await FirestoreService().saveTokenToDatabase(token);
    }
    fm.onTokenRefresh.listen(FirestoreService().saveTokenToDatabase);
  }

  @override
  initState() {
    super.initState();
    pushToken();
    userFuture = FirestoreService().getUserType();
  }

  @override
  Widget build(BuildContext context) {
    return QuizzzyTemplate(
        body: FutureBuilder(
      future: userFuture,
      builder: (context, snapshot) {
        Widget ret = Container();
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == null && firstTime) {
            ret = Builder(
                builder: (context) => Column(
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: Image.asset(
                              'assets/images/Quizzzy.png',
                            ),
                          ),
                        ),
                        QuizzzyTextInput(
                            text: "Name", controller: nameController),
                        Container(
                          width: double.maxFinite - 20,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 0),
                          alignment: Alignment.bottomCenter,
                          child: Column(children: [
                            SizedBox(
                              width: double.maxFinite - 20,
                              child: QuizzzyNavigatorBtn(
                                text: "I'm a Teacher",
                                onTap: () {
                                  sendUserType(
                                      context, nameController.text, true);
                                  setState(() {
                                    // user will stuck at user type assign if network is slow, so
                                    // bypassing fireabse response (only needed for first time use)
                                    firstTime = false;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: double.maxFinite - 20,
                              child: QuizzzyNavigatorBtn(
                                  text: "I'm a Student",
                                  onTap: () {
                                    sendUserType(
                                        context, nameController.text, false);
                                    setState(() {
                                      firstTime = false;
                                    });
                                  }),
                            ),
                          ]),
                        )
                      ],
                    ));
          } else {
            Get.find<UserTypeController>().setUserType(snapshot.data as String);
            ret = (Builder(
              builder: (context) => Column(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/Quizzzy.png',
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                    child: Column(children: [
                      SizedBox(
                        width: double.maxFinite - 20,
                        child: QuizzzyNavigatorBtn(
                          text: "Import PDF",
                          onTap: () => Get.to(() => const ImportFile()),
                        ),
                      ),
                      SizedBox(
                        width: double.maxFinite - 20,
                        child: QuizzzyNavigatorBtn(
                            text: "Question Bank",
                            onTap: () {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext cntxt) {
                                    checkQuesGenerated(cntxt);
                                    return const Loading();
                                  });

                              // print("hi");
                            }),
                      ),
                      snapshot.data == "Student"
                          ? SizedBox(
                              width: double.maxFinite - 20,
                              child: QuizzzyNavigatorBtn(
                                text: "Attempt quiz",
                                onTap: () async {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext cntxt) {
                                        return StatefulBuilder(
                                            builder: (cntxt, setState) {
                                          return PopupModal(size: 200.0, wids: [
                                            Column(
                                              children: [
                                                QuizzzyTextInput(
                                                  text: "Enter code",
                                                  controller: codeController,
                                                ),
                                                QuizzzyNavigatorBtn(
                                                  text: "Confirm",
                                                  onTap: () async {
                                                    // var questionnaire =
                                                    //     (await FirestoreService()
                                                    //             .dummyGetQuestionnaire())
                                                    //         .map((e) =>
                                                    //             (QuestionSet
                                                    //                 .fromJson(
                                                    //                     e)))
                                                    //         .toList();
                                                    Navigator.pop(cntxt);
                                                    Get.to(() =>
                                                        const Questionnaire());
                                                  },
                                                )
                                              ],
                                            ),
                                          ]);
                                        });
                                      });
                                },
                              ),
                            )
                          : SizedBox(
                              width: double.maxFinite - 20,
                              child: QuizzzyNavigatorBtn(
                                  text: "Saved quiz",
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext cntxt) {
                                          checkQuesGenerated(cntxt);
                                          return const Loading();
                                        });
                                  }),
                            ),
                      SizedBox(
                        width: double.maxFinite - 20,
                        child: QuizzzyNavigatorBtn(
                          text: "Review quizzes",
                          onTap: () => Get.to(() => const HomePage()),
                        ),
                      ),
                      SizedBox(
                        width: double.maxFinite - 20,
                        child: QuizzzyNavigatorBtn(
                          text: "Log out",
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext cntxt) {
                                  return PopupModal(size: 150.0, wids: [
                                    const Text(
                                      "Are you sure ?",
                                      style: TextStyle(
                                          fontFamily: 'Heebo',
                                          fontSize: 19,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        QuizzzyNavigatorBtn(
                                          text: "Yes",
                                          onTap: () async {
                                            String res =
                                                await Auth().userSignout();
                                            if (res == "Success") {
                                              Navigator.of(cntxt).pop();
                                              Get.to(() => const Login());
                                            } else {
                                              snackBar("Error", res,
                                                  Colors.red.shade800);
                                            }
                                          },
                                        ),
                                        QuizzzyNavigatorBtn(
                                          text: "No",
                                          onTap: () =>
                                              Navigator.of(cntxt).pop(),
                                        )
                                      ],
                                    )
                                  ]);
                                });
                          },
                        ),
                      ),
                      SizedBox(
                        width: double.maxFinite - 20,
                        child: QuizzzyNavigatorBtn(
                          text: "Quit",
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext cntxt) {
                                  return PopupModal(size: 150.0, wids: [
                                    const Text(
                                      "Are you sure ?",
                                      style: TextStyle(
                                          fontFamily: 'Heebo',
                                          fontSize: 19,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        QuizzzyNavigatorBtn(
                                          text: "Yes",
                                          onTap: () => SystemNavigator
                                              .pop(), // it will only suspend app for iOS,
                                        ), // need to manually close in iOS as of iOS policy ...
                                        QuizzzyNavigatorBtn(
                                          text: "No",
                                          onTap: () =>
                                              Navigator.of(cntxt).pop(),
                                        )
                                      ],
                                    )
                                  ]);
                                });
                          },
                        ),
                      )
                    ]),
                  )
                ],
              ),
            ));
          }
        } else {
          ret = const Loading();
        }
        return ret;
      },
    ));
  }

  /// Check if prevoius request got served.
  ///
  /// Returns wheter previous request state is finished or not.
  Future<void> checkQuesGenerated(BuildContext context) async {
    List<Object?> data = await FirestoreService().getQuestionnaireNameList();
    Get.find<QuestionListController>().overwriteList(data);

    String? str = await FirestoreService().getGeneratorStatus();
    if (str == "Generated" || data.isNotEmpty) {
      Get.to(() => const QuestionBank());
    } else {
      Navigator.pop(context);
      snackBar(
          "...",
          str == "Waiting"
              ? "Please wait for questions to get generated"
              : "Please upload a document to generate questions",
          (Colors.amber.shade400));
    }
  }
}

/// Store user type on database
///
/// Throws error if any server error occurs
Future sendUserType(
  BuildContext context,
  String str,
  bool isTeacher,
) async {
  // explicitly initialize inorder to reload
  User? user = Auth().auth.currentUser;

  await user!.reload();
  await user.updateDisplayName(str);
  await user.reload();
  user = Auth().auth.currentUser;

  if (!await FirestoreService()
      .saveUser(true, name: str, type: isTeacher ? 'Teacher' : 'Student')) {
    snackBar("Error", "Internal server error", (Colors.red.shade800));
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizzzy/src/auth/login.dart';
import 'package:quizzzy/src/import.dart';
import 'package:quizzzy/src/service/db_model/question_set.dart';
import 'package:quizzzy/src/service/fbase_auth.dart';
import 'package:quizzzy/src/service/fs_database.dart';
import 'package:quizzzy/src/service/local_database.dart';
import 'package:quizzzy/src/service/dynamic_links.dart';
import 'package:quizzzy/src/question_bank.dart';
import '../libs/custom_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<String?> userFuture;
  bool firstTime = true;
  final nameController = TextEditingController();

  Future<void> pushToken() async {
    questionSetBox = await setBox();
    String? token = await FirebaseMessaging.instance.getToken();
    String? oldToken = await sharedPref.getToken();
    if (oldToken != token) {
      await sharedPref.setToken(token!);
      await fs.saveTokenToDatabase(token);
    }
    FirebaseMessaging.instance.onTokenRefresh.listen(fs.saveTokenToDatabase);
  }

  @override
  initState() {
    super.initState();
    pushToken();
    userFuture = fs.getUserType();
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
                          cont: context,
                          page: const ImportFile(),
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
                                text: "Saved questionnaire",
                                onTap: () async {
                                  await dlink.generateDynamicLink(
                                      "teacherID", "quizID");
                                },
                              ),
                            )
                          : SizedBox(
                              width: double.maxFinite - 20,
                              child: QuizzzyNavigatorBtn(
                                text: "Saved quiz",
                                cont: context,
                                page: HomePage(),
                              ),
                            ),
                      SizedBox(
                        width: double.maxFinite - 20,
                        child: QuizzzyNavigatorBtn(
                          text: "Review quizzes",
                          cont: context,
                          page: HomePage(),
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
                                                await auth.userSignout();
                                            if (res == "Success") {
                                              Navigator.of(cntxt).pop();
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: ((context) =>
                                                          const Login())));
                                            } else {
                                              snackBar(context, res,
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

  Future<void> checkQuesGenerated(BuildContext context) async {
    List<Object?> data = await fs.getQuestionnaireNameList();
    String? str = await fs.getGeneratorStatus();
    if (str == "Generated" || data.isNotEmpty) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => QuestionBank(objData: data, status: str)));
    } else {
      Navigator.pop(context);
      snackBar(
          context,
          str == "Waiting"
              ? "Please wait for questions to get generated"
              : "Please upload a document to generate questions",
          (Colors.amber.shade400));
    }
  }
}

Future sendUserType(
  BuildContext context,
  String str,
  bool isTeacher,
) async {
  // explicitly initialize inorder to reload
  User? user = FirebaseAuth.instance.currentUser;

  await user!.reload();
  await user.updateDisplayName(str);
  await user.reload();
  user = FirebaseAuth.instance.currentUser;

  if (!await fs.saveUser(str, isTeacher ? 'Teacher' : 'Student')) {
    snackBar(context, "Internal server error", (Colors.red.shade800));
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:quizzzy/src/import.dart';
import 'package:quizzzy/src/service/fs_database.dart';
import 'package:quizzzy/src/service/local_database.dart';
import 'package:quizzzy/src/teacher/review_quiz.dart';
import 'package:quizzzy/src/teacher/saved_questions.dart';
import 'package:quizzzy/src/student/saved_quiz.dart';
import 'package:quizzzy/src/question_bank.dart';
import 'package:quizzzy/src/userType.dart';
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
    String? token = await FirebaseMessaging.instance.getToken();
    String? oldToken = await UserSharedPrefernces.getToken();
    if (oldToken != token) {
      await UserSharedPrefernces.setToken(token!);
      await saveTokenToDatabase(token);
    }
    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
  }

  @override
  initState() {
    super.initState();
    pushToken();
    userFuture = getUserType();
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
            ret = UserType(firstTime: firstTime);
            // ret = Builder(
            //     builder: (context) => Column(
            //           children: [
            //             Expanded(
            //               child: Container(
            //                 alignment: Alignment.center,
            //                 child: Image.asset(
            //                   'assets/images/Quizzzy.png',
            //                 ),
            //               ),
            //             ),
            //             QuizzzyTextInput(
            //                 text: "Name", controller: nameController),
            //             Container(
            //               width: double.maxFinite - 20,
            //               padding: const EdgeInsets.symmetric(
            //                   horizontal: 30, vertical: 0),
            //               alignment: Alignment.bottomCenter,
            //               child: Column(children: [
            //                 SizedBox(
            //                   width: double.maxFinite - 20,
            //                   child: QuizzzyNavigatorBtn(
            //                     text: "I'm a Teacher",
            //                     onTap: () => {
            //                       sendUserType(
            //                           context, nameController.text, true),
            //                       setState(() {
            //                         // user will stuck at user type assign if network is slow, so
            //                         // bypassing fireabse response (only needed for first time use)
            //                         firstTime = false;
            //                       })
            //                     },
            //                   ),
            //                 ),
            //                 SizedBox(
            //                   width: double.maxFinite - 20,
            //                   child: QuizzzyNavigatorBtn(
            //                       text: "I'm a Student",
            //                       onTap: () => {
            //                             sendUserType(context,
            //                                 nameController.text, false),
            //                             setState(() {
            //                               firstTime = false;
            //                             }),
            //                           }),
            //                 ),
            //               ]),
            //             )
            //           ],
            //         ));
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
                          route: MaterialPageRoute(
                              builder: (context) => const ImportFile()),
                        ),
                      ),
                      SizedBox(
                        width: double.maxFinite - 20,
                        child: QuizzzyNavigatorBtn(
                            text: "Question Bank",
                            onTap: () => {checkQuesGenerated(context)}),
                      ),
                      snapshot.data == "Student"
                          ? SizedBox(
                              width: double.maxFinite - 20,
                              child: QuizzzyNavigatorBtn(
                                text: "Saved questionnaire",
                                cont: context,
                                route: MaterialPageRoute(
                                    builder: (context) =>
                                        const SavedQuestions()),
                              ),
                            )
                          : SizedBox(
                              width: double.maxFinite - 20,
                              child: QuizzzyNavigatorBtn(
                                text: "Saved quiz",
                                cont: context,
                                route: MaterialPageRoute(
                                    builder: (context) => const SavedQuiz()),
                              ),
                            ),
                      SizedBox(
                        width: double.maxFinite - 20,
                        child: QuizzzyNavigatorBtn(
                          text: "Review quizzes",
                          cont: context,
                          route: MaterialPageRoute(
                              builder: (context) => const ReviewQuiz()),
                        ),
                      ),
                      SizedBox(
                        width: double.maxFinite - 20,
                        child: QuizzzyNavigatorBtn(
                          text: "Log out",
                          cont: context,
                          route: MaterialPageRoute(
                              builder: (context) => const ReviewQuiz()),
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
    List<Object?> data = await getQuestionnaireNameList('users/${user!.uid}');
    String? str = await getGeneratorStatus();
    if (str == "Generated" || data.isNotEmpty) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => QuestionBank(data: data, status: str!)));
    } else {
      snackBar(
          context,
          str == "Waiting"
              ? "Please wait for questions to get generated"
              : "Please upload a document to generate questions",
          (Colors.amber.shade400));
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

    if (!await saveUser((user?.uid)!, isTeacher ? 'Teacher' : 'Student')) {
      snackBar(context, "Internal server error", (Colors.red.shade800));
    }
  }
}

//////////////////////////////// await user?.delete()

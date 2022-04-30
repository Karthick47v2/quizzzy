import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizzzy/src/import.dart';
import 'package:quizzzy/src/service/fs_database.dart';
import 'package:quizzzy/src/teacher/review_quiz.dart';
import 'package:quizzzy/src/teacher/saved_questions.dart';
import 'package:quizzzy/src/student/saved_quiz.dart';
import 'package:quizzzy/src/generated.dart';
import '../libs/custom_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<String?> userFuture;
  bool firstTime = false; ////////////////////////////////////////////// true
  final nameController = TextEditingController();

  @override
  void initState() {
    userFuture = getUserType();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: MaterialApp(
          home: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: const Color.fromARGB(255, 37, 37, 37),
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
                                  CustomTextInput(
                                      text: "Name", controller: nameController),
                                  Container(
                                    width: double.maxFinite - 20,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 0),
                                    alignment: Alignment.bottomCenter,
                                    child: Column(children: [
                                      SizedBox(
                                        width: double.maxFinite - 20,
                                        child: CustomNavigatorBtn(
                                          text: "I'm a Teacher",
                                          func: () => {
                                            sendUserType(context,
                                                nameController.text, true),
                                            setState(() {
                                              // user will stuck at user type assign if network is slow, so
                                              // bypassing fireabse response (only needed for first time use)
                                              firstTime = false;
                                            })
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: double.maxFinite - 20,
                                        child: CustomNavigatorBtn(
                                            text: "I'm a Student",
                                            func: () => {
                                                  sendUserType(
                                                      context,
                                                      nameController.text,
                                                      false),
                                                  setState(() {
                                                    firstTime = false;
                                                  }),
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 0),
                              child: Column(children: [
                                SizedBox(
                                  width: double.maxFinite - 20,
                                  child: CustomNavigatorBtn(
                                    text: "Import PDF",
                                    cont: context,
                                    route: MaterialPageRoute(
                                        builder: (context) =>
                                            const ImportFile()),
                                  ),
                                ),
                                SizedBox(
                                  width: double.maxFinite - 20,
                                  child: CustomNavigatorBtn(
                                      text: "Generated",
                                      func: () =>
                                          {checkQuesGenerated(context)}),
                                ),
                                snapshot.data == "Student"
                                    ? SizedBox(
                                        width: double.maxFinite - 20,
                                        child: CustomNavigatorBtn(
                                          text: "Saved questionnaire",
                                          cont: context,
                                          route: MaterialPageRoute(
                                              builder: (context) =>
                                                  const SavedQuestions()),
                                        ),
                                      )
                                    : SizedBox(
                                        width: double.maxFinite - 20,
                                        child: CustomNavigatorBtn(
                                          text: "Saved quiz",
                                          cont: context,
                                          route: MaterialPageRoute(
                                              builder: (context) =>
                                                  const SavedQuiz()),
                                        ),
                                      ),
                                SizedBox(
                                  width: double.maxFinite - 20,
                                  child: CustomNavigatorBtn(
                                    text: "Review quizzes",
                                    cont: context,
                                    route: MaterialPageRoute(
                                        builder: (context) =>
                                            const ReviewQuiz()),
                                  ),
                                ),
                                SizedBox(
                                  width: double.maxFinite - 20,
                                  child: CustomNavigatorBtn(
                                    text: "Log out",
                                    cont: context,
                                    route: MaterialPageRoute(
                                        builder: (context) =>
                                            const ReviewQuiz()),
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
              ))),
    );
  }
}

Future<void> checkQuesGenerated(BuildContext context) async {
  String? str = await getGeneratorStatus();
  if (str == "Generated") {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Generated()));
  } else {
    snackBar(
        context,
        str == "Waiting"
            ? "Please wait for questions to get generated"
            : "Please upload a document to generate questions",
        (Colors.amber.shade400));
  }
}

Future<void> sendUserType(
  BuildContext context,
  String str,
  bool isTeacher,
) async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  User? user = FirebaseAuth.instance.currentUser;

  await user!.reload();
  await user.updateDisplayName(str);
  await user.reload();
  user = FirebaseAuth.instance.currentUser;

  await users.doc(user?.uid).set({
    'name': user?.displayName,
    'userType': isTeacher ? 'Teacher' : 'Student'
  }, SetOptions(merge: true)).catchError(
      (err) => snackBar(context, err.toString(), (Colors.red.shade800)));
}
//////////////////////////////// await user?.delete()

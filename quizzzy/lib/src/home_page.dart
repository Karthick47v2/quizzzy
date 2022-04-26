import 'package:flutter/material.dart';
import 'package:quizzzy/src/import.dart';
import 'package:quizzzy/src/service/fs_database.dart';
import 'package:quizzzy/src/teacher/review_quiz.dart';
import 'package:quizzzy/src/teacher/saved_questions.dart';
import 'package:quizzzy/src/student/saved_quiz.dart';
import '../libs/custom_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<bool> userFuture;

  @override
  void initState() {
    userFuture = getUserType();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            backgroundColor: const Color.fromARGB(255, 37, 37, 37),
            body: FutureBuilder(
              future: userFuture,
              builder: (context, snapshot) {
                Widget ret = Container();
                if (snapshot.connectionState == ConnectionState.done) {
                  ret = (Builder(
                    builder: (context) => Stack(
                      alignment: Alignment.center,
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/images/Quizzzy.png',
                            width: 229,
                            height: 278,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomNavigatorBtn(
                              text: "Import PDF",
                              bt: 340.0,
                              h: 59.0,
                              w: 197.0,
                              cont: context,
                              route: MaterialPageRoute(
                                  builder: (context) => const ImportFile()),
                            ),
                            snapshot.data == true
                                ? CustomNavigatorBtn(
                                    text: "Saved questions",
                                    bt: 240.0,
                                    h: 59.0,
                                    w: 220.0,
                                    cont: context,
                                    route: MaterialPageRoute(
                                        builder: (context) =>
                                            const SavedQuestions()),
                                  )
                                : CustomNavigatorBtn(
                                    text: "Saved quiz",
                                    bt: 240.0,
                                    h: 59.0,
                                    w: 220.0,
                                    cont: context,
                                    route: MaterialPageRoute(
                                        builder: (context) =>
                                            const SavedQuiz()),
                                  ),
                            CustomNavigatorBtn(
                              text: "Review quizzes",
                              bt: 140.0,
                              h: 59.0,
                              w: 220.0,
                              cont: context,
                              route: MaterialPageRoute(
                                  builder: (context) => const ReviewQuiz()),
                            ),
                            CustomNavigatorBtn(
                              text: "Log out",
                              bt: 40.0,
                              h: 59.0,
                              w: 160.0,
                              cont: context,
                              route: MaterialPageRoute(
                                  builder: (context) => const ReviewQuiz()),
                            ),
                          ],
                        )
                      ],
                    ),
                  ));
                } else {
                  ret = const CircularProgressIndicator(
                    color: Color.fromARGB(255, 93, 0, 155),
                    backgroundColor: Colors.grey,
                  );
                }
                return ret;
              },
            )));
  }
}

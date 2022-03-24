import 'package:flutter/material.dart';
import 'package:quizzzy/import.dart';
import 'package:quizzzy/review_quiz.dart';
import 'package:quizzzy/saved_questions.dart';
import 'custom_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override 
    Widget build(BuildContext context) {
      return MaterialApp(
        home: Scaffold(
          backgroundColor: const Color.fromARGB(255, 37, 37, 37),
          body: Builder(
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
                      bt: 240.0, 
                      h: 59.0,
                      w: 197.0, 
                      cont: context,
                      route: MaterialPageRoute(builder: (context) => const ImportFile()),
                      ),
                    CustomNavigatorBtn(
                      text: "Saved questions", 
                      bt: 140.0, 
                      h: 59.0, 
                      w: 220.0,
                      cont: context,
                      route: MaterialPageRoute(builder: (context) => const SavedQuestions()),
                      ),
                    CustomNavigatorBtn(
                      text: "Review quizzes", 
                      bt: 40.0, 
                      h: 59.0, 
                      w: 220.0,
                      cont: context,
                      route: MaterialPageRoute(builder: (context) => const ReviewQuiz()),
                      ),
                  ],
                )
              ],
            ),
          )
        )
      );
    }
}
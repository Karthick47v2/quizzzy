import 'package:flutter/material.dart';

class ReviewQuiz extends StatefulWidget {
  const ReviewQuiz({Key? key}) : super(key: key);

  @override
  State<ReviewQuiz> createState() => _ReviewQuizState();
}

class _ReviewQuizState extends State<ReviewQuiz> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Container());
  }
}

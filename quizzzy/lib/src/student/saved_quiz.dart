import 'package:flutter/material.dart';

class SavedQuiz extends StatefulWidget {
  const SavedQuiz({Key? key}) : super(key: key);

  @override
  State<SavedQuiz> createState() => _SavedQuizState();
}

class _SavedQuizState extends State<SavedQuiz> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Container());
  }
}

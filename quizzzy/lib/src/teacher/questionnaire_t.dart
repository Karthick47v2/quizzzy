import 'package:flutter/material.dart';
import 'package:quizzzy/src/questionnaire.dart';
import 'package:quizzzy/src/service/db_model/question_set.dart';

class QuestionnaireT extends Questionnaire {
  const QuestionnaireT({Key? key, required List<QuestionSet> questionnaire})
      : super(key: key, questionnaire: questionnaire);

  @override
  State<QuestionnaireT> createState() => _QuestionnaireTState();
}

class _QuestionnaireTState extends State<QuestionnaireT> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

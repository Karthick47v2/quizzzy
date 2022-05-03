import 'package:hive/hive.dart';

part 'question_set.g.dart';

@HiveType(typeId: 1)
class QuestionSet extends HiveObject {
  @HiveField(0)
  String question;
  @HiveField(1)
  String crctAns;
  @HiveField(2)
  List<String> allAns;

  QuestionSet(
      {required this.question, required this.crctAns, required this.allAns});

  factory QuestionSet.fromJson(Map<String, dynamic> parsedJson) {
    return QuestionSet(
        question: parsedJson['question'],
        crctAns: parsedJson['crct_ans'],
        allAns: parsedJson['all_ans'].cast<String>());
  }
}

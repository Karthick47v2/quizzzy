import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:quizzzy/src/service/fs_database.dart';

part 'question_set.g.dart';

@HiveType(typeId: 1)
class QuestionSet extends HiveObject {
  @HiveField(0)
  final String question;
  @HiveField(1)
  final String crctAns;
  @HiveField(2)
  final List<String> allAns;

  QuestionSet(
      {required this.question, required this.crctAns, required this.allAns});

  factory QuestionSet.fromJson(Map<String, dynamic> parsedJson) {
    return QuestionSet(
        question: parsedJson['question'],
        crctAns: parsedJson['crct_ans'],
        allAns: parsedJson['all_ans'].cast<String>());
  }

  factory QuestionSet.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return QuestionSet(
        question: data?['question'],
        crctAns: data?['crctAns'],
        allAns: List.from(data?['allAns']));
  }

  Map<String, dynamic> toFirestore() {
    return ({
      'question': question,
      'crctAns': crctAns,
      'allAns': allAns,
    });
  }
}

late Box questionSetBox;
Future setBox() async => await Hive.openBox((fs.user!.displayName)!);

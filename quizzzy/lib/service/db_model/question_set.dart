import 'package:hive/hive.dart';

import 'package:quizzzy/service/fs_database.dart';

part 'question_set.g.dart';

/// Generate type adapter to store custom object [QuestionSet] in [Hive].
///
/// A [QuestionSet] object contains [question], [crctAns] and [allAns] which is a list of 4
/// answers (3 false + 1 true)
@HiveType(typeId: 1)
class QuestionSet extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String question;
  @HiveField(2)
  final String crctAns;
  @HiveField(3)
  final List<String> allAns;

  QuestionSet(
      {required this.id,
      required this.question,
      required this.crctAns,
      required this.allAns});

  /// Generates object from json
  factory QuestionSet.fromJson(Map<String, dynamic> parsedJson, String id) {
    return QuestionSet(
        id: id,
        question: parsedJson['question'],
        crctAns: parsedJson['crct_ans'],
        allAns: parsedJson['all_ans'].cast<String>());
  }
}

late Box localStorage;
Future setBox() async =>
    await Hive.openBox((FirestoreService().user!.displayName)!);

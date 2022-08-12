import 'package:flutter_test/flutter_test.dart';
import 'package:quizzzy/service/db_model/question_set.dart';

main() {
  late Map<String, dynamic> apiRes;
  late QuestionSet obj;

  const String id = '0';
  setUp(() {
    String question = '_';
    String crctAns = '_';
    List<String> allAns = ['_', '_'];
    apiRes = {
      'question': question,
      'crct_ans': crctAns,
      'all_ans': allAns,
    };
    obj = QuestionSet(
        id: id, question: question, crctAns: crctAns, allAns: allAns);
  });
  test('Parsing API response', () {
    expect(QuestionSet.fromJson(apiRes, id).toString(), obj.toString());
  });
}

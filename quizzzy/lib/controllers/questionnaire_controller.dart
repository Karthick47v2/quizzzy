import 'package:get/get.dart';
import 'package:quizzzy/src/service/db_model/question_set.dart';
import 'package:quizzzy/src/service/fs_database.dart';

class QuestionnaireController extends GetxController {
  String _questionnaireName = "";
  List<QuestionSet> _questionnaire = [];
  int _time = 0;
  int _score = 0;

  List<QuestionSet> get questionnaire => _questionnaire;
  String get questionnaireName => _questionnaireName;
  int get score => _score;
  int get time => _time;

  Future<bool> overwriteList(String qName) async {
    _questionnaireName = qName;
    var dummy = questionSetBox.get(qName);

    if (dummy == null) {
      dummy = (await FirestoreService().getQuestionnaire(qName))
          .map((e) => (QuestionSet.fromJson(e)))
          .toList();
      questionSetBox.put(qName, dummy);
    } else {
      dummy = dummy..cast<QuestionSet>();

      /// Fake delay for future builder to work without break
      await Future.delayed(Duration.zero);
    }
    _questionnaire = dummy;
    update();
    return true;
  }

  storeTime(int time) {
    _time = time;
    update();
  }

  scoreInc() {
    _score++;
    update();
  }
}

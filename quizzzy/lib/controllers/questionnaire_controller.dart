import 'package:get/get.dart';

import 'package:quizzzy/service/db_model/question_set.dart';
import 'package:quizzzy/service/fs_database.dart';

class QuestionnaireController extends GetxController {
  String _questionnaireName = "";
  List<String> _removalList = [];
  List<QuestionSet> _questionnaire = [];
  int _score = 0;

  List<QuestionSet> get questionnaire => _questionnaire;
  List<String> get removalList => _removalList;
  String get questionnaireName => _questionnaireName;
  int get score => _score;
  double get avg => _score / questionnaire.length;

  Future<bool> overwriteList(String qName) async {
    _questionnaireName = qName;
    var dummy = localStorage.get(qName);
    if (dummy == null) {
      _questionnaire = (await FirestoreService().getQuestionnaire(qName))
          .map((e) => (QuestionSet.fromJson(e.data(), e.id)))
          .toList();
      sendToLocal();
    } else {
      _questionnaire = dummy.cast<QuestionSet>();

      /// Fake delay for future builder to work without break
      await Future.delayed(Duration.zero);
    }
    update();
    return true;
  }

  addToRemovalList(String n) {
    _removalList.add(n);
    update();
  }

  overwriteRemovalList() {
    _removalList = [
      for (int i = 0; i < _questionnaire.length; i++) _questionnaire[i].id
    ];
    update();
  }

  resetRemovalList() {
    _removalList.clear();
    update();
  }

  sendToLocal() {
    localStorage.put(_questionnaireName, _questionnaire);
  }

  scoreInc() {
    _score++;
    update();
  }
}

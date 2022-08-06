import 'package:get/get.dart';

import 'package:quizzzy/service/db_model/question_set.dart';
import 'package:quizzzy/service/firestore_db.dart';

class QuestionnaireController extends GetxController {
  String _questionnaireName = "";
  String _authorCode = "";
  List<String> _removalList = [];
  List<QuestionSet> _questionnaire = [];
  int _score = 0;

  /// List of [QuestionSet] for single questionniare.
  List<QuestionSet> get questionnaire => _questionnaire;

  /// List of ids of questions that needs to be removed.
  List<String> get removalList => _removalList;

  /// Questionnaire author's (aka teacher's) uid.
  String get author => _authorCode;

  /// Name of questionniare
  String get questionnaireName => _questionnaireName;

  /// Score attained by user.
  int get score => _score;

  /// Score percentage attained by user.
  double get avg => _score / questionnaire.length;

  /// Fetch List of [QuestionSet] from local(if any) or remote.
  Future<bool> overwriteList(String qName, {String userID = ""}) async {
    _questionnaireName = qName;
    var dummy = localStorage.get(qName);
    if (dummy == null) {
      _questionnaire =
          (await FirestoreService().getQuestionnaire(qName, userID))
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

  /// Update removal list.
  addToRemovalList(String n) {
    _removalList.add(n);
    update();
  }

  /// Add all quesions' id to list.
  overwriteRemovalList() {
    _removalList = [
      for (int i = 0; i < _questionnaire.length; i++) _questionnaire[i].id
    ];
    update();
  }

  /// Reset.
  resetRemovalList() {
    _removalList.clear();
    update();
  }

  /// Store to local database.
  sendToLocal() {
    localStorage.put(_questionnaireName, _questionnaire);
  }

  /// Increase score.
  scoreInc() {
    _score++;
    update();
  }

  /// Set questionnaire author id
  setAuthor(String code) {
    _authorCode = code;
  }
}

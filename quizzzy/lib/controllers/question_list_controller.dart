import 'package:get/get.dart';

import 'package:quizzzy/controllers/questionnaire_controller.dart';
import 'package:quizzzy/service/db_model/question_set.dart';

class QuestionListController extends GetxController {
  String listKey = 'completedList';
  List<String> _questionList = [];
  List<String> _completedList = [];

  /// List of questionnaire names, fetched from firestore.
  List<String> get questionList => _questionList;

  /// List of completed questions, fetched from local storage.
  List<String> get completedList => _loadCompletedList();

  /// Add to questions list.
  overwriteList(List<Object?> data) {
    _questionList = data.map((val) => val.toString()).toList().cast<String>();
    update();
  }

  /// Fetch completed list from local storage.
  List<String> _loadCompletedList() {
    _completedList = localStorage.get(listKey, defaultValue: []).cast<String>();
    update();
    return _completedList;
  }

  /// Update completed list.
  updateCompletedList() {
    String quiz = Get.find<QuestionnaireController>().questionnaireName;
    _loadCompletedList();
    if (!(_completedList.contains(quiz))) {
      _completedList.add(quiz);
    }
    localStorage.put(listKey, _completedList);
    update();
  }
}

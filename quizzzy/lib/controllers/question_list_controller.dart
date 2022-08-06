import 'package:get/get.dart';

class QuestionListController extends GetxController {
  List<String> _questionList = [];

  /// List of questionnaire names, fetched from firestore.
  List<String> get questionList => _questionList;

  overwriteList(List<Object?> data) {
    _questionList = data.map((val) => val.toString()).toList().cast<String>();
    update();
  }
}

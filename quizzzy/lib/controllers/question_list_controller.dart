import 'package:get/get.dart';

import 'package:quizzzy/service/local_database.dart';

class QuestionListController extends GetxController {
  List<String> _questionList = [];
  List<String>? _poppedList;

  List<String> get questionList => _questionList;
  List<String>? get poppedList => _poppedList;

  overwriteList(List<Object?> data) {
    _questionList = data.map((val) => val.toString()).toList().cast<String>();
    update();
  }

  /// As Firestore takes few minutes to delete documents, Manully altering [questionList] when user
  /// deletes a questionniare.
  Future<bool> filterList() async {
    _poppedList = await UserSharedPreferences().getPoppedItems();
    if (_poppedList != null) {
      List<String> newList = [];
      for (int i = 0; i < _poppedList!.length; i++) {
        if (_questionList.contains(_poppedList![i])) {
          _questionList.remove(_poppedList![i]);
          newList.add(_poppedList![i]);
        }
      }
      _poppedList = newList;
      UserSharedPreferences().setPoppedItems(_poppedList!);
    } else {
      _poppedList = [];
    }
    update();
    return true;
  }
}

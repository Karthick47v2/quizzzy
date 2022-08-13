import 'dart:collection';

import 'package:get/get.dart';

class Result {
  String name;
  double score;

  Result(this.name, this.score);
}

class QuizController extends GetxController {
  HashMap<String, List<Result>> results = HashMap<String, List<Result>>();

  // ignore: prefer_final_fields
  List<HashMap<String, double>> _processedList = [];

  List<String> get quizList => results.keys.toList();

  HashMap<String, double> getPieList(int n) {
    return _processedList[n];
  }

  bool setupQuizInfo(Map<String, dynamic> info) {
    info.forEach((key, value) {
      HashMap<String, double> temp = HashMap<String, double>();
      List<Result> tempList = [];
      value.forEach((k, v) {
        String keyString = v >= 0.75
            ? ">= 75%"
            : (v >= 0.5 ? ">=0.5" : (v >= 0.3 ? ">=0.3" : "<0.3"));
        tempList.add(Result(k, v * 100));
        double d = temp[keyString] ?? 0;
        temp[keyString] = ++d;
        temp[k] = v * 100;
      });
      results[key] = tempList;
      _processedList.add(temp);
    });
    return _processedList.isNotEmpty;
  }
}

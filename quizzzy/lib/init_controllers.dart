import 'package:get/get.dart';
import 'package:quizzzy/controllers/question_list_controller.dart';
import 'package:quizzzy/controllers/questionnaire_controller.dart';

import 'package:quizzzy/controllers/user_type_controller.dart';

Future initControllers() async {
  Get.lazyPut(() => UserTypeController());
  Get.lazyPut(() => QuestionListController());
  Get.lazyPut(() => QuestionnaireController());
}

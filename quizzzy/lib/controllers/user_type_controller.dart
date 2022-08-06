import 'package:get/get.dart';

enum UserType { none, teacher, student }

class UserTypeController extends GetxController {
  UserType _userType = UserType.none;

  UserType get userType => _userType;

  setUserType(String str) {
    _userType = str == "Student" ? UserType.student : UserType.teacher;
    update();
  }
}

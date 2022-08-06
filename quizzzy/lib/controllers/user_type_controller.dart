import 'package:get/get.dart';

enum UserType { none, teacher, student }

enum Mode { self, quiz, review }

class UserTypeController extends GetxController {
  UserType _userType = UserType.none;
  Mode _mode = Mode.self;

  UserType get userType => _userType;
  Mode get mode => _mode;

  setUserType(String str) {
    _userType = str == "Student" ? UserType.student : UserType.teacher;
    update();
  }

  setMode(Mode mode) {
    _mode = mode;
  }
}

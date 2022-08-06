import 'package:get/get.dart';

/// Types of users.
enum UserType { none, teacher, student }

/// Types of Questionniare access mode.
enum Mode { self, quiz, review }

class UserTypeController extends GetxController {
  UserType _userType = UserType.none;
  Mode _mode = Mode.self;

  /// Current user type.
  UserType get userType => _userType;

  /// Current questionniare access mode.
  Mode get mode => _mode;

  /// Set user type.
  setUserType(String str) {
    _userType = str == "Student" ? UserType.student : UserType.teacher;
    update();
  }

  /// Set mode.
  setMode(Mode mode) {
    _mode = mode;
  }
}

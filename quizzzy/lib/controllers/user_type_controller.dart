import 'package:get/get.dart';

class UserTypeController extends GetxController {
  String _userType = "";

  String get userType => _userType;

  setUserType(String str) {
    _userType = str;
    update();
  }
}

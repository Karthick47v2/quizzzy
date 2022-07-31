import 'package:get/get.dart';

class UtilsController extends GetxController {
  bool _firstTime = true;

  bool get firstTime => _firstTime;

  setRegistered() {
    _firstTime = false;
    update();
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzzy/theme/palette.dart';

/// Customized GetX snackbar.
void customSnackBar(String title, String msg, Color clr) {
  Get.snackbar(title, msg,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: clr,
      colorText: Palette.font);
}

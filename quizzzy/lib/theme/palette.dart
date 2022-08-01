import 'package:flutter/material.dart';

/// Controls all colors in app
class Palette {
  /// App theme
  static Color theme = const Color.fromARGB(255, 93, 0, 155);
  static Color bg = const Color.fromARGB(255, 19, 19, 19);

  /// Snackbar
  static Color error = Colors.red.shade800;
  static Color warning = Colors.amber.shade400;
  static Color sucess = Colors.green.shade700;

  /// Background
  static Color loadingBg = Colors.grey;
  static Color popupBg = const Color.fromARGB(255, 13, 13, 15);
  static Color txtFieldBg = const Color.fromARGB(94, 153, 0, 255);
  static Color questionBg = const Color.fromARGB(94, 155, 155, 155);

  /// Timer
  static Color timerGreen = const Color.fromARGB(94, 0, 255, 34);
  static Color timerRed = const Color.fromARGB(94, 255, 0, 0);

  /// Font
  static Color font = Colors.white;
  static Color cursor = const Color.fromARGB(255, 168, 168, 168);
  static Color txtInput = const Color.fromARGB(255, 212, 212, 212);
  static Color authTitle = const Color.fromARGB(204, 79, 0, 170);

  /// TextBox
  static Color txtInputBorder = const Color.fromARGB(255, 122, 122, 122);

  /// Button
  static Color ansBtnNoClick = const Color.fromARGB(94, 104, 104, 104);
  static Color ansBtnClicked = const Color.fromARGB(255, 93, 0, 155);
  static Color hyperBtn = const Color.fromARGB(255, 114, 0, 190);
  static Color btnOutline = const Color.fromARGB(255, 85, 46, 110);

  /// Misc
  static Color transparent = Colors.transparent;
  static Color icon = const Color.fromARGB(115, 155, 155, 155);
}

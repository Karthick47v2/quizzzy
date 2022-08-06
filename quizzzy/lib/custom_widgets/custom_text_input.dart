import 'package:flutter/material.dart';

import 'package:quizzzy/theme/palette.dart';

/// Custom user input
class CustomTextInput extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool isPass;
  const CustomTextInput(
      {Key? key,
      required this.text,
      required this.controller,
      this.validator,
      this.isPass = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: TextFormField(
        obscureText: isPass,
        cursorColor: Palette.cursor,
        decoration: InputDecoration(
            filled: true,
            labelText: text,
            labelStyle: TextStyle(color: Palette.txtInput),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
              color: Palette.txtInputBorder,
            )),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
              color: Palette.cursor,
            ))),
        controller: controller,
        validator: validator,
        style: TextStyle(color: Palette.font),
      ),
    );
  }
}

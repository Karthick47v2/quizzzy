import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool isPass;
  final Color cursorClr = const Color.fromARGB(255, 168, 168, 168);
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
        cursorColor: cursorClr,
        decoration: InputDecoration(
            filled: true,
            labelText: text,
            labelStyle:
                const TextStyle(color: Color.fromARGB(255, 212, 212, 212)),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
              color: Color.fromARGB(255, 122, 122, 122),
            )),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
              color: cursorClr,
            ))),
        controller: controller,
        validator: validator,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

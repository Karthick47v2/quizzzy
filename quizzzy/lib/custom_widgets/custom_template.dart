import 'package:flutter/material.dart';

class CustomTemplate extends StatefulWidget {
  final Widget body;

  const CustomTemplate({Key? key, required this.body}) : super(key: key);

  @override
  State<CustomTemplate> createState() => _CustomTemplateState();
}

class _CustomTemplateState extends State<CustomTemplate> {
  @override
  Widget build(context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color.fromARGB(255, 19, 19, 19),
        body: widget.body);
  }
}

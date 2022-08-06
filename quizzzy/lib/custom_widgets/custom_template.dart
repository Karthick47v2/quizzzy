import 'package:flutter/material.dart';

import 'package:quizzzy/theme/palette.dart';

/// Custom template for all screens of Quizzzy Application
class CustomTemplate extends StatefulWidget {
  final Widget body;

  const CustomTemplate({Key? key, required this.body}) : super(key: key);

  @override
  State<CustomTemplate> createState() => _CustomTemplateState();
}

class _CustomTemplateState extends State<CustomTemplate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Palette.bg,
        body: widget.body);
  }
}

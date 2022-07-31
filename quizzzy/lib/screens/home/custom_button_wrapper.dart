import 'package:flutter/material.dart';

import 'package:quizzzy/custom_widgets/custom_button.dart';

class CustomButtonWrapper extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  const CustomButtonWrapper({Key? key, required this.text, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite - 20,
      child: CustomButton(text: text, onTap: onTap),
    );
  }
}

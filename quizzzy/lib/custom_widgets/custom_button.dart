import 'package:flutter/material.dart';

import 'package:quizzzy/theme/font.dart';
import 'package:quizzzy/theme/palette.dart';

/// Customized button to be used in whole app.
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const CustomButton({Key? key, required this.text, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: Palette.btnOutline,
            width: 2.0,
            style: BorderStyle.solid,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: fontFamily,
            fontSize: 24,
            fontWeight: Font.medium,
            color: Palette.font,
          ),
        ));
  }
}

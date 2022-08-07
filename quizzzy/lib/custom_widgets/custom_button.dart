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
    return ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          onPrimary: Palette.bg,
          primary: Palette.containerBg,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Palette.bg),
              borderRadius: const BorderRadius.all(Radius.circular(25))),
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

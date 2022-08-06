import 'package:flutter/material.dart';

import 'package:quizzzy/theme/font.dart';
import 'package:quizzzy/theme/palette.dart';

/// Questionnaire top bar template for both usertypes.
class TopQBar extends StatelessWidget {
  final Color color;
  final String txt;
  const TopQBar({Key? key, required this.color, required this.txt})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(120, 70, 120, 10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Center(
          child: Text(
            txt,
            style: TextStyle(
                fontFamily: fontFamily,
                fontSize: 19,
                fontWeight: Font.extraBold,
                color: Palette.font),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

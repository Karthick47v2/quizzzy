import 'package:flutter/material.dart';

import 'package:quizzzy/theme/font.dart';
import 'package:quizzzy/theme/palette.dart';

/// Customized card for ListView
class CustomCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  const CustomCard(
      {Key? key,
      required this.title,
      required this.onTap,
      required this.onLongPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Palette.containerBg,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Palette.bg),
          borderRadius: const BorderRadius.all(Radius.circular(25))),
      child: InkWell(
        splashColor: Palette.bg,
        highlightColor: Palette.bg,
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              title,
              style: TextStyle(
                fontFamily: fontFamily,
                fontSize: 22,
                fontWeight: Font.regular,
                color: Palette.font,
              ),
            )),
      ),
    );
  }
}

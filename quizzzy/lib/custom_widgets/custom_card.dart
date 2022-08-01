import 'package:flutter/material.dart';
import 'package:quizzzy/theme/font.dart';
import 'package:quizzzy/theme/palette.dart';

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
      color: Palette.theme,
      child: InkWell(
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
        onTap: onTap,
        onLongPress: onLongPress,
      ),
    );
  }
}

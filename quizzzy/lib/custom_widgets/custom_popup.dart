import 'package:flutter/material.dart';

import 'package:quizzzy/theme/palette.dart';

/// Customized interactive popup.
class CustomPopup extends StatelessWidget {
  final double size;
  final List<Widget> wids;
  const CustomPopup({Key? key, required this.size, required this.wids})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        color: Palette.popupBg,
        height: size,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: wids,
        ),
      ),
    );
  }
}

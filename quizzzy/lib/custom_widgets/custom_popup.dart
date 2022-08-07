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
      backgroundColor: Palette.popupBg,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Palette.bg),
          borderRadius: const BorderRadius.all(Radius.circular(50))),
      child: SizedBox(
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

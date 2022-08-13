import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:quizzzy/custom_widgets/custom_button.dart';
import 'package:quizzzy/custom_widgets/custom_popup.dart';
import 'package:quizzzy/custom_widgets/render_img.dart';
import 'package:quizzzy/theme/font.dart';
import 'package:quizzzy/theme/palette.dart';

/// Render [CustomPopup] when [Exit] button pressed.
class ExitPopup extends StatelessWidget {
  const ExitPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPopup(size: 400.0, wids: [
      const RenderImage(
        path: 'assets/images/select.svg',
        expaned: false,
        svgHeight: 200,
      ),
      Text(
        "Are you sure ?",
        style: TextStyle(
            fontFamily: fontFamily,
            fontSize: 19,
            fontWeight: Font.regular,
            color: Palette.font),
        textAlign: TextAlign.center,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CustomButton(
            key: const Key('btn-quit-conf'),
            text: "Yes",
            onTap: () =>
                SystemNavigator.pop(), // it will only suspend app for iOS,
          ), // need to manually close in iOS as of iOS policy ...
          CustomButton(
            key: const Key('btn-quit-decl'),
            text: "No",
            onTap: () => Get.back(),
          )
        ],
      )
    ]);
  }
}

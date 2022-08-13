import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:quizzzy/custom_widgets/custom_button.dart';
import 'package:quizzzy/custom_widgets/custom_popup.dart';
import 'package:quizzzy/custom_widgets/custom_snackbar.dart';
import 'package:quizzzy/custom_widgets/render_img.dart';
import 'package:quizzzy/screens/auth/login.dart';
import 'package:quizzzy/service/firebase_auth.dart';
import 'package:quizzzy/theme/font.dart';
import 'package:quizzzy/theme/palette.dart';

/// Render [CustomPopup] when [Logout] button pressed.
class LogoutPopup extends StatefulWidget {
  const LogoutPopup({Key? key}) : super(key: key);

  @override
  State<LogoutPopup> createState() => _LogoutPopupState();
}

class _LogoutPopupState extends State<LogoutPopup> {
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
            key: const Key('btn-logout-conf'),
            text: "Yes",
            onTap: () async {
              String res = await Auth().userSignout();
              if (res == "Success") {
                Get.back();
                Get.offAll(() => const Login());
              } else {
                customSnackBar("Error", res, Palette.error);
              }
            },
          ),
          CustomButton(
            key: const Key('btn-logout-decl'),
            text: "No",
            onTap: () => Get.back(),
          )
        ],
      )
    ]);
  }
}

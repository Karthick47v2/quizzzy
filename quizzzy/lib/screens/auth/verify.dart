import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:quizzzy/custom_widgets/custom_button.dart';
import 'package:quizzzy/custom_widgets/custom_template.dart';
import 'package:quizzzy/screens/home/home_page.dart';
import 'package:quizzzy/service/fs_database.dart';
import 'package:quizzzy/theme/font.dart';
import 'package:quizzzy/theme/palette.dart';

/// Renders [VerifyEmail] screen
///
/// Invokes [checkEmailVerification()] every 3 seconds. Sends email verification when
/// [CustomButton] pressed. Once users gets verified navigates to [HomePage]
class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  Timer? timer;

  @override
  initState() {
    timer = Timer.periodic(const Duration(seconds: 3), (time) {
      checkEmailVerification();
    });
    super.initState();
  }

  @override
  dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTemplate(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '''You need to verify your account before going further. A verification email has been 
          already sent to your email.''',
          style: TextStyle(
            fontFamily: fontFamily,
            fontSize: 18,
            fontWeight: Font.regular,
            color: Palette.font,
          ),
          textAlign: TextAlign.center,
        ),
        CustomButton(
          text: "Resend Email",
          onTap: () => FirestoreService().user!.sendEmailVerification(),
        ),
      ],
    ));
  }

  /// Verify email
  ///
  /// Navigate to [HomePage] only, if email got verified
  Future<void> checkEmailVerification() async {
    await FirestoreService().user!.reload();

    if (FirestoreService().user!.emailVerified) {
      timer?.cancel();
      Get.to(() => const HomePage());
    }
  }
}
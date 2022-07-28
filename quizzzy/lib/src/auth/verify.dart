import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:quizzzy/src/home_page.dart';
import 'package:quizzzy/src/service/fs_database.dart';
import 'package:quizzzy/libs/custom_widgets.dart';

/// Renders [VerifyEmail] screen
///
/// Invokes [checkEmailVerification()] every 3 seconds. Sends email verification when
/// [QuizzzyNavigatorBtn] pressed. Once users gets verified navigates to [HomePage]
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
    return QuizzzyTemplate(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          '''You need to verify your account before going further. A verification email has been 
          already sent to your email.''',
          style: TextStyle(
            fontFamily: 'Heebo',
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          textAlign: TextAlign.center,
        ),
        QuizzzyNavigatorBtn(
          text: "Resend Email",
          onTap: () => FirestoreService().user!.sendEmailVerification(),
          clr: Colors.green[400],
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

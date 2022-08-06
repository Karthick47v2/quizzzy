import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:quizzzy/screens/auth/auth_widget.dart';
import 'package:quizzzy/custom_widgets/custom_snackbar.dart';
import 'package:quizzzy/screens/auth/signup.dart';
import 'package:quizzzy/screens/auth/verify.dart';
import 'package:quizzzy/screens/home/home_page.dart';
import 'package:quizzzy/service/firebase_auth.dart';
import 'package:quizzzy/theme/palette.dart';

/// Renders [Login] screen
///
/// Verify user credentials once [CustomButton] pressed and navigates to [HomePage] if
/// verified account else navigates to [VerifyEmail] screen. If credentials are not valid then,
/// throws error
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> gkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AuthWidget(
      pageTitle: "Log In",
      primaryBtnFunc: () async {
        String res = await Auth()
            .userLogin(emailController.text, passwordController.text);
        if (res == "Verified") {
          Get.to(() => const HomePage());
        } else if (res == "Not Verified") {
          Get.to(() => const VerifyEmail());
        } else {
          customSnackBar("Error", res, Palette.error);
        }
      },
      bottomBtnTxt: "Sign up",
      bottomText: "Don't have an account ?",
      hyperLinkFunc: () => Get.to(() => const SignUp()),
      emailController: emailController,
      passwordController: passwordController,
      gkey: gkey,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:quizzzy/screens/auth/auth_widget.dart';
import 'package:quizzzy/custom_widgets/custom_button.dart';
import 'package:quizzzy/custom_widgets/custom_snackbar.dart';
import 'package:quizzzy/screens/auth/login.dart';
import 'package:quizzzy/service/fbase_auth.dart';
import 'package:quizzzy/theme/palette.dart';

/// Renders [SignUp] screen
///
/// Validate user credentials once [CustomButton] pressed and sends verification email to
/// user if email and password are in valid format. If not, throws error.
class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> gkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AuthWidget(
        pageTitle: "Sign Up",
        primaryBtnFunc: () async {
          if (gkey.currentState!.validate()) {
            String res = await Auth()
                .userSignup(emailController.text, passwordController.text);
            if (res == "Success") {
              customSnackBar(
                  "Check mail",
                  "A verification email has been sent to your mail",
                  Palette.warning);
            } else {
              customSnackBar("Error", res, Palette.error);
            }
          }
        },
        bottomBtnTxt: "Log in",
        bottomText: "Already have an account ?",
        hyperLinkFunc: () => Get.to(() => const Login()),
        emailController: emailController,
        passwordController: passwordController,
        gkey: gkey);
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:quizzzy/libs/custom_widgets.dart';
import 'package:quizzzy/src/auth/login.dart';
import 'package:quizzzy/src/auth/validation.dart';
import 'package:quizzzy/src/service/fbase_auth.dart';

/// Renders [SignUp] screen
///
/// Validate user credentials once [QuizzzyNavigatorBtn] pressed and sends verification email to
/// user if email and password are in valid format. If not, throws error.
class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  late String res;

  @override
  Widget build(BuildContext context) {
    return QuizzzyTemplate(body: Builder(builder: (context) {
      return Form(
        key: _key,
        child: Column(
          children: [
            Expanded(
              child: Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/Quizzzy.png',
                  )),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 0),
                      child: const Text(
                        "Sign Up",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontFamily: 'Heebo',
                            fontSize: 48,
                            fontWeight: FontWeight.w800,
                            color: Color.fromARGB(204, 79, 0, 170)),
                      ),
                    ),
                  ],
                ),
                QuizzzyTextInput(
                    text: "Email",
                    controller: emailController,
                    validator: validateEmail),
                QuizzzyTextInput(
                    text: "Password",
                    controller: passwordController,
                    validator: validatePassword,
                    isPass: true),
              ],
            ),
            Container(
              height: 50,
              width: double.maxFinite - 20,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
              child: QuizzzyNavigatorBtn(
                  text: "Sign Up",
                  onTap: () async {
                    if (_key.currentState!.validate()) {
                      res = await Auth().userSignup(
                          emailController.text, passwordController.text);
                      if (res == "Success") {
                        snackBar(
                            "Check mail",
                            "A verification email has been sent to your mail",
                            (Colors.amber.shade400));
                      } else {
                        snackBar("Error", res, (Colors.red.shade800));
                      }
                    }
                  }),
            ),
            Container(
              height: 50,
              width: double.maxFinite,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account ?",
                    style: TextStyle(
                        fontFamily: 'Heebo',
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                  const SizedBox(width: 18),
                  TextButton(
                    child: const Text(
                      "Log in",
                      style: TextStyle(
                          fontFamily: 'Heebo',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 114, 0, 190)),
                    ),
                    onPressed: () => Get.to(() => const Login()),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }));
  }
}

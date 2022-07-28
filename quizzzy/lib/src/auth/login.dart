import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:quizzzy/libs/custom_widgets.dart';
import 'package:quizzzy/src/auth/signup.dart';
import 'package:quizzzy/src/auth/validation.dart';
import 'package:quizzzy/src/auth/verify.dart';
import 'package:quizzzy/src/home_page.dart';
import 'package:quizzzy/src/service/fbase_auth.dart';

/// Renders [Login] screen
///
/// Verify user credentials once [QuizzzyNavigatorBtn] pressed and navigates to [HomePage] if
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
  late String res;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

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
                child: Image.asset('assets/images/Quizzzy.png'),
              ),
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
                        "Log In",
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
                text: "Log In",
                onTap: () async => {
                  res = await Auth()
                      .userLogin(emailController.text, passwordController.text),
                  if (res == "Verified")
                    {Get.to(() => const HomePage())}
                  else if (res == "Not Verified")
                    {Get.to(() => const VerifyEmail())}
                  else
                    {snackBar("Error", res, (Colors.red.shade800))}
                },
              ),
            ),
            Container(
              height: 50,
              width: double.maxFinite,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account ?",
                    style: TextStyle(
                        fontFamily: 'Heebo',
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                  const SizedBox(width: 18),
                  TextButton(
                    child: const Text(
                      "Sign up",
                      style: TextStyle(
                          fontFamily: 'Heebo',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 114, 0, 190)),
                    ),
                    onPressed: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUp()))
                    },
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

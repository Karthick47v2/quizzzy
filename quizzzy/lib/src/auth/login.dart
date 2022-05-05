import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quizzzy/src/auth/signup.dart';
import 'package:quizzzy/src/auth/verify.dart';
import 'package:quizzzy/src/home_page.dart';
import '../../libs/custom_widgets.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
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
                  // ignore: prefer_const_literals_to_create_immutables
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
                onTap: () async {
                  try {
                    await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text)
                        .then((_) => {
                              if (FirebaseAuth
                                  .instance.currentUser!.emailVerified)
                                {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HomePage()))
                                }
                              else
                                {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const VerifyEmail()))
                                }
                            });
                  } on FirebaseAuthException catch (e) {
                    snackBar(context, e.message!, (Colors.red.shade800));
                  }
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

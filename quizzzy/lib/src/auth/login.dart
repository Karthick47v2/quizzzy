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

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: const Color.fromARGB(255, 37, 37, 37),
            body: Builder(builder: (context) {
              return Form(
                key: _key,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 50,
                      child: Image.asset('assets/images/Quizzzy.png',
                          width: 229, height: 278, fit: BoxFit.cover),
                    ),
                    Positioned(
                      bottom: 40,
                      child: Row(
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
                                      builder: (context) => SignUp()))
                            },
                          ),
                        ],
                      ),
                    ),
                    CustomNavigatorBtn(
                      text: "Log In",
                      bt: 100.0,
                      h: 45.0,
                      w: 317.0,
                      func: () async {
                        setState(() => isLoading = true);
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
                        setState(() => isLoading = false);
                      },
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // const Text(
                        //     "Log in",
                        //     textAlign: TextAlign.left,
                        //     style: TextStyle(fontFamily: 'Heebo', fontSize: 48, fontWeight: FontWeight.w800, color: Color.fromARGB(204, 114, 0, 190)),
                        //   ),
                        CustomTextInput(
                            text: "Email",
                            controller: emailController,
                            validator: validateEmail),
                        CustomTextInput(
                            text: "Password",
                            controller: passwordController,
                            validator: validatePassword,
                            isPass: true),
                      ],
                    )
                  ],
                ),
              );
            })));
  }
}

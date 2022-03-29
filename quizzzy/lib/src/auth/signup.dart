import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../libs/custom_widgets.dart';
import 'package:quizzzy/src/auth/login.dart';

class SignUp extends StatefulWidget {
  const SignUp({ Key? key }) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  bool isLoading = false;//////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromARGB(255, 37, 37, 37),
        body: Builder(
          builder: (context) {
            return Form(
              key: _key,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 50,
                      child: Image.asset(
                        'assets/images/Quizzzy.png',
                        width: 229,
                        height: 278,
                        fit: BoxFit.cover
                        ),
                    ),
                    Positioned(
                      bottom: 40,
                      child: Row(
                        children: [
                          const Text(
                            "Already have an account ?",
                            style: TextStyle(fontFamily: 'Heebo', fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white),
                            ),
                            const SizedBox(width: 18),
                            TextButton(
                              child: const Text(
                                "Log in",
                                style: TextStyle(fontFamily: 'Heebo', fontSize: 18, fontWeight: FontWeight.w500, color: Color.fromARGB(255, 114, 0, 190)),
                              ),
                              onPressed: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Login())
                                )
                              },
                            ),
                          ],
                      ),
                    ),
                    CustomFunctionBtn(
                      text: "Sign Up", 
                      bt: 100.0, 
                      h: 45.0, 
                      w: 317.0, 
                      func: () async {
                        setState(() => isLoading = true);
                        if(_key.currentState!.validate()){
                          try{
                            await FirebaseAuth.instance.createUserWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text
                              );
                          }
                          on FirebaseAuthException catch(e){
                            errorSnackBar(context, e.message!);
                          }
                          setState(() => isLoading = false);
                        }
                      }
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // const Text(
                        //     "Sign Up",
                        //     textAlign: TextAlign.left,
                        //     style: TextStyle(fontFamily: 'Heebo', fontSize: 48, fontWeight: FontWeight.w800, color: Color.fromARGB(204, 114, 0, 190)),
                        //   ),
                        CustomTextInput(text: "Email", controller: emailController, validator: validateEmail),
                        CustomTextInput(text: "Password", controller: passwordController, validator: validatePassword, isPass: true),
                      ],
                    )
                  ],
                ),
              //             ),
              //           ElevatedButton(
              //             child: const Text("Log Out"),
              //             onPressed: () async {
              //               setState(() => isLoading = true);
              //               await FirebaseAuth.instance.signOut();
              //               setState(() => isLoading = false);
              //             },
              //             ),
              //         ],
              //       ),
              //       // isLoading ? CircularProgressIndicator(
              //       //   color: Colors.cyan.shade700,
              //       // ) 
              //     ],
              //   )
              // ),
            );
          }
        )
      )
    );
  }
}

String? validateEmail(String? email){
  if(email == null || email.isEmpty){
    return "Email is required.";
  }

  // alnum@alnum.alnum
  RegExp regex = RegExp(r'\w+@\w+\.\w+');

  if(!regex.hasMatch(email)){
    return "Invalid Email format.";
  }

  return null;
}

String? validatePassword(String? pass){
  if(pass == null || pass.isEmpty){
    return "Password is required.";
  }

  // 8 letter min, must have upper,lower letters, symbol and number
  RegExp regExp = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  if(!regExp.hasMatch(pass)){
    return "Password must be at least 8 characters & contain an uppercase letter, number and symbol.";
  }
  return null;
}

void errorSnackBar(BuildContext context, String str){
  final snackBar = SnackBar(
    content: Text(str),
    backgroundColor: Colors.red[800],
    // shape: const StadiumBorder(),
    behavior: SnackBarBehavior.floating,
  );

  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
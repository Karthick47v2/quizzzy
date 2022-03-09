import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthApp extends StatefulWidget {
  const AuthApp({ Key? key }) : super(key: key);

  @override
  State<AuthApp> createState() => _AuthAppState();
}

class _AuthAppState extends State<AuthApp> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
                          Text(
                            "Already have an account ? Log in",
                            style: TextStyle(fontFamily: 'Heebo', fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white),
                            ),
                            TextButton(
                              child: Text(
                                "Log in"
                              ),
                            )
                            ],
                    ),
                  ],
                ),
              // child: Center(
              //   child: Column(
              //     children: [
              //       TextFormField(
              //         controller: emailController, 
              //         validator: validateEmail,
              //         style: const TextStyle(color: Colors.white),
              //         ),
              //       TextFormField(
              //         controller: passwordController, 
              //         obscureText: true, 
              //         validator: validatePassword,
              //         style: const TextStyle(color: Colors.white),
              //         ),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceAround,
              //         children: [
              //           ElevatedButton(
              //             child: const Text("Sign Up"),
              //             onPressed: () async {
              //               setState(() => isLoading = true);
              //               if(_key.currentState!.validate()){
              //                 try{
              //                   await FirebaseAuth.instance.createUserWithEmailAndPassword(
              //                     email: emailController.text,
              //                     password: passwordController.text
              //                     );
              //                 }
              //                 on FirebaseAuthException catch(e){
              //                   errorSnackBar(context, e.message!);
              //                 }
              //                 setState(() => isLoading = false);
              //               }
              //             },
              //             ),
              //           ElevatedButton(
              //             child: const Text("Log In"),
              //             onPressed: () async {
              //               setState(() => isLoading = true);
              //               try{
              //                 await FirebaseAuth.instance.signInWithEmailAndPassword(
              //                   email: emailController.text, 
              //                   password: passwordController.text
              //                   );
              //               }
              //               on FirebaseAuthException catch(e){
              //                 errorSnackBar(context, e.message!);
              //               }
              //               setState(() => isLoading = false);
              //             },
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
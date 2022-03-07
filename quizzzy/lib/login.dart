import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(AuthApp());
} 

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
    User? user = FirebaseAuth.instance.currentUser;

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blueGrey[900],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: const Text(
            'Quizzy',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.cyan,
            )
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
              color: Colors.blueGrey[800],
            )
          ), systemOverlayStyle: SystemUiOverlayStyle.light
        ),
        body: Builder(
          builder: (context) {
            return Form(
              key: _key,
              child: Center(
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController, 
                      validator: validateEmail,
                      style: const TextStyle(color: Colors.white),
                      ),
                    TextFormField(
                      controller: passwordController, 
                      obscureText: true, 
                      validator: validatePassword,
                      style: const TextStyle(color: Colors.white),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          child: const Text("Sign Up"),
                          onPressed: () async {
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
                          },
                          ),
                        ElevatedButton(
                          child: const Text("Log In"),
                          onPressed: () async {
                            setState(() => isLoading = true);
                            try{
                              await FirebaseAuth.instance.signInWithEmailAndPassword(
                                email: emailController.text, 
                                password: passwordController.text
                                );
                            }
                            on FirebaseAuthException catch(e){
                              errorSnackBar(context, e.message!);
                            }
                            setState(() => isLoading = false);
                          },
                          ),
                        ElevatedButton(
                          child: const Text("Log Out"),
                          onPressed: () async {
                            setState(() => isLoading = true);
                            await FirebaseAuth.instance.signOut();
                            setState(() => isLoading = false);
                          },
                          ),
                      ],
                    ),
                    // isLoading ? CircularProgressIndicator(
                    //   color: Colors.cyan.shade700,
                    // ) 
                  ],
                )
              ),
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
    shape: StadiumBorder(),
    behavior: SnackBarBehavior.floating,
  );

  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
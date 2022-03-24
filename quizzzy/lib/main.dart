import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizzzy/greeting.dart';
import 'package:quizzzy/home_page.dart';
import 'package:quizzzy/import.dart';
import 'package:quizzzy/login.dart';
import 'package:quizzzy/signup.dart';
import 'custom_widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  User? fbuser = FirebaseAuth.instance.currentUser;
  bool user = await checkFileExists();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    ));

    if(!user && fbuser == null){
      runApp(const RootPage());
      return;
    }
    runApp(Root(fbuser: fbuser,));
  }

  class Root extends StatefulWidget {
    final User? fbuser;
    const Root({ Key? key, required this.fbuser }) : super(key: key);
  
    @override
    State<Root> createState() => _RootState();
  }
  
  class _RootState extends State<Root> {
    bool canScroll = true;
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        home: Scaffold(
          body: PageView(
            scrollDirection: Axis.vertical,
            physics: canScroll ? const ScrollPhysics() : const NeverScrollableScrollPhysics(),
            children: [
              const Greetings(),
              (widget.fbuser == null) ? const ImportFile() : const HomePage(),
              // const ImportFile(),
            ],
            onPageChanged: (n) => {
              setState(() => canScroll = false)
            },
          ),
        )
      );
    }
  }

class RootPage extends StatelessWidget {
  const RootPage({ Key? key }) : super(key: key);

  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 37, 37, 37),
        body: Builder(
          builder: (context) => Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/Quizzzy.png',
                  width: 229,
                  height: 278,
                  fit: BoxFit.cover,
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  CustomNavigatorBtn(
                    text: "I'm a Teacher", 
                    bt: 139.0, 
                    h: 59.0,
                    w: 197.0, 
                    cont: context,
                    route: MaterialPageRoute(builder: (context) => SignUp()),
                    ),
                  CustomNavigatorBtn(
                    text: "I'm a Student", 
                    bt: 40.0, 
                    h: 59.0, 
                    w: 197.0,
                    cont: context,
                    route: MaterialPageRoute(builder: (context) => ImportFile()),
                    ),
                ],
              )
            ],
          ),
        )
      )
    );
  }
}
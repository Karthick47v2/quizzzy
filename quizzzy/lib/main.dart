import 'package:flutter/material.dart';
import 'package:quizzzy/import.dart';
import 'package:quizzzy/login.dart';
import 'custom_buttons.dart';

void main() => runApp(HomePage());

class HomePage extends StatelessWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override 
  Widget build(BuildContext context) {
  
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 37, 37, 37),
        body: Stack(
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
                CustomOutlinedBtn(
                  text: "I'm a Teacher", 
                  bt: 139, 
                  h: 59,
                  w: 197, 
                  context: context, 
                  route: MaterialPageRoute(builder: (context) => AuthApp(),),
                  ),
                CustomOutlinedBtn(
                  text: "I'm a Student", 
                  bt: 40, 
                  h: 59, 
                  w: 197,
                  context: context,
                  route: MaterialPageRoute(builder: (context) => ImportFile(),),
                  ),
              ],
            )
          ],
        )
      )
    );
  }
}
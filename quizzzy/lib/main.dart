import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(HomePage());

class HomePage extends StatelessWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                primary: Colors.cyan,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                textStyle: const TextStyle(fontSize: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: const Text("Teacher"),
               ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                primary: Colors.cyan,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                textStyle: const TextStyle(fontSize: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: const Text("Student"),
               ),
          ],
        ),)
    );
  }
}
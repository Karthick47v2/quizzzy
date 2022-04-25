import 'package:flutter/material.dart';

class Greetings extends StatelessWidget {
  const Greetings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            backgroundColor: const Color.fromARGB(255, 37, 37, 37),
            body: Builder(
              builder: (context) => Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 40,
                    child: Image.asset(
                      'assets/images/Quizzzy.png',
                      width: 338,
                      height: 407,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Positioned(
                    bottom: 80,
                    child: Text(
                      "WELCOME",
                      style: TextStyle(
                          fontFamily: 'Heebo',
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 93, 0, 155)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Positioned(
                    bottom: 40,
                    child: Text(
                      "Scroll up to continue",
                      style: TextStyle(
                          fontFamily: 'Heebo',
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: Color.fromARGB(255, 209, 209, 209)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            )));
  }
}

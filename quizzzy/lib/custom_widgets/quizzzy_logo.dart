import 'package:flutter/material.dart';

class QuizzzyLogo extends StatelessWidget {
  const QuizzzyLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        child: Image.asset('assets/images/Quizzzy.png'),
      ),
    );
  }
}

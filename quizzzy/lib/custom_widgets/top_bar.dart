import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final String txt;
  const TopBar({Key? key, required this.txt}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      alignment: Alignment.bottomCenter,
      width: double.maxFinite,
      child: Text(
        txt,
        style: const TextStyle(
          fontFamily: 'Heebo',
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: Color.fromARGB(255, 255, 255, 255),
        ),
      ),
    );
  }
}

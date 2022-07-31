import 'package:flutter/material.dart';

class CustomPopup extends StatelessWidget {
  final double size;
  final List<Widget> wids;
  const CustomPopup({Key? key, required this.size, required this.wids})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        color: const Color.fromARGB(255, 13, 13, 15),
        height: size,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: wids,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  const CustomCard(
      {Key? key,
      required this.title,
      required this.onTap,
      required this.onLongPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 93, 0, 155),
      child: InkWell(
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Heebo',
                fontSize: 22,
                fontWeight: FontWeight.w400,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            )),
        onTap: onTap,
        onLongPress: onLongPress,
      ),
    );
  }
}

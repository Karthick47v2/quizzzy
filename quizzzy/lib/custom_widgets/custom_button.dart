import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final Color? clr;
  final Color? txtClr;

  const CustomButton(
      {Key? key, required this.text, this.onTap, this.clr, this.txtClr})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color:
                (clr != null) ? clr! : const Color.fromARGB(255, 85, 46, 110),
            width: 2.0,
            style: BorderStyle.solid,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Heebo',
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: (txtClr != null)
                ? txtClr!
                : const Color.fromARGB(255, 255, 255, 255),
          ),
        ));
  }
}

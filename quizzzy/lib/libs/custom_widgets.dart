import 'package:flutter/material.dart';

abstract class CustomOutlinedBtn extends StatelessWidget {
  final String text;
  final double bt;
  final double h;
  final double w;

  CustomOutlinedBtn({ Key? key, required this.text, required this.bt, required this.h, required this.w }) : super(key: key);

}

class CustomNavigatorBtn extends CustomOutlinedBtn {
  final BuildContext cont;
  final Route route;

  CustomNavigatorBtn({ Key? key, required text, required bt, required h, required w,
                       required this.cont, required this.route }) : super(key: key, text: text, bt: bt, h: h, w: w);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bt,
      height: h,
      width: w,
      child: OutlinedButton(
        onPressed: (() => Navigator.push(cont,route)),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(
            color: Color.fromARGB(255, 93, 0, 155),
            width: 2.0,
            style: BorderStyle.solid,
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontFamily: 'Heebo', fontSize: 24, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      )
    );
  }
}

class CustomFunctionBtn extends CustomOutlinedBtn {
  final VoidCallback func;

  CustomFunctionBtn({ Key? key, required text, required bt, required h, required w,
                       required this.func }) : super(key: key, text: text, bt: bt, h: h, w: w);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bt,
      height: h,
      width: w,
      child: OutlinedButton(
        onPressed: func,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(
            color: Color.fromARGB(255, 93, 0, 155),
            width: 2.0,
            style: BorderStyle.solid,
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontFamily: 'Heebo', fontSize: 24, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      )
    );
  }
}

class CustomTextInput extends StatefulWidget {
  final String text;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  bool isPass;
  CustomTextInput({ Key? key, required this.text, required this.controller, required this.validator,  this.isPass = false}) : super(key: key);

  @override
  State<CustomTextInput> createState() => _CustomTextInputState();
}

class _CustomTextInputState extends State<CustomTextInput> {
  final Color cursorClr = const Color.fromARGB(255, 168, 168, 168);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: TextFormField(
        obscureText: widget.isPass,
        cursorColor: cursorClr,
        decoration: InputDecoration(
          filled: true,
          labelText: widget.text,
          labelStyle: const TextStyle(color: Color.fromARGB(255, 212, 212, 212)),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 122, 122, 122),
            )
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: cursorClr,
            )
          )
        ),
        controller: widget.controller, 
        validator: widget.validator,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}


class LoadingBox extends StatelessWidget {
  final String title;
  final String info;
  const LoadingBox({ Key? key, required this.title, required this.info }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Container(
        color: const Color.fromARGB(255, 80, 80, 80),
        height: 300,
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            const SizedBox(
              height: 120,
              width: 120,
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 93, 0, 155),
                backgroundColor: Colors.grey,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Column(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontFamily: 'Heebo', fontSize: 23, fontWeight: FontWeight.w400, color: Colors.white),
                ),
                Text(
                  info,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontFamily: 'Heebo', fontSize: 17, fontWeight: FontWeight.w400, color: Colors.white),
                ),
              ],
            )
          ]
        )
      ),
    );
  }
}

class NavigationBox extends StatelessWidget {
  final BuildContext cont;
  final String text;
  const NavigationBox({ Key? key, required this.cont, required this.text }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}
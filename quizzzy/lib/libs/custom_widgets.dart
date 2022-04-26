import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomNavigatorBtn extends StatelessWidget {
  final String text;
  final double bt;
  final double h;
  final double w;
  BuildContext? cont;
  Route? route;
  VoidCallback? func;
  Color? clr;
  Color? txtClr;

  CustomNavigatorBtn(
      {Key? key,
      required this.text,
      required this.bt,
      required this.h,
      required this.w,
      this.cont,
      this.route,
      this.func,
      this.clr,
      this.txtClr})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: bt,
        height: h,
        width: w,
        child: OutlinedButton(
            onPressed:
                (func != null) ? func : (() => Navigator.push(cont!, route!)),
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: (clr != null)
                    ? clr!
                    : const Color.fromARGB(255, 85, 46, 110),
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
            )));
  }
}

// ignore: must_be_immutable
class CustomTextInput extends StatefulWidget {
  final String text;
  TextEditingController controller;
  String? Function(String?)? validator;
  bool isPass;
  CustomTextInput(
      {Key? key,
      required this.text,
      required this.controller,
      this.validator,
      this.isPass = false})
      : super(key: key);

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
            labelStyle:
                const TextStyle(color: Color.fromARGB(255, 212, 212, 212)),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
              color: Color.fromARGB(255, 122, 122, 122),
            )),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
              color: cursorClr,
            ))),
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
  const LoadingBox({Key? key, required this.title, required this.info})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Container(
          color: const Color.fromARGB(255, 80, 80, 80),
          height: 300,
          child: Column(children: [
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
                  style: const TextStyle(
                      fontFamily: 'Heebo',
                      fontSize: 23,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
                Text(
                  info,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontFamily: 'Heebo',
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
              ],
            )
          ])),
    );
  }
}

class NavigationBox extends StatelessWidget {
  final BuildContext cont;
  final String text;
  const NavigationBox({Key? key, required this.cont, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomNavigatorBtn extends StatelessWidget {
  final String text;
  BuildContext? cont;
  Route? route;
  VoidCallback? func;
  Color? clr;
  Color? txtClr;

  CustomNavigatorBtn(
      {Key? key,
      required this.text,
      this.cont,
      this.route,
      this.func,
      this.clr,
      this.txtClr})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed:
            (func != null) ? func : (() => Navigator.push(cont!, route!)),
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

class PopupModal extends StatefulWidget {
  final double size;
  final List<Widget> wids;
  const PopupModal({Key? key, required this.size, required this.wids})
      : super(key: key);

  @override
  State<PopupModal> createState() => _PopupModalState();
}

class _PopupModalState extends State<PopupModal> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Container(
        color: const Color.fromARGB(255, 13, 13, 15),
        height: widget.size,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: widget.wids,
        ),
      ),
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: Color.fromARGB(255, 93, 0, 155),
        backgroundColor: Colors.grey,
      ),
    );
  }
}

void snackBar(BuildContext context, String str, Color clr) {
  final snackBar = SnackBar(
    content: Text(
      str,
      textAlign: TextAlign.center,
    ),
    backgroundColor: clr,
    behavior: SnackBarBehavior.floating,
  );

  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

import 'package:flutter/material.dart';

class QuizzzyTemplate extends StatefulWidget {
  final Widget body;

  const QuizzzyTemplate({Key? key, required this.body}) : super(key: key);

  @override
  State<QuizzzyTemplate> createState() => _QuizzzyTemplateState();
}

class _QuizzzyTemplateState extends State<QuizzzyTemplate> {
  @override
  Widget build(context) {
    return WillPopScope(
      onWillPop: () async {
        return true; ///////////////////// TODO: CHECK IF SCREENS NEEDS TO BE LOCKED
      },
      child: MaterialApp(
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: const Color.fromARGB(255, 19, 19, 19),
            body: widget.body),
      ),
    );
  }
}

class QuizzzyNavigatorBtn extends StatelessWidget {
  final String text;
  final BuildContext? cont;
  final dynamic page;
  final VoidCallback? onTap;
  final Color? clr;
  final Color? txtClr;

  const QuizzzyNavigatorBtn(
      {Key? key,
      required this.text,
      this.cont,
      this.page,
      this.onTap,
      this.clr,
      this.txtClr})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: (onTap != null)
            ? onTap
            : () => Navigator.push(
                cont!, MaterialPageRoute(builder: ((context) => page))),
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

class QuizzzyTextInput extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool isPass;
  final Color cursorClr = const Color.fromARGB(255, 168, 168, 168);
  const QuizzzyTextInput(
      {Key? key,
      required this.text,
      required this.controller,
      this.validator,
      this.isPass = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: TextFormField(
        obscureText: isPass,
        cursorColor: cursorClr,
        decoration: InputDecoration(
            filled: true,
            labelText: text,
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
        controller: controller,
        validator: validator,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

class PopupModal extends StatelessWidget {
  final double size;
  final List<Widget> wids;
  const PopupModal({Key? key, required this.size, required this.wids})
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

class QuizzzyCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  const QuizzzyCard(
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

class QuizzzyAns extends StatefulWidget {
  final String ans;
  final bool isPicked;
  final VoidCallback onTap;
  const QuizzzyAns({
    Key? key,
    required this.ans,
    required this.isPicked,
    required this.onTap,
  }) : super(key: key);

  @override
  State<QuizzzyAns> createState() => _QuizzzyAnsState();
}

class _QuizzzyAnsState extends State<QuizzzyAns> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      child: InkWell(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: widget.isPicked
                ? const Color.fromARGB(255, 93, 0, 155)
                : const Color.fromARGB(94, 104, 104, 104),
            borderRadius: const BorderRadius.all(Radius.circular(24)),
          ),
          child: Center(
            child: Text(
              widget.ans,
              style: const TextStyle(
                  fontFamily: 'Heebo',
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        onTap: widget.onTap,
      ),
    );
  }
}

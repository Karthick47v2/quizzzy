import 'package:flutter/material.dart';

class AnswerContainer extends StatefulWidget {
  final String ans;
  final bool isPicked;
  final VoidCallback onTap;
  const AnswerContainer({
    Key? key,
    required this.ans,
    required this.isPicked,
    required this.onTap,
  }) : super(key: key);

  @override
  State<AnswerContainer> createState() => _AnswerContainerState();
}

class _AnswerContainerState extends State<AnswerContainer> {
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

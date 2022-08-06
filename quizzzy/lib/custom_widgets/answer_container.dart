import 'package:flutter/material.dart';
import 'package:quizzzy/theme/font.dart';
import 'package:quizzzy/theme/palette.dart';

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
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color:
                widget.isPicked ? Palette.ansBtnClicked : Palette.ansBtnNoClick,
            borderRadius: const BorderRadius.all(Radius.circular(24)),
          ),
          child: Center(
            child: Text(
              widget.ans,
              style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: 22,
                  fontWeight: Font.regular,
                  color: Palette.font),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

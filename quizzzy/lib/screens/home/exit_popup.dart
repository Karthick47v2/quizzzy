import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:quizzzy/custom_widgets/custom_button.dart';
import 'package:quizzzy/custom_widgets/custom_popup.dart';

class ExitPopup extends StatelessWidget {
  final BuildContext context;
  const ExitPopup({Key? key, required this.context}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPopup(size: 150.0, wids: [
      const Text(
        "Are you sure ?",
        style: TextStyle(
            fontFamily: 'Heebo',
            fontSize: 19,
            fontWeight: FontWeight.w400,
            color: Colors.white),
        textAlign: TextAlign.center,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CustomButton(
            text: "Yes",
            onTap: () =>
                SystemNavigator.pop(), // it will only suspend app for iOS,
          ), // need to manually close in iOS as of iOS policy ...
          CustomButton(
            text: "No",
            onTap: () => Navigator.of(context).pop(),
          )
        ],
      )
    ]);
  }
}

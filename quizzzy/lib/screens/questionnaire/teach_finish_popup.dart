import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:quizzzy/custom_widgets/custom_button.dart';
import 'package:quizzzy/custom_widgets/custom_popup.dart';
import 'package:quizzzy/screens/home/home_page.dart';
import 'package:quizzzy/theme/font.dart';
import 'package:quizzzy/theme/palette.dart';

class TeachFinishPopup extends StatelessWidget {
  const TeachFinishPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPopup(size: 150.0, wids: [
      Text(
        "Press continue to modify changes, cancel to revert",
        style: TextStyle(
            fontFamily: fontFamily,
            fontSize: 22,
            fontWeight: Font.regular,
            color: Palette.font),
        textAlign: TextAlign.center,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CustomButton(
            text: "Cancel",
            onTap: () => Get.to(() => const HomePage()),
          ),
          CustomButton(
            text: "Continue",
            onTap: () async {
              // if (isRemove) {
              //   if (questionnaire.length == 1) {
              //     // removeQuestionnaire();
              //   } else {
              //     modifyQuestionSet(
              //         name, questionnaire, true);
              //   }
              // } else {
              //   modifyQuestionSet(
              //       name, questionnaire, false);
              // }
              Get.back();
              Get.to(() => const HomePage());
            },
          )
        ],
      ),
    ]);
  }
}

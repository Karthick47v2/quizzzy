import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:quizzzy/custom_widgets/custom_button.dart';
import 'package:quizzzy/custom_widgets/custom_template.dart';
import 'package:quizzzy/screens/home/home_page.dart';
import 'package:quizzzy/controllers/questionnaire_controller.dart';
import 'package:quizzzy/theme/font.dart';
import 'package:quizzzy/theme/palette.dart';

class Score extends StatelessWidget {
  Score({Key? key}) : super(key: key);

  final double avg = Get.find<QuestionnaireController>().avg;

  @override
  Widget build(BuildContext context) {
    return CustomTemplate(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "$avg",
            style: TextStyle(
                fontFamily: fontFamily,
                fontSize: 17,
                fontWeight: Font.regular,
                color: Palette.font),
            textAlign: TextAlign.center,
          ),
          Text(
            avg == 1
                ? "Great"
                : (avg >= 0.75
                    ? "You have done well"
                    : (avg >= 0.5
                        ? "Not bad. You can still try again"
                        : "Try again later, you can do it.")),
            style: TextStyle(
                fontFamily: fontFamily,
                fontSize: 17,
                fontWeight: Font.regular,
                color: Palette.font),
            textAlign: TextAlign.center,
          ),
          CustomButton(
            text: "Continue",
            onTap: () => Get.to(() => const HomePage()),
          ),
        ],
      ),
    ));
  }
}
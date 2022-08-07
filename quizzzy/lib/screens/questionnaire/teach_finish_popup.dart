import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:quizzzy/controllers/questionnaire_controller.dart';
import 'package:quizzzy/custom_widgets/custom_button.dart';
import 'package:quizzzy/custom_widgets/custom_popup.dart';
import 'package:quizzzy/custom_widgets/render_img.dart';
import 'package:quizzzy/screens/home/home_page.dart';
import 'package:quizzzy/screens/question_bank/wipe_data.dart';
import 'package:quizzzy/theme/font.dart';
import 'package:quizzzy/theme/palette.dart';

/// Render [CustomPopup] when teacher finishes modifying.
class TeachFinishPopup extends StatelessWidget {
  final String name = Get.find<QuestionnaireController>().questionnaireName;
  TeachFinishPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPopup(size: 400.0, wids: [
      const RenderImage(
        path: 'assets/images/select.svg',
        expaned: false,
        svgHeight: 200,
      ),
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
              wipeQuestions(name);
              Get.to(() => const HomePage());
            },
          )
        ],
      ),
    ]);
  }
}

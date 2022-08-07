import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:quizzzy/controllers/questionnaire_controller.dart';
import 'package:quizzzy/controllers/user_type_controller.dart';
import 'package:quizzzy/custom_widgets/custom_button.dart';
import 'package:quizzzy/custom_widgets/custom_popup.dart';
import 'package:quizzzy/custom_widgets/render_img.dart';
import 'package:quizzzy/screens/home/home_page.dart';
import 'package:quizzzy/screens/score/score.dart';
import 'package:quizzzy/service/firestore_db.dart';
import 'package:quizzzy/theme/font.dart';
import 'package:quizzzy/theme/palette.dart';

/// Render [CustomPopup] when time's up.
class TimesupPopup extends StatelessWidget {
  final Mode currentMode = Get.find<UserTypeController>().mode;
  final QuestionnaireController controller =
      Get.find<QuestionnaireController>();
  TimesupPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPopup(size: 350.0, wids: [
      const RenderImage(
        path: "assets/images/timeup.svg",
        expaned: false,
        svgHeight: 200,
      ),
      Text(
        "Time's up",
        style: TextStyle(
            fontFamily: fontFamily,
            fontSize: 22,
            fontWeight: Font.regular,
            color: Palette.font),
        textAlign: TextAlign.center,
      ),
      CustomButton(
        text: "Finish",
        onTap: () async {
          Get.back();

          Get.back();
          if (currentMode == Mode.self) {
            Get.to(() => Score());
          } else {
            FirestoreService().sendScore(controller.questionnaireName,
                controller.avg, controller.author);
            Get.offAll(() => const HomePage());
          }
        },
      )
    ]);
  }
}

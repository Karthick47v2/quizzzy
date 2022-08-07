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

/// Render [CustomPopup] when student finishes quiz.
class StudFinishPopup extends StatelessWidget {
  final Mode currentMode = Get.find<UserTypeController>().mode;
  final QuestionnaireController controller =
      Get.find<QuestionnaireController>();
  StudFinishPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPopup(size: 400.0, wids: [
      const RenderImage(
        path: 'assets/images/done.svg',
        expaned: false,
        svgHeight: 200,
      ),
      Text(
        currentMode == Mode.review
            ? "Press continue to finish review"
            : "Press continue to finish the quiz",
        style: TextStyle(
            fontFamily: fontFamily,
            fontSize: 22,
            fontWeight: Font.regular,
            color: Palette.font),
        textAlign: TextAlign.center,
      ),
      currentMode == Mode.self
          ? Text(
              "You can always review quizzes from main menu",
              style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: 19,
                  fontWeight: Font.regular,
                  color: Palette.font),
              textAlign: TextAlign.center,
            )
          : Container(),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomButton(
            text: "Continue",
            onTap: () async {
              Get.back();
              if (currentMode == Mode.self) {
                Get.to(() => Score());
              } else {
                if (currentMode == Mode.quiz) {
                  FirestoreService().sendScore(controller.questionnaireName,
                      controller.avg, controller.author);
                }
                Get.offAll(() => const HomePage());
              }
            },
          )
        ],
      ),
    ]);
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzzy/controllers/questionnaire_controller.dart';
import 'package:quizzzy/controllers/user_type_controller.dart';

import 'package:quizzzy/custom_widgets/custom_button.dart';
import 'package:quizzzy/custom_widgets/custom_popup.dart';
import 'package:quizzzy/screens/home/home.dart';
import 'package:quizzzy/screens/score/score.dart';
import 'package:quizzzy/service/fs_database.dart';
import 'package:quizzzy/theme/font.dart';
import 'package:quizzzy/theme/palette.dart';

class StudFinishPopup extends StatelessWidget {
  final Mode currentMode = Get.find<UserTypeController>().mode;
  final QuestionnaireController controller =
      Get.find<QuestionnaireController>();
  StudFinishPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPopup(size: 150.0, wids: [
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
      currentMode == Mode.quiz
          ? Container()
          : Text(
              "You can always review quizzes from main menu",
              style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: 19,
                  fontWeight: Font.regular,
                  color: Palette.font),
              textAlign: TextAlign.center,
            ),
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
                FirestoreService().sendScore(controller.questionnaireName,
                    controller.avg, controller.author);
                Get.to(() => const Home());
              }
            },
          )
        ],
      ),
    ]);
  }
}

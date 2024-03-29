import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzzy/controllers/questionnaire_controller.dart';

import 'package:quizzzy/custom_widgets/custom_button.dart';
import 'package:quizzzy/custom_widgets/custom_popup.dart';
import 'package:quizzzy/custom_widgets/render_img.dart';
import 'package:quizzzy/screens/question_bank/wipe_data.dart';
import 'package:quizzzy/theme/font.dart';
import 'package:quizzzy/theme/palette.dart';

/// Render [CustomPopup] when [Delete] button pressed.
class DeletePopup extends StatelessWidget {
  final String qName;
  const DeletePopup({Key? key, required this.qName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPopup(size: 400.0, wids: [
      const RenderImage(
        path: 'assets/images/delete.svg',
        expaned: false,
        svgHeight: 200,
      ),
      Text(
        "Do you want to delete this questionnaire?",
        style: TextStyle(
          fontFamily: fontFamily,
          fontSize: 19,
          fontWeight: Font.regular,
          color: Palette.font,
        ),
        textAlign: TextAlign.center,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CustomButton(
            key: const Key('button-q-dlt-conf'),
            text: "Yes",
            onTap: () async {
              Get.find<QuestionnaireController>().overwriteRemovalList();
              await wipeQuestions(qName);
            },
          ),
          CustomButton(
            key: const Key('button-q-dlt-decl'),
            text: "No",
            onTap: () => Get.back(),
          ),
        ],
      ),
    ]);
  }
}

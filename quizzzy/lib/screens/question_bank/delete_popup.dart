import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:quizzzy/controllers/question_list_controller.dart';
import 'package:quizzzy/custom_widgets/custom_button.dart';
import 'package:quizzzy/custom_widgets/custom_popup.dart';
import 'package:quizzzy/custom_widgets/custom_snackbar.dart';
import 'package:quizzzy/service/db_model/question_set.dart';
import 'package:quizzzy/service/fs_database.dart';
import 'package:quizzzy/service/local_database.dart';
import 'package:quizzzy/theme/font.dart';
import 'package:quizzzy/theme/palette.dart';

class DeletePopup extends StatelessWidget {
  final BuildContext cntxt;
  final int idx;
  final List<String> questionList =
      Get.find<QuestionListController>().questionList;
  DeletePopup({Key? key, required this.cntxt, required this.idx})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuestionListController>(
      builder: (controller) {
        return CustomPopup(size: 150.0, wids: [
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
                text: "Yes",
                onTap: () async {
                  questionSetBox.delete(questionList[idx]);
                  if (!await FirestoreService().deleteQuestionnaire(
                      "users/${FirestoreService().user!.uid}/${questionList[idx]}")) {
                    customSnackBar("Error", "Please try again", Palette.error);
                  } else {
                    controller.poppedList!.add(questionList[idx]);
                    UserSharedPreferences()
                        .setPoppedItems(controller.poppedList!);
                    customSnackBar(
                        "...",
                        "This may take some time... Will be deleted on your next visit.",
                        Palette.sucess);
                  }
                  Navigator.of(cntxt).pop();
                },
              ),
              CustomButton(
                text: "No",
                onTap: () => Navigator.of(cntxt).pop(),
              ),
            ],
          ),
        ]);
      },
    );
  }
}

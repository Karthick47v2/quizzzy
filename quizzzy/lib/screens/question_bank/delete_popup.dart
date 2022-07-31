import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:quizzzy/controllers/question_list_controller.dart';
import 'package:quizzzy/custom_widgets/custom_button.dart';
import 'package:quizzzy/custom_widgets/custom_popup.dart';
import 'package:quizzzy/custom_widgets/custom_snackbar.dart';
import 'package:quizzzy/service/db_model/question_set.dart';
import 'package:quizzzy/service/fs_database.dart';
import 'package:quizzzy/service/local_database.dart';

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
          const Text(
            "Do you want to delete this questionnaire?",
            style: TextStyle(
              fontFamily: 'Heebo',
              fontSize: 19,
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(255, 255, 255, 255),
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
                      '''users/${FirestoreService().user!.uid}/
                                                            ${questionList[idx]}''')) {
                    customSnackBar(
                        "Error", "Please try again", Colors.red.shade800);
                  } else {
                    controller.poppedList!.add(questionList[idx]);
                    UserSharedPreferences()
                        .setPoppedItems(controller.poppedList!);
                    // setState(() {});
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

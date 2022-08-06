import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:quizzzy/controllers/question_list_controller.dart';
import 'package:quizzzy/controllers/questionnaire_controller.dart';
import 'package:quizzzy/custom_widgets/custom_button.dart';
import 'package:quizzzy/custom_widgets/custom_card.dart';
import 'package:quizzzy/custom_widgets/custom_loading.dart';
import 'package:quizzzy/custom_widgets/custom_template.dart';
import 'package:quizzzy/screens/question_bank/top_bar.dart';
import 'package:quizzzy/screens/question_bank/delete_popup.dart';
import 'package:quizzzy/screens/question_bank/quiz_start_popup.dart';

/// Renders list of questionnaire naems on [QuestionBank] screen
///
/// OnClick functions of [CustomButton] will depend on [userType].
class QuestionBank extends StatefulWidget {
  const QuestionBank({Key? key}) : super(key: key);

  @override
  State<QuestionBank> createState() => _QuestionBankState();
}

class _QuestionBankState extends State<QuestionBank> {
  List<String> questionList = Get.find<QuestionListController>().questionList;

  /// Render popup common template.
  Widget popupTemplate(int idx, Widget popup) {
    return FutureBuilder(
        future: Get.find<QuestionnaireController>()
            .overwriteList(questionList[idx]),
        builder: (cntxt, snapshot) {
          Widget ret = Container();
          if (snapshot.connectionState == ConnectionState.done) {
            ret = popup;
          } else {
            ret = const CustomLoading();
          }
          return ret;
        });
  }

  @override
  Widget build(BuildContext context) {
    return CustomTemplate(
      body: Column(
        children: [
          const TopBar(txt: "Select Questionnaire"),
          Expanded(
            child: ListView.builder(
              itemCount: questionList.length,
              itemBuilder: (context, idx) {
                return CustomCard(
                    title: questionList[idx],
                    onLongPress: () {
                      showDialog(
                          context: context,
                          builder: (_) {
                            return popupTemplate(
                                idx,
                                DeletePopup(
                                  qName: questionList[idx],
                                ));
                          });
                    },
                    onTap: () async {
                      showDialog(
                          context: context,
                          builder: (_) {
                            return popupTemplate(idx, QuizStartPopup(idx: idx));
                          });
                    });
              },
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:quizzzy/controllers/question_list_controller.dart';
import 'package:quizzzy/controllers/questionnaire_controller.dart';
import 'package:quizzzy/custom_widgets/custom_button.dart';
import 'package:quizzzy/custom_widgets/custom_card.dart';
import 'package:quizzzy/custom_widgets/custom_loading.dart';
import 'package:quizzzy/custom_widgets/custom_template.dart';
import 'package:quizzzy/custom_widgets/top_bar.dart';
import 'package:quizzzy/screens/question_bank/delete_popup.dart';
import 'package:quizzzy/screens/question_bank/quiz_start_popup.dart';
import 'package:quizzzy/service/db_model/question_set.dart';

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

  /// Initialize Hive box
  @override
  initState() {
    super.initState();
    setBox();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTemplate(
      body: FutureBuilder(
          future: Get.find<QuestionListController>().filterList(),
          builder: (context, snapshot) {
            Widget ret = Container();
            if (snapshot.connectionState == ConnectionState.done) {
              ret = Column(
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
                                  builder: (BuildContext cntxt) {
                                    return DeletePopup(cntxt: cntxt, idx: idx);
                                  });
                            },
                            onTap: () async {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext cntxt) {
                                    return FutureBuilder(
                                        future:
                                            Get.find<QuestionnaireController>()
                                                .overwriteList(
                                                    questionList[idx]),
                                        builder: (cntxt, snapshot) {
                                          Widget ret = Container();
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            ret = QuizStartPopup(
                                                cntxt: cntxt, idx: idx);
                                          } else {
                                            ret = const CustomLoading();
                                          }
                                          return ret;
                                        });
                                  });
                            });
                      },
                    ),
                  )
                ],
              );
            } else {
              ret = const CustomLoading();
            }
            return ret;
          }),
    );
  }
}

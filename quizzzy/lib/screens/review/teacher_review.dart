import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzzy/controllers/quiz_controller.dart';

import 'package:quizzzy/custom_widgets/custom_card.dart';
import 'package:quizzzy/custom_widgets/custom_template.dart';
import 'package:quizzzy/screens/question_bank/top_bar.dart';
import 'package:quizzzy/screens/review/questionnaire_view.dart';

class TeacherReview extends StatelessWidget {
  final List<String> quizList = Get.find<QuizController>().quizList;
  TeacherReview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTemplate(
      body: Column(
        children: [
          const TopBar(txt: "Select Questionnaire"),
          Expanded(
            child: ListView.builder(
              itemCount: quizList.length,
              itemBuilder: (context, idx) {
                return CustomCard(
                    title: quizList[idx],
                    onLongPress: () {},
                    // onLongPress: () {
                    //   showDialog(
                    //       context: context,
                    //       builder: (_) {
                    //         return popupTemplate(
                    //             idx,
                    //             DeletePopup(
                    //               qName: questionList[idx],
                    //             ));
                    //       });
                    // },
                    onTap: () => Get.to(() => const QuestionnaireView()));
              },
            ),
          )
        ],
      ),
    );
  }
}

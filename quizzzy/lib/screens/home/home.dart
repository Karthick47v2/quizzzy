import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:quizzzy/controllers/question_list_controller.dart';
import 'package:quizzzy/controllers/user_type_controller.dart';
import 'package:quizzzy/screens/home/custom_button_wrapper.dart';
import 'package:quizzzy/custom_widgets/custom_loading.dart';
import 'package:quizzzy/custom_widgets/custom_snackbar.dart';
import 'package:quizzzy/custom_widgets/quizzzy_logo.dart';
import 'package:quizzzy/screens/home/exit_popup.dart';
import 'package:quizzzy/screens/home/home_page.dart';
import 'package:quizzzy/screens/import/import.dart';
import 'package:quizzzy/screens/home/logout_popup.dart';
import 'package:quizzzy/screens/question_bank/question_bank.dart';
import 'package:quizzzy/screens/home/quiz_code_popup.dart';
import 'package:quizzzy/service/fs_database.dart';

class Home extends StatelessWidget {
  final TextEditingController codeController;
  const Home({Key? key, required this.codeController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserTypeController>(builder: (controller) {
      return Builder(
        builder: (context) => Column(
          children: [
            const QuizzzyLogo(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
              child: Column(children: [
                CustomButtonWrapper(
                    text: "Import PDF",
                    onTap: () => Get.to(() => const ImportFile())),
                CustomButtonWrapper(
                    text: "Question Bank",
                    onTap: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext cntxt) {
                            checkQuesGenerated(cntxt);
                            return const CustomLoading();
                          });
                    }),
                controller.userType == "Student"
                    ? CustomButtonWrapper(
                        text: "Attempt quiz",
                        onTap: () async {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext cntxt) {
                                return StatefulBuilder(
                                    builder: (cntxt, setState) {
                                  return QuizCodePopup(
                                      context: cntxt,
                                      codeController: codeController);
                                });
                              });
                        })
                    : CustomButtonWrapper(
                        text: "Saved quiz",
                        onTap: () {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext cntxt) {
                                checkQuesGenerated(cntxt);
                                return const CustomLoading();
                              });
                        }),
                CustomButtonWrapper(
                    text: "Review quizzes",
                    onTap: () => Get.to(() => const HomePage())),
                CustomButtonWrapper(
                    text: "Log out",
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext cntxt) {
                            return LogoutPopup(context: cntxt);
                          });
                    }),
                CustomButtonWrapper(
                    text: "Quit",
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext cntxt) {
                            return ExitPopup(context: cntxt);
                          });
                    }),
              ]),
            )
          ],
        ),
      );
    });
  }

  /// Check if prevoius request got served.
  ///
  /// Returns wheter previous request state is finished or not.
  Future<void> checkQuesGenerated(BuildContext context) async {
    List<Object?> data = await FirestoreService().getQuestionnaireNameList();
    Get.find<QuestionListController>().overwriteList(data);

    String? str = await FirestoreService().getGeneratorStatus();

    if (str == "Generated" || data.isNotEmpty) {
      Get.to(() => const QuestionBank());
    } else {
      Navigator.pop(context);
      customSnackBar(
          "...",
          str == "Waiting"
              ? "Please wait for questions to get generated"
              : "Please upload a document to generate questions",
          (Colors.amber.shade400));
    }
  }
}

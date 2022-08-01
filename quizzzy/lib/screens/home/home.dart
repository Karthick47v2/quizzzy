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
import 'package:quizzzy/service/db_model/question_set.dart';
import 'package:quizzzy/service/fs_database.dart';
import 'package:quizzzy/service/local_database.dart';
import 'package:quizzzy/service/local_notification_service.dart';
import 'package:quizzzy/theme/palette.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final codeController = TextEditingController();

  Future<void> pushToken() async {
    questionSetBox = await setBox();
    String? token = await fm.getToken();
    String? oldToken = await UserSharedPreferences().getToken();
    if (oldToken != token) {
      await UserSharedPreferences().setToken(token!);
      await FirestoreService().saveTokenToDatabase(token);
    }
    fm.onTokenRefresh.listen(FirestoreService().saveTokenToDatabase);
  }

  @override
  initState() {
    super.initState();
    pushToken();
  }

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
    Navigator.pop(context);

    if (str == "Generated" || data.isNotEmpty) {
      Get.to(() => const QuestionBank());
    } else {
      customSnackBar(
          "No questionnaire found",
          str == "Waiting"
              ? "Please wait for questions to get generated"
              : "Please upload a document to generate questions",
          Palette.warning);
    }
  }
}

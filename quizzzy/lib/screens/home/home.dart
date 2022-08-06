import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:quizzzy/controllers/user_type_controller.dart';
import 'package:quizzzy/custom_widgets/custom_loading.dart';
import 'package:quizzzy/custom_widgets/quizzzy_logo.dart';
import 'package:quizzzy/screens/home/check_list.dart';
import 'package:quizzzy/screens/home/custom_button_wrapper.dart';
import 'package:quizzzy/screens/home/exit_popup.dart';
import 'package:quizzzy/screens/home/home_page.dart';
import 'package:quizzzy/screens/home/logout_popup.dart';
import 'package:quizzzy/screens/home/quiz_code_popup.dart';
import 'package:quizzzy/screens/import/import.dart';
import 'package:quizzzy/service/db_model/question_set.dart';
import 'package:quizzzy/service/firestore_db.dart';
import 'package:quizzzy/service/local_notification_service.dart';

/// Render [Home] screen for signned up users.
class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  /// Send device FCM token to [Firestore] if token updated.
  Future<void> pushToken() async {
    localStorage = await setBox();
    String? token = await fm.getToken();
    String? oldToken = localStorage.get('token');
    if (oldToken != token) {
      localStorage.put('token', token!);
      await FirestoreService().saveTokenToDatabase(token);
    }
    fm.onTokenRefresh.listen(FirestoreService().saveTokenToDatabase);
  }

  /// Initialize Hive Box and update FCM Token.
  @override
  initState() {
    super.initState();
    setBox();
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
                          builder: (_) {
                            Get.find<UserTypeController>().setMode(Mode.self);
                            checkQuesGenerated();
                            return const CustomLoading();
                          });
                    }),
                controller.userType == UserType.student
                    ? CustomButtonWrapper(
                        text: "Attempt quiz",
                        onTap: () async {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext cntxt) {
                                return StatefulBuilder(
                                    builder: (cntxt, setState) {
                                  Get.find<UserTypeController>()
                                      .setMode(Mode.quiz);
                                  return const QuizCodePopup();
                                });
                              });
                        })
                    : Container(),
                CustomButtonWrapper(
                    text: "Review quizzes",
                    onTap: () {
                      Get.find<UserTypeController>().setMode(Mode.review);
                      Get.to(() => const HomePage());
                    }),
                CustomButtonWrapper(
                    text: "Log out",
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_) {
                            return const LogoutPopup();
                          });
                    }),
                CustomButtonWrapper(
                    text: "Quit",
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_) {
                            return const ExitPopup();
                          });
                    }),
              ]),
            )
          ],
        ),
      );
    });
  }
}

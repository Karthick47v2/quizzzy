import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import 'package:quizzzy/custom_widgets/custom_template.dart';
import 'package:quizzzy/custom_widgets/quizzzy_logo.dart';
import 'package:quizzzy/screens/home/home_page.dart';
import 'package:quizzzy/service/local_notification_service.dart';
import 'package:quizzzy/theme/font.dart';
import 'package:quizzzy/theme/palette.dart';

/// Renders [Greetings] screen
class Greetings extends StatefulWidget {
  const Greetings({Key? key}) : super(key: key);

  @override
  State<Greetings> createState() => _GreetingsState();
}

class _GreetingsState extends State<Greetings> {
  @override
  initState() {
    super.initState();
    localNotificationService = LocalNotificationService(context);

    /// Notification handler - App on background state / terminated state.
    fm.getInitialMessage().then((msg) {
      if (msg != null) {
        Get.to(() => const HomePage());
      }
    });

    /// Notification handler - App on foreground state.
    FirebaseMessaging.onMessage.listen((msg) {
      if (msg.notification != null) {}

      localNotificationService.display(msg);
    });

    /// onTap - foreground state
    FirebaseMessaging.onMessageOpenedApp.listen((msg) {
      Get.to(() => const HomePage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomTemplate(
        body: Builder(
      builder: (_) => Column(
        children: [
          const QuizzzyLogo(),
          Container(
            width: double.maxFinite - 20,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
            alignment: Alignment.bottomCenter,
            child: Column(children: [
              Text(
                "WELCOME",
                style: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: 47,
                    fontWeight: Font.extraBold,
                    color: Palette.theme),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Scroll up to continue",
                style: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: 17,
                    fontWeight: Font.regular,
                    color: Palette.txtInput),
                textAlign: TextAlign.center,
              ),
            ]),
          ),
        ],
      ),
    ));
  }
}

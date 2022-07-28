import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import 'package:quizzzy/libs/custom_widgets.dart';
import 'package:quizzzy/src/home_page.dart';
import 'package:quizzzy/src/service/local_notification_service.dart';

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
    return QuizzzyTemplate(
        body: Builder(
      builder: (context) => Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/Quizzzy.png',
              ),
            ),
          ),
          Container(
            width: double.maxFinite - 20,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
            alignment: Alignment.bottomCenter,
            child: Column(children: const [
              Text(
                "WELCOME",
                style: TextStyle(
                    fontFamily: 'Heebo',
                    fontSize: 47,
                    fontWeight: FontWeight.w800,
                    color: Color.fromARGB(255, 93, 0, 155)),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Scroll up to continue",
                style: TextStyle(
                    fontFamily: 'Heebo',
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: Color.fromARGB(255, 209, 209, 209)),
                textAlign: TextAlign.center,
              ),
            ]),
          ),
        ],
      ),
    ));
  }
}

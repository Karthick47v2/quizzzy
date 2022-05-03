import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:quizzzy/libs/custom_widgets.dart';
import 'package:quizzzy/src/service/local_notification_service.dart';
import 'home_page.dart';

class Greetings extends StatefulWidget {
  const Greetings({Key? key}) : super(key: key);

  @override
  State<Greetings> createState() => _GreetingsState();
}

class _GreetingsState extends State<Greetings> {
  @override
  initState() {
    super.initState();

    // initialze local notification handler (when in foreground)
    LocalNotificationService.initialize(context);

    // always go to home when notification is pressed (bg / terminated state only)
    FirebaseMessaging.instance.getInitialMessage().then((msg) {
      if (msg != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      }
    });

    // foreground msg handler
    FirebaseMessaging.onMessage.listen((msg) {
      if (msg.notification != null) {
        //TODO: LATER
      }

      LocalNotificationService.display(msg);
    });

    // onTap
    FirebaseMessaging.onMessageOpenedApp.listen((msg) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return QuizzzyTemplate(
        body: Builder(
      builder: (context) => Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 40,
            child: Image.asset(
              'assets/images/Quizzzy.png',
              width: 338,
              height: 407,
              fit: BoxFit.cover,
            ),
          ),
          const Positioned(
            bottom: 80,
            child: Text(
              "WELCOME",
              style: TextStyle(
                  fontFamily: 'Heebo',
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 93, 0, 155)),
              textAlign: TextAlign.center,
            ),
          ),
          const Positioned(
            bottom: 40,
            child: Text(
              "Scroll up to continue",
              style: TextStyle(
                  fontFamily: 'Heebo',
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  color: Color.fromARGB(255, 209, 209, 209)),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    ));
  }
}

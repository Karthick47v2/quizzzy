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
    localNotificationService = LocalNotificationService(context);

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

      localNotificationService.display(msg);
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

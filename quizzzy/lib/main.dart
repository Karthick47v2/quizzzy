import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quizzzy/src/greeting.dart';
import 'package:quizzzy/src/home_page.dart';
import 'package:quizzzy/src/import.dart';
import 'package:quizzzy/src/service/local_notification_service.dart';

Future<void> main() async {
  // initialize all widgets
  WidgetsFlutterBinding.ensureInitialized();
  // initialize firebase
  await Firebase.initializeApp();
  // initialize fcm bg msh handler (when in bg / terminiated)
  FirebaseMessaging.onBackgroundMessage(bgNotificationHandler);

  // check if user is logged in (firebase)
  User? user = FirebaseAuth.instance.currentUser;

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(Root(
    user: user,
  ));
}

// bg notification handler
Future<void> bgNotificationHandler(RemoteMessage msg) async {
  print(msg.data.toString());
  print(msg.notification!.title);
}

class Root extends StatefulWidget { 
  final User? user;
  const Root({Key? key, required this.user}) : super(key: key);

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  bool canScroll = true;

  // @override
  // void initState() {
  //   super.initState();

  //   // initialze local notification handler (when in foreground)
  //   LocalNotificationService.initialize(context);

  //   // always go to home when notification is pressed (bg / terminated state only)
  //   FirebaseMessaging.instance.getInitialMessage().then((msg) {
  //     if (msg != null) {
  //       Navigator.push(
  //           context, MaterialPageRoute(builder: (context) => const HomePage()));
  //     }
  //   });

  //   // foreground msg handler
  //   FirebaseMessaging.onMessage.listen((msg) {
  //     if (msg.notification != null) {
  //       print(msg.notification!.body);
  //       print(msg.notification!.title);
  //     }

  //     LocalNotificationService.display(msg);
  //   });

  //   // onTap
  //   FirebaseMessaging.onMessageOpenedApp.listen((msg) {
  //     Navigator.push(
  //         context, MaterialPageRoute(builder: (context) => const HomePage()));
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // if user email is verified show homepage or else show login page
    return MaterialApp(
        home: Scaffold(
      body: PageView(
        scrollDirection: Axis.vertical,
        physics: canScroll
            ? const ScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        children: [
          const Greetings(),
          const ImportFile()
          // (widget.user == null)
          //     ? const SignUp()
          //     : (widget.user!.emailVerified)
          //         ? const HomePage()
          // : const VerifyEmail(),
        ],
        onPageChanged: (n) => {setState(() => canScroll = false)},
      ),
    ));
  }
}

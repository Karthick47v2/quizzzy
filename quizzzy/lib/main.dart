//TODO: FIND MULTIPLE INSTANCES OF FIREBASE

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quizzzy/src/auth/signup.dart';
import 'package:quizzzy/src/auth/verify.dart';
import 'package:quizzzy/src/greeting.dart';
import 'package:quizzzy/src/home_page.dart';
import 'package:quizzzy/src/service/db_model/question_set.dart';
import 'package:quizzzy/src/service/local_database.dart';

Future main() async {
  // initialize required things
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.registerAdapter(QuestionSetAdapter());
  await UserSharedPrefernces.init();
  FirebaseMessaging.onBackgroundMessage(bgNotificationHandler);
  User? user = FirebaseAuth.instance.currentUser;

  // store box to mem
  await Hive.openBox('user');

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(Root(
    user: user,
  ));
}

// bg notification handler
Future bgNotificationHandler(RemoteMessage msg) async {
  //TODO: LATER
}

class Root extends StatefulWidget {
  final User? user;
  const Root({Key? key, required this.user}) : super(key: key);

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  bool canScroll = true;

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
          (widget.user == null)
              ? const SignUp()
              : (widget.user!.emailVerified)
                  ? const HomePage()
                  : const VerifyEmail(),
        ],
        onPageChanged: (n) => {setState(() => canScroll = false)},
      ),
    ));
  }
}

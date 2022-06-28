import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quizzzy/src/greeting.dart';
import 'package:quizzzy/src/service/db_model/question_set.dart';
import 'package:quizzzy/src/service/dynamic_links.dart';
import 'package:quizzzy/src/service/fbase_auth.dart';
import 'package:quizzzy/src/service/fs_database.dart';
import 'package:quizzzy/src/service/local_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/auth/signup.dart';
import 'src/auth/verify.dart';
import 'src/home_page.dart';

Future main() async {
  // initialize required things
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.registerAdapter(QuestionSetAdapter());
  sharedPref =
      UserSharedPreferences(prefs: await SharedPreferences.getInstance());
  FirebaseMessaging.onBackgroundMessage(bgNotificationHandler);
  auth = Auth(auth: FirebaseAuth.instance);
  dlink = DynamicLinks(dLink: FirebaseDynamicLinks.instance);

  fs = FirestoreService(
      inst: FirebaseFirestore.instance, user: auth.auth.currentUser, fbFunc: FirebaseFunctions.instance);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  // // store box to mem
  // await Hive.openBox('user');

  runApp(const Root());
}

// bg notification handler
Future bgNotificationHandler(RemoteMessage msg) async {
  //TODO: LATER
}

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  bool canScroll = true;

  @override
  Widget build(BuildContext context) {
    //initialize dynamic links
    dlink.initDynamicLink(context);
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
          // ignore: unnecessary_null_comparison
          (fs.user == null)
              ? const SignUp()
              : (fs.user!.emailVerified)
                  ? const HomePage()
                  : const VerifyEmail(),
        ],
        onPageChanged: (n) => {setState(() => canScroll = false)},
      ),
    ));
  }
}

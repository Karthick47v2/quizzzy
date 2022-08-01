import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quizzzy/theme/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:quizzzy/custom_widgets/custom_template.dart';
import 'package:quizzzy/screens/landing/greeting.dart';
import 'package:quizzzy/screens/auth/signup.dart';
import 'package:quizzzy/screens/auth/verify.dart';
import 'package:quizzzy/screens/home/home_page.dart';
import 'package:quizzzy/service/db_model/question_set.dart';
import 'package:quizzzy/service/local_database.dart';
import 'package:quizzzy/service/local_notification_service.dart';
import 'package:quizzzy/service/fs_database.dart';
import 'package:quizzzy/init_controllers.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await initServices();
  await initControllers();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Palette.transparent,
  ));

  runApp(const Root());
}

/// Handle notification while app is on background
Future bgNotificationHandler(RemoteMessage msg) async {}

/// Renders [Root] widget.
///
/// Returns [HomePage] or [SignUp] page according to user auth status. If user signed up and not
/// verified their email address, then [VerifyEmail] page will be rendered
class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  bool canScroll = true;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        home: CustomTemplate(
      body: PageView(
        scrollDirection: Axis.vertical,
        physics: canScroll
            ? const ScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        children: [
          const Greetings(),
          (FirestoreService().user == null)
              ? const SignUp()
              : (FirestoreService().user!.emailVerified)
                  ? const HomePage()
                  : const VerifyEmail(),
        ],
        onPageChanged: (n) => {setState(() => canScroll = false)},
      ),
    ));
  }
}

/// Initialize and setup all database management services
initServices() async {
  Hive.registerAdapter(QuestionSetAdapter());
  UserSharedPreferences(prefs: await SharedPreferences.getInstance());
  fm = FirebaseMessaging.instance;
  // FirebaseMessaging.onBackgroundMessage(bgNotificationHandler);
}

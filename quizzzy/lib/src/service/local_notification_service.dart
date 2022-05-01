import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin notificationPlugin =
      FlutterLocalNotificationsPlugin();
  static void initialize(BuildContext context) {
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"));

    notificationPlugin.initialize(initializationSettings);
  }

  static void display(RemoteMessage msg) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      const NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails("mcq-gen", "mcq-gen-app",
              importance: Importance.max, priority: Priority.high));

      await notificationPlugin.show(id, msg.notification!.title,
          msg.notification!.body, notificationDetails,
          payload: msg.notification!.body);
    } on Exception catch (e) {
      print(e);
    }
  }
}

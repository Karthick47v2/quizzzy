import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LocalNotificationService {
  late FlutterLocalNotificationsPlugin _notificationPlugin;

  LocalNotificationService(BuildContext context) {
    _notificationPlugin = FlutterLocalNotificationsPlugin();
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"));

    _notificationPlugin.initialize(initializationSettings);
  }

  /// Push notification to mobile with [msg]
  display(RemoteMessage msg) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      const NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails("mcq-gen", "mcq-gen-app",
              importance: Importance.max, priority: Priority.high));

      await _notificationPlugin.show(id, msg.notification!.title,
          msg.notification!.body, notificationDetails,
          payload: msg.notification!.body);
      // ignore: empty_catches, unused_catch_clause
    } on Exception catch (e) {}
  }
}

late LocalNotificationService localNotificationService;
late FirebaseMessaging fm;

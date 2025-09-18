import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:jobprogress/common/models/push_notifications/push_notification.dart';
import 'package:jobprogress/common/services/local_notifications/index.dart';

class PushNotificationsService {

  static Future<String?> getToken() async {
    try {
      if (Platform.isIOS) {
        String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        if (apnsToken != null) {
          return await FirebaseMessaging.instance.getToken();
        }
        return null;
      } else {
        return await FirebaseMessaging.instance.getToken();
      }
    } catch (e) {
      return null;
    }
  }

  static Future<void> init() async {

    await FirebaseMessaging.instance.requestPermission(
      sound: true,
      alert: true,
    );

    await LocalNotificationsService.init(); // setting up local notifications

    // initializing a stream to listen foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint('MESSAGE : ${message.toMap()}');
      await LocalNotificationsService.show(message); // displaying notification
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // parsing data notification response
      final PushNotificationModel notificationData = PushNotificationModel.fromJson(message.data);
      LocalNotificationsService.parseAndNavigate(jsonEncode(notificationData));
    });

    // setting up background notification stream
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }
}

// top-level function to handle background notifications
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  debugPrint('MESSAGE : ${message.toMap()}');
  debugPrint('Handling a background message ${message.messageId}');

  await LocalNotificationsService.init(); // setting up local notifications

  try {
    await Firebase.initializeApp(); // setting up firebase app
  } catch (e) {
    debugPrint(e.toString());
  } finally {
    if(message.notification == null) LocalNotificationsService.show(message); // displaying notification
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jobprogress/common/models/push_notifications/push_notification.dart';
import 'package:jobprogress/common/services/local_notifications/settings.dart';
import 'package:jobprogress/common/services/local_notifications/tap_handler.dart';

class LocalNotificationsService {

  /// flutterLocalNotificationsPlugin will handle local notifications
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// AndroidNotificationChannel for heads up notifications
  static AndroidNotificationChannel channel =
      LocalNotificationSettings.androidChannelDetails;

  static int? lastNotificationClickId;

  /// init(): will initialize local notification
  static Future<void> init() async {

    // initializing up platform notification settings
    const InitializationSettings initializationSettings = InitializationSettings(
      android: LocalNotificationSettings.initializationSettingsAndroid,
      iOS: LocalNotificationSettings.initializationSettingsIos,
    );

    // overriding default notification channel
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.

    if(Platform.isIOS) {
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        sound: true,
        alert: true,
        badge: true,
      );
    }

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {

        if(lastNotificationClickId == notificationResponse.id) return;

        LocalNotificationsService.parseAndNavigate(notificationResponse.payload!);

        lastNotificationClickId = notificationResponse.id;

      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  static Future<void> show(RemoteMessage message) async {

    /// creating notification id
    final notificationTime = (message.sentTime ?? DateTime.now()).microsecondsSinceEpoch.toString();
    final notificationId = notificationTime.substring(7, notificationTime.length);

    // parsing data notification response
    final PushNotificationModel notificationData = PushNotificationModel.fromJson(message.data);

    if(!Platform.isAndroid) return;

    await flutterLocalNotificationsPlugin.show(
      int.parse(notificationId),
      notificationData.title,
      notificationData.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: Importance.high,
          priority: Priority.defaultPriority,
          enableVibration: true,
          visibility: NotificationVisibility.public,
        ),
        iOS: const DarwinNotificationDetails()
      ),
      payload: jsonEncode(notificationData),
    );
  }

  static void parseAndNavigate(String notificationPayload) {
    // parsing payload
    Map<String, dynamic> payload = jsonDecode(notificationPayload);

    // navigates to respective view as of notification type
    LocalNotificationHandler.typeToView(data: PushNotificationModel.fromJson(payload));
  }

  @pragma('vm:entry-point')
  static void notificationTapBackground(NotificationResponse notificationResponse) {

    debugPrint('notification(${notificationResponse.id}) action tapped: '
        '${notificationResponse.actionId} with'
        ' payload: ${notificationResponse.payload}');

    if (notificationResponse.payload?.isNotEmpty ?? false) {
      debugPrint('notification action tapped with input: ${notificationResponse.payload}');
    }

  }
}

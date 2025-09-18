import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jobprogress/core/constants/push_notification.dart';

class LocalNotificationSettings {

  static AndroidNotificationChannel androidChannelDetails = const AndroidNotificationChannel(
    PushNotificationConstants.channelId, // id
    PushNotificationConstants.channelTitle, // title
    description:
    PushNotificationConstants.channelDescription, // description
    importance: Importance.high,
  );

  static const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('ic_notification');

  static const DarwinInitializationSettings initializationSettingsIos = DarwinInitializationSettings();
}

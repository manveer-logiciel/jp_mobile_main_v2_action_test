import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/enums/notification.dart';
import 'package:jobprogress/common/models/notification/notification.dart';
import 'package:jobprogress/modules/notification_listing/widgets/notification_subtitle.dart';
import 'package:jobprogress/modules/notification_listing/widgets/notification_title.dart';

void main() {

  Widget buildTestableWidget(Widget widget) {
    return MediaQuery(
      data: const MediaQueryData(),
      child: MaterialApp(home: Material(child: widget))
    );
  }

  group("Notification Listing Widget testing", () {
    testWidgets("NotificationSubtitle widget should return some widget", (WidgetTester tester) async {
      NotificationListingModel notificationData = NotificationListingModel.fromJson(notificationJson1);
      UniqueKey widgetKey = UniqueKey();

      final subTitleWidget = buildTestableWidget(
        NotificationSubtitle(
          key: widgetKey,
          notification: notificationData,
        )
      );

      await tester.pumpWidget(subTitleWidget);

      expect(find.byKey(widgetKey), findsOneWidget);
    });
    testWidgets("NotificationTitle widget should return some widget", (WidgetTester tester) async {
      NotificationListingModel notificationData = NotificationListingModel.fromJson(notificationJson1);
      UniqueKey widgetKey = UniqueKey();

      final titleWidget = buildTestableWidget(
        NotificationTitle(
          key: widgetKey,
          notification: notificationData,
        )
      );

      await tester.pumpWidget(titleWidget);

      expect(find.byKey(widgetKey), findsOneWidget);
    });

    test('NotificationListingModel should get notification type NotificationType.workCrewNote', () {
      NotificationListingModel notificationData = NotificationListingModel.fromJson(notificationJson1);
      expect(notificationData.notificationType, NotificationType.workCrewNote);
    });

    test('NotificationListingModel should Get default notification type if dont have any notification type notification object', () {
      NotificationListingModel notificationData = NotificationListingModel.fromJson(notificationJson2);
      expect(notificationData.notificationType, NotificationType.notification);
    });

    test('NotificationListingModel@getIcon should Get Notification icon', () {
      NotificationListingModel notificationData = NotificationListingModel.fromJson(notificationJson1);
      IconData icon = notificationData.getIcon();
      
      expect(icon, Icons.three_p_outlined);
    });
    
    test('NotificationListingModel@getIcon should Get Default Notification icon if dont have any notification type notification object', () {
      NotificationListingModel notificationData = NotificationListingModel.fromJson(notificationJson2);
      IconData icon = notificationData.getIcon();

      expect(icon, Icons.notifications_outlined);
    });
  });
}

Map<dynamic, dynamic> notificationJson1 = {
  "id": 89355,
  "subject": "Anuj Singh mentioned you in a Work Crew Note for AMber stone / 2205-30374-33",
  "body": {
    "job_id": 17312,
    "customer_id": 30374,
    "stage_resource_id": 17,
    "job_resource_id": "282422",
    "company_id": 1
  },
  "object_type": "WorkCrewNote",
  "object": {
    "id": 2133,
    "job_id": 17312,
    "note": "sdasd @[u:1]",
    "created_by": 1,
    "deleted_by": 0,
    "created_at": "2022-06-20 12:46:52",
    "updated_at": "2022-06-20 12:46:52",
    "deleted_at": null
  },
  "job": {
    "id": 17312,
    "customer_id": 30374,
    "number": "2205-30374-33",
    "alt_id": "2020-899",
    "customer_first_name": "AMber stone",
    "customer_full_name": "AMber stone",
    "customer_full_name_mobile": "AMber stone",
    "customer_email": "nikhilsharma101@gmail.com"
  },
  "recipients": {
    "data": [
      {
        "id": 1,
        "first_name": "Anuj",
        "last_name": "Singh",
        "full_name": "Anuj Singh",
        "full_name_mobile": "Anuj Singh",
        "email": "rahul@logiciel.io",
        "group_id": 5,
        "profile_pic": "https://scdn.jobprog.net/public%2Fuploads%2Fcompany%2Fusers%2F1_1652070356.jpg",
        "color": "#1c36ee",
        "all_divisions_access": true,
      }
    ]
  }
};

Map<dynamic, dynamic> notificationJson2 = {
  "id": 89350,
};
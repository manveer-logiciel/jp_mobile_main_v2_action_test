import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/notification/notification_group.dart';
import 'package:jobprogress/global_widgets/listview/index.dart';
import 'package:jobprogress/modules/notification_listing/widgets/notification_tile.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';

import '../controller.dart';

class NotificationsList extends StatelessWidget {

  const NotificationsList({
    super.key,
    required this.notifications,
    required this.controller
  });

  final GroupNotificationListingModel notifications;

  final NotificationListingController controller;

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        JPListView(
            listCount: notifications.groupValues.length - 1,
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (_, index) {

              final notification = notifications.groupValues[index];

              return Material(
                color: JPAppTheme.themeColors.base,
                child: InkWell(
                  child: NotificationTile(
                    notification: notification,
                    onReject: () => controller.jobPriceStatusUpdate(notification, 0),
                    onAccept: () => controller.jobPriceStatusUpdate(notification, 1),
                  ),
                  onTap: () => controller.handleNotificationClick(notification),
                ),
              );
            }),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/notification/notification.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import 'notification_actions.dart';
import 'notification_subtitle.dart';
import 'notification_title.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.notification,
    this.onAccept,
    this.onReject
  });

  final NotificationListingModel notification;

  final VoidCallback? onAccept;

  final VoidCallback? onReject;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: (notification.isRead
              ? null
              : JPAppTheme.themeColors.lightBlue.withValues(alpha: 0.8))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  color: JPAppTheme.themeColors.primary),
              child: JPIcon(notification.getIcon(),
                  color: JPAppTheme.themeColors.base, size: 16),
            ),
          ),
          Expanded(
            child: Row(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NotificationTitle(notification: notification),
                    NotificationSubtitle(notification: notification),
                    const SizedBox(height: 3),
                    JPText(
                      height: 1.5,
                      textSize: JPTextSize.heading5,
                      textAlign: TextAlign.left,
                      text: DateTimeHelper.formatDate(
                          notification.createdAt.toString(), 'am_time_ago'),
                      textColor: (notification.isRead
                          ? JPAppTheme.themeColors.darkGray
                          : JPAppTheme.themeColors.primary),
                    ),
                    NotificationActions(
                      notification: notification,
                      onAccept: onAccept,
                      onReject: onReject,
                    ),
                  ],
                ),
              )
            ]),
          )
        ],
      ),
    );
  }
}

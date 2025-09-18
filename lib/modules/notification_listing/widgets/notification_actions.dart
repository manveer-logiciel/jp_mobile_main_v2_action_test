import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/notification.dart';
import 'package:jobprogress/common/models/notification/notification.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class NotificationActions extends StatelessWidget {

  const NotificationActions({
    super.key,
    required this.notification,
    this.onAccept,
    this.onReject,
  });

  final NotificationListingModel notification;

  final VoidCallback? onAccept;

  final VoidCallback? onReject;

  @override
  Widget build(BuildContext context) {
    switch (notification.notificationType) {
      case NotificationType.jobPriceRequest:
        if (
          notification.jobPrice!.approvedBy == null &&
          notification.jobPrice!.rejectedBy == null
        ) {
          return Padding(
            padding: const EdgeInsets.only(top: 7),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: JPButton(
                    text: "approve".tr.toUpperCase(),
                    size: JPButtonSize.extraSmall,
                    colorType: JPButtonColorType.primary,
                    onPressed: onAccept,
                  ),
                ),
                JPButton(
                  text: "reject".tr.toUpperCase(),
                  size: JPButtonSize.extraSmall,
                  colorType: JPButtonColorType.lightGray,
                  onPressed: onReject,
                )
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();  
        }
      default:
        return const SizedBox.shrink();
    }
  }
}

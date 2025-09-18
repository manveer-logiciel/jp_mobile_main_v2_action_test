import 'package:flutter/material.dart';
import 'package:jobprogress/common/enums/notification.dart';
import 'package:jobprogress/common/models/notification/notification.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class NotificationSubtitle extends StatelessWidget {

  const NotificationSubtitle({
    super.key,
    required this.notification
  });

  final NotificationListingModel notification;

  Widget getSubtitle() {
    switch (notification.notificationType) {
      case NotificationType.workCrewNote:
      case NotificationType.jobNote:
      case NotificationType.jobFollowUp:
        return Container(
          margin: const EdgeInsets.only(top: 3),
          child: JPRichText(
            text: Helper.formatNote(
              notification.noteDetail!.note.toString(),
              notification.recipients,
              'id',
              'full_name',
              JPAppTheme.themeColors.darkGray,
              JPTextSize.heading5
            ),
            strutStyle: const StrutStyle(
              height: 1.5
            ),
            maxLines: 3,
            textHeightBehavior: const TextHeightBehavior(
          applyHeightToFirstAscent: false,
        ),
            overflow: TextOverflow.ellipsis,
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return getSubtitle();
  }
}

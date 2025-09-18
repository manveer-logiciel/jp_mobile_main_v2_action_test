import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/notification.dart';
import 'package:jobprogress/common/models/notification/notification.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:jobprogress/common/extensions/String/index.dart';

class NotificationTitle extends StatelessWidget {

  const NotificationTitle({
    super.key,
    required this.notification
  });

  final NotificationListingModel notification;

  TextSpan getTitle() {
    TextSpan subject = JPTextSpan.getSpan('', height: 1.5, children: []);
    
    switch (notification.notificationType) {
      
      case NotificationType.userRegistrationInvite:
      subject.children?.addAll([
        JPTextSpan.getSpan('${notification.subject ?? ''} '),
        JPTextSpan.getSpan('you_may_send_a_new_invitation_from_user_settings_if_needed'.tr)
      ]);
    
        break;
      case NotificationType.task:
        subject.children?.add(
          JPTextSpan.getSpan(
            TrimEnter(notification.subject!).trim()
          )
        );

        if(notification.body!.type == 'task_completed') {

          if(notification.body!.completedBy != null){
            subject.children?.add(
              JPTextSpan.getSpan(' by ')
            );
            subject.children?.add(
              JPTextSpan.getSpan(
                notification.body!.completedBy!,
                textColor: JPAppTheme.themeColors.primary
              )
            );
          }
          
          if(notification.task != null) {
            subject.children?.add(
              JPTextSpan.getSpan(
                ' - ${notification.task!.title}'
              )
            );
          }
        }

        break;
      case NotificationType.customer:
        subject.children?.add(
          JPTextSpan.getSpan(
            '${TrimEnter(notification.subject!).trim()} for '
          )
        );

        if(
          notification.customer != null &&
          notification.customer!.fullName != null
        ){
          subject.children?.add(
            JPTextSpan.getSpan(
              notification.customer!.fullName!,
              textColor: JPAppTheme.themeColors.primary
            )
          );
        }

        break;
      case NotificationType.job:
        subject.children?.add(
          JPTextSpan.getSpan(
            '${TrimEnter(notification.subject!).trim()} for '
          )
        );

        if(
          notification.job != null &&
          notification.job!.customer != null &&
          notification.job!.customer!.fullName != null
        ){
          subject.children?.add(
            JPTextSpan.getSpan(
              '${notification.job!.customer!.fullName!} / ${Helper.getJobName(notification.job!)}',
              textColor: JPAppTheme.themeColors.primary
            )
          );
        }

        break;
      case NotificationType.workCrewNote:
      case NotificationType.jobNote:
      case NotificationType.jobFollowUp:
        if(notification.sender != null) {
          subject.children?.add(
            JPTextSpan.getSpan(
              notification.sender!.fullName,
              textColor: JPAppTheme.themeColors.primary
            )
          );
        }

        subject.children?.add(
          JPTextSpan.getSpan(' mentioned you in a ')
        );


        if(notification.notificationType == NotificationType.jobFollowUp){
          subject.children?.add(
            JPTextSpan.getSpan('job followup note')
          );
        }

        if(notification.notificationType == NotificationType.workCrewNote){
          subject.children?.add(
            JPTextSpan.getSpan('work crew note')
          );
        }

        if(notification.notificationType == NotificationType.jobNote){
          subject.children?.add(
            JPTextSpan.getSpan('job note')
          );
        }

        if (
          notification.job != null &&
          notification.job!.customer != null &&
          notification.job!.customer!.fullName != null
        ) {
          subject.children?.add(
            JPTextSpan.getSpan(' for ')
          );

          subject.children?.add(
            JPTextSpan.getSpan(
              '${notification.job!.customer!.fullName!} / ${Helper.getJobName(notification.job!)}',
              textColor: JPAppTheme.themeColors.primary
            )
          );
        }
        break;
      case NotificationType.jobPriceRequest:
        subject.children?.add(
          JPTextSpan.getSpan('You have received a job price update request')
        );

        if (
          notification.job != null &&
          notification.job!.customer!.fullName != null
        ) {
          subject.children?.add(
            JPTextSpan.getSpan(' for ')
          );
          
          subject.children?.add(
            JPTextSpan.getSpan(
              notification.job!.customer!.fullName!,
              textColor: JPAppTheme.themeColors.primary
            )
          );
          
          if(notification.job != null){
            subject.children?.add(
              JPTextSpan.getSpan(
                ' / ${Helper.getJobName(notification.job!)}',
                textColor: JPAppTheme.themeColors.primary
              )
            );
          }
        }

        break;
      case NotificationType.announcement:
      case NotificationType.documentExpired:
      case NotificationType.message:
      case NotificationType.worksheet:
      default:
        subject.children?.add(
          JPTextSpan.getSpan(
            TrimEnter(notification.subject!).trim()
          )
        );
        break;
    }

    return subject;
  }

  @override
  Widget build(BuildContext context) {
    return JPRichText(
        text: getTitle(),
        textHeightBehavior: const TextHeightBehavior(
          applyHeightToFirstAscent: false,
        ),
        maxLines: 3,
    );
  }
}

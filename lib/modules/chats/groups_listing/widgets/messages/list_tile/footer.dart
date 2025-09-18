import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/global_widgets/replace_job_id_with_company_setting/job_name_with_company_setting.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ChatsMessageTileFooter extends StatelessWidget {
  const ChatsMessageTileFooter({
    super.key,
    required this.lastMessage,
    required this.job,
    required this.messageCount,
  });

  /// lastMessage to display message
  final String lastMessage;

  /// job to display job details
  final JobModel? job;

  /// messageCount helps in displaying message count
  final int messageCount;

  @override
  Widget build(BuildContext context) {

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 2,
              ),
              
              Row(
                children: [
                  Expanded(
                    child: JPText(
                      text: lastMessage,
                      maxLine: 1,
                      textSize: JPTextSize.heading5,
                      overflow: TextOverflow.ellipsis,
                      textColor: JPAppTheme.themeColors.tertiary,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 3,
              ),
              if(job != null)
                JobNameWithCompanySetting(
                  job: job!,
                  textSize: JPTextSize.heading5,
                  textColor: JPAppTheme.themeColors.tertiary,
                )
            ],
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        if(messageCount > 0) ...[
          JPBadge(
            text: '$messageCount',
            backgroundColor: JPAppTheme.themeColors.tertiary,
          ),
        ]
      ],
    );
  }
}

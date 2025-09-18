
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job/job_follow_up_status.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JobOverViewLostJobCard extends StatelessWidget {

  const JobOverViewLostJobCard({
    super.key,
    this.onTapReinstate,
    this.status
  });

  final JobFollowUpStatus? status;

  final VoidCallback? onTapReinstate;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: JPAppTheme.themeColors.base,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Row(
          crossAxisAlignment: !AuthService.isPrimeSubUser() ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 2
              ),
              child: Image.asset(
                'assets/images/lost-job-watermark.png',
                height: 42,
                width: 42,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  JPText(
                    text: status?.note ?? '',
                    textAlign: TextAlign.start,
                    textColor: JPAppTheme.themeColors.tertiary,
                    height: 1.3,
                  ),
                  if(!AuthService.isPrimeSubUser())...{
                    const SizedBox(
                      height: 10,
                    ),
                    JPButton(
                      text: 'reinstate'.tr.toUpperCase(),
                      type: JPButtonType.outline,
                      size: JPButtonSize.extraSmall,
                      onPressed: onTapReinstate,
                    )
                  }
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

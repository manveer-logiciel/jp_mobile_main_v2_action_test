import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JobHeaderDetail extends StatelessWidget {
  const JobHeaderDetail({
    super.key,
     required this.job,
     this.textColor
  });
  
  final JobModel? job;
  final Color? textColor;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        JPText(
          text: job?.customer?.fullName?? '',
          textColor: textColor ?? JPAppTheme.themeColors.base,
          fontWeight: JPFontWeight.medium,
        ),
        const SizedBox(height: 3),
        if (job != null)
          JPText(
          text: Helper.getJobName(job!),
          textSize: JPTextSize.heading5,
          textColor:textColor ?? JPAppTheme.themeColors.base,
        ),
      ]
    );
  }
}
import 'package:flutter/material.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../core/constants/assets_files.dart';

class ScheduleDetailTimeDetails extends StatelessWidget {
  const ScheduleDetailTimeDetails({
    this.startDateTime,
    this.endDateTime,
    this.isRecurring = false,
    super.key
  });

  final String? startDateTime;
  final String? endDateTime;
  final bool isRecurring;

  @override
  Widget build(BuildContext context) {

    String startDate = DateTimeHelper.formatDate(
      startDateTime.toString(),
      DateFormatConstants.dateMonthOnlyDateLetterFormat
    );

    String endDate = DateTimeHelper.formatDate(
      endDateTime.toString(),
      DateFormatConstants.dateMonthOnlyDateLetterFormat
    );

    String startTime = DateTimeHelper.formatDate(
      startDateTime.toString(),
      DateFormatConstants.timeOnlyFormat
    );

    String endTime = DateTimeHelper.formatDate(
      endDateTime.toString(),
      DateFormatConstants.timeOnlyFormat
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        JPIcon(
          Icons.access_time,
          color: JPAppTheme.themeColors.darkGray,
        ),
        const SizedBox(
          width: 15,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                JPText(
                  text: startDate,
                ),
                (startDate != endDate)
                    ? JPText(text: ' - $endDate')
                    : const SizedBox.shrink(),
                const SizedBox(width: 9,),
                Image.asset(isRecurring
                  ? AssetsFiles.recurringIcon
                  : AssetsFiles.notRecurringIcon,
                  width: 13, height: 14
                ),
              ],
            ),
            const SizedBox(
              height: 6,
            ),
            JPText(text: '$startTime- $endTime'),
          ],
        )
      ],
    );
  }
}

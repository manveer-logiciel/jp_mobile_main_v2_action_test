import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../core/constants/date_formats.dart';
import '../../core/utils/date_time_helpers.dart';

class DateDetailTile extends StatelessWidget {
  final String title;
  final String? date;
  const DateDetailTile({
    super.key, required this.title, this.date,
  });

  @override
  Widget build(BuildContext context) {
    return date != null && date!.isNotEmpty ?
    Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          JPText(
            text: title,
            textColor: JPAppTheme.themeColors.tertiary,
          ),
          JPText(
            text: 
            '${DateTimeHelper.formatDate(date!, DateFormatConstants.chatPastMessageFormat)} at ${DateTimeHelper.formatDate(date!, DateFormatConstants.timeOnlyFormat)}'
          ),
        ],
      ),
    ): const SizedBox.shrink();
  }
}
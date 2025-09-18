
import 'package:flutter/material.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class CalendarHeaderDateSelector extends StatelessWidget {
  const CalendarHeaderDateSelector({
    super.key,
    this.onTap,
    required this.selectedDate
  });

  /// handles click on date
  final VoidCallback? onTap;

  /// selectedDate used to display selected month and year
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      transform: Matrix4.translationValues(-4, 0, 0),
      child: Material(
        color: JPColor.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      child: JPText(
                        text: DateTimeHelper.format(selectedDate, DateFormatConstants.monthName),
                        textSize: JPTextSize.heading3,
                        fontWeight: JPFontWeight.medium,
                        textColor: JPAppTheme.themeColors.text,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const JPIcon(
                      Icons.keyboard_arrow_down,
                      size: 24,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 3,
                ),
                JPText(
                  text: DateTimeHelper.format(selectedDate, DateFormatConstants.year),
                  textColor: JPAppTheme.themeColors.secondaryText,
                  textSize: JPTextSize.heading5,
                  fontWeight: JPFontWeight.medium,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

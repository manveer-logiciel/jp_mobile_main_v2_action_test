
import 'package:flutter/material.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class CalendarsTimeLineHourTile extends StatelessWidget {
  const CalendarsTimeLineHourTile({
    super.key,
    required this.date,
    required this.isSelected,
    this.onSelectDate
  });

  /// used to display current date
  final DateTime date;

  /// helps in identifying selected date
  final bool isSelected;

  /// onSelectDate handles click on date
  final VoidCallback? onSelectDate;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(
        top: 2
      ),
      child: Material(
        color: isSelected
            ? JPAppTheme.themeColors.primary
            : JPAppTheme.themeColors.base,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onSelectDate,
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                JPText(
                  text: DateTimeHelper.format(date.toString(), DateFormatConstants.hour).toString(),
                  textColor: isSelected
                      ? JPAppTheme.themeColors.base
                      : JPAppTheme.themeColors.tertiary,
                  textSize: JPTextSize.heading5,
                ),
                const SizedBox(
                  width: 2,
                ),
                JPText(
                  text: DateTimeHelper.format(date.toString(), DateFormatConstants.period),
                  textColor: isSelected
                      ? JPAppTheme.themeColors.base
                      : JPAppTheme.themeColors.tertiary,
                  textSize: JPTextSize.heading5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

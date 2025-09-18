
import 'package:flutter/material.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class CalendarsTimeLineDateTile extends StatelessWidget {
  const CalendarsTimeLineDateTile({
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
    return Material(
      color: isSelected
          ? JPAppTheme.themeColors.primary
          : JPAppTheme.themeColors.base,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onSelectDate,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: 40,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              JPText(
                text: date.day.toString(),
                textColor: isSelected
                    ? JPAppTheme.themeColors.base
                    : JPAppTheme.themeColors.tertiary,
                textSize: JPTextSize.heading5,
              ),
              const SizedBox(
                height: 2,
              ),
              JPText(
                text: DateTimeHelper.format(date.toString(), DateFormatConstants.day),
                textColor: isSelected
                    ? JPAppTheme.themeColors.base
                    : JPAppTheme.themeColors.tertiary,
                textSize: JPTextSize.heading5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

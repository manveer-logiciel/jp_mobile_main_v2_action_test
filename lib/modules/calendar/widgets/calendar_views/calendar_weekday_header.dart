import 'package:flutter/material.dart';
import 'package:jobprogress/core/constants/calendars.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class CalenderWeekDayHeaderTile extends StatelessWidget {
  const CalenderWeekDayHeaderTile({
    super.key,
    this.dayIndex,
    this.dateTime,
    required this.viewType,
    this.isToday = false
  });

  /// Index of week day.
  final int? dayIndex;

  /// used to get date of week
  final DateTime? dateTime;

  /// viewType helps in differentiating day display logic
  final CalendarsViewType viewType;

  /// isToday check if date is current date, default value is [false]
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8
        ),
        child: getHeaderCell(),
      ),
    );
  }

  Widget getHeaderCell() {

    switch (viewType) {
      case CalendarsViewType.month:
        return JPText(
          text: CalendarsConstants.weekTitles[dayIndex!].substring(0, 3),
          maxLine: 1,
          overflow: TextOverflow.clip,
          fontWeight: JPFontWeight.medium,
          textSize: JPTextSize.heading5,
        );

      case CalendarsViewType.monthWeek:
      case CalendarsViewType.week:
        return JPText(
          text: CalendarsConstants.weekTitles[(dateTime!.weekday - 1) % 7].substring(0, 3),
          maxLine: 1,
          overflow: TextOverflow.clip,
          fontWeight: JPFontWeight.medium,
          textSize: JPTextSize.heading5,
        );

      case CalendarsViewType.day:
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: isToday ? JPAppTheme.themeColors.primary : JPAppTheme.themeColors.inverse,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: JPText(
                    text: dateTime!.day.toString(),
                    maxLine: 1,
                    overflow: TextOverflow.clip,
                    textSize: JPTextSize.heading4,
                    fontWeight: JPFontWeight.medium,
                    textColor: isToday ? JPAppTheme.themeColors.base : JPAppTheme.themeColors.text,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              JPText(
                text: CalendarsConstants.weekTitles[(dateTime!.weekday - 1) % 7],
                maxLine: 1,
                overflow: TextOverflow.clip,
                textSize: JPTextSize.heading3,
                fontWeight: JPFontWeight.medium,
              ),
            ],
          ),
        );

      default:
        return const SizedBox();
    }
  }

}


import 'package:flutter/material.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/modules/calendar/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class CalendarWeekView extends StatelessWidget {
  const CalendarWeekView({
    super.key,
    required this.controller,
    required this.scrollController,
  });

  final CalendarPageController controller;

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          controller: scrollController,
          child: const SizedBox(),
        ),
        Expanded(
          child: WeekView<dynamic>(
            key: controller.weekViewKey,
            isLoading: controller.isLoading,
            controller: controller.eventController,
            backgroundColor: JPColor.transparent,
            timeLineWidth: 70,
            timeLineBuilder: (DateTime date) {
              return JPText(
                text: DateTimeHelper.format(date, DateFormatConstants.hourAndPeriod),
                textSize: JPTextSize.heading5,
                textColor: JPAppTheme.themeColors.tertiary,
              );
            },
            initialDay: controller.selectedDate,
            onPageChange: controller.onPageChanged,
            startDay: controller.weekStartFrom,
            onEventTap: (List<CalendarEventData<dynamic>> events, DateTime date) {
              controller.onTapEvent(events);
            },
          ),
        ),
      ],
    );
  }
}

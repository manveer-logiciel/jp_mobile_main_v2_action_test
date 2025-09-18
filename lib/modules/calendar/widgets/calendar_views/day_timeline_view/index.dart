import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/modules/calendar/controller.dart';
import 'package:jobprogress/modules/calendar/widgets/calendar_views/timeline_view/event_tile.dart';
import 'package:jobprogress/modules/calendar/widgets/calendar_views/timeline_view/event_tile_shimmer.dart';
import 'package:jp_mobile_flutter_ui/CalendarView/src/day_timeline_view/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import 'event_shimmer.dart';
import 'event_tile.dart';
import 'hour_tile.dart';

class CalendarDayTimeLineView extends StatelessWidget {
  const CalendarDayTimeLineView({
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
          child: DayTimeLineView<dynamic>(
            isLoading: controller.isLoading,
            key: controller.dayTimeLineViewKey,
            controller: controller.eventController,
            onPageChange: controller.onPageChanged,
            heightPerMinute: 0.9,
            initialDay: controller.selectedDateUTC,
            timeLineWidth: 60,
            allDayShimmer: const TimeLineTileEventShimmer(),
            eventShimmer: const CalendarDayTimelineEventShimmer(),
            allDayBuilder: (DateTime date, CalendarEventData<dynamic> event) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 2
                ),
                child: TimeLineEventTile(
                    event: event,
                    controller: controller,
                ),
              );
            },
            moreBuilder: (events) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 16
                ),
                child: JPButton(
                  size: JPButtonSize.extraSmall,
                  text: '+${events.length - 3} ${'more'.tr.capitalizeFirst!}',
                  fontWeight: JPFontWeight.medium,
                  colorType: JPButtonColorType.lightGray,
                  onPressed: () {
                    controller.onTapEvent(events);
                  },
                  textSize: JPTextSize.heading5,
                ),
              );
            },
            eventTileBuilder: (DateTime date, List<CalendarEventData<dynamic>> events, Rect boundary, DateTime startDuration, DateTime endDuration) {
              return CalendarDayViewEventTile(
                event: events[0],
                onTap: () {
                  controller.onTapEvent(events);
                },
              );
            },
            timeLineBuilder: (DateTime date) {

              final now = DateTime.now();
              final isSelected = now.compareWithoutTime(controller.selectedDate) && date.hour == now.hour;

              return CalendarsTimeLineHourTile(
                date: date,
                isSelected: isSelected,
              );
            },
          ),
        ),
      ],
    );
  }

}

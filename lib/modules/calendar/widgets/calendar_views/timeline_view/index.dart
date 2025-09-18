
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/modules/calendar/controller.dart';
import 'package:jobprogress/modules/calendar/widgets/calendar_views/timeline_view/event_tile.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import 'date_tile.dart';
import 'event_tile_shimmer.dart';

class CalendarTimeLineView extends StatelessWidget {
  const CalendarTimeLineView({
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
          child: TimeLineView(
            key: controller.timeLineViewKey,
            isLoading: controller.isLoading,
            eventController: controller.eventController,
            selectedDate: controller.selectedDate,
            dateBuilder: (DateTime date, bool isSelected) {
              return CalendarsTimeLineDateTile(
                date: date,
                isSelected: isSelected,
                onSelectDate: () {
                  controller.onTapMonthCell(null, date);
                },
              );
            },
            eventTileBuilder: (CalendarEventData<dynamic> data) {
              return TimeLineEventTile(
                event: data,
                controller: controller,
              );
            },
            eventTileShimmer: const TimeLineTileEventShimmer(),
            onPageChange: controller.onPageChanged,
            moreBuilder: (events) {
              return Material(
                color: JPColor.transparent,
                child: JPTextButton(
                  text: '+${events.length - 3} ${'more'.tr.capitalizeFirst!}',
                  fontWeight: JPFontWeight.medium,
                  isExpanded: false,
                  color: JPAppTheme.themeColors.primary,
                  onPressed: () {
                    controller.onTapEvent(events);
                  },
                  padding: 6,
                  textSize: JPTextSize.heading5,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

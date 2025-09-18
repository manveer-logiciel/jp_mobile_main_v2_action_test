import 'package:flutter/material.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/modules/calendar/controller.dart';
import 'package:jobprogress/modules/calendar/widgets/calendar_header/index.dart';
import 'package:jobprogress/modules/calendar/widgets/calendar_views/day_timeline_view/index.dart';
import 'package:jobprogress/modules/calendar/widgets/calendar_views/day_view/index.dart';
import 'package:jobprogress/modules/calendar/widgets/calendar_views/month_view/index.dart';
import 'package:jobprogress/modules/calendar/widgets/calendar_views/month_week_view/index.dart';
import 'package:jobprogress/modules/calendar/widgets/calendar_views/timeline_view/index.dart';
import 'package:jobprogress/modules/calendar/widgets/calendar_views/week_view/index.dart';
import 'package:jobprogress/modules/calendar/widgets/events/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class CalendarView extends StatelessWidget {
  const CalendarView({
    super.key,
    required this.controller,
  });

  final CalendarPageController controller;

  @override
  Widget build(BuildContext context) {

    return JPSafeArea(
      bottom: false,
      child: JPCalendar<dynamic>(
          switcherKey: controller.switcherKey,
          selectedDate: controller.selectedDate,
          width: JPScreen.orientation == Orientation.portrait ? JPScreen.width : JPScreen.height,
          monthView: CalendarMonthView(
            controller: controller,
          ),
          weekMonthView: CalendarMonthWeekView(
            controller: controller,
          ),
          dayView: CalendarDayView(
            controller: controller,
          ),
          timeLineView: CalendarHeader(
              startDate: controller.selectedDate,
              controller: controller,
          ),
          monthViewSideList: CalendarEvents(
            controller: controller,
            hideLiftUp: true,
            scrollController: ScrollController(),
          ),
          monthViewKey: controller.monthViewKey,
          onViewChanged: controller.updateView,
          activeView: controller.viewType,
          bottomWidget: (_, scrollController) {
            return Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: JPAppTheme.themeColors.dimGray,
                    offset: const Offset(0, -2),
                    blurRadius: 10),
                  BoxShadow(
                    color: JPAppTheme.themeColors.base,
                    offset: const Offset(0, 100),
                    blurRadius: 0),
                ],
                color: JPAppTheme.themeColors.base,
              ),
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: controller.pageController,
                  children: [
                    CalendarWeekView(
                      controller: controller,
                      scrollController: scrollController,
                    ),
                    CalendarEvents(
                      controller: controller,
                      scrollController: scrollController,
                    ),
                    CalendarDayTimeLineView(
                        controller: controller,
                        scrollController: scrollController,
                    ),
                    CalendarTimeLineView(
                      controller: controller,
                      scrollController: scrollController,
                    )
                  ],
              )
            );
          },
      ),
    );
  }

}

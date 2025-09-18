import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/utils/calendar_helper/calendar_time_helper.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/global_widgets/no_data_found/index.dart';
import 'package:jobprogress/modules/calendar/controller.dart';
import 'package:jobprogress/modules/calendar/widgets/events/animated_events_list.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'shimmer.dart';

class CalendarEvents extends StatelessWidget {
  const CalendarEvents({
    super.key,
    required this.controller,
    required this.scrollController,
    this.doLimitHeight = false,
    this.hideLiftUp = false,
    this.bannerDate,
  });

  /// controller used to handle callbacks
  final CalendarPageController controller;

  /// scrollController helps in slide switch between views
  final ScrollController scrollController;

  /// doLimitHeight limits height of list in case of bottom sheet, default value is [false]
  final bool doLimitHeight;

  final bool hideLiftUp;

  /// [bannerDate] is used to display customized date on banner
  final DateTime? bannerDate;

  @override
  Widget build(BuildContext context) {

    return Container(
      constraints: BoxConstraints(
        maxHeight: doLimitHeight
        ? JPScreen.height * 0.75
        : double.maxFinite,
      ),
      child: Material(
        color: JPAppTheme.themeColors.base,
        borderRadius: hideLiftUp ? JPResponsiveDesign.bottomSheetRadius : BorderRadiusDirectional.zero,
        child: SafeArea(
          child: ClipRRect(
            borderRadius: hideLiftUp ? JPResponsiveDesign.bottomSheetRadius : BorderRadiusDirectional.zero,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// event lift up
                if(controller.viewType != CalendarsViewType.day )...{
                  SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    controller: scrollController,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.decelerate,
                      constraints: BoxConstraints(
                        maxHeight: controller.viewType != CalendarsViewType.day
                            ? 100
                            : 0,
                      ),
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            /// slide indicator
                            SizedBox(
                              height: hideLiftUp ? 16 : 10,
                            ),
                            if(!hideLiftUp)... {
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 28,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
                                      color: JPAppTheme.themeColors.dimGray,
                                    ),
                                  )
                                ],
                              ),
                            },
                            dateBanner(),
                          ],
                        ),
                      ),
                    ),
                  ),
                } else...{
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SingleChildScrollView(
                        controller: scrollController,
                        child: const SizedBox(),
                      ),
                      dateBanner(),
                    ],
                  )
                },
                if (controller.isLoading) ...{
                  const CalendarEventsShimmer()
                } else ...{
                  Flexible(
                    child: Stack(
                      children: [
                        CalendarEventsAnimatedList(
                          controller: controller,
                        ),
                        if(controller.selectedDateEvents.isEmpty)...{
                          if(JPScreen.isSmallHeightMobile)...{
                            Center(
                              child:SingleChildScrollView(
                                child: noDataFound(iconSize: 60),
                              )
                            )
                          } else...{
                            noDataFound()
                          }
                        }

                      ],
                    ),
                  ),
                }
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget dateBanner() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 12,
        ),
        /// date banner
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              JPText(
                text: "${DateTimeHelper.format(bannerDate ?? controller.selectedDate.toString(), DateFormatConstants.dayDateMonth)} (${controller.selectedDateEvents.length})",
                textColor: JPAppTheme.themeColors.secondaryText,
                textSize: JPTextSize.heading5,
                fontWeight: JPFontWeight.bold,
              ),
              const Spacer(),
              JPText(
                text: CalendarTimeHelper.dateToDayLabel(controller.selectedDate),
                textColor: JPAppTheme.themeColors.secondaryText,
                textSize: JPTextSize.heading5,
                fontWeight: JPFontWeight.bold,
              )
            ],
          ),
        ),
        SizedBox(
          height: hideLiftUp ? 22 : 12,
        ),
        Divider(
          height: 1.5,
          thickness: 1.5,
          color: JPAppTheme.themeColors.dimGray,
        ),
      ],
    );
  }

  Widget noDataFound({double? iconSize}) => Center(
    child: NoDataFound(
      title: 'no_event_found'.tr.capitalize,
      icon: Icons.event_note_outlined,
      iconSize: iconSize,
    ),
  );

}

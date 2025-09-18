import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/phases_visibility.dart';
import 'package:jobprogress/global_widgets/job_overview_placeholders/header_placeholder.dart';
import 'package:jobprogress/global_widgets/main_drawer/index.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/modules/calendar/controller.dart';
import 'package:jobprogress/modules/calendar/widgets/calender_header_tile.dart';
import 'package:jobprogress/modules/calendar/widgets/calender_sub_header/index.dart';
import 'package:jobprogress/modules/calendar/widgets/index.dart';
import 'package:jp_mobile_flutter_ui/PopUpMenu/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
class CalendarPageView extends StatelessWidget {
  const CalendarPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CalendarPageController>(
      init: CalendarPageController(),
      global: false,
      builder: (controller) {
        return JPScaffold(
          resizeToAvoidBottomInset: false,
          scaffoldKey: controller.scaffoldKey,
          appBar: JPHeader(
            titleWidget:controller.isLoading ?
            const JobOverViewHeaderPlaceHolder() :
            CalenderHeaderTile(
              isProductionCalendar: controller.isProductionCalendar,
              job: controller.job,
            ),
            onBackPressed: Get.back<void>,
            actions: [
              Center(
                child: JPTextButton(
                  icon: Icons.menu,
                  onPressed: () {
                    controller.scaffoldKey.currentState!.openEndDrawer();
                  },
                  color: JPAppTheme.themeColors.base,
                  iconSize: 25,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
            ],
          ),
          endDrawer: JPMainDrawer(
            selectedRoute: controller.isProductionCalendar
              ? 'production_calender'
              : 'staff_calender',
            onRefreshTap: controller.fetchEvents,
          ),
          floatingActionButton: Visibility(
            visible: PhasesVisibility.canShowSecondPhase,
            child: JPButton(
              size: JPButtonSize.floatingButton,
              iconWidget: JPIcon(
                Icons.add,
                color: JPAppTheme.themeColors.base,
              ),
              onPressed: controller.onTapAdd,
            ),
          ),
          body: Column(
            children: [
              CalendarSubHeader(controller: controller),
              Expanded(
                child: AbsorbPointer(
                  absorbing: controller.isLoading,
                  child: CalendarView(
                      controller: controller,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  Widget actions({Function(String val)? onTap}) {
    return Center(
      child: JPPopUpMenuButton<String>(
        itemList: const [
          'create'
        ],
        popUpMenuChild: (val) {
          return Padding(
            padding: const EdgeInsets.all(2),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10
              ),
              child: Row(
                children: [
                  JPText(text: val.tr.capitalize!),
                  const SizedBox(
                    width: 40,
                  ),
                ],
              ),
            ),
          );
        },
        onTap: onTap,
        offset: const Offset(0, 35),
        popUpMenuButtonChild: Padding(
          padding: const EdgeInsets.all(6.0),
          child: JPIcon(
            Icons.more_vert,
            color: JPAppTheme.themeColors.base,
          ),
        ),
      ),
    );
  }

}


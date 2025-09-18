import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/feature_flag.dart';
import 'package:jobprogress/core/constants/assets_files.dart';
import 'package:jobprogress/core/constants/feature_flag_constant.dart';
import 'package:jobprogress/global_widgets/feature_flag/index.dart';
import 'package:jobprogress/modules/calendar/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class CalendarSubHeader extends StatelessWidget {
  const CalendarSubHeader({
    super.key,
    required this.controller,
  });

  /// controller helps in handling callbacks
  final CalendarPageController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: JPColor.transparent,
      padding: const EdgeInsets.only(left: 15, right: 15, top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if(controller.doShowFilterIcon) ...{
            Center(
              child: JPFilterIcon(
                type: JPFilterIconType.button,
                isFilterActive: controller.isFilterApplied(),
                onTap: controller.isLoading ? null : controller.showFilterDialog,
              ),
            ),
          },
          const Spacer(),
          Row(
            children: [
              if(controller.isProductionCalendar && controller.jobId == null && !AuthService.isPrimeSubUser())
                Center(
                  child: JPTextButton(
                    isDisabled: controller.isLoading,
                    icon: Icons.format_color_fill_outlined,
                    onPressed: controller.showColorSelector,
                    color: JPAppTheme.themeColors.dimBlack,
                    iconSize: 22,
                  ),
                ),
                const SizedBox(width: 10,),

              //Schedule toggle
              if(!controller.isProductionCalendar && FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.production]))
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    JPText(
                      text: 'schedules'.tr.capitalizeFirst!,
                      textSize: JPTextSize.heading4,
                      textColor: JPAppTheme.themeColors.text,
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      child: JPToggle(
                        value: controller.requestParams.filter?.isScheduleHidden ?? false,
                        onToggle: controller.toggleSchedule,
                        toggleHeight: 20,
                        innerToggleHeight: 16,
                        innerToggleWidth: 16,
                        disabled: controller.isLoading,
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              HasFeatureAllowed(
                feature: const [FeatureFlagConstant.production],
                child: InkWell(
                  onTap: controller.isLoading ? null : controller.switchCalendar,
                  child: SizedBox(
                    height: 22,
                    width: 22,
                    child: Image.asset(AssetsFiles.calenderSwitch),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
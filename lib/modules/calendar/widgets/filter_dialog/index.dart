
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/calendars.dart';
import 'package:jobprogress/common/models/calendars/calendars_request_params.dart';
import 'package:jobprogress/core/constants/feature_flag_constant.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/feature_flag/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import 'controller.dart';

class StaffCalendarFilterDialog extends StatelessWidget {
  const StaffCalendarFilterDialog({
    super.key,
    required this.params,
    required this.defaultParams,
    required this.onApplyFilter,
    this.isForProductionCalendar = false
  });

  /// params contain selected filters
  final CalendarsRequestParams params;

  /// defaultParams contain default params to apply on reset
  final CalendarsRequestParams defaultParams;

  /// onApplyFilter used to indicate filters are applied
  final Function(CalendarsRequestParams params) onApplyFilter;

  /// isForProductionCalendar is used to differentiate between staff and production calendar
  final bool isForProductionCalendar;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Helper.hideKeyboard(),
      child: JPSafeArea(
        child: GetBuilder<StaffCalendarFilterDialogController>(
          init: StaffCalendarFilterDialogController(params, isForProductionCalendar),
          builder: (controller) => AlertDialog(
            insetPadding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            contentPadding: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: Builder(
              builder: (context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            JPText(
                              text: "filters".tr,
                              textSize: JPTextSize.heading3,
                              fontWeight: JPFontWeight.medium,
                            ),

                            JPTextButton(
                              onPressed: () {
                                Get.back();
                              },
                              color: JPAppTheme.themeColors.text,
                              icon: Icons.clear,
                              iconSize: 24,
                            ),

                          ],
                        ),
                      ),

                      Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),

                              if(isForProductionCalendar)...{
                                /// customer name filter
                                JPInputBox(
                                  label: 'customer_name'.tr.capitalize,
                                  type: JPInputBoxType.withLabel,
                                  hintText: 'name'.tr,
                                  fillColor: JPAppTheme.themeColors.base,
                                  controller: controller.customerNameToController,
                                  onChanged: (val) {
                                    controller.tempFilterKeys.filter?.customerName = val;
                                    controller.tempFilterKeys.customerName = val;
                                    controller.update();
                                  },
                                ),

                              } else...{
                                /// users filter
                                JPInputBox(
                                    label: 'assigned_to'.tr,
                                    type: JPInputBoxType.withLabel,
                                    readOnly: true,
                                    hintText: 'select'.tr,
                                    fillColor: JPAppTheme.themeColors.base,
                                    controller: controller.assignedToController,
                                    onPressed: () {
                                      controller.showSelectionSheet(CalendarFilterType.assignedTo);
                                    },
                                    suffixChild: defaultParams.canSelectOtherUsers! ? const Padding(
                                      padding: EdgeInsets.only(right: 9),
                                      child: JPIcon(Icons.keyboard_arrow_down),
                                    ) : null,
                                  disabled: !defaultParams.canSelectOtherUsers!,
                                  ),
                              },
                              const SizedBox(
                                height: 15,
                              ),

                              /// divisions filter
                              JPInputBox(
                                label: "division".tr.capitalize,
                                type: JPInputBoxType.withLabel,
                                readOnly: true,
                                hintText: 'select'.tr,
                                fillColor: JPAppTheme.themeColors.base,
                                controller: controller.divisionsController,
                                onPressed: () {
                                  controller.showSelectionSheet(CalendarFilterType.divisions);
                                },
                                suffixChild: const Padding(
                                  padding: EdgeInsets.only(right: 9),
                                  child: JPIcon(Icons.keyboard_arrow_down),
                                ),
                              ),

                              const SizedBox(
                                height: 15,
                              ),
                              /// category filter
                              JPInputBox(
                                label: "category".tr,
                                type: JPInputBoxType.withLabel,
                                readOnly: true,
                                hintText: 'select'.tr,
                                fillColor: JPAppTheme.themeColors.base,
                                controller: controller.categoryController,
                                onPressed: () {
                                  controller.showSelectionSheet(CalendarFilterType.category);
                                },
                                suffixChild: const Padding(
                                  padding: EdgeInsets.only(right: 9),
                                  child: JPIcon(Icons.keyboard_arrow_down),
                                ),
                              ),

                              if(params.canSelectOtherUsers ?? false) ...{
                                Column(
                                  children: [
                                    const SizedBox(
                                      height: 15,
                                    ),

                                    /// Company Crew filter
                                    HasFeatureAllowed(
                                      feature: const [FeatureFlagConstant.userManagement],
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom:15),
                                        child: JPInputBox(
                                          label: "company_crew".tr,
                                          type: JPInputBoxType.withLabel,
                                          readOnly: true,
                                          hintText: 'select'.tr,
                                          fillColor: JPAppTheme.themeColors.base,
                                          controller: controller.companyCrewController,
                                          onPressed: () {
                                            controller.showSelectionSheet(
                                                CalendarFilterType.companyCrew);
                                          },
                                          suffixChild: const Padding(
                                            padding: EdgeInsets.only(right: 9),
                                            child: JPIcon(Icons.keyboard_arrow_down),
                                          ),
                                        ),
                                      ),
                                    ),
                                    /// Labour/Sub filter
                                    HasFeatureAllowed(
                                      feature: const [FeatureFlagConstant.production],
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 15),
                                        child: JPInputBox(
                                          label: "labor_sub".tr,
                                          type: JPInputBoxType.withLabel,
                                          readOnly: true,
                                          hintText: 'select'.tr,
                                          fillColor: JPAppTheme.themeColors.base,
                                          controller: controller.labourSubController,
                                          onPressed: () {
                                            controller.showSelectionSheet(
                                                CalendarFilterType.subContractor);
                                          },
                                          suffixChild: const Padding(
                                            padding: EdgeInsets.only(right: 9),
                                            child: JPIcon(Icons.keyboard_arrow_down),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              },
                              /// trade type filter
                              JPInputBox(
                                  label: "trade_type".tr,
                                  type: JPInputBoxType.withLabel,
                                  fillColor: JPAppTheme.themeColors.base,
                                  readOnly: true,
                                  hintText: 'select'.tr,
                                  controller: controller.tradeTypeController,
                                  onPressed: () {
                                    controller.showSelectionSheet(CalendarFilterType.tradeType);
                                  },
                                  suffixChild: const Padding(
                                      padding: EdgeInsets.only(right: 9),
                                      child: JPIcon(Icons.keyboard_arrow_down))),

                              const SizedBox(
                                height: 15,
                              ),

                              if(isForProductionCalendar)...{
                                /// workTypes
                                JPInputBox(
                                    label: "work_type".tr,
                                    type: JPInputBoxType.withLabel,
                                    fillColor: JPAppTheme.themeColors.base,
                                    readOnly: true,
                                    hintText: 'select'.tr,
                                    controller: controller.workTypesController,
                                    onPressed: () {
                                      controller.showSelectionSheet(CalendarFilterType.workType);
                                    },
                                    suffixChild: const Padding(
                                        padding: EdgeInsets.only(right: 9),
                                        child: JPIcon(Icons.keyboard_arrow_down))),

                                const SizedBox(
                                  height: 15,
                                ),
                              },

                              JPInputBox(
                                  label: "job_flag".tr,
                                  type: JPInputBoxType.withLabel,
                                  fillColor: JPAppTheme.themeColors.base,
                                  readOnly: true,
                                  hintText: 'select'.tr,
                                  controller: controller.jobFlagController,
                                  onPressed: () {
                                    controller.showSelectionSheet(CalendarFilterType.jobFlag);
                                  },
                                  suffixChild: const Padding(
                                      padding: EdgeInsets.only(right: 9),
                                      child: JPIcon(Icons.keyboard_arrow_down))),

                              const SizedBox(
                                height: 15,
                              ),
                              JPInputBox(
                                  label: "city".tr.capitalize!,
                                  controller: controller.cityController,
                                  hintText: 'select'.tr,
                                  type: JPInputBoxType.withLabel,
                                  readOnly: true,
                                  fillColor: JPAppTheme.themeColors.base,
                                  onPressed: () {
                                    controller.showNetworkMultiSelect();
                                  },
                                  suffixChild: const Padding(
                                      padding: EdgeInsets.only(right: 9),
                                      child: JPIcon(Icons.keyboard_arrow_down))),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: JPResponsiveDesign.popOverButtonFlex,
                                child: JPButton(
                                  text: 'reset'.tr,
                                  onPressed: () {
                                    Helper.hideKeyboard();
                                    controller.setDefaultKeys(defaultParams);
                                  },
                                  disabled: controller.isResetButtonDisabled(defaultParams),
                                  fontWeight: JPFontWeight.medium,
                                  size: JPButtonSize.small,
                                  colorType: JPButtonColorType.lightGray,
                                  textColor:
                                  JPAppTheme.themeColors.tertiary,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                flex: JPResponsiveDesign.popOverButtonFlex,
                                child: JPButton(
                                  onPressed: () {
                                    Helper.hideKeyboard();
                                    Get.back();
                                    onApplyFilter(controller.tempFilterKeys);
                                  },
                                  text: 'apply'.tr,
                                  fontWeight: JPFontWeight.medium,
                                  size: JPButtonSize.small,
                                  colorType: JPButtonColorType.tertiary,
                                  textColor: JPAppTheme.themeColors.base,
                                ),
                              )
                            ]),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}


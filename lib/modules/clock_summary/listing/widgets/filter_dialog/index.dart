import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/clock_summary.dart';
import 'package:jobprogress/common/models/clock_summary/clock_summary_request_params.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/single_select_helper.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'controller.dart';

class ClockSummaryFilterDialog extends StatelessWidget {
  const ClockSummaryFilterDialog({
    super.key,
    required this.filterKeys,
    required this.defaultKeys,
    required this.onApply,
  });

  final ClockSummaryRequestParams filterKeys; // contain applied filter data

  final ClockSummaryRequestParams defaultKeys; // used to reset filters

  final void Function(ClockSummaryRequestParams params) onApply;

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(ClockSummaryFilterController(filterKeys));

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: JPSafeArea(
        child: GetBuilder<ClockSummaryFilterController>(
            builder: (_) => AlertDialog(
                  insetPadding: const EdgeInsets.only(left: 10, right: 10),
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
                                      text: "custom_filters".tr,
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
                                      height: 5,
                                    ),
                                    /// users filter
                                    JPInputBox(
                                      label: "users".tr,
                                      type: JPInputBoxType.withLabel,
                                      fillColor: controller.isUsersDisabled() ? null : JPAppTheme.themeColors.base,
                                      readOnly: true,
                                      hintText: 'select'.tr,
                                      controller: controller.usersController,
                                      onPressed: controller.isUsersDisabled() ? null : () {
                                        controller.showSelectionSheet(ClockSummaryFilterType.user);
                                      },
                                      disabled: controller.isUsersDisabled(),
                                      suffixChild: const Padding(
                                        padding: EdgeInsets.only(right: 9),
                                        child: JPIcon(Icons.keyboard_arrow_down),
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 15,
                                    ),
                                    /// divisions filter
                                    JPInputBox(
                                      label: "divisions".tr,
                                      type: JPInputBoxType.withLabel,
                                      fillColor: controller.isDivisionDisabled() ? null : JPAppTheme.themeColors.base ,
                                      readOnly: true,
                                      hintText: 'select'.tr,
                                      controller: controller.divisionsController,
                                      onPressed: controller.isDivisionDisabled() ? null : () {
                                        controller.showSelectionSheet(ClockSummaryFilterType.division);
                                      },
                                      disabled: controller.isDivisionDisabled(),
                                      suffixChild: const Padding(
                                        padding: EdgeInsets.only(right: 9),
                                        child: JPIcon(Icons.keyboard_arrow_down),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    /// duration filter
                                    if(!controller.isDateFieldVisible())
                                      JPInputBox(
                                        label: "duration".tr,
                                        hintText: 'select'.tr,
                                        type: JPInputBoxType.withLabel,
                                        fillColor: JPAppTheme.themeColors.base,
                                        readOnly: true,
                                        onPressed: () {
                                          controller.showDurationSelector();
                                        },
                                        controller: TextEditingController(text: SingleSelectHelper.getSelectedSingleSelectValue(controller.durationsList, controller.selectedDuration)),
                                        suffixChild: controller.selectedDuration == "DurationType.custom" ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            JPButton(
                                              text: DateTimeHelper.convertHyphenIntoSlash(controller.tempFilterKeys.startDate!),
                                              size: JPButtonSize.extraSmall,
                                              colorType: JPButtonColorType.lightGray,
                                              onPressed: () => controller.pickStartDate(),
                                            ),
                                            const JPText(text: ' - '),
                                            JPButton(
                                              text: DateTimeHelper.convertHyphenIntoSlash(controller.tempFilterKeys.endDate!),
                                              size: JPButtonSize.extraSmall,
                                              colorType: JPButtonColorType.lightGray,
                                              onPressed: () => controller.pickEndDate(),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        ) : const Padding(
                                          padding: EdgeInsets.only(right: 9),
                                          child: JPIcon(Icons.keyboard_arrow_down),
                                        ),
                                      ),
                                    /// date filter
                                    if(controller.isDateFieldVisible())
                                      JPInputBox(
                                        label: "date".tr,
                                        hintText: 'select'.tr,
                                        type: JPInputBoxType.withLabel,
                                        fillColor: JPAppTheme.themeColors.base,
                                        readOnly: true,
                                        onPressed: () {
                                          controller.pickDate();
                                        },
                                        controller: controller.dateController,
                                        suffixChild: const Padding(
                                          padding: EdgeInsets.only(right: 9),
                                          child: JPIcon(Icons.keyboard_arrow_down),
                                        ),
                                      ),

                                    const SizedBox(
                                      height: 15,
                                    ),
                                    /// trade type filter
                                    JPInputBox(
                                        label: "trade_type".tr,
                                        type: JPInputBoxType.withLabel,
                                        fillColor: JPAppTheme.themeColors.base,
                                        readOnly: true,
                                        hintText: 'select'.tr,
                                        controller: controller.tradeTypesController,
                                        onPressed: () {
                                          controller.showSelectionSheet(ClockSummaryFilterType.tradeType);
                                        },
                                        suffixChild: const Padding(
                                            padding: EdgeInsets.only(right: 9),
                                            child: JPIcon(Icons.keyboard_arrow_down))),

                                    const SizedBox(
                                      height: 15,
                                    ),
                                    JPInputBox(
                                        label: "customer_type".tr,
                                        type: JPInputBoxType.withLabel,
                                        fillColor: JPAppTheme.themeColors.base,
                                        readOnly: true,
                                        hintText: 'select'.tr,
                                        controller: controller.customerTypeController,
                                        onPressed: () {
                                          controller.showSelectionSheet(ClockSummaryFilterType.customerType);
                                        },
                                        suffixChild: const Padding(
                                            padding: EdgeInsets.only(right: 9),
                                            child: JPIcon(Icons.keyboard_arrow_down))),

                                    const SizedBox(
                                      height: 15,
                                    ),
                                    JPInputBox(
                                        label: "job".tr,
                                        hintText: 'select'.tr,
                                        onChanged: controller.updateJobName,
                                        type: controller.isJobDisabled() ? JPInputBoxType.withLabel : JPInputBoxType.withLabelAndClearIcon,
                                        onTapSuffix:controller.jobController.clear ,
                                        fillColor: controller.isJobDisabled() ? null : JPAppTheme.themeColors.base,
                                        readOnly: true,
                                        controller: controller.jobController,
                                        onPressed: controller.isJobDisabled() ? null : controller.selectJob,
                                        disabled: controller.isJobDisabled(),
                                    ),

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
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          controller.setDefaultKeys(defaultKeys);
                                        },
                                        disabled: controller.isResetButtonDisabled(defaultKeys),
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
                                          FocusManager.instance.primaryFocus?.unfocus();
                                          if(controller.validateAndApply()) {
                                            onApply(controller.tempFilterKeys);
                                            Get.back();
                                          }
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

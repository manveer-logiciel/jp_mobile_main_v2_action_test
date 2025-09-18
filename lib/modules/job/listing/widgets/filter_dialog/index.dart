import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/date_picker_type.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jp_mobile_flutter_ui/HierarchicalMultiSelect/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../../../common/enums/filter_dialog_text_type.dart';
import '../../../../../common/models/job/job_listing_filter.dart';
import '../../../../../common/services/auth.dart';
import '../../../../../core/utils/date_time_helpers.dart';
import 'controller.dart';

class JobListingFilterDialog extends StatelessWidget {
  const JobListingFilterDialog({
    super.key,
    required this.selectedFilters,
    required this.defaultFilters,
    required this.onApply,
    required this.stages,
    required this.groupedStages,
  });

  final JobListingFilterModel selectedFilters;
  final JobListingFilterModel defaultFilters;
  final List<JPMultiSelectModel> stages;
  final List<JPHierarchicalSelectorGroupModel> groupedStages;
  final void Function(JobListingFilterModel params) onApply;

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(JobListingFilterDialogController(selectedFilters, defaultFilters, stages, groupedStages));

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: JPSafeArea(
        child: GetBuilder<JobListingFilterDialogController>(
            builder: (_) => AlertDialog(
              insetPadding: const EdgeInsets.all(10),
              contentPadding: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
              content: Builder(
                builder: (context) {
                  return Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.zero,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ///   header
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                JPText(
                                  text: "filters".tr.toUpperCase(),
                                  textSize: JPTextSize.heading3,
                                  fontWeight: JPFontWeight.medium,
                                ),
                                JPTextButton(
                                  onPressed: () => Get.back(),
                                  color: JPAppTheme.themeColors.text,
                                  icon: Icons.clear,
                                  iconSize: 24,
                                )
                              ]
                          ),
                        ),
                        ///   body
                        Flexible(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ///   stages
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                                  child: JPInputBox(
                                      controller: controller.stagesTextController,
                                      onPressed: () => controller.openMultiSelect(FilterDialogTextType.stages),
                                      type: JPInputBoxType.withLabel,
                                      label: "stages".tr.capitalize,
                                      hintText: "select".tr,
                                      readOnly: true,
                                      fillColor: JPAppTheme.themeColors.base,
                                      suffixChild: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(Icons.keyboard_arrow_down, size: 18),
                                      )
                                  ),
                                ),
                                ///   divisions
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                                  child: JPInputBox(
                                      controller: controller.divisionsTextController,
                                      onPressed: () => controller.openMultiSelect(FilterDialogTextType.divisions),
                                      type: JPInputBoxType.withLabel,
                                      label: "divisions".tr.capitalize,
                                      hintText: "select".tr,
                                      readOnly: true,
                                      fillColor: JPAppTheme.themeColors.base,
                                      suffixChild: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(Icons.keyboard_arrow_down, size: 18),
                                      )
                                  ),
                                ),
                                ///   users
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                                  child: JPInputBox(
                                      controller: controller.usersTextController,
                                      onPressed: () => controller.openMultiSelect(FilterDialogTextType.users),
                                      type: JPInputBoxType.withLabel,
                                      label: "users".tr.capitalize,
                                      hintText: "select".tr,
                                      readOnly: true,
                                      disabled: AuthService.isStandardUser() ? AuthService.isRestricted : AuthService.isPrimeSubUser() ? true : false,
                                      fillColor: JPAppTheme.themeColors.base,
                                      suffixChild: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(Icons.keyboard_arrow_down, size: 18),
                                      )
                                  ),
                                ),
                                ///   trades
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                                  child: JPInputBox(
                                      controller: controller.tradeTextController,
                                      onPressed: () => controller.openMultiSelect(FilterDialogTextType.trades),
                                      type: JPInputBoxType.withLabel,
                                      label: "trades".tr.capitalize,
                                      hintText: "select".tr,
                                      readOnly: true,
                                      fillColor: JPAppTheme.themeColors.base,
                                      suffixChild: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(Icons.keyboard_arrow_down, size: 18),
                                      )
                                  ),
                                ),
                                /// Flags
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                                  child: JPInputBox(
                                      controller: controller.flagsTextController,
                                      onPressed: () => controller.openMultiSelect(FilterDialogTextType.flags),
                                      type: JPInputBoxType.withLabel,
                                      label: "flags".tr.capitalize,
                                      hintText: "select".tr,
                                      readOnly: true,
                                      fillColor: JPAppTheme.themeColors.base,
                                      suffixChild: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(Icons.keyboard_arrow_down, size: 18),
                                      )
                                  ),
                                ),
                                ///   job / project
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                                  child: JPInputBox(
                                    controller: controller.jobTextController,
                                    fillColor: JPAppTheme.themeColors.base,
                                    type: JPInputBoxType.withLabel,
                                    label: "name".tr,
                                    readOnly: false,
                                    onChanged: (val) => controller.updateResetButtonDisable(),
                                    avoidPrefixConstraints: true,
                                    prefixChild: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children:  [
                                          Material(
                                            color: JPAppTheme.themeColors.base,
                                            borderRadius: BorderRadius.circular(8),
                                            child: InkWell(
                                              onTap: () => controller.selectJobProjectFilterType(),
                                              borderRadius: BorderRadius.circular(8),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 6, right: 14),
                                                    child: JPText(
                                                      text: controller.selectJobProject?.label ?? '${ 'job'.tr } #',
                                                      textSize: JPTextSize.heading4,
                                                    ),
                                                  ),
                                                  const JPIcon(Icons.keyboard_arrow_down, size: 18),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 5, right: 10),
                                            child: Container(
                                              width: 1,
                                              height: 18,
                                              color: JPAppTheme.themeColors.dimGray,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                  ),
                                ),
                                ///   job id / project id
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                                  child: JPInputBox(
                                    controller: controller.jobIdTextController,
                                    fillColor: JPAppTheme.themeColors.base,
                                    type: JPInputBoxType.withLabel,
                                    label: "name".tr,
                                    readOnly: false,
                                    onChanged: (val) => controller.updateResetButtonDisable(),
                                    avoidPrefixConstraints: true,
                                    prefixChild: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children:  [
                                          Material(
                                            color: JPAppTheme.themeColors.base,
                                            borderRadius: BorderRadius.circular(8),
                                            child: InkWell(
                                              onTap: () => controller.selectJobProjectIdFilterType(),
                                              borderRadius: BorderRadius.circular(8),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 6, right: 14),
                                                    child: JPText(
                                                      text: controller.selectJobProjectId?.label ?? "job_id".tr,
                                                      textSize: JPTextSize.heading4,
                                                    ),
                                                  ),
                                                  const JPIcon(Icons.keyboard_arrow_down, size: 18),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 5, right: 10),
                                            child: Container(
                                              width: 1,
                                              height: 18,
                                              color: JPAppTheme.themeColors.dimGray,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                  ),
                                ),
                                ///   address
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                                  child: JPInputBox(
                                    controller: controller.addressTextController,
                                    fillColor: JPAppTheme.themeColors.base,
                                    type: JPInputBoxType.withLabel,
                                    label: "address".tr.capitalize,
                                    readOnly: false,
                                    onChanged: (val) => controller.onTextChange(value: val.trim(), type: FilterDialogTextType.address),
                                  ),
                                ),
                                ///   state
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                                  child: JPInputBox(
                                      maxLength: 50,
                                      maxLines: 1,
                                      controller: controller.stateTextController,
                                      fillColor: JPAppTheme.themeColors.base,
                                      hintText: "select".tr,
                                      onPressed: () => controller.openMultiSelect(FilterDialogTextType.states),
                                      type: JPInputBoxType.withLabel,
                                      label: "states".tr.capitalize,
                                      readOnly: true,
                                      suffixChild: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(Icons.keyboard_arrow_down, size: 18),
                                      )
                                  ),
                                ),
                                ///   zip
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                                  child: JPInputBox(
                                    controller: controller.zipTextController,
                                    fillColor: JPAppTheme.themeColors.base,
                                    type: JPInputBoxType.withLabel,
                                    label: "zip".tr.capitalize,
                                    readOnly: false,
                                    onChanged: (val) => controller.onTextChange(value: val.trim(), type: FilterDialogTextType.zip),
                                  ),
                                ),
                                ///   customer_name
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                                  child: JPInputBox(
                                    controller: controller.customerNameTextController,
                                    fillColor: JPAppTheme.themeColors.base,
                                    type: JPInputBoxType.withLabel,
                                    label: "customer_name".tr.capitalize,
                                    readOnly: false,
                                    onChanged: (val) => controller.onTextChange(value: val.trim(), type: FilterDialogTextType.address),
                                  ),
                                ),
                                ///   date type
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                                  child: JPInputBox(
                                    controller: controller.dateTypeTextController,
                                    fillColor: JPAppTheme.themeColors.base,
                                    type: JPInputBoxType.withLabel,
                                    label: "date_type".tr.capitalize,
                                    hintText: "select".tr,
                                    readOnly: true,
                                    suffixChild: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(Icons.keyboard_arrow_down, size: 18),
                                    ),
                                    onPressed: () => controller.openSingleSelect(FilterDialogTextType.dateType),
                                  ),
                                ),
                                ///   duration
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                                  child: JPInputBox(
                                    controller: controller.durationTextController,
                                    onPressed: () => controller.openSingleSelect(FilterDialogTextType.duration),
                                    fillColor: JPAppTheme.themeColors.base,
                                    type: JPInputBoxType.withLabel,
                                    label: "duration".tr.capitalize,
                                    hintText: "select".tr,
                                    readOnly: true,
                                    suffixChild: controller.filterKeys.duration == "custom"
                                        ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Icon(Icons.keyboard_arrow_down, size: 18)),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 10),
                                          child: Container(
                                            width: 1,
                                            height: 18,
                                            color: JPAppTheme.themeColors.dimGray,
                                          ),
                                        ),
                                        JPButton(
                                          onPressed: () => controller.openDatePicker(initialDate: controller.filterKeys.startDate, datePickerType: DatePickerType.start),
                                          size: JPButtonSize.datePickerButton,
                                          colorType: JPButtonColorType.lightGray,
                                          text: controller.filterKeys.startDate == null ? "start_date".tr : DateTimeHelper.convertHyphenIntoSlash(controller.filterKeys.startDate!),
                                          textColor: JPAppTheme.themeColors.text,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 5),
                                          child: JPText(text: '- '),
                                        ),
                                        JPButton(
                                          onPressed: () => controller.openDatePicker(initialDate: controller.filterKeys.endDate, datePickerType: DatePickerType.end),
                                          size: JPButtonSize.datePickerButton,
                                          colorType: JPButtonColorType.lightGray,
                                          text: controller.filterKeys.endDate == null ? "end_date".tr : DateTimeHelper.convertHyphenIntoSlash(controller.filterKeys.endDate!),
                                          textColor: JPAppTheme.themeColors.text,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    )
                                        : const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(Icons.keyboard_arrow_down, size: 18),
                                    ),

                                  ),
                                ),
                                ///   Check Box
                                Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Wrap(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ///   include archived
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(14, 00, 15, 0),
                                            child: JPCheckbox(
                                              onTap: (value) => controller.selectCheckBox(1),
                                              padding: EdgeInsets.zero,
                                              text: "include_archived".tr.capitalize,
                                              borderColor: JPAppTheme.themeColors.themeGreen,
                                              selected: controller.selectedCheckBox == 1,
                                            ),
                                          ),
                                          ///   lost only
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(14, 0, 15, 0),
                                            child: JPCheckbox(
                                              onTap: (value) => controller.selectCheckBox(3),
                                              padding: EdgeInsets.zero,
                                              text: "lost_only".tr.capitalize,
                                              borderColor: JPAppTheme.themeColors.themeGreen,
                                              selected: controller.selectedCheckBox == 3,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ///   archived only
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(14, 0, 15, 0),
                                            child: JPCheckbox(
                                              onTap: (value) => controller.selectCheckBox(2),
                                              padding: EdgeInsets.zero,
                                              text: "archived_only".tr.capitalize,
                                              borderColor: JPAppTheme.themeColors.themeGreen,
                                              selected: controller.selectedCheckBox == 2,
                                            ),
                                          ),
                                          ///   insurance only
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(14, 0, 15, 0),
                                            child: JPCheckbox(
                                              onTap: (value) => controller.selectCheckBox(4),
                                              padding: EdgeInsets.zero,
                                              text: "insurance_only".tr.capitalize,
                                              borderColor: JPAppTheme.themeColors.themeGreen,
                                              selected: controller.selectedCheckBox == 4,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                        ///   bottom buttons
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: JPResponsiveDesign.popOverButtonFlex,
                                  child: JPButton(
                                    text: 'reset'.tr,
                                    onPressed: () {
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      controller.cleanFilterKeys(defaultFilters: defaultFilters);
                                    },
                                    disabled: controller.isResetButtonDisable,
                                    fontWeight: JPFontWeight.medium,
                                    size: JPButtonSize.small,
                                    colorType: JPButtonColorType.lightGray,
                                    textColor: JPAppTheme.themeColors.tertiary,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  flex: JPResponsiveDesign.popOverButtonFlex,
                                  child: JPButton(
                                    onPressed: () => controller.applyFilter(onApply),
                                    text: 'apply'.tr,
                                    fontWeight: JPFontWeight.medium,
                                    size: JPButtonSize.small,
                                    colorType: JPButtonColorType.tertiary,
                                    textColor: JPAppTheme.themeColors.base,
                                  ),
                                )
                              ]
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
        ),
      ),
    );
  }
}

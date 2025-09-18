import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/feature_flag_constant.dart';
import 'package:jobprogress/global_widgets/feature_flag/index.dart';
import 'package:jp_mobile_flutter_ui/IconButton/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../common/enums/filter_dialog_text_type.dart';
import '../../../../common/models/progress_board/progress_board_filter_model.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../global_widgets/safearea/safearea.dart';
import 'controller.dart';

class PBFilterDialog extends StatelessWidget {
  const PBFilterDialog({
    super.key,
    required this.selectedFilters,
    required this.defaultFilters,
    required this.onApply,
  });

  final ProgressBoardFilterModel selectedFilters;
  final ProgressBoardFilterModel defaultFilters;
  final void Function(ProgressBoardFilterModel params) onApply;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Helper.hideKeyboard(),
        child: JPSafeArea(
          child: GetBuilder<PBFilterDialogController>(
            global: false,
            init: PBFilterDialogController(selectedFilters, defaultFilters),
            builder: (controller) => AlertDialog(
              insetPadding: const EdgeInsets.all(10),
              contentPadding: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
              content: Builder(builder: (context) => Container(
                width: double.maxFinite,
                padding: const EdgeInsets.fromLTRB(20, 10, 10, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///   header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: JPText(
                              text: "filter".tr.toUpperCase(),
                              textSize: JPTextSize.heading3,
                              fontWeight: JPFontWeight.medium,
                            ),
                        ),
                        JPIconButton(
                            onTap: () => Get.back(),
                            backgroundColor: JPColor.transparent,
                            icon: Icons.clear,
                            iconColor: JPAppTheme.themeColors.text,
                            iconSize: 24,
                          ),
                      ]
                    ),
                    ///   body
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(right: 10),
                        child: Form(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ///   stages
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: JPInputBox(
                                    controller: controller.stagesTextController,
                                    onPressed: () => controller.openMultiSelect(FilterDialogTextType.stages),
                                    type: JPInputBoxType.withLabel,
                                    label: "stages".tr,
                                    hintText: "select".tr,
                                    readOnly: true,
                                    fillColor: JPAppTheme.themeColors.base,
                                    suffixChild: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(Icons.keyboard_arrow_down, size: 18),
                                    )
                                ),
                              ),
                              ///   division
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
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
                              ///   salesman / customer rep
                              HasFeatureAllowed(
                                feature:const [FeatureFlagConstant.userManagement],
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: JPInputBox(
                                      controller: controller.usersTextController,
                                      onPressed: () => controller.openMultiSelect(FilterDialogTextType.users),
                                      type: JPInputBoxType.withLabel,
                                      label: "salesman_customer_rep".tr.capitalize,
                                      hintText: "select".tr,
                                      readOnly: true,
                                      fillColor: JPAppTheme.themeColors.base,
                                      suffixChild: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(Icons.keyboard_arrow_down, size: 18),
                                      )
                                  ),
                                ),
                              ),
                              ///   trade
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: JPInputBox(
                                    controller: controller.tradeTextController,
                                    onPressed: () => controller.openSingleSelect(FilterDialogTextType.trades),
                                    type: JPInputBoxType.withLabel,
                                    label: "trade_type".tr,
                                    hintText: "none".tr,
                                    readOnly: true,
                                    fillColor: JPAppTheme.themeColors.base,
                                    suffixChild: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(Icons.keyboard_arrow_down, size: 18),
                                    )
                                ),
                              ),
                              ///   job status
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: JPInputBox(
                                    controller: controller.jobStatusTextController,
                                    onPressed: () => controller.openSingleSelect(FilterDialogTextType.status),
                                    type: JPInputBoxType.withLabel,
                                    label: "job_status".tr,
                                    hintText: "active".tr,
                                    readOnly: true,
                                    fillColor: JPAppTheme.themeColors.base,
                                    suffixChild: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(Icons.keyboard_arrow_down, size: 18),
                                    )
                                ),
                              ),
                              ///   job / project id
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: JPInputBox(
                                  controller: controller.jobIdTextController,
                                  type: JPInputBoxType.withLabel,
                                  label: "job_or_project_id".tr.capitalize,
                                  readOnly: false,
                                  fillColor: JPAppTheme.themeColors.base,
                                  onChanged: (val) => controller.onTextChange(value: val.trim(), type: FilterDialogTextType.job),
                                ),
                              ),
                              ///   job name / project name
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: JPInputBox(
                                  controller: controller.jobNameTextController,
                                  type: JPInputBoxType.withLabel,
                                  label: "job_or_project_name".tr,
                                  readOnly: false,
                                  fillColor: JPAppTheme.themeColors.base,
                                  onChanged: (val) => controller.onTextChange(value: val.trim(), type: FilterDialogTextType.jobName),
                                ),
                              ),
                              ///   customer name
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: JPInputBox(
                                  controller: controller.customerNameTextController,
                                  type: JPInputBoxType.withLabel,
                                  label: "customer_name".tr.capitalize,
                                  readOnly: false,
                                  fillColor: JPAppTheme.themeColors.base,
                                  onChanged: (val) => controller.onTextChange(value: val.trim(), type: FilterDialogTextType.customerName),
                                ),
                              ),
                              ///   job / project address
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: JPInputBox(
                                  controller: controller.jobAddressTextController,
                                  type: JPInputBoxType.withLabel,
                                  label: "job_or_project_address".tr.capitalize,
                                  readOnly: false,
                                  fillColor: JPAppTheme.themeColors.base,
                                  onChanged: (val) => controller.onTextChange(value: val.trim(), type: FilterDialogTextType.address),
                                ),
                              ),
                              ///   zip
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: JPInputBox(
                                  controller: controller.zipTextController,
                                  type: JPInputBoxType.withLabel,
                                  label: "zip".tr,
                                  readOnly: false,
                                  fillColor: JPAppTheme.themeColors.base,
                                  onChanged: (val) => controller.onTextChange(value: val.trim(), type: FilterDialogTextType.zip),
                                ),
                              ),
                            ]
                          )
                        )
                      )
                    ),
                    ///   bottom buttons
                    Padding(
                      padding: const EdgeInsets.only(top: 20, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: JPResponsiveDesign.popOverButtonFlex,
                            child: JPButton(
                              text: 'clear_all'.tr.toUpperCase(),
                              onPressed: () {
                                Helper.hideKeyboard();
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
                              text: 'apply'.tr.toUpperCase(),
                              fontWeight: JPFontWeight.medium,
                              size: JPButtonSize.small,
                              colorType: JPButtonColorType.primary,
                              textColor: JPAppTheme.themeColors.base,
                            ),
                          )
                        ]
                      ),
                    ),
                  ]
                )
              ))
            )
          )
        )
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/automation/filter.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../../common/enums/date_picker_type.dart';
import '../../../../core/constants/widget_keys.dart';
import '../../../../global_widgets/safearea/safearea.dart';
import 'controller.dart';

class AutomationFilterDialogView extends StatelessWidget {
  const AutomationFilterDialogView({
    super.key,
      required this.selectedFilters,
    required this.defaultFilters,
    required this.onApply,
  });

  final AutomationFilterModel defaultFilters;
  final AutomationFilterModel selectedFilters;

  final void Function(AutomationFilterModel params) onApply;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: JPSafeArea(
        child: GetBuilder<AutomationFilterDialogController>(
            init: AutomationFilterDialogController(selectedFilters,defaultFilters),
            global: false,
            builder: (controller) => AlertDialog(
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
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    children: [
                                      ///   divisions
                                      Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: JPInputBox(
                                          key: const ValueKey(WidgetKeys.division),
                                            controller: controller.divisionsTextController,
                                            onPressed: () => controller.openDivisionSelector(),
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
                                      Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: JPInputBox(
                                          key: const ValueKey(WidgetKeys.duration),
                                          controller: controller.durationTextController,
                                          onPressed: () => controller.openDurationSelector(),
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
                                                text: controller.getStartDate(),
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
                                                text: controller.getEndDate(),
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
                                    ],
                                  ),
                                ),
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

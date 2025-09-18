import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/appointment/appointment.dart';
import 'package:jobprogress/common/models/appointment/appointment_result/appointment_result_options.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/single_select_helper.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/modules/appointment_details/widgets/result_options_dialog/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class AppointmentResultOptionsDialog extends StatelessWidget {

  const AppointmentResultOptionsDialog({
    super.key,
    required this.resultOptions,
    required this.appointment,
  });

  /// resultOptions will store fields available to store appointment result
  final List<AppointmentResultOptionsModel> resultOptions;

  final AppointmentModel appointment;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Helper.hideKeyboard,
      child: JPSafeArea(
        child: GetBuilder<AppointmentResultOptionsDialogController>(
          init: AppointmentResultOptionsDialogController(
              resultOptions, appointment),
          builder: (controller) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AlertDialog(
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
                        /// header
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              JPText(
                                text: "appointment_result".tr.toUpperCase(),
                                textSize: JPTextSize.heading3,
                                fontWeight: JPFontWeight.medium,
                              ),
                              JPTextButton(
                                isDisabled: controller.isLoading,
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
                        /// fields and options
                        Flexible(
                            child: SingleChildScrollView(
                          child: Column(
                            children: [
                              JPInputBox(
                                label: "result_option".tr,
                                type: JPInputBoxType.withLabel,
                                readOnly: true,
                                hintText: 'select'.tr,
                                controller: TextEditingController(
                                    text: SingleSelectHelper
                                        .getSelectedSingleSelectValue(
                                            controller.fieldsFilter,
                                            controller.selectedFilter)),
                                onPressed: controller.showFieldsSelector,
                                fillColor: JPAppTheme.themeColors.base,
                                suffixChild: const Padding(
                                  padding: EdgeInsets.only(right: 9),
                                  child: JPIcon(Icons.keyboard_arrow_down),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Form(
                                key: controller.formKey,
                                child: Column(
                                  children: controller.fieldsList.map((field) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: JPInputBox(
                                        isRequired: true,
                                        controller: field.controller,
                                        type: JPInputBoxType.withLabel,
                                        label: field.name?.capitalize ?? '',
                                        fillColor: JPAppTheme.themeColors.base,
                                        maxLines:
                                            field.type == 'textarea' ? 4 : 1,
                                        validator: (value) {
                                          return controller
                                              .validateField(value!);
                                        },
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        )),
                        /// buttons
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: JPResponsiveDesign.popOverButtonFlex,
                                  child: JPButton(
                                    text: 'cancel'.tr.toUpperCase(),
                                    onPressed: () {
                                      Helper.hideKeyboard();
                                      Get.back();
                                    },
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
                                    onPressed: controller.validateAndSave,
                                    text: controller.isLoading ? '' : 'save'.tr.toUpperCase(),
                                    fontWeight: JPFontWeight.medium,
                                    size: JPButtonSize.small,
                                    colorType: JPButtonColorType.primary,
                                    textColor: JPAppTheme.themeColors.base,
                                    disabled: controller.isLoading,
                                    iconWidget: showJPConfirmationLoader(
                                        show: controller.isLoading),
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
      ),
    );
  }
}

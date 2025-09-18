import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../common/models/customer_list/customer_listing_filter.dart';
import 'controller.dart';

class CustomerListingDialog extends StatelessWidget {
  const CustomerListingDialog({
    super.key,
    required this.selectedFilters,
    required this.defaultFilterKeys,
    required this.onApply
  });

  final CustomerListingFilterModel selectedFilters;
  final CustomerListingFilterModel defaultFilterKeys;
  final void Function(CustomerListingFilterModel params) onApply;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CustomerListingFilterDialogController(selectedFilters, defaultFilterKeys));

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: JPSafeArea(
        child: GetBuilder<CustomerListingFilterDialogController>(
            builder: (_) => AlertDialog(
              insetPadding: const EdgeInsets.all(10),
              contentPadding: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
              content: Builder(
                builder: (context) {
                  return Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ///   header
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              JPText(
                                text: "filters".tr,
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
                        Flexible(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ///   assigned to
                                if(!AuthService.isPrimeSubUser())...{
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20,),
                                    child: JPInputBox(
                                        key: const ValueKey(WidgetKeys.assignedToKey),
                                        controller: controller.assignedTextController,
                                        onPressed: () => controller.selectAssignedTo(),
                                        type: JPInputBoxType.withLabel,
                                        label: "assigned_to".tr,
                                        hintText: "all".tr,
                                        readOnly: true,
                                        disabled: AuthService.isStandardUser() ? AuthService.isRestricted : AuthService.isPrimeSubUser() ? true : false,
                                        fillColor: JPAppTheme.themeColors.base,
                                        onChanged: (val) => controller.updateResetButtonDisable(),
                                        suffixChild: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: JPIcon(Icons.keyboard_arrow_down, size: 18),
                                        )
                                    ),
                                  ),
                                },
                                
                                ///   name
                                Padding(
                                  padding: EdgeInsets.only(top: !AuthService.isPrimeSubUser() ? 15 : 20,),
                                  child: JPInputBox(
                                    key: const ValueKey(WidgetKeys.customerFilterNameKey),
                                    controller: controller.nameTextController,
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
                                              onTap: () => controller.selectNameFilterType(),
                                              borderRadius: BorderRadius.circular(8),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 6, right: 14),
                                                    child: JPText(
                                                      text: controller.selectedNameFilter?.label ?? "customer".tr,
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
                                ///   phone
                                Padding(
                                  padding: const EdgeInsets.only(top: 15,),
                                  child: JPInputBox(
                                    key: const ValueKey(WidgetKeys.phoneKey),
                                    controller: controller.phoneTextController,
                                    fillColor: JPAppTheme.themeColors.base,
                                    type: JPInputBoxType.withLabel,
                                    label: "phone".tr,
                                    keyboardType: TextInputType.phone,
                                    onChanged: (val) => controller.updateResetButtonDisable(),
                                    inputFormatters: [ TextInputMask(mask: '(XXX) XXX-XXXX', placeholder: '(XXX) XXX-XXXX')],
                                  ),
                                ),
                                ///   email
                                Form(
                                  key: controller.filterFormKey,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 15,),
                                    child: JPInputBox(
                                      key: const ValueKey(WidgetKeys.emailKey),
                                      controller: controller.emailTextController,
                                      fillColor: JPAppTheme.themeColors.base,
                                      type: JPInputBoxType.withLabel,
                                      label: "email".tr,
                                      readOnly: false,
                                      onChanged: (val) => controller.updateResetButtonDisable(),
                                      onSaved: (val) {},
                                      validator: (value) {
                                        return controller.validateEmail(value!.toString().trim());
                                      },
                                    ),
                                  ),
                                ),
                                ///   address
                                Padding(
                                  padding: const EdgeInsets.only(top: 15,),
                                  child: JPInputBox(
                                    key: const ValueKey(WidgetKeys.addressKey),
                                    controller: controller.addressTextController,
                                    fillColor: JPAppTheme.themeColors.base,
                                    type: JPInputBoxType.withLabel,
                                    label: "address".tr,
                                    readOnly: false,
                                    onChanged: (val) => controller.updateResetButtonDisable(),
                                  ),
                                ),
                                ///   state
                                Padding(
                                  padding: const EdgeInsets.only(top: 15,),
                                  child: JPInputBox(
                                      key: const ValueKey(WidgetKeys.stateKey),
                                      maxLength: 50,
                                      maxLines: 1,
                                      controller: controller.stateTextController,
                                      fillColor: JPAppTheme.themeColors.base,
                                      hintText: "select".tr,
                                      onPressed: () => controller.selectState(),
                                      type: JPInputBoxType.withLabel,
                                      label: "states".tr,
                                      readOnly: true,
                                      onChanged: (val) => controller.updateResetButtonDisable(),
                                      suffixChild: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: JPIcon(Icons.keyboard_arrow_down, size: 18),
                                      )
                                  ),
                                ),
                                ///   zip
                                Padding(
                                  padding: const EdgeInsets.only(top: 15,),
                                  child: JPInputBox(
                                    key: const ValueKey(WidgetKeys.zipKey),
                                    controller: controller.zipTextController,
                                    fillColor: JPAppTheme.themeColors.base,
                                    type: JPInputBoxType.withLabel,
                                    label: "zip".tr,
                                    readOnly: false,
                                    onChanged: (val) => controller.updateResetButtonDisable(),
                                  ),
                                ),

                                ///   customer_note
                                Padding(
                                  padding: const EdgeInsets.only(top: 15,),
                                  child: JPInputBox(
                                    key: const ValueKey(WidgetKeys.customerNoteKey),
                                    controller: controller.customerNoteTextController,
                                    fillColor: JPAppTheme.themeColors.base,
                                    type: JPInputBoxType.withLabel,
                                    label: "customer_note".tr,
                                    readOnly: false,
                                    onChanged: (val) => controller.updateResetButtonDisable(),
                                  ),
                                ),

                                ///   flags
                                Padding(
                                  padding: const EdgeInsets.only(top: 15,),
                                  child: JPInputBox(
                                      key: const ValueKey(WidgetKeys.flagKey),
                                      maxLength: 50,
                                      maxLines: 1,
                                      controller: controller.flagsTextController,
                                      fillColor: JPAppTheme.themeColors.base,
                                      hintText: "select".tr,
                                      onPressed: controller.selectFlags,
                                      type: JPInputBoxType.withLabel,
                                      label: "flags".tr,
                                      readOnly: true,
                                      onChanged: (val) => controller.updateResetButtonDisable(),
                                      suffixChild: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: JPIcon(Icons.keyboard_arrow_down, size: 18),
                                      )
                                  ),
                                ),
                              ],
                            ),
                            ),
                        ),
                        ///   bottom buttons
                        Padding(
                          padding: const EdgeInsets.only(top: 25),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: JPResponsiveDesign.popOverButtonFlex,
                                  child: JPButton(
                                    key: const ValueKey(WidgetKeys.resetKey),
                                    text: 'reset'.tr,
                                    onPressed: () {
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      controller.cleanFilterKeys();
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
                                    key: const ValueKey(WidgetKeys.applyKey),
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
                        )
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

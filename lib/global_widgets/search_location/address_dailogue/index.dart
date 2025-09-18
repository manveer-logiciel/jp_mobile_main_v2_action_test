import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../common/models/address/address.dart';
import '../../../core/utils/form/validators.dart';
import '../../loader/index.dart';
import '../../safearea/safearea.dart';
import 'controller.dart';

class SearchedAddressDialogueView extends StatelessWidget {
  const SearchedAddressDialogueView({
    super.key,
    this.addressModel,
    required this.onApply,
  });

  final AddressModel? addressModel;
  final void Function(AddressModel params) onApply;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: JPSafeArea(
        child: GetBuilder<SearchedAddressDialogueController>(
          init: SearchedAddressDialogueController(addressModel: addressModel),
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
                                  text: "address".tr.toUpperCase(),
                                  textSize: JPTextSize.heading3,
                                  fontWeight: JPFontWeight.medium,
                                ),
                                JPTextButton(
                                  onPressed: () => Get.back(),
                                  color: JPAppTheme.themeColors.text,
                                  icon: Icons.clear,
                                  iconSize: 24,
                                  isDisabled: controller.isLoading,
                                )
                              ]
                          ),
                        ),
                        ///   body
                        Flexible(
                          child: SingleChildScrollView(
                            child: Form(
                              key: controller.formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ///   address
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                                    child: JPInputBox(
                                      key: const ValueKey(WidgetKeys.addressKey),
                                      inputBoxController: controller.addressTextController,
                                      type: JPInputBoxType.withLabel,
                                      label: "address".tr.capitalize,
                                      hintText: "address".tr,
                                      fillColor: JPAppTheme.themeColors.base,
                                      isRequired: true,
                                      onChanged: controller.onDataChanged,
                                      validator: (val) => FormValidator.requiredFieldValidator(
                                        val, errorMsg: "address_field_is_required".tr),
                                    ),
                                  ),
                                  ///   city
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                                    child: JPInputBox(
                                      key: const ValueKey(WidgetKeys.cityKey),
                                      inputBoxController: controller.cityTextController,
                                      type: JPInputBoxType.withLabel,
                                      label: "city".tr.capitalize,
                                      hintText: "city".tr,
                                      fillColor: JPAppTheme.themeColors.base,
                                      isRequired: true,
                                      onChanged: controller.onDataChanged,
                                      validator: (val) => FormValidator.requiredFieldValidator(
                                        val, errorMsg: "city_field_is_required".tr),
                                    ),
                                  ),
                                  ///   state
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                                    child: JPInputBox(
                                        key: const ValueKey(WidgetKeys.stateKey),
                                        maxLength: 50,
                                        maxLines: 1,
                                        inputBoxController: controller.stateTextController,
                                        fillColor: JPAppTheme.themeColors.base,
                                        hintText: "select".tr,
                                        onPressed: () => controller.selectState(),
                                        type: JPInputBoxType.withLabel,
                                        label: "states".tr.capitalize,
                                        readOnly: true,
                                        isRequired: true,
                                        suffixChild: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(Icons.keyboard_arrow_down, size: 18),
                                        ),
                                      validator: (val) => FormValidator.requiredFieldValidator(
                                        val, errorMsg: "state_field_is_required".tr),
                                    ),
                                  ),
                                  ///   zip
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                                    child: JPInputBox(
                                      key: const ValueKey(WidgetKeys.zipKey),
                                      inputBoxController: controller.zipTextController,
                                      fillColor: JPAppTheme.themeColors.base,
                                      type: JPInputBoxType.withLabel,
                                      label: "zip".tr.capitalize,
                                      isRequired: true,
                                      onChanged: controller.onDataChanged,
                                      validator: (val) => FormValidator.requiredFieldValidator(
                                        val, errorMsg: "zip_field_is_required".tr),
                                    ),
                                  ),
                                  const SizedBox(height: 20,),
                                ],
                              ),
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
                                    text: 'cancel'.tr.toUpperCase(),
                                    onPressed: () {
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      Get.back();
                                    },
                                    fontWeight: JPFontWeight.medium,
                                    size: JPButtonSize.small,
                                    colorType: JPButtonColorType.lightGray,
                                    textColor: JPAppTheme.themeColors.tertiary,
                                    disabled: controller.isLoading,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  flex: JPResponsiveDesign.popOverButtonFlex,
                                  child: JPButton(
                                    key: const ValueKey(WidgetKeys.searchKey),
                                    onPressed: () => controller.validateAddress(onApply),
                                    text: controller.isLoading ? "" : 'search'.tr.toUpperCase(),
                                    fontWeight: JPFontWeight.medium,
                                    size: JPButtonSize.small,
                                    colorType: JPButtonColorType.primary,
                                    textColor: JPAppTheme.themeColors.base,
                                    disabled: controller.isLoading,
                                    iconWidget: showJPConfirmationLoader(show: controller.isLoading),
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


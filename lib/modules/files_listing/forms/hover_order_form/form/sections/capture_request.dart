
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/files_listing/forms/hover_order_form/index.dart';
import 'package:jobprogress/common/services/phone_masking.dart';
import 'package:jobprogress/modules/files_listing/forms/hover_order_form/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class HoverOrderFormCaptureRequest extends StatelessWidget {
  const HoverOrderFormCaptureRequest({
    super.key,
    required this.controller
  });

  final HoverOrderFormController controller;

  Widget get inputFieldSeparator => SizedBox(
    height: controller.formUiHelper.inputVerticalSeparator,
    width: controller.formUiHelper.horizontalPadding,
  );

  HoverOrderFormService get service => controller.service;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        inputFieldSeparator,

        /// request for
        JPInputBox(
          inputBoxController: service.requestForController,
          label: 'request_for'.tr,
          isRequired: true,
          disabled: controller.isSavingForm,
          type: JPInputBoxType.withLabel,
          fillColor: JPAppTheme.themeColors.base,
          suffixChild: Padding(
            padding: const EdgeInsets.only(
              right: 8,
            ),
            child: JPTextButton(
              text: service.requestForTypeId.tr.toUpperCase(),
              color: JPAppTheme.themeColors.secondaryText,
              textSize: JPTextSize.heading5,
              isExpanded: false,
              onPressed: service.selectRequestFor,
            ),
          ),
          onChanged: controller.onDataChanged,
          validator: (val) => service.validateRequestFor(val),
        ),

        inputFieldSeparator,

        /// phone number
        JPInputBox(
          inputBoxController: service.phoneController,
          label: 'phone'.tr,
          isRequired: true,
          keyboardType: TextInputType.number,
          disabled: controller.isSavingForm,
          type: JPInputBoxType.withLabel,
          fillColor: JPAppTheme.themeColors.base,
          inputFormatters: [
            PhoneMasking.inputFieldMask()
          ],
          suffixChild: Padding(
            padding: const EdgeInsets.only(
              right: 8,
            ),
            child: service.doShowPhoneSelect ? JPTextButton(
              text: 'select'.tr.toUpperCase(),
              color: JPAppTheme.themeColors.primary,
              textSize: JPTextSize.heading5,
              isExpanded: false,
              onPressed: service.selectPhone,
            ) : null,
          ),
          onChanged: controller.onDataChanged,
          validator: (val) => service.validatePhoneNumber(val),
        ),

        inputFieldSeparator,

        /// email
        JPInputBox(
          inputBoxController: service.emailController,
          label: 'email'.tr,
          isRequired: true,
          textCapitalization: TextCapitalization.none,
          disabled: controller.isSavingForm,
          type: JPInputBoxType.withLabel,
          fillColor: JPAppTheme.themeColors.base,
          suffixChild: Padding(
            padding: const EdgeInsets.only(
              right: 8,
            ),
            child: service.doShowEmailSelect ? JPTextButton(
              text: 'select'.tr.toUpperCase(),
              color: JPAppTheme.themeColors.primary,
              textSize: JPTextSize.heading5,
              isExpanded: false,
              onPressed: service.selectEmail,
            ) : null,
          ),
          onChanged: controller.onDataChanged,
          validator: (val) => service.validateEmail(val),
        ),

        inputFieldSeparator,

        /// address
        JPInputBox(
          inputBoxController: service.addressController,
          label: 'address'.tr,
          isRequired: true,
          disabled: controller.isSavingForm,
          type: JPInputBoxType.withLabel,
          fillColor: JPAppTheme.themeColors.base,
          readOnly: true,
          onPressed: service.selectAddress,
          suffixChild: Padding(
            padding: EdgeInsets.symmetric(horizontal: controller.formUiHelper.suffixPadding),
            child: JPIcon(
              Icons.location_on_outlined,
              color: JPAppTheme.themeColors.primary,
            ),
          ),
          onChanged: controller.onDataChanged,
          validator: (val) => service.validateAddress(val),
        ),

        inputFieldSeparator,

        /// address line two
        JPInputBox(
          inputBoxController: service.addressLineTwoController,
          label: 'address_line_2'.tr,
          disabled: controller.isSavingForm,
          type: JPInputBoxType.withLabel,
          fillColor: JPAppTheme.themeColors.base,
        ),

        inputFieldSeparator,

        /// city & state
        Row(
          children: [
            Expanded(
              child: JPInputBox(
                inputBoxController: service.cityController,
                label: 'city'.tr.capitalizeFirst,
                disabled: controller.isSavingForm,
                type: JPInputBoxType.withLabel,
                fillColor: JPAppTheme.themeColors.base,
              ),
            ),
            inputFieldSeparator,
            Expanded(
              child: JPInputBox(
                inputBoxController: service.stateController,
                label: 'state'.tr,
                disabled: controller.isSavingForm,
                type: JPInputBoxType.withLabel,
                readOnly: true,
                onPressed: service.selectState,
                fillColor: JPAppTheme.themeColors.base,
                suffixChild: service.doShowStateSelect ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: controller.formUiHelper.suffixPadding),
                  child: JPIcon(
                    Icons.expand_more,
                    color: JPAppTheme.themeColors.text,
                  ),
                ) : null,
              ),
            ),
          ],
        ),

        inputFieldSeparator,

        /// zipcode & country
        Row(
          children: [
            Expanded(
              child: JPInputBox(
                inputBoxController: service.zipCodeController,
                label: 'zip'.tr,
                disabled: controller.isSavingForm,
                type: JPInputBoxType.withLabel,
                fillColor: JPAppTheme.themeColors.base,
              ),
            ),
            inputFieldSeparator,
            Expanded(
              child: JPInputBox(
                inputBoxController: service.countryController,
                label: 'country'.tr,
                disabled: controller.isSavingForm,
                type: JPInputBoxType.withLabel,
                readOnly: true,
                onPressed: service.doShowCountrySelect ? service.selectCountry : null,
                fillColor: JPAppTheme.themeColors.base,
                suffixChild: service.doShowCountrySelect ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: controller.formUiHelper.suffixPadding),
                  child: JPIcon(
                    Icons.expand_more,
                    color: JPAppTheme.themeColors.text,
                  ),
                ) : null,
              ),
            ),
          ],
        ),

      ],
    );
  }
}
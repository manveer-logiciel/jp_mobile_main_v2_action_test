import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/address_form_type.dart';
import 'package:jobprogress/common/models/forms/address/index.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/global_widgets/expansion_tile/index.dart';
import 'package:jobprogress/global_widgets/forms/address/controller.dart';
import 'package:jobprogress/global_widgets/forms/address/widgets/city_field.dart';
import 'package:jobprogress/global_widgets/forms/address/widgets/country_field.dart';
import 'package:jobprogress/global_widgets/forms/address/widgets/state_field.dart';
import 'package:jobprogress/global_widgets/forms/address/widgets/zip_field.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class AddressSection extends StatelessWidget {
  const AddressSection({
    super.key,
    this.isDisabled = false,
    required this.withoutSectionHeader,
    required this.hideAddressLine3Field,
    required this.hideCountryField,
    required this.controller,
    required this.data,
    required this.title,
    required this.type,
    this.showName = false,
    this.isAbcOrder = false
  });

  // provides access to controller
  final AddressFormController controller;

  // helps in setting up field controllers & data
  final AddressFormData data;

  // used to disable form fields
  final bool isDisabled;

  // used to give title to collapsable section
  final String title;

  /// helps in rendering element accordingly
  final AddressFormType type;

  /// used to show form fields without section
  final bool withoutSectionHeader;

  /// used to hide address line 3 field
  final bool hideAddressLine3Field;

  /// used to hide country field
  final bool hideCountryField;

  final bool showName;

  Widget get separator => SizedBox(
        height: controller.formUiHelper.verticalPadding,
        width: controller.formUiHelper.horizontalPadding,
      );
  bool get isPlaceSrsOrder => type == AddressFormType.placeSrsOrder;
  final bool isAbcOrder;

  @override
  Widget build(BuildContext context) {
    if (withoutSectionHeader) {
      return Column(children: formFields);
    }

    return JPExpansionTile(
      key: const Key(WidgetKeys.addressSectionKey),
      enableHeaderClick: true,
      initialCollapsed: true,
      preserveWidgetOnCollapsed: true,
      borderRadius: controller.formUiHelper.sectionBorderRadius,
      isExpanded: data.isSectionExpanded,
      headerPadding: EdgeInsets.symmetric(
        horizontal: controller.formUiHelper.horizontalPadding,
        vertical: controller.formUiHelper.verticalPadding,
      ),
      header: JPText(
        text: title.toUpperCase(),
        textSize: JPTextSize.heading4,
        fontWeight: JPFontWeight.medium,
        textColor: JPAppTheme.themeColors.darkGray,
        textAlign: TextAlign.start,
      ),
      trailing: (_) => JPIcon(
        Icons.expand_more,
        color: JPAppTheme.themeColors.secondaryText,
      ),
      contentPadding: EdgeInsets.only(
        left: controller.formUiHelper.horizontalPadding,
        right: controller.formUiHelper.horizontalPadding,
        bottom: controller.formUiHelper.verticalPadding,
      ),
      onExpansionChanged: (val) => controller.onExpansionChanged(data, val),
      children: [

        if (type == AddressFormType.job) ...{
          Row(
            children: [
              Transform.translate(
                offset: const Offset(-6, -2),
                child: JPCheckbox(
                  selected: data.sameAsCustomerAddress,
                  text: "same_as_customer_address".tr,
                  padding: EdgeInsets.zero,
                  separatorWidth: 2,
                  disabled: isDisabled,
                  onTap: (val) => controller.toggleSameAsCustomerAddress(data, val),
                ),
              )
            ],
          ),
          if (!hideFormFields)
            const SizedBox(height: 12,),
        },

        if (!hideFormFields)
          ...formFields
      ],
    );
  }

  bool get hideFormFields => type == AddressFormType.job
      && data.sameAsCustomerAddress;

  List<Widget> get formFields => [
    /// Billing Name
    if(showName)...{
      JPInputBox(
        inputBoxController: data.nameController,
        type: JPInputBoxType.withLabel,
        maxLength: 35,
        label: 'name'.tr,
        fillColor: JPAppTheme.themeColors.base,
        disabled: isDisabled,
        onChanged: (val) {
          controller.onValueChanged(data);
        },
      ),
      separator,
    },   
    /// Address
    JPInputBox(
      key: const Key(WidgetKeys.addressKey),
      inputBoxController: data.addressController,
      type: JPInputBoxType.withLabel,
      label: 'address'.tr,
      fillColor: JPAppTheme.themeColors.base,
      disabled: isDisabled,
      isRequired: controller.isRequired,
      onPressed: () => controller.selectAddress(data: data),
      readOnly: true,
      suffixChild: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: controller.formUiHelper.horizontalPadding),
        child: JPIcon(
          Icons.location_on_outlined,
          color: JPAppTheme.themeColors.primary,
        ),
      ),
      validator: (val) => controller.isRequired ? data.validateAddress() : null,
    ),
    separator,

    ///   Address line 2
    JPInputBox(
      key: const Key(WidgetKeys.addressLineTwoKey),
      inputBoxController: data.addressLine2Controller,
      type: JPInputBoxType.withLabel,
      label: 'address_line_two'.tr,
      fillColor: JPAppTheme.themeColors.base,
      disabled: isDisabled,
      onChanged: (val) {
        controller.onValueChanged(data);
      },
    ),
    separator,

    if (!hideAddressLine3Field) ...[
      ///   Address line 3
      JPInputBox(
        key: const Key(WidgetKeys.addressLineThreeKey),
        inputBoxController: data.addressLine3Controller,
        type: JPInputBoxType.withLabel,
        label: 'address_line_three'.tr,
        fillColor: JPAppTheme.themeColors.base,
        disabled: isDisabled,
        onChanged: (val) {
          controller.onValueChanged(data);
        },
      ),
      separator,
    ],

    ///   City & State
    if (hideCountryField) 
      CityField(controller: controller, data: data, isDisabled: isDisabled, isRequired: isPlaceSrsOrder)
    else
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: CityField(controller: controller, data: data, isDisabled: isDisabled, isRequired: isAbcOrder)),
          separator,
          Expanded(child: StateField(controller: controller, data: data, isDisabled: isDisabled, isRequired: isAbcOrder)),
        ],
      ),
    separator,

    ///   Zip & Country
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: ZipField(controller: controller, data: data, isDisabled: isDisabled, isRequired: isPlaceSrsOrder)),
        separator,
        Expanded(
          child: hideCountryField 
            ? StateField(controller: controller, data: data, isDisabled: isDisabled, isRequired: isPlaceSrsOrder) 
            : CountryField(controller: controller, data: data, isDisabled: isDisabled, isRequired: isAbcOrder),
          ),
      ],
    ),

    ///   Billing address toggle
    if(data.showBillingAddressToggle) ...{
      Align(
        alignment: Alignment.centerLeft,
        child: Transform.translate(
          offset: const Offset(-6, 8),
          child: JPCheckbox(
            disabled: isDisabled,
            selected: !data.showBillingAddress,
            text: "billing_address_same_as_customer".tr,
            onTap: (val) => controller.toggleBillingAddress(data: data, val: val),
            padding: const EdgeInsets.symmetric(
                vertical: 5
            ),
          ),
        ),
      )
    }
  ];
  
}

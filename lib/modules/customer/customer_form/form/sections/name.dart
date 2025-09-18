
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/forms/common/params.dart';
import 'package:jobprogress/common/services/customer/customer_form/add_customer.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/global_widgets/add_remove_icon/index.dart';
import 'package:jobprogress/modules/customer/customer_form/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class CustomerFormCustomerCompanyName extends StatelessWidget {

  const CustomerFormCustomerCompanyName({
    super.key,
    required this.controller,
    required this.field,
    this.isDisabled = false
  });

  final CustomerFormController controller;
  final InputFieldParams field;
  final bool isDisabled;

  CustomerFormService get service => controller.service;

  Widget get separator => SizedBox(
    width: controller.formUiHelper.horizontalPadding,
    height: controller.formUiHelper.verticalPadding,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///   First Name
            Expanded(
              child: JPInputBox(
                key: const Key(WidgetKeys.customerFormFirstName),
                inputBoxController: service.firstNameController,
                label: 'first_name'.tr,
                isRequired: field.isRequired,
                disabled: isDisabled,
                type: JPInputBoxType.withLabel,
                fillColor: JPAppTheme.themeColors.base,
                onChanged: field.onDataChange,
                validator: (val) => service.validateFirstName(val),
              ),
            ),
            separator,

            ///   Last Name
            Expanded(
              child: JPInputBox(
                key: const Key(WidgetKeys.customerFormLastName),
                inputBoxController: service.lastNameController,
                label: 'last_name'.tr,
                isRequired: field.isRequired,
                disabled: isDisabled,
                type: JPInputBoxType.withLabel,
                fillColor: JPAppTheme.themeColors.base,
                onChanged: field.onDataChange,
                validator: (val) => service.validateLastName(val),
              ),
            ),

            if (!service.showSecondaryNameField && !service.isCommercial)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: FormAddRemoveButton(
                    key: const Key(WidgetKeys.customerFormSecNameButtonKey),
                    onTap: service.toggleSecondaryNameFields,
                    isAddBtn: true,
                ),
              ),
          ],
        ),

        if(service.showSecondaryNameField && !service.isCommercial) ...{
          separator,
          Row(
            children: [
              /// Secondary First Name
              Expanded(
                child: JPInputBox(
                  inputBoxController: service.secFirstNameController,
                  label: 'sec_first_name'.tr,
                  disabled: isDisabled,
                  type: JPInputBoxType.withLabel,
                  fillColor: JPAppTheme.themeColors.base,
                  onChanged: field.onDataChange,
                ),
              ),
              separator,

              ///   Secondary Last Name
              Expanded(
                child: JPInputBox(
                  inputBoxController: service.secLastNameController,
                  label: 'sec_last_name'.tr,
                  isRequired: false,
                  disabled: isDisabled,
                  type: JPInputBoxType.withLabel,
                  fillColor: JPAppTheme.themeColors.base,
                  onChanged: field.onDataChange,
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: FormAddRemoveButton(
                  key: const Key(WidgetKeys.customerFormSecNameButtonKey),
                  onTap: service.toggleSecondaryNameFields,
                  isAddBtn: false,
                ),
              ),

            ],
          ),
        }
      ],
    );
  }
}

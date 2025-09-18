import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/company_contact_listing/create_company_contact.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/global_widgets/forms/email/index.dart';
import 'package:jobprogress/global_widgets/forms/phone/index.dart';
import 'package:jobprogress/modules/company_contacts/create_company_contacts/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class CompanyContactDetailsSection extends StatelessWidget {

  const CompanyContactDetailsSection({
    super.key,
    required this.controller,
  });

  final CreateCompanyContactFormController controller;

  Widget get inputFieldSeparator => SizedBox(
        height: controller.formUiHelper.inputVerticalSeparator,
      );

  CreateCompanyContactFormService get service => controller.service;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: JPAppTheme.themeColors.base,
      borderRadius:
          BorderRadius.circular(controller.formUiHelper.sectionBorderRadius),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: controller.formUiHelper.horizontalPadding,
          vertical: controller.formUiHelper.verticalPadding,
        ),
        child: Column(
          children: [
            Form(
              key: controller.key,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // first Name
                  Expanded(
                    child: JPInputBox(
                      key: const Key(WidgetKeys.firstNameKey),
                      inputBoxController: service.firstNameController,
                      label: 'first_name'.tr.capitalize,
                      isRequired: true,
                      disabled: !service.isFieldEditable(),
                      type: JPInputBoxType.withLabel,
                      fillColor: JPAppTheme.themeColors.base,
                      onChanged: controller.onDataChanged,
                      validator: (val) => service.validateFirstName(val),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // last Name
                  Expanded(
                    child: JPInputBox(
                      key: const Key(WidgetKeys.lastNameKey),
                      inputBoxController: service.lastNameController,
                      label: 'last_name'.tr.capitalize,
                      isRequired: true,
                      disabled: !service.isFieldEditable(),
                      type: JPInputBoxType.withLabel,
                      fillColor: JPAppTheme.themeColors.base,
                       onChanged: controller.onDataChanged,
                       validator: (val) => service.validateLastName(val),
                    ),
                  ),
                ],
              ),
            ),
            inputFieldSeparator,

            // company Name
            JPInputBox(
              key: const Key(WidgetKeys.companyNameKey),
              inputBoxController: service.companyNameController,
              label: 'company_name'.tr.capitalize,
              disabled: !service.isFieldEditable(),
              type: JPInputBoxType.withLabel,
              fillColor: JPAppTheme.themeColors.base,
               onChanged: controller.onDataChanged,
            ),

            // phone list
            if(!service.isLoading) 
              Visibility(
                visible: service.isFieldVisible(),
                child: Column(
                  children: [
                    inputFieldSeparator,
                    PhoneForm(
                      key: controller.phoneFormKey,
                      phoneField: service.phoneList,
                      isDisabled: !service.isFieldEditable(),
                    ),
                  ],
                )),
            inputFieldSeparator,

            // email list
            if(!service.isLoading)
              EmailsForm(
              key: controller.emailFormKey,
              emails: service.emailList,
              isRequired: false,
              onDataChange: controller.onDataChanged,
              isDisabled: !service.isFieldEditable(),
              )
          ],
        ),
      ),
    );
  }
}

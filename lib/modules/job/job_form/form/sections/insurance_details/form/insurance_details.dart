import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/job/insurance_form/add_insurance.dart';
import 'package:jobprogress/common/services/phone_masking.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jobprogress/global_widgets/forms/phone/index.dart';
import 'package:jobprogress/modules/job/job_form/form/sections/insurance_details/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class InsuranceDetailsFormSection extends StatelessWidget {
  const InsuranceDetailsFormSection({
    super.key,
    required this.controller,
  });

  final InsuranceDetailsFormController controller;

  Widget get inputFieldSeparator => SizedBox(height: controller.formUiHelper.inputVerticalSeparator);

  InsuranceDetailsFormService get service => controller.service;

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
            JPInputBox(
              key: const Key(WidgetKeys.insuranceCompanyKey),
              inputBoxController: service.insuranceCompanyController,
              label: 'insurance_company'.tr,
              type: JPInputBoxType.withLabel,
              fillColor: JPAppTheme.themeColors.base,
            ),
            inputFieldSeparator,
            JPInputBox(
              key: const Key(WidgetKeys.claimKey),
              inputBoxController: service.claimController,
              label: 'claim'.tr,
              type: JPInputBoxType.withLabel,
              fillColor: JPAppTheme.themeColors.base,
            ),
            inputFieldSeparator,
            JPInputBox(
              key: const Key(WidgetKeys.policyKey),
              inputBoxController: service.policyController,
              label: 'policy'.tr,
              type: JPInputBoxType.withLabel,
              fillColor: JPAppTheme.themeColors.base,
            ),
            inputFieldSeparator,
            JPInputBox(
              key: const Key(WidgetKeys.phoneKey),
              inputBoxController: service.phoneController,
              label: 'phone'.tr,
              hintText: PhoneMasking.maskedPlaceHolder,
              type: JPInputBoxType.withLabel,
              fillColor: JPAppTheme.themeColors.base,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                PhoneMasking.inputFieldMask()
              ],
              validator: (val) => FormValidator.validatePhoneNumber(val, isRequired: false),
              onChanged: controller.onDataChanged,
            ),
            inputFieldSeparator,
            JPInputBox(
              key: const Key(WidgetKeys.faxKey),
              inputBoxController: service.faxController,
              label: 'fax'.tr,
              hintText: PhoneMasking.maskedPlaceHolder,
              type: JPInputBoxType.withLabel,
              fillColor: JPAppTheme.themeColors.base,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                PhoneMasking.inputFieldMask()
              ],
              validator: (val) => FormValidator.validatePhoneNumber(val, isRequired: false),
              onChanged: controller.onDataChanged,
            ),
            inputFieldSeparator,
            JPInputBox(
              key: const Key(WidgetKeys.emailKey),
              inputBoxController: service.emailController,
              label: 'email'.tr,
              textCapitalization: TextCapitalization.none,
              type: JPInputBoxType.withLabel,
              fillColor: JPAppTheme.themeColors.base,
              keyboardType: TextInputType.emailAddress,
              validator: (val) => FormValidator.validateEmail(val, isRequired: false),
              onChanged: controller.onDataChanged,
            ),
            inputFieldSeparator,
            JPInputBox(
              key: const Key(WidgetKeys.adjusterNameKey),
              inputBoxController: service.adjusterNameController,
              label: 'adjuster_name'.tr,
              type: JPInputBoxType.withLabel,
              fillColor: JPAppTheme.themeColors.base,
            ),
            inputFieldSeparator,
            PhoneForm(
              key: service.adjusterPhoneFormKey, 
              phoneField: service.adjusterPhoneField, 
              isRequired: false, 
              label: 'adjuster_phone'.tr, 
              showSufixIcon: false,
            ),
            inputFieldSeparator,
            JPInputBox(
              key: const Key(WidgetKeys.adjusterEmailKey),
              inputBoxController: service.adjusterEmailController,
              label: 'adjuster_email'.tr,
              textCapitalization: TextCapitalization.none,
              type: JPInputBoxType.withLabel,
              fillColor: JPAppTheme.themeColors.base,
              keyboardType: TextInputType.emailAddress,
              validator: (val) => FormValidator.validateEmail(val, isRequired: false),
              onChanged: controller.onDataChanged,
            ),
          ],
        ),
      ),
    );
  }
}

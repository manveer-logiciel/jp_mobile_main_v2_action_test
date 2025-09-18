import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:jobprogress/common/services/company_contact_listing/create_company_contact.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/modules/company_contacts/create_company_contacts/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JobContactAdditionalOptionsSection extends StatelessWidget {
  const JobContactAdditionalOptionsSection({super.key, required this.controller});

  final CreateCompanyContactFormController controller;

  Widget get inputFieldSeparator => SizedBox(height: controller.formUiHelper.inputVerticalSeparator);

  CreateCompanyContactFormService get service => controller.service;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: JPAppTheme.themeColors.base,
      borderRadius: BorderRadius.circular(controller.formUiHelper.sectionBorderRadius),
      child: Padding(
        key: const Key(WidgetKeys.jobContactAdditionalOptionsSectionKey),
        padding: EdgeInsets.symmetric(
          horizontal: controller.formUiHelper.horizontalPadding,
          vertical: controller.formUiHelper.verticalPadding,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                JPText(
                  text: 'set_as_primary'.tr.capitalize!,
                  textSize: JPTextSize.heading4,
                  textColor: JPAppTheme.themeColors.text,
                ),
                JPToggle(
                  key: const Key(WidgetKeys.setAsPrimaryKey),
                  value: service.isPrimary,
                  disabled: !service.isFieldEditable(val: false),
                  onToggle: service.toggleIsSetAsPrimary,
                ),
              ],
            ),
            if (service.companyContactModel?.id == null) ...[
              inputFieldSeparator,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  JPText(
                    text: 'save_as_company_contact'.tr.capitalize!,
                    textSize: JPTextSize.heading4,
                    textColor: JPAppTheme.themeColors.text,
                  ),
                  JPToggle(
                    key: const Key(WidgetKeys.saveAsCompanyContactKey),
                    value: service.isSaveAsCompanyContact,
                    disabled: !service.isFieldEditable(),
                    onToggle: service.toggleIsSaveAsCompanyContact,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
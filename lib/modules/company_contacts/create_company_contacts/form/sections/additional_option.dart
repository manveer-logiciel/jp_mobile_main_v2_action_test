import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/company_contact_form_type.dart';
import 'package:jobprogress/common/services/company_contact_listing/create_company_contact.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/global_widgets/expansion_tile/index.dart';
import 'package:jobprogress/modules/company_contacts/create_company_contacts/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class AdditionalOptionsSection extends StatelessWidget {

  const AdditionalOptionsSection({super.key, required this.controller});

  final CreateCompanyContactFormController controller;

  Widget get inputFieldSeparator => SizedBox(height: controller.formUiHelper.inputVerticalSeparator);

  CreateCompanyContactFormService get service => controller.service;

  @override
  Widget build(BuildContext context) {
    return JPExpansionTile(
      key: const Key(WidgetKeys.additionalOptionsSectionKey),
      enableHeaderClick: true,
      initialCollapsed: false,
      borderRadius: controller.formUiHelper.sectionBorderRadius,
      isExpanded: service.isAdditionalDetailsExpanded,
      headerPadding: EdgeInsets.symmetric(
        horizontal: controller.formUiHelper.horizontalPadding,
        vertical: controller.formUiHelper.verticalPadding,
      ),
      header: JPText(
        text: 'additional_options'.tr.toUpperCase(),
        textSize: JPTextSize.heading4,
        fontWeight: JPFontWeight.medium,
        textColor: JPAppTheme.themeColors.secondaryText,
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
      onExpansionChanged: controller.onAdditionalOptionsExpansionChanged,
      children: [ 
        // select assign group
        JPInputBox(
          key: const Key(WidgetKeys.assignGroupsKey),
          inputBoxController: service.assignGroupsController,
          fillColor: JPAppTheme.themeColors.base,
          hintText: "select".tr,
          onPressed: service.selectAssignGroups,
          disabled: !service.isFieldEditable(),
          type: JPInputBoxType.withLabel,
          label: "assign_groups".tr.capitalize,
          readOnly: true,
          suffixChild: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(Icons.person_add_alt,color: JPAppTheme.themeColors.primary,),
          )
        ),
        if (controller.pageType == CompanyContactFormType.createForm)
          ...[
            inputFieldSeparator,
            JPInputBox(
              key: const Key(WidgetKeys.notesKey),
              inputBoxController: service.notesController,
              label: 'notes'.tr.capitalize,
              type: JPInputBoxType.withLabel,
              fillColor: JPAppTheme.themeColors.base,
              disabled: !service.isFieldEditable(),
              maxLines: 4,
            )
          ],
      ],
    );
  }
}

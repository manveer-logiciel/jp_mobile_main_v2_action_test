import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../../../common/enums/form_field_type.dart';
import '../../../../../../common/services/files_listing/forms/eagle_view_form/eagle_view_form.dart';
import '../../../../../../global_widgets/expansion_tile/index.dart';
import '../../controller.dart';

class EagleViewInsuranceSection extends StatelessWidget {
  const EagleViewInsuranceSection({
    super.key,
    required this.controller
  });

  final EagleViewFormController controller;
  EagleViewFormService get service => controller.service;

  @override
  Widget build(BuildContext context) {
    return JPExpansionTile(
      enableHeaderClick: true,
      initialCollapsed: true,
      borderRadius: controller.formUiHelper.sectionBorderRadius,
      isExpanded: service.isInstructionSectionExpanded,
      headerPadding: EdgeInsets.symmetric(
        horizontal: controller.formUiHelper.horizontalPadding,
        vertical: controller.formUiHelper.verticalPadding,
      ),
      header: JPText(
        text: 'insurance_information'.tr.toUpperCase(),
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
      onExpansionChanged: controller.onInsuranceSectionExpansionChanged,
      children: [
        ///  insured
        JPInputBox(
          inputBoxController: service.insuredNameController,
          label: 'insured_name'.tr,
          type: JPInputBoxType.withLabel,
          fillColor: JPAppTheme.themeColors.base,
          disabled: !service.isFieldEditable(FormFieldType.insuredName),
          readOnly: !service.isFieldEditable(FormFieldType.insuredName),
        ),

        ///  reference
        Padding(
          padding: EdgeInsets.only(top: controller.formUiHelper.inputVerticalSeparator),
          child: JPInputBox(
            inputBoxController: service.referenceIdController,
            label: 'reference_id'.tr,
            type: JPInputBoxType.withLabel,
            fillColor: JPAppTheme.themeColors.base,
            disabled: !service.isFieldEditable(FormFieldType.referenceId),
            readOnly: !service.isFieldEditable(FormFieldType.referenceId),
          ),
        ),

        ///  batch
        Padding(
          padding: EdgeInsets.only(top: controller.formUiHelper.inputVerticalSeparator),
          child: JPInputBox(
            inputBoxController: service.batchIdController,
            label: 'batch_id'.tr,
            type: JPInputBoxType.withLabel,
            fillColor: JPAppTheme.themeColors.base,
            disabled: !service.isFieldEditable(FormFieldType.batchId),
            readOnly: !service.isFieldEditable(FormFieldType.batchId),
          ),
        ),

        ///  policy Number
        Padding(
          padding: EdgeInsets.only(top: controller.formUiHelper.inputVerticalSeparator),
          child: JPInputBox(
            inputBoxController: service.policyNoController,
            label: 'policy_number'.tr,
            type: JPInputBoxType.withLabel,
            fillColor: JPAppTheme.themeColors.base,
            disabled: !service.isFieldEditable(FormFieldType.policyNo),
            readOnly: !service.isFieldEditable(FormFieldType.policyNo),
          ),
        ),

      ],
    );
  }
}
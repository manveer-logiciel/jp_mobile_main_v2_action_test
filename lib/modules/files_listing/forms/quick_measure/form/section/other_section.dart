import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/expansion_tile/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../../../../common/enums/form_field_type.dart';
import '../../../../../../common/services/files_listing/forms/quck_measure_form/quick_measure_form.dart';
import '../../../../../../core/utils/form/validators.dart';
import '../../controller.dart';

class QuickMeasureOtherSection extends StatelessWidget {

  const QuickMeasureOtherSection({
    super.key,
    required this.controller,
  });

  final QuickMeasureFormController controller;

  QuickMeasureFormService get service => controller.service;

  @override
  Widget build(BuildContext context) {
    return JPExpansionTile(
      enableHeaderClick: true,
      initialCollapsed: true,
      borderRadius: controller.formUiHelper.sectionBorderRadius,
      isExpanded: service.isOtherInfoSectionExpanded,
      headerPadding: EdgeInsets.symmetric(
        horizontal: controller.formUiHelper.horizontalPadding,
        vertical: controller.formUiHelper.verticalPadding,
      ),
      header: JPText(
        text: 'other_information'.tr.toUpperCase(),
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
      onExpansionChanged: controller.onOtherInfoSectionExpansionChanged,
      children: [
        ///  email
        JPInputBox(
          inputBoxController: service.emailController,
          label: 'email_recipient'.tr,
          type: JPInputBoxType.withLabel,
          textCapitalization: TextCapitalization.none,
          fillColor: JPAppTheme.themeColors.base,
          disabled: !service.isFieldEditable(FormFieldType.emailNotification),
          readOnly: !service.isFieldEditable(FormFieldType.emailNotification),
          validator: (val) => val.trim().isNotEmpty ?? false ? FormValidator.validateEmail(val) : null,
          onChanged: service.onEmailRecipientChange,
        ),


        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: JPText(
            text: "quick_measure_note".tr,
            textAlign: TextAlign.start,
            textSize: JPTextSize.heading5,
            textColor: JPAppTheme.themeColors.darkGray,
            fontStyle: FontStyle.italic,
          ),
        ),

        ///  special instructions
        Padding(
          padding: EdgeInsets.only(top: controller.formUiHelper.inputVerticalSeparator),
          child: JPInputBox(
            inputBoxController: service.specialInfoController,
            label: 'special_instructions'.tr,
            type: JPInputBoxType.withLabel,
            fillColor: JPAppTheme.themeColors.base,
            maxLines: 5,
            disabled: !service.isFieldEditable(FormFieldType.special),
            readOnly: !service.isFieldEditable(FormFieldType.special),
          ),
        ),

      ],
    );
  }
}

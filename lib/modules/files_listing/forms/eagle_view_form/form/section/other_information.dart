import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../../../common/enums/form_field_type.dart';
import '../../../../../../common/services/files_listing/forms/eagle_view_form/eagle_view_form.dart';
import '../../../../../../core/utils/form/validators.dart';
import '../../../../../../global_widgets/expansion_tile/index.dart';
import '../../controller.dart';

class EagleViewOtherSection extends StatelessWidget {
  const EagleViewOtherSection({
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
        Align(
          alignment: Alignment.centerLeft,
          child: JPText(
            text: 'email_recipient'.tr.capitalize!,
            textSize: JPTextSize.heading4,
            fontWeight: JPFontWeight.medium,
            textColor: JPAppTheme.themeColors.text,
            textAlign: TextAlign.start,
          ),
        ),
        ///  send copy
        Padding(
          padding: EdgeInsets.only(top: controller.formUiHelper.inputVerticalSeparator),
          child: JPInputBox(
            inputBoxController: service.sendCopyToController,
            label: 'send_copy_to_the_report'.tr,
            type: JPInputBoxType.withLabel,
            textCapitalization: TextCapitalization.none,
            fillColor: JPAppTheme.themeColors.base,
            validator: (val) => val.trim().isNotEmpty ?? false ? FormValidator.validateEmail(val) : null,
            disabled: !service.isFieldEditable(FormFieldType.sendCopy),
            readOnly: !service.isFieldEditable(FormFieldType.sendCopy),
            onChanged: service.onSendCopyEmailChange,
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: JPText(
            text: "eagle_view_other_info_note".tr,
            textAlign: TextAlign.start,
            textSize: JPTextSize.heading5,
            textColor: JPAppTheme.themeColors.darkGray,
            fontStyle: FontStyle.italic,
          ),
        ),


        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(top: controller.formUiHelper.inputVerticalSeparator),
            child: JPText(
              text: 'special_instructions'.tr.capitalize!,
              textSize: JPTextSize.heading4,
              fontWeight: JPFontWeight.medium,
              textColor: JPAppTheme.themeColors.text,
              textAlign: TextAlign.start,
            ),
          ),
        ),

        ///  comments
        Padding(
          padding: EdgeInsets.only(top: controller.formUiHelper.inputVerticalSeparator),
          child: JPInputBox(
            inputBoxController: service.commentController,
            label: 'comments'.tr,
            maxLines: 5,
            type: JPInputBoxType.withLabel,
            fillColor: JPAppTheme.themeColors.base,
            disabled: !service.isFieldEditable(FormFieldType.comments),
            readOnly: !service.isFieldEditable(FormFieldType.comments),
          ),
        ),

        Align(
          alignment: Alignment.centerLeft,
          child: Transform.translate(
            offset: const Offset(-8, 8),
            child: JPCheckbox(
              selected: service.havePreviousChanges,
              onTap: service.toggleHavePreviousChanges,
              separatorWidth: 2,
              padding: const EdgeInsets.only(left: 4),
              disabled: !service.isFieldEditable(FormFieldType.sendCopy),
              borderColor: JPAppTheme.themeColors.themeGreen,
              text: 'changes_in_last_4_years'.tr,
            ),
          ),
        ),

      ],
    );
  }
}

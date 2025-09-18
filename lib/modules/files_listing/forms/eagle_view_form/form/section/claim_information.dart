import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../../../common/enums/form_field_type.dart';
import '../../../../../../common/services/files_listing/forms/eagle_view_form/eagle_view_form.dart';
import '../../../../../../global_widgets/expansion_tile/index.dart';
import '../../controller.dart';

class EagleViewClaimSection extends StatelessWidget {
  const EagleViewClaimSection({
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
      isExpanded: service.isClaimSectionExpanded,
      headerPadding: EdgeInsets.symmetric(
        horizontal: controller.formUiHelper.horizontalPadding,
        vertical: controller.formUiHelper.verticalPadding,
      ),
      header: JPText(
        text: 'claim_information'.tr.toUpperCase(),
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
      onExpansionChanged: controller.onClaimSectionExpansionChanged,
      children: [
        ///  claim number
        JPInputBox(
          inputBoxController: service.claimNumberController,
          label: 'claim_number'.tr,
          type: JPInputBoxType.withLabel,
          fillColor: JPAppTheme.themeColors.base,
          disabled: !service.isFieldEditable(FormFieldType.claimNumber),
          readOnly: !service.isFieldEditable(FormFieldType.claimNumber),
        ),

        ///  claim Info
        Padding(
          padding: EdgeInsets.only(top: controller.formUiHelper.inputVerticalSeparator),
          child: JPInputBox(
            inputBoxController: service.claimInfoController,
            label: 'claim_info'.tr,
            type: JPInputBoxType.withLabel,
            fillColor: JPAppTheme.themeColors.base,
            disabled: !service.isFieldEditable(FormFieldType.claimInfo),
            readOnly: !service.isFieldEditable(FormFieldType.claimInfo),
          ),
        ),

        ///  PO Number
        Padding(
          padding: EdgeInsets.only(top: controller.formUiHelper.inputVerticalSeparator),
          child: JPInputBox(
            inputBoxController: service.poNumberController,
            label: 'po_number'.tr,
            type: JPInputBoxType.withLabel,
            fillColor: JPAppTheme.themeColors.base,
            disabled: !service.isFieldEditable(FormFieldType.poNumber),
            readOnly: !service.isFieldEditable(FormFieldType.poNumber),
          ),
        ),

        ///  cat id
        Padding(
          padding: EdgeInsets.only(top: controller.formUiHelper.inputVerticalSeparator),
          child: JPInputBox(
            inputBoxController: service.catIdController,
            label: 'cat_id'.tr,
            type: JPInputBoxType.withLabel,
            fillColor: JPAppTheme.themeColors.base,
            disabled: !service.isFieldEditable(FormFieldType.catId),
            readOnly: !service.isFieldEditable(FormFieldType.catId),
          ),
        ),

        ///  date of loss
        Padding(
          padding: EdgeInsets.only(top: controller.formUiHelper.inputVerticalSeparator),
          child: JPInputBox(
            onPressed: () => service.selectDate(),
            inputBoxController: service.dateOfLossController,
            fillColor: JPAppTheme.themeColors.base,
            type: JPInputBoxType.withLabel,
            label: "date_of_loss".tr.capitalize,
            readOnly: true,
            disabled: !service.isFieldEditable(FormFieldType.dateOfLoss),
            suffixChild: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: controller.formUiHelper.horizontalPadding),
              child: JPIcon(
                Icons.date_range_outlined,
                color: JPAppTheme.themeColors.darkGray,
              ),
            ),
          ),
        ),

      ],
    );
  }
}

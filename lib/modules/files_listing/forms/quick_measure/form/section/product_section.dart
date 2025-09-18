import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/expansion_tile/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../../../../common/enums/form_field_type.dart';
import '../../../../../../common/services/files_listing/forms/quck_measure_form/quick_measure_form.dart';
import '../../../../../../core/constants/widget_keys.dart';
import '../../../../../../core/utils/form/validators.dart';
import '../../controller.dart';

class QuickMeasureProductSection extends StatelessWidget {

  const QuickMeasureProductSection({
    super.key,
    required this.controller,
  });

  final QuickMeasureFormController controller;

  Widget get inputFieldSeparator => SizedBox(
    height: controller.formUiHelper.inputVerticalSeparator,
  );

  QuickMeasureFormService get service => controller.service;

  @override
  Widget build(BuildContext context) {
    return JPExpansionTile(
      enableHeaderClick: true,
      initialCollapsed: true,
      borderRadius: controller.formUiHelper.sectionBorderRadius,
      isExpanded: service.isProductSectionExpanded,
      headerPadding: EdgeInsets.symmetric(
        horizontal: controller.formUiHelper.horizontalPadding,
        vertical: controller.formUiHelper.verticalPadding,
      ),
      header: JPText(
        key: const ValueKey(WidgetKeys.productInformationKey),
        text: 'product_information'.tr.toUpperCase(),
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
      onExpansionChanged: controller.onProductSectionExpansionChanged,
      children: [
        ///  products
        JPInputBox(
          key: const ValueKey(WidgetKeys.productsKey),
          readOnly: true,
          label: 'products'.tr,
          type: JPInputBoxType.withLabel,
          isRequired: true,
          onPressed: service.selectProductType,
          fillColor: JPAppTheme.themeColors.base,
          inputBoxController: service.productsController,
          validator: (val) => FormValidator.requiredFieldValidator(val),
          disabled: !service.isFieldEditable(FormFieldType.product),
          suffixChild: Padding(
            padding: const EdgeInsets.all(8.0),
            child: JPIcon(Icons.expand_more, color: JPAppTheme.themeColors.darkGray,),
          ),
        ),

        ///  account ID
        Padding(
          padding: EdgeInsets.only(top: controller.formUiHelper.inputVerticalSeparator),
          child: JPInputBox(
            inputBoxController: service.accountController,
            textCapitalization: TextCapitalization.none,
            label: 'account_id'.tr,
            type: JPInputBoxType.withLabel,
            fillColor: JPAppTheme.themeColors.base,
            disabled: !service.isFieldEditable(FormFieldType.accountId),
            readOnly: !service.isFieldEditable(FormFieldType.accountId),
            onChanged: (val) => controller.onDataChanged(val, formFieldType: FormFieldType.title),
          ),
        ),

      ],
    );
  }
}

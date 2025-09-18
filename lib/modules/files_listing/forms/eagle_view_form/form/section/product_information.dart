import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../../../common/enums/form_field_type.dart';
import '../../../../../../common/services/files_listing/forms/eagle_view_form/eagle_view_form.dart';
import '../../../../../../core/utils/form/validators.dart';
import '../../../../../../global_widgets/chips_input_box/index.dart';
import '../../../../../../global_widgets/expansion_tile/index.dart';
import '../../controller.dart';

class EagleViewProductSection extends StatelessWidget {
  const EagleViewProductSection({
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
          key: const ValueKey(WidgetKeys.roofProductKey),
          readOnly: true,
          label: 'roof_products'.tr,
          type: JPInputBoxType.withLabel,
          isRequired: true,
          onPressed: service.selectProduct,
          fillColor: JPAppTheme.themeColors.base,
          suffixChild: Padding(
            padding: const EdgeInsets.all(8.0),
            child: JPIcon(Icons.expand_more, color: JPAppTheme.themeColors.darkGray,),
          ),
          inputBoxController: service.productsController,
          validator: (val) => FormValidator.requiredFieldValidator(val, errorMsg: "roof_products_error".tr),
          disabled: !service.isFieldEditable(FormFieldType.product),
        ),

        ///  delivery
        Padding(
          padding: EdgeInsets.only(top: controller.formUiHelper.inputVerticalSeparator),
          child: JPInputBox(
            key: const ValueKey(WidgetKeys.deliveryKey),
            inputBoxController: service.deliveryController,
            label: 'delivery'.tr,
            isRequired: true,
            readOnly: true,
            type: JPInputBoxType.withLabel,
            fillColor: JPAppTheme.themeColors.base,
            validator: (val) => FormValidator.requiredFieldValidator(val, errorMsg: "delivery_field_error".tr),
            disabled: !service.isFieldEditable(FormFieldType.delivery),
            onPressed: service.selectDelivery,
            suffixChild: Padding(
              padding: const EdgeInsets.all(8.0),
              child: JPIcon(Icons.expand_more, color: JPAppTheme.themeColors.darkGray,),
            ),
          ),
        ),

        ///   other products
        Visibility(
          visible: service.isFieldEditable(FormFieldType.addOnProducts) && service.addOnProductList.isNotEmpty,
          child: Padding(
            padding: EdgeInsets.only(top: controller.formUiHelper.inputVerticalSeparator),
            child: JPChipsInputBox<EagleViewFormController>(
              inputBoxController: service.addOnProductsController,
              label: 'other_products'.tr,
              controller: controller,
              selectedItems: service.selectedAddOns,
              onTap: service.selectAddOnProducts,
              disabled: !service.isFieldEditable(FormFieldType.addOnProducts),
              disableEditing: !service.isFieldEditable(FormFieldType.addOnProducts),
              onDataChanged: controller.onDataChanged,
              suffixChild: Padding(
                padding: EdgeInsets.symmetric(horizontal: controller.formUiHelper.horizontalPadding),
                child: JPText(
                  text: "select".tr.toUpperCase(),
                  textColor: JPAppTheme.themeColors.primary,
                ),
              ),
            ),
          ),
        ),

        ///  measurement
        Padding(
          padding: EdgeInsets.only(top: controller.formUiHelper.inputVerticalSeparator),
          child: JPInputBox(
            key: const ValueKey(WidgetKeys.measurementInstructionKey),
            inputBoxController: service.measurementController,
            label: 'measurement_instructions'.tr,
            isRequired: true,
            readOnly: true,
            type: JPInputBoxType.withLabel,
            fillColor: JPAppTheme.themeColors.base,
            validator: (val) => FormValidator.requiredFieldValidator(val, errorMsg: "measurement_field_error".tr),
            disabled: !service.isFieldEditable(FormFieldType.measurement),
            onPressed: service.selectMeasurement,
            suffixChild: Padding(
              padding: const EdgeInsets.all(8.0),
              child: JPIcon(Icons.expand_more, color: JPAppTheme.themeColors.darkGray,),
            ),
          ),
        ),

        Align(
          alignment: Alignment.centerLeft,
          child: Transform.translate(
            offset: const Offset(-8, 12),
            child: JPCheckbox(
              selected: service.havePromoCode,
              onTap: service.toggleHavePromoCode,
              separatorWidth: 2,
              padding: const EdgeInsets.only(left: 4),
              disabled: !service.isFieldEditable(FormFieldType.sendCopy),
              borderColor: JPAppTheme.themeColors.themeGreen,
              text: "${'have_promo_code'.tr}?",
            ),
          ),
        ),

        ///  promo code
        Visibility(
          visible: service.havePromoCode,
          child: Padding(
            padding: EdgeInsets.only(top: controller.formUiHelper.inputVerticalSeparator),
            child: JPInputBox(
              inputBoxController: service.promoCodeController,
              label: 'promo_code'.tr,
              type: JPInputBoxType.withLabel,
              fillColor: JPAppTheme.themeColors.base,
              disabled: !service.isFieldEditable(FormFieldType.promoCode),
              readOnly: !service.isFieldEditable(FormFieldType.promoCode),
              validator: (val) => FormValidator.requiredFieldValidator(val),
            ),
          ),
        ),

      ],
    );
  }
}

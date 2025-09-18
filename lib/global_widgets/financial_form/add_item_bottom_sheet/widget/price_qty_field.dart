import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../core/constants/regex_expression.dart';
import '../../../../core/constants/widget_keys.dart';
import '../../../../core/utils/form/validators.dart';
import '../controller.dart';

class AddItemPriceQtyField extends StatelessWidget {
  const AddItemPriceQtyField({
    super.key,
    required this.controller, 
    this.isPriceRequired =  true, 
    this.isQuantityRequired = true
  });

  final AddItemBottomSheetController controller;
  final bool isPriceRequired;
  final bool isQuantityRequired;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: controller.formUiHelper.inputVerticalSeparator),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: JPInputBox(
              key: const ValueKey(WidgetKeys.price),
              inputBoxController: controller.service.priceController,
              label: 'price'.tr,
              type: JPInputBoxType.withLabel,
              fillColor: JPAppTheme.themeColors.base,
              isRequired: isPriceRequired,
              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(RegexExpression.price))],
              validator:(val) => FormValidator.validatePrice(val, isNumberRequired: isPriceRequired),
              onChanged: controller.service.priceQtyChange,
              maxLength: 9,
            ),),
          Container(
            margin: const EdgeInsets.only(top: 20,left: 5,right: 5,),
            child: const JPText(text: 'x', textSize: JPTextSize.heading3),
          ),
          Expanded(
            child: JPInputBox(
              key: const ValueKey(WidgetKeys.quantity),
              inputBoxController: controller.service.qtyController,
              label: 'qty'.tr,
              type: JPInputBoxType.withLabel,
              fillColor: JPAppTheme.themeColors.base,
              isRequired: isQuantityRequired,
              maxLength: 9,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(RegexExpression.amount))],
              validator:(val)=> FormValidator.validateQty(val,isNumberRequired: isQuantityRequired),
              onChanged: controller.service.priceQtyChange,
            ),),
        ],),
    );
  }
}

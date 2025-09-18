import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/files_listing/forms/worksheet_form/add_item.dart';
import 'package:jobprogress/core/constants/regex_expression.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import '../../controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class WorksheetAddItemPriceQtyField extends StatelessWidget {

  const WorksheetAddItemPriceQtyField({
    super.key,
    required this.controller,
  });

  final WorksheetAddItemController controller;

  WorksheetAddItemService get service => controller.service;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: controller.formUiHelper.inputVerticalSeparator),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          /// Price field
          if (!service.conditionsService.hidePrice) ...{
            Expanded(
              child: JPInputBox(
                key: const ValueKey(WidgetKeys.price),
                inputBoxController: service.priceController,
                label: 'price'.tr,
                type: JPInputBoxType.withLabel,
                fillColor: JPAppTheme.themeColors.base,
                keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(RegexExpression.price))],
                disabled: service.conditionsService.disablePrice,
                onChanged: service.priceQtyChange,
                maxLength: 9,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 22,
                left: 5,
                right: 5,
              ),
              child: const JPIcon(Icons.close, size: 16,),
            ),
          },

          /// Quantity field
          Expanded(
              child: JPInputBox(
                key: const ValueKey(WidgetKeys.quantity),
                inputBoxController: service.quantityController,
                label: 'qty'.tr,
                type: JPInputBoxType.withLabel,
                fillColor: JPAppTheme.themeColors.base,
                maxLength: 9,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(RegexExpression.amount))],
                disabled: service.conditionsService.disableQuantity,
                onChanged: service.priceQtyChange,
              ),
            ),
        ],
      ),
    );
  }
}

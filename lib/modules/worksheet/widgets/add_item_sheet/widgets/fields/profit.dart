import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/files_listing/forms/worksheet_form/add_item.dart';
import 'package:jobprogress/core/constants/regex_expression.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import '../../controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class WorksheetAddItemProfitField extends StatelessWidget {

  const WorksheetAddItemProfitField({
    super.key,
    required this.controller,
  });

  final WorksheetAddItemController controller;

  WorksheetAddItemService get service => controller.service;

  TextInputType get keyboardType =>
      const TextInputType.numberWithOptions(decimal: true);

  FilteringTextInputFormatter get inputFormatter =>
      FilteringTextInputFormatter.allow(RegExp(RegexExpression.amount));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: controller.formUiHelper.inputVerticalSeparator),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          /// Profit percent
          Expanded(
            child: JPInputBox(
              inputBoxController: service.profitPercentController,
              label: 'profit_percent'.tr,
              type: JPInputBoxType.withLabel,
              fillColor: JPAppTheme.themeColors.base,
              keyboardType: keyboardType,
              inputFormatters: [inputFormatter],
              prefixChild: const Center(child: JPIcon(Icons.percent, size: 16,)),
              disabled: service.conditionsService.disableProfit,
              onChanged: (val) => service.onPercentChange(val, avoidZero: false),
              maxLength: 9,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 20,
              left: 3,
              right: 3,
            ),
            child: const JPIcon(Icons.swap_horiz_outlined, size: 18,),
          ),
          /// Profit amount
          Expanded(
            child: JPInputBox(
              inputBoxController: service.profitAmountController,
              label: 'profit_amount'.tr,
              type: JPInputBoxType.withLabel,
              fillColor: JPAppTheme.themeColors.base,
              maxLength: 9,
              keyboardType: keyboardType,
              prefixChild: Center(child: JPIcon(JobFinancialHelper.getCurrencyIcon(), size: 16,)),
              inputFormatters: [inputFormatter],
              disabled: service.conditionsService.disableProfit,
              onChanged: (val) => service.onAmountChange(val, avoidZero: false),
            ),
          ),
        ],
      ),
    );
  }
}

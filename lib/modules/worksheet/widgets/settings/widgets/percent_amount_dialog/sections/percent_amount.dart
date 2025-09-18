import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/worksheet.dart';
import 'package:jobprogress/core/constants/regex_expression.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jp_mobile_flutter_ui/ToolTip/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../controller.dart';

class WorksheetPercentAmountProfitSection extends StatelessWidget {
  const WorksheetPercentAmountProfitSection({
    super.key,
    this.subTitle = "",
    required this.type,
    required this.controller,
  });

  final String subTitle;
  final WorksheetPercentAmountDialogType type;
  final WorksheetPercentAmountController controller;

  TextInputType get keyboardType =>
      const TextInputType.numberWithOptions(decimal: true);

  List<FilteringTextInputFormatter> get percentInputFormatter => getPercentInputFormatter();
  List<FilteringTextInputFormatter> get amountInputFormatter => getAmountInputFormatter();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (subTitle.isNotEmpty) ...{
          JPText(
            text: subTitle,
            textAlign: TextAlign.start,
            textColor: JPAppTheme.themeColors.tertiary,
            height: 1.5,
          ),
          const SizedBox(height: 12,)
        },

        if (controller.showMarkupMargin) ...{
          Row(
            children: [

              ///   Markup
              JPRadioBox(
                groupValue: controller.isProfitMarkup,
                onChanged: controller.changeProfitType,
                isTextClickable: true,
                radioData: [
                  JPRadioData(
                    value: true,
                    label: 'markup'.tr,
                  ),
                ],
              ),
              const SizedBox(width: 2,),
              JPToolTip(
                message: 'markup_formula'.tr,
                child: JPIcon(Icons.info_outline,
                  size: 18,
                  color: JPAppTheme.themeColors.primary,
                ),
              ),
              const SizedBox(width: 20),

              ///   Margin
              JPRadioBox(
                groupValue: controller.isProfitMarkup,
                onChanged: controller.changeProfitType,
                isTextClickable: true,
                radioData: [
                  JPRadioData(
                    value: false,
                    label: 'margin'.tr,
                  )
                ],
              ),
              const SizedBox(width: 2,),
              JPToolTip(
                message: 'margin_formula'.tr,
                child: JPIcon(Icons.info_outline,
                  size: 18,
                  color: JPAppTheme.themeColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16,),
        },

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: JPInputBox(
                inputBoxController: controller.percentController,
                label: controller.percentFieldLabel,
                type: JPInputBoxType.withLabel,
                fillColor: JPAppTheme.themeColors.base,
                keyboardType: keyboardType,
                inputFormatters: percentInputFormatter,
                prefixChild: const Center(child: JPIcon(Icons.percent, size: 16,)),
                onChanged: controller.onPercentChange,
                validator: percentValidator
              ),
            ),

            if (controller.showAmountField) ...{
              Container(
                margin: const EdgeInsets.only(
                  top: 20,
                  left: 3,
                  right: 3,
                ),
                child: const JPIcon(Icons.swap_horiz_outlined, size: 18,),
              ),
              Expanded(
                child: JPInputBox(
                  inputBoxController: controller.amountController,
                  label: controller.amountFieldLabel,
                  type: JPInputBoxType.withLabel,
                  fillColor: JPAppTheme.themeColors.base,
                  maxLength: 9,
                  keyboardType: keyboardType,
                  prefixChild: Center(child: JPIcon(JobFinancialHelper.getCurrencyIcon(), size: 16,)),
                  inputFormatters: amountInputFormatter,
                  onChanged: controller.onAmountChange,
                  validator: amountValidator,
                ),
              ),
            }
          ],
        ),

        const SizedBox(height: 12,),

      ],
    );
  }

  /// [getPercentInputFormatter] gives the input formatter as per the [WorksheetPercentAmountDialogType]
  List<FilteringTextInputFormatter> getPercentInputFormatter() {
    switch (type) {
      case WorksheetPercentAmountDialogType.cardFee:
      case WorksheetPercentAmountDialogType.discount:
      case WorksheetPercentAmountDialogType.overhead:
      case WorksheetPercentAmountDialogType.overAllProfit:
      case WorksheetPercentAmountDialogType.commission:
      return [
        FilteringTextInputFormatter.allow(RegExp(RegexExpression.amountTwentyDecimals)),
      ];

      default:
        return [
          FilteringTextInputFormatter.allow(RegExp(RegexExpression.amount)),
        ];
    }
  }

  /// [getAmountInputFormatter] gives the input formatter as per the [WorksheetPercentAmountDialogType]
  List<FilteringTextInputFormatter> getAmountInputFormatter() {
    return [
      FilteringTextInputFormatter.allow(RegExp(RegexExpression.amount)),
    ];
  }

  /// [percentValidator] gives the validation as per the [WorksheetPercentAmountDialogType]
  String? percentValidator(dynamic val) {
    switch (type) {
      case WorksheetPercentAmountDialogType.discount:
        return FormValidator.validatePrice(val,
            shouldNotZero: false,
            requiredErrorMsg: 'percent_is_required'.tr,
            invalidErrorMsg: 'invalid_percentage'.tr,
            isNumberRequired: true,
            maxValue: 100,
            invalidRangeErrorMsg: 'discount_percentage_cannot_be_greater_than_100'.tr
        );

      case WorksheetPercentAmountDialogType.commission:
      case WorksheetPercentAmountDialogType.overhead:
      case WorksheetPercentAmountDialogType.cardFee:
      case WorksheetPercentAmountDialogType.overAllProfit:
      case WorksheetPercentAmountDialogType.lineItemProfit:
        return FormValidator.validatePrice(val,
            shouldNotZero: false,
            requiredErrorMsg: 'percent_is_required'.tr,
            invalidErrorMsg: 'invalid_percentage'.tr,
            isNumberRequired: true,
        );

      default:
        return FormValidator.validatePrice(val,
            shouldNotZero: true,
            requiredErrorMsg: 'percent_is_required'.tr,
            invalidErrorMsg: 'invalid_percentage'.tr,
            isNumberRequired: true
        );
    }
  }

  /// [amountValidator] gives the validation as per the [WorksheetPercentAmountDialogType]
  String? amountValidator(dynamic val) {
    switch (type) {
      case WorksheetPercentAmountDialogType.commission:
      case WorksheetPercentAmountDialogType.overhead:
      case WorksheetPercentAmountDialogType.cardFee:
      case WorksheetPercentAmountDialogType.discount:
      case WorksheetPercentAmountDialogType.overAllProfit:
        return FormValidator.validatePrice(val,
          shouldNotZero: false,
          requiredErrorMsg: 'amount_is_required'.tr,
          invalidErrorMsg: 'invalid_amount'.tr,
          isNumberRequired: true,
        );
      default:
        return FormValidator.validatePrice(val,
          shouldNotZero: true,
          requiredErrorMsg: 'percent_is_required'.tr,
          invalidErrorMsg: 'invalid_percentage'.tr,
          isNumberRequired: true,
        );
    }
  }
}

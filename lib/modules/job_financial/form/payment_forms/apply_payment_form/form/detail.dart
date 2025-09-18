import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/payment/payment_form.dart';
import 'package:jobprogress/core/constants/regex_expression.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/modules/job_financial/form/payment_forms/apply_payment_form/controller.dart';
import 'package:jobprogress/modules/job_financial/form/payment_forms/apply_payment_form/form/shimmer.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ApplyPaymentDetailsection extends StatelessWidget {
  const ApplyPaymentDetailsection({
    super.key, required this.controller,
  });

  final ApplyPaymentFormController controller;

  PaymentFormService get service => controller.service;
   
  Widget get inputFieldSeparator => SizedBox(
    height: controller.formUiHelper.inputVerticalSeparator,
  );

  @override
  Widget build(BuildContext context) {
    return Material(
      color: JPAppTheme.themeColors.base,
      borderRadius:
        BorderRadius.circular(controller.formUiHelper.sectionBorderRadius), 
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: controller.formUiHelper.horizontalPadding,
          vertical: controller.formUiHelper.verticalPadding,
        ),
        child: 
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: JPText(
                    text: 'apply_payment_to_invoice'.tr.toUpperCase(),
                    fontWeight: JPFontWeight.medium,
                    textColor: JPAppTheme.themeColors.darkGray,
                    textAlign: TextAlign.left,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    JPText(
                      text: 'unapplied'.tr.toUpperCase(),
                      fontWeight: JPFontWeight.medium,
                    ),
                    const SizedBox(height: 5),
                    JPText(
                      text:service.calculatedUnappliedAmount != 0 ? 
                        JobFinancialHelper.getCurrencyFormattedValue(value: service.calculatedUnappliedAmount):
                        JobFinancialHelper.getCurrencyFormattedValue(value: service.unApplidAmount),
                      textColor: service.calculatedUnappliedAmount.isNegative? 
                        JPAppTheme.themeColors.secondary:
                        JPAppTheme.themeColors.themeBlue
                    )
                  ],
                ),
              ],
            ),
            inputFieldSeparator,
            if(controller.isLoading)...{
              const ApplyPaymentFormShimmer()
            } else... {
              for(int i= 0; i < service.apiInvoiceList!.length; i++)...{
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  Expanded(
                    child: JPInputBox(
                      inputBoxController: service.invoiceFieldControllerList[i],
                      fillColor: JPColor.white,
                      type: JPInputBoxType.withLabel,
                      label: service.apiInvoiceList![i].name,
                      disabled: controller.isSavingForm,
                      hintText: "0.00",
                      maxLength: 9,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(RegexExpression.amount)),],
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      onChanged:(val) => controller.onDataChanged(val),
                      onPressed: null,
                      validator:(val)=> service.validateApplyPaymentFormAmounts(val, i),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Flexible(
                    child: Wrap(
                      children: [
                        JPText(
                          text: '${'balance'.tr.capitalize!}: ',
                          textColor: JPAppTheme.themeColors.tertiary,
                          fontWeight: JPFontWeight.medium,
                        ),
                        const SizedBox(width: 5,),
                        JPText(
                          text: JobFinancialHelper.getCurrencyFormattedValue(
                            value: service.apiInvoiceList![i].openBalance
                          ),
                          textAlign: TextAlign.left,
                        )
                      ],
                    ),
                  )
                ],
              ),
              inputFieldSeparator
              }
            }
          ],
        ),
      ),
    );
  }
}

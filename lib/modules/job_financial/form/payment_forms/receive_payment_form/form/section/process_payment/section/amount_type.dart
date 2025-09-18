import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/payment/payment_form.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/modules/job_financial/form/payment_forms/receive_payment_form/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class PaymentMethodAmountSection extends StatelessWidget {

  const PaymentMethodAmountSection({
    super.key,
    required this.controller
  });

  final ReceivePaymentFormController controller;

  PaymentFormService get service => controller.service;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Label
          Padding(
            padding: const EdgeInsets.only(
                bottom: 16
            ),
            child: JPText(
              text: 'choose_a_payment_amount'.tr,
              textSize: JPTextSize.heading5,
            ),
          ),
          Wrap(
            spacing: 5,
            runAlignment: WrapAlignment.center,
            runSpacing: 5,
            children: [
              /// Invoice Balance Selector
              JPRadioBox(
                groupValue: service.isInvoiceAmount,
                onChanged: service.changePaymentAmount,
                isTextClickable: true,
                radioData: [
                  JPRadioData(
                      value: true,
                      label: 'invoice_balance'.tr,
                      disabled: controller.isSavingForm
                  ),
                ],
              ),
              JPText(
                text: JobFinancialHelper.getCurrencyFormattedValue(
                  value: service.invoicesAmount,
                ),
                height: 1.4,
                fontWeight: JPFontWeight.medium,
                textSize: JPTextSize.heading3,
                textColor: JPAppTheme.themeColors.themeBlue,
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          /// Custom Amount Selector
          JPRadioBox(
            groupValue: service.isInvoiceAmount,
            onChanged: service.changePaymentAmount,
            isTextClickable: true,
            radioData: [
              JPRadioData(
                  value: false,
                  label: 'custom_amount'.tr,
                  disabled: controller.isSavingForm
              )
            ],
          )
        ],
      ),
    );
  }
}

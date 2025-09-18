import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/payment/payment_form.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/modules/job_financial/form/payment_forms/receive_payment_form/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class TotalAmount extends StatelessWidget {
  const TotalAmount({
    super.key,
    required this.controller,
  });

  final ReceivePaymentFormController controller;

  PaymentFormService get service => controller.service;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReceivePaymentFormController>(
        init: controller,
        builder: (context) {
          return Visibility(
            visible: service.pendingInvoiceAmount != 0,
            child: Row(
              children: [
                JPText(
                  text: '${'total'.tr.capitalize!}: ',
                  fontWeight: JPFontWeight.medium,
                ),
                JPText(
                  text: JobFinancialHelper.getCurrencyFormattedValue(
                      value: service.pendingInvoiceAmount),
                  fontWeight: JPFontWeight.medium,
                  textColor: service.pendingInvoiceAmount.isNegative ?
                  JPAppTheme.themeColors.secondary : 
                  JPAppTheme.themeColors.success
                )
              ],
            ),
          );
        });
  }
}

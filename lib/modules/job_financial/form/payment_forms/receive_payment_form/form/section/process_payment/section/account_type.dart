import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/payment/payment_form.dart';
import 'package:jobprogress/modules/job_financial/form/payment_forms/receive_payment_form/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class PaymentAccountTypeSection extends StatelessWidget {

  const PaymentAccountTypeSection({
    super.key,
    required this.controller
  });

  final ReceivePaymentFormController controller;

  PaymentFormService get service => controller.service;

  Widget get inputFieldSeparator => SizedBox(
    height: controller.formUiHelper.verticalPadding,
    width: controller.formUiHelper.horizontalPadding,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16,
        left: 8,
        right: 8
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///   Label
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 16
            ),
            child: JPText(
              text: 'choose_an_account_type'.tr,
              textSize: JPTextSize.heading5,
            ),
          ),
          Row(
            children: [
              ///   Checking Selector
              JPRadioBox(
                groupValue: service.isSavingAccount,
                onChanged: service.changeAccountType,
                isTextClickable: true,
                radioData: [
                  JPRadioData(
                      value: false,
                      label: 'Checking'.tr,
                      disabled: controller.isSavingForm
                  ),
                ],
              ),
              inputFieldSeparator,
              ///   Savings Account Selector
              JPRadioBox(
                groupValue: service.isSavingAccount,
                onChanged: service.changeAccountType,
                isTextClickable: true,
                radioData: [
                  JPRadioData(
                      value: true,
                      label: 'savings'.tr,
                      disabled: controller.isSavingForm
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

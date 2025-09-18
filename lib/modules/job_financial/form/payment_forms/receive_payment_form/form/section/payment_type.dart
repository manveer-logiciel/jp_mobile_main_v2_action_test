import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/payment/payment_form.dart';
import 'package:jobprogress/modules/job_financial/form/payment_forms/receive_payment_form/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class PaymentFormTypeSection extends StatelessWidget {

  const PaymentFormTypeSection({
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
      padding: EdgeInsets.only(
          bottom: controller.formUiHelper.verticalPadding,
          left: controller.formUiHelper.verticalPadding
      ),
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              runSpacing: 10,
              children: [
                /// Process Payment
                JPRadioBox(
                  groupValue: service.isRecordPaymentForm,
                  onChanged: service.changePaymentType,
                  isTextClickable: true,
                  radioData: [
                    JPRadioData(
                        value: false,
                        label: 'process_payment'.tr,
                        disabled: controller.isSavingForm
                    ),
                  ],
                ),
                inputFieldSeparator,
                ///   Record Payment
                JPRadioBox(
                  groupValue: service.isRecordPaymentForm,
                  onChanged: service.changePaymentType,
                  isTextClickable: true,
                  radioData: [
                    JPRadioData(
                        value: true,
                        label: 'record_payment'.tr,
                        disabled: controller.isSavingForm
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

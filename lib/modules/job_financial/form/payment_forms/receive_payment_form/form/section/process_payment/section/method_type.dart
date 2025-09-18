import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/payment/payment_form.dart';
import 'package:jobprogress/core/constants/leap_pay_payment_method.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/modules/job_financial/form/payment_forms/receive_payment_form/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class PaymentMethodTypeSection extends StatelessWidget {

  const PaymentMethodTypeSection({
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
          right: 8,
          left: 8,
          bottom: service.isCardForm ? 12 : 0,
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
              text: 'choose_a_payment_method'.tr,
              textSize: JPTextSize.heading5,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  JPRadioBox(
                    groupValue: service.isCardForm,
                    onChanged: service.changePaymentMethod,
                    isTextClickable: true,
                    radioData: [
                      JPRadioData(
                          value: true,
                          label: 'debit_credit_card'.tr,
                          disabled: controller.isSavingForm || !(service.defaultPaymentMethod == LeapPayPaymentMethod.both)
                      ),
                    ],
                  ),
                  if(service.feePassover) ...{
                    Container(
                      margin: const EdgeInsets.only(left: 32),
                      child: JPText(
                        textAlign: TextAlign.left,
                        text: Helper.getPayMethodSubtitle(LeapPayPaymentMethod.card),
                        textColor: JPColor.darkGray,
                        textSize: JPTextSize.heading5,
                      ),
                    ),
                  }
                ],
              ),
              if(service.feePassover) ...{
                Expanded(
                  child: JPRichText(
                    textAlign: TextAlign.end,
                    text: JPTextSpan.getSpan(
                      'Fee Total: ',
                      textSize: JPTextSize.heading5,
                      children: [
                        WidgetSpan(
                          child: JPText(
                            text: JobFinancialHelper.getCurrencyFormattedValue(
                              value: service.calculateFees(LeapPayPaymentMethod.card)
                            ),
                            textSize: JPTextSize.heading4,
                            fontWeight: JPFontWeight.bold,
                            textAlign: TextAlign.left,
                          ),
                        )
                      ]
                    ),
                  )
                ),
              }
              
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  JPRadioBox(
                    groupValue: service.isCardForm,
                    onChanged: service.changePaymentMethod,
                    isTextClickable: true,
                    radioData: [
                      JPRadioData(
                          value: false,
                          label: 'bank_account'.tr,
                          disabled: controller.isSavingForm || !(service.defaultPaymentMethod == LeapPayPaymentMethod.both)
                      )
                    ],
                  ),
                  if(service.feePassover) ...{
                    Container(
                      margin: const EdgeInsets.only(left: 32),
                      child: JPText(
                        textAlign: TextAlign.left,
                        text: Helper.getPayMethodSubtitle(LeapPayPaymentMethod.achOnly),
                        textColor: JPColor.darkGray,
                        textSize: JPTextSize.heading5,
                      ),
                    ),
                  }
                ],
              ),
              if(service.feePassover) ...{
                Expanded(
                  child: JPRichText(
                    textAlign: TextAlign.end,
                    text: JPTextSpan.getSpan(
                      'Fee Total: ',
                      textSize: JPTextSize.heading5,
                      children: [
                        WidgetSpan(
                          child: JPText(
                            text: JobFinancialHelper.getCurrencyFormattedValue(
                              value: service.calculateFees(LeapPayPaymentMethod.achOnly)
                            ),
                            textSize: JPTextSize.heading4,
                            fontWeight: JPFontWeight.bold,
                            textAlign: TextAlign.left,
                          ),
                        )
                      ]
                    ),
                  )
                ),
              }
            ],
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

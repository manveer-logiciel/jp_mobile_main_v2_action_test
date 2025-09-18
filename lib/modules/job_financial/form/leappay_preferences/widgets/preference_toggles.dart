import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/core/constants/leap_pay_payment_method.dart';
import 'package:jobprogress/global_widgets/from_launch_darkly/index.dart';
import 'package:jobprogress/modules/job_financial/form/leappay_preferences/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'labelled_toggle.dart';

class LeapPayPreferences extends StatelessWidget {
  const LeapPayPreferences({
    this.amount = 0,
    this.controller,
    super.key,
  });

  final LeapPayPreferencesController? controller;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LeapPayPreferencesController>(
      global: false,
      init: controller ?? LeapPayPreferencesController(),
      builder: (controller) {
        return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                JPText(
                  text: 'leap_pay'.tr,
                  textSize: JPTextSize.heading4,
                  fontWeight: JPFontWeight.medium,
                ),
                const SizedBox(
                  height: 5,
                ),
                JPText(
                  text: 'enable_payments_through_leap_pay'.tr,
                  textSize: JPTextSize.heading4,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(
                  height: 15,
                ),
                LeapPayPreferencesLabeledToggle(
                  title: 'accept_leap_pay'.tr,
                  value: controller.acceptingLeapPay,
                  onToggle: controller.toggleLeapPayMethod,
                ),

                const SizedBox(
                  height: 5,
                ),

                JPText(
                  text: 'payment_methods'.tr,
                  textSize: JPTextSize.heading4,
                  fontWeight: JPFontWeight.medium,
                ),
                const SizedBox(
                  height: 5,
                ),
                JPText(
                  textAlign: TextAlign.left,
                  text: 'choose_payment_method_for_invoice'.tr,
                  textSize: JPTextSize.heading4,
                  //fontWeight: JPFontWeight.medium,
                ),
                const SizedBox(
                  height: 15,
                ),
                LeapPayPreferencesLabeledToggle(
                  title: 'debit_credit_card'.tr,
                  subTitle: controller.getPayMethodSubtitle(LeapPayPaymentMethod.card),
                  value: controller.isCardEnabled,
                  isDisabled: !controller.acceptingLeapPay,
                  fee: controller.calculateFee(LeapPayPaymentMethod.card, amount),
                  onToggle: controller.toggleCard,
                ),
                LeapPayPreferencesLabeledToggle(
                  title: 'bank_account'.tr,
                  subTitle: controller.getPayMethodSubtitle(LeapPayPaymentMethod.achOnly),
                  value: controller.isAchEnabled,
                  isDisabled: !controller.acceptingLeapPay,
                  fee: controller.calculateFee(LeapPayPaymentMethod.achOnly, amount),
                  onToggle: controller.toggleACH,
                ),
                FromLaunchDarkly(
                  flagKey: LDFlagKeyConstants.leapPayFeePassOver,
                  showHideOnly: true,
                  child: (_) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      JPText(
                        text: 'pass_processing_fees'.tr,
                        textSize: JPTextSize.heading4,
                        textAlign: TextAlign.left,
                        fontWeight: JPFontWeight.medium,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      JPText(
                        textAlign: TextAlign.left,
                        text: 'fee_passover_desc'.tr,
                        textSize: JPTextSize.heading4,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      if(!controller.isFeePassoverEnabled && AuthService.isStandardUser())
                      Column(
                        children: [
                          JPText(
                            textAlign: TextAlign.left,
                            text: 'reach_out_to_your_admin_to_enable_fee_passover'.tr,
                            textSize: JPTextSize.heading4,
                            fontWeight: JPFontWeight.medium,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                      
                      LeapPayPreferencesLabeledToggle(
                        title: 'pass_fees_to_customer'.tr,
                        value: controller.isFeePassoverEnabled,
                        isDisabled: AuthService.isStandardUser(),
                        onToggle: controller.toggleLeapPayFeePassOver,
                      ),
                    ],
                  ),
                )
              ],
            )
        );
      },
    );
  }
}

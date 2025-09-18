import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/payment/payment_form.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/core/constants/leap_pay_payment_method.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jobprogress/global_widgets/from_launch_darkly/index.dart';
import 'package:jobprogress/modules/job_financial/form/payment_forms/receive_payment_form/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'section/account_type.dart';
import 'section/amount_type.dart';
import 'section/justifi.dart';
import 'section/method_type.dart';

class PaymentFormProcessPaymentSection extends StatelessWidget {
  const PaymentFormProcessPaymentSection({
    required this.controller,
    super.key,
  });

  final ReceivePaymentFormController controller;

  Widget get inputFieldSeparator => SizedBox(
    height: controller.formUiHelper.inputVerticalSeparator,
  );

  PaymentFormService get service => controller.service;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: controller.isSavingForm,
      child: Opacity(
        opacity: controller.isSavingForm ? 0.8 : 1,
        child: Material(
          color: JPAppTheme.themeColors.base,
          borderRadius: BorderRadius.circular(controller.formUiHelper.sectionBorderRadius),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: controller.formUiHelper.verticalPadding,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///   Invoice Amount & Custom Amount Switcher
                if (service.showPaymentAmountSection) ...{
                  PaymentMethodAmountSection(
                    controller: controller,
                  ),
                  if (service.leapPayPreferencesController.isCardEnabled)
                    const SizedBox(
                      height: 16,
                    ),
                },
                ///   Payment Amount
                if (service.showPaymentAmountField) ...{
                  if (service.filterInvoiceList.isNotEmpty)
                    inputFieldSeparator,
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8
                    ),
                    child: JPInputBox(
                      inputBoxController: service.paymentAmountController,
                      fillColor: JPColor.white,
                      type: JPInputBoxType.withLabelOutside,
                      isRequired: true,
                      label: 'payment_amount'.tr,
                      hintText: "enter_amount".tr,
                      maxLength: 9,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                      ],
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (val) => controller.onDataChanged(val, isAmountChanged: true),
                      onPressed: null,
                      validator: (val) => service.validateAmount(val),
                    ),
                  ),
                },
                if(service.filterInvoiceList.isEmpty && service.isGlobalFeePassoverSettingEnabled) ...{
                  FromLaunchDarkly(
                    flagKey: LDFlagKeyConstants.leappayPaymentFeePassoverToggle,
                    child: (_) => Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              JPToggle(
                                value: service.feePassover,
                                onToggle: (value) => service.toggleFeePassover(),
                              ),
                              const SizedBox(width: 10),
                              JPText(
                                text: 'pass_over_processing_fee'.tr,
                                textSize: JPTextSize.heading4,
                                textColor: JPAppTheme.themeColors.text,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                },
                ///   Justifi Form Selector
                AbsorbPointer(
                  absorbing: !(service.defaultPaymentMethod == LeapPayPaymentMethod.both),
                  child: PaymentMethodTypeSection(
                    controller: controller,
                  ),
                ),

                ///   Checking & Savings Selector
                if (!service.isCardForm)
                  PaymentAccountTypeSection(
                    controller: controller,
                  ),

                ///   Name On Card
                Visibility(
                  visible: service.isCardForm,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 0,left: 8,right: 8,bottom: 5),         
                    child: JPInputBox(
                      inputBoxController: service.nameController,
                      fillColor: JPColor.white,
                      type: JPInputBoxType.withLabelOutside,
                      hintText: 'enter_name'.tr,
                      isRequired: true,
                      label: 'name_on_card'.tr.capitalize!,
                      onChanged: (val) => controller.onDataChanged(val),
                      onPressed: null,
                      validator: (val) => FormValidator.requiredFieldValidator(val),
                    ),
                  ),
                ),

                  
                if(service.isCardForm && service.defaultPaymentMethod != LeapPayPaymentMethod.both)
                  const SizedBox(
                    height: 10,
                  ),
                ///   Justifi Form
                ProcessPaymentJustifiSection(
                  controller: controller,
                ),

                ///   Account Owner
                Visibility(
                  visible: !service.isCardForm,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8
                    ),
                    child: JPInputBox(
                      inputBoxController: service.accountOwnerController,
                      fillColor: JPColor.white,
                      type: JPInputBoxType.withLabelOutside,
                      isRequired: true,
                      hintText: 'enter_name'.tr,
                      label: 'account_owner'.tr.capitalize!,
                      onChanged: (val) => controller.onDataChanged(val),
                      onPressed: null,
                      validator: (val) => FormValidator.requiredFieldValidator(val),
                    ),
                  ),
                ),

                ///   Zip Code
                Visibility(
                  visible: service.isCardForm,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8
                    ),
                    child: JPInputBox(
                      inputBoxController: service.zipController,
                      fillColor: JPColor.white,
                      type: JPInputBoxType.withLabelOutside,
                      isRequired: true,
                      label: 'zip_code'.tr.capitalize!,
                      hintText: 'enter_zip_code'.tr,
                      onChanged: (val) => controller.onDataChanged(val),
                      onPressed: null,
                      validator: (val) => FormValidator.requiredFieldValidator(val),
                    ),
                  ),
                ),
                inputFieldSeparator,
                ///   Email Receipt To
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: JPInputBox(
                    inputBoxController: service.emailReceiptController,
                    fillColor: JPColor.white,
                    type: JPInputBoxType.withLabelOutside,
                    isRequired: true,
                    hintText: 'enter_email_receipt'.tr,
                    label: 'email_receipt_to'.tr.capitalize!,
                    onChanged: (val) => controller.onDataChanged(val),
                    onPressed: null,
                    validator: (val) => FormValidator.validateEmail(val, isRequired: true),
                    suffixChild: service.emailReceiptList.isNotEmpty ? InkWell(
                      onTap: service.selectEmailReceipt,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: controller.formUiHelper.suffixPadding),
                        child: JPIcon(
                          Icons.expand_more,
                          color: JPAppTheme.themeColors.secondaryText,
                        ),
                      ),
                    ) : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

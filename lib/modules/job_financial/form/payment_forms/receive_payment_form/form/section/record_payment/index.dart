import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/payment/payment_form.dart';
import 'package:jobprogress/core/constants/payment_method.dart';
import 'package:jobprogress/modules/job_financial/form/payment_forms/receive_payment_form/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class RecordPaymentDetailsection extends StatelessWidget {
  const RecordPaymentDetailsection({
    super.key,
    required this.controller,
  });

  final ReceivePaymentFormController controller;

  Widget get inputFieldSeparator => SizedBox(
        height: controller.formUiHelper.inputVerticalSeparator,
      );

  PaymentFormService get service => controller.service;

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            JPInputBox(
              inputBoxController: service.paymentAmountController,
              disabled: controller.isSavingForm,
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
              onChanged: (val) =>
                  controller.onDataChanged(val, isAmountChanged: true),
              onPressed: null,
              validator: (val) => service.validateAmount(val),
            ),
            inputFieldSeparator,
            JPInputBox(
              inputBoxController: service.paymentMethodController,
              label: '${'payment'.tr.capitalize!} ${'method'.tr.capitalize!}',
              type: JPInputBoxType.withLabelOutside,
              fillColor: JPAppTheme.themeColors.base,
              disabled: controller.isSavingForm,
              readOnly: true,
              onPressed: service.openPaymentMethodList,
              suffixChild: const Padding(
                padding: EdgeInsets.only(right: 9),
                child: JPIcon(Icons.keyboard_arrow_down),
              ),
            ),
            inputFieldSeparator,
            JPInputBox(
              inputBoxController: service.dateController,
              label: 'date'.tr,
              disabled: controller.isSavingForm,
              type: JPInputBoxType.withLabelOutside,
              fillColor: JPAppTheme.themeColors.base,
              readOnly: true,
              isRequired: true,
              onPressed: service.selectDueOnDate,
              onChanged: (data) {},
              suffixChild: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: JPIcon(
                  Icons.date_range,
                  color: JPAppTheme.themeColors.dimGray,
                ),
              ),
            ),
            inputFieldSeparator,
            JPInputBox(
              inputBoxController: service.checkRefernceNumberController,
              label: service.selectedPaymentMethodId != PaymentMethodId.check
                  ? 'reference_number_optional'.tr : 'reference_number'.tr,
              disabled: controller.isSavingForm,
              isRequired: service.selectedPaymentMethodId == PaymentMethodId.check,
              onChanged: controller.onDataChanged,
              type: JPInputBoxType.withLabelOutside,
              fillColor: JPAppTheme.themeColors.base,
              hintText: 'enter_reference_number'.tr,
              maxLength: 20,
              validator: (val) => service.validateCheckReferenceNumber(val),
            ),
          ],
        ),
      ),
    );
  }
}

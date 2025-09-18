import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../controller.dart';

class RefundDetailsBox extends StatelessWidget {
  final RefundFormController controller;
  const RefundDetailsBox({super.key,required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 16),
        width: double.infinity,
        decoration: BoxDecoration(color: JPAppTheme.themeColors.base, borderRadius: BorderRadius.circular(18)),
        child: Form(
          key: controller.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             JPText( text: 'refund_details'.tr.toUpperCase(),
               fontWeight: JPFontWeight.medium,
               textSize: JPTextSize.heading4,
             ),

              const SizedBox(height: 19,),

              JPInputBox(
                inputBoxController: controller.service.paymentMethodController,
                type: JPInputBoxType.withLabel,
                label: 'payment_method'.tr,
                fillColor: JPAppTheme.themeColors.base,
                readOnly: true,
                suffixChild: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10),
                  child: JPIcon(
                    Icons.keyboard_arrow_down_outlined,
                    color: JPAppTheme.themeColors.text,
                  ),
                ),
                onPressed: controller.service.openPaymentMethod,
                disabled: controller.isSavingForm,
              ),
              const SizedBox(height: 19,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: JPInputBox(
                      inputBoxController: controller.service.refundFromController,
                      hintText: 'accounting_head'.tr,
                      type: JPInputBoxType.withLabel,
                      label: 'refund_from'.tr,
                      fillColor: JPAppTheme.themeColors.base,
                      readOnly: true,
                      isRequired: true,
                      onPressed: controller.service.openRefundFrom,
                      validator: controller.validateRefundFrom,
                      disabled: controller.isSavingForm,
                    ),
                  ),
                  const SizedBox(width: 19,),
                  Expanded(
                    flex: 1,
                    child: JPInputBox(
                      inputBoxController: controller.service.receiptDateController,
                      type: JPInputBoxType.withLabel,
                      label: 'receipt_date'.tr,
                      fillColor: JPAppTheme.themeColors.base,
                      readOnly: true,
                      isRequired: true,
                      suffixChild: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10),
                        child: JPIcon(
                          Icons.date_range_rounded,
                          color: JPAppTheme.themeColors.secondaryText.withValues(alpha: 0.6),
                        ),
                      ),
                      onPressed: controller.service.onClickDateField,
                      disabled: controller.isSavingForm,
                    ),
                  ),
                ],),
              const SizedBox(height: 19,),
              JPInputBox(
                inputBoxController: controller.service.addressController,
                type: JPInputBoxType.withLabel,
                label: 'address'.tr,
                fillColor: JPAppTheme.themeColors.base,
                maxLines: 4,
                disabled: controller.isSavingForm,
              )
          ],),
        )
    );
  }
}

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/payment/payment_form.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/modules/job_financial/form/payment_forms/receive_payment_form/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class LinkedInvoiceDetail extends StatelessWidget {
  const LinkedInvoiceDetail({
    super.key,
    required this.controller,
  });

  final ReceivePaymentFormController controller;

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
        padding: EdgeInsets.only(
          left: controller.formUiHelper.horizontalPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  JPText(
                    text: 'link_invoice'.tr.toUpperCase(),
                    fontWeight: JPFontWeight.medium,
                    textColor: JPAppTheme.themeColors.darkGray,
                  ),
                  const SizedBox(width: 5,),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: controller.formUiHelper.horizontalPadding
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (service.filterInvoiceList.isNotEmpty) ...{
                            Flexible(
                              child: JPText(
                                text: JobFinancialHelper.getCurrencyFormattedValue(
                                  value: service.pendingInvoiceAmount),
                                fontWeight: JPFontWeight.medium,
                                textColor: service.pendingInvoiceAmount.isNegative
                                  ? JPAppTheme.themeColors.red
                                  : JPAppTheme.themeColors.success,
                                textAlign: TextAlign.left,
                              ),
                            ),
                            const SizedBox(width: 10),
                          },
                          if (!service.hasInvoiceSelected)
                            JPButton(
                            disabled: controller.isSavingForm,
                            onPressed: service.openInvoiceList,
                            colorType: JPButtonColorType.lightBlue,
                            size: JPButtonSize.smallIcon,
                            iconWidget: JPIcon(
                              Icons.add,
                              size: 18,
                              color: JPAppTheme.themeColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (service.filterInvoiceList.isEmpty) ...{
              const SizedBox(height: 15),
              Padding(
                  padding: EdgeInsets.only(
                      bottom: controller.formUiHelper.verticalPadding),
                  child: JPRichText(
                    text: JPTextSpan.getSpan('${'tap_here'.tr} ',
                        recognizer: TapGestureRecognizer()
                          ..onTap = service.openInvoiceList,
                        textColor: JPAppTheme.themeColors.primary,
                        children: [
                          JPTextSpan.getSpan('to_link_invoice'.tr,
                              textColor: JPAppTheme.themeColors.darkGray)
                        ]),
                  ))
            } else ...{
              const SizedBox(height: 5),
              for (int i = 0; i < service.filterInvoiceList.length; i++)
                Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: JPAppTheme.themeColors.lightBlue.withValues(alpha: 0.8)),
                        child: Center(
                          child: JPText(
                            textColor: JPAppTheme.themeColors.primary,
                            text: (i + 1).toString(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                            bottom: BorderSide(
                              color: JPAppTheme.themeColors.dimGray,
                              width: 1,
                            ),
                          )),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          JPText(
                                            text: service.filterInvoiceList[i].label,
                                            textAlign: TextAlign.left,
                                          ),
                                          const SizedBox(height: 5),
                                          JPText(
                                            text: JobFinancialHelper.getCurrencyFormattedValue(
                                              value: service.filterInvoiceList[i].additionData
                                            ),
                                            textColor:JPAppTheme.themeColors.tertiary,
                                            textSize: JPTextSize.heading5,
                                          ),
                                          const SizedBox(
                                            height: 14,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (!service.hasInvoiceSelected)
                                Padding(
                                padding: EdgeInsets.only(
                                  right: controller.formUiHelper.horizontalPadding
                                ),
                                child: JPTextButton(
                                  isDisabled: controller.isSavingForm,
                                  icon: Icons.clear,
                                  color: JPAppTheme.themeColors.secondary,
                                  iconSize: 24,
                                  onPressed: () => service.removeInvoice(i),
                                  padding: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 25)
            }
          ],
        ),
      ),
    );
  }
}

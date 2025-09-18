import 'package:get/get.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/modules/job_financial/listing/controller.dart';
import 'package:jp_mobile_flutter_ui/ToolTip/index.dart';
import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';


class InvoiceTotalTile extends StatelessWidget {
  const InvoiceTotalTile({
    super.key, required this.controller,
  });
  final JobFinancialListingModuleController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: JPAppTheme.themeColors.lightBlue.withValues(alpha: 0.40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 5,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        JPText(
                          text: 'total_invoice_amount'.tr,
                          fontWeight: JPFontWeight.medium,
                          textColor: JPAppTheme.themeColors.tertiary,
                        ),
                        if (!Helper.isValueNullOrEmpty(controller.job) && controller.getPendingAmount(controller.job!) > 0)
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: JPToolTip(
                            message: 'invoice_yet_to_be_created'.tr,
                            child: JPIcon(
                              Icons.info,
                              size: 18,
                              color: JPAppTheme.themeColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: JPText(
                        text: JobFinancialHelper.getCurrencyFormattedValue(value: controller.job!.financialDetails!.jobInvoiceAmount),
                        fontWeight: JPFontWeight.bold,
                        textSize: JPTextSize.heading2,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    JPText(
                      text: 'job_amount'.tr,
                      textColor: JPAppTheme.themeColors.tertiary,
                    ),
                    const SizedBox(width: 5,),
                    JPText(
                      text: JobFinancialHelper.getCurrencyFormattedValue(value: controller.job!.amount),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,

                  children: [
                    JPText(
                      text: 'pending_invoice_amount'.tr,
                      textColor: JPAppTheme.themeColors.tertiary,
                    ),
                    JPText(
                      text: JobFinancialHelper.getCurrencyFormattedValue(value: controller.getPendingAmount(controller.job!)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

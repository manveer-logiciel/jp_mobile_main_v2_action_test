import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:jobprogress/common/models/job_financial/financial_listing.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/modules/job_financial/listing/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JobFinancialInvoicesListingTile extends StatelessWidget {
  const JobFinancialInvoicesListingTile({
  super.key, required this.index, required this.controller,
  });

  final int index; 
  final JobFinancialListingModuleController controller;

  @override
  Widget build(BuildContext context) {
    FinancialListingModel invoices = controller.financialList[index];
    return Material(
      color: JPAppTheme.themeColors.base,
      child: InkWell( 
        onLongPress:() => controller.showQuickAction(index: index),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1,
                color: JPAppTheme.themeColors.dimGray
              )
            )
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  JPText(
                    text: '#${invoices.invoiceNumber ?? "unsaved_invoice".tr}',
                    fontWeight: JPFontWeight.medium,),
                  const SizedBox(width: 5,),
                  Flexible(
                    child: JPText(
                      text: JobFinancialHelper.getCurrencyFormattedValue(value: invoices.invoiceTotalAmount),
                      textColor: JPAppTheme.themeColors.primary,
                      textSize: JPTextSize.heading2,
                      fontWeight: JPFontWeight.medium,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: JPText(
                        text: '${'price'.tr}: ${JobFinancialHelper.getCurrencyFormattedValue(value: invoices.totalAmount)} | ${DateTimeHelper.convertHyphenIntoSlash(invoices.date ?? "")}',
                        textSize: JPTextSize.heading5,
                        textColor: JPAppTheme.themeColors.tertiary,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    JPText(
                      text: invoices.status == 'open' ? 'open'.tr : 'paid'.tr ,
                      textColor: invoices.status == 'open'
                        ? JPAppTheme.themeColors.warning
                        : JPAppTheme.themeColors.success,
                      textSize: JPTextSize.heading5,
                      fontWeight: JPFontWeight.medium,
                    ),
                  ],
                ),
              ),
              if(invoices.taxRate != null)
                Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: JPText(
                    text: '${'tax'.tr}: ${JobFinancialHelper.getCurrencyFormattedValue(value: controller.getTaxableAmount(invoices))} (${invoices.taxRate!}%)  | ${'taxable'.tr}: ${JobFinancialHelper.getCurrencyFormattedValue(value: invoices.totalAmount)}',
                    textSize: JPTextSize.heading5,
                    textColor: JPAppTheme.themeColors.tertiary,
                    textAlign: TextAlign.left,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

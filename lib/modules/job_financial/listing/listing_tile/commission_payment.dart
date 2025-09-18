import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job_financial/financial_listing.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/modules/job_financial/listing/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';


class JobFinancialCommissionPaymentListingTile extends StatelessWidget {
  const JobFinancialCommissionPaymentListingTile({
  super.key, required this.index, required this.controller,
  });

  final int index; 
  final JobFinancialListingModuleController controller;

  @override
  Widget build(BuildContext context) {
    FinancialListingModel commission = controller.financialList[index];
    bool isCancelled = commission.canceled == null ? false : true;

    return Material(
       color: isCancelled ? JPAppTheme.themeColors.inverse.withValues(alpha: 0.4) : JPAppTheme.themeColors.base,
      child: InkWell( 
        onLongPress:(){
          controller.showQuickAction(index: index);
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1,
                color: JPAppTheme.themeColors.dimGray)
            ) 
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              JPText(
                textAlign: TextAlign.start,
                text: DateTimeHelper.convertHyphenIntoSlash(commission.date!),
                textColor: isCancelled ? 
                  JPAppTheme.themeColors.text.withValues(alpha: 0.7):
                  JPAppTheme.themeColors.text,
                fontWeight: JPFontWeight.medium,
              ),
              Column(
               crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  JPText(
                    text: JobFinancialHelper.getCurrencyFormattedValue(value: commission.totalAmount!) , 
                    textColor: isCancelled ?
                      JPAppTheme.themeColors.primary.withValues(alpha: 0.7) :
                      JPAppTheme.themeColors.primary,
                    textSize: JPTextSize.heading2,
                    fontWeight: JPFontWeight.medium,
                  ),
                  if(isCancelled)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: JPText(
                      text: 'cancelled'.tr, 
                      textColor: JPAppTheme.themeColors.secondary,
                      textSize: JPTextSize.heading5,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

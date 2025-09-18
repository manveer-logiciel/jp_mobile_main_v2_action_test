import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job_financial/financial_listing.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/modules/job_financial/listing/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JobFinancialJobPriceHistoryListingTile extends StatelessWidget {
  const JobFinancialJobPriceHistoryListingTile({
  super.key, required this.index, required this.controller,
  });

  final int index; 
  final JobFinancialListingModuleController controller;

  @override
  Widget build(BuildContext context) {
    FinancialListingModel jobPriceHistory = controller.financialList[index];
    
    return Container(
      decoration: BoxDecoration(
        color: JPAppTheme.themeColors.base,
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: JPAppTheme.themeColors.dimGray
          )
        )
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                JPText(
                  text:DateTimeHelper.formatDate(jobPriceHistory.date!,DateFormatConstants.dateTimeFormatWithoutSeconds),
                  textColor: JPAppTheme.themeColors.text,
                  fontWeight: JPFontWeight.medium,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 7),
                JPText(
                  textAlign: TextAlign.left,
                  text: jobPriceHistory.createdBy!,
                  textSize: JPTextSize.heading5,
                  textColor: JPAppTheme.themeColors.tertiary,
                ),		                
              ],
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  if(index == 0)
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: JPAppTheme.themeColors.success),
                      child:JPIcon(Icons.done, color: JPAppTheme.themeColors.base, size: 18),
                    ),
                  ),
                  JPText(
                    text:JobFinancialHelper.getCurrencyFormattedValue(value: JobFinancialHelper.getTaxableTotalAmount(jobPriceHistory)),
                    textColor: JPAppTheme.themeColors.primary,
                    textSize: JPTextSize.heading2,
                    fontWeight: JPFontWeight.medium,
                  ),
                ],
              ),
              if(jobPriceHistory.taxable)
              JPText(
                text: '(${'inclusive_tax'.tr})',
                textSize: JPTextSize.heading5,
                textColor: JPAppTheme.themeColors.tertiary,
              ),                
            ],
          )
        ],
      ),
    );
  }
}

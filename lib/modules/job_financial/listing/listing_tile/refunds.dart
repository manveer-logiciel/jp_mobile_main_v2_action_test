import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job_financial/financial_listing.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/global_widgets/quick_book/index.dart';
import 'package:jobprogress/modules/job_financial/listing/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JobFinancialRefundsListingTile extends StatelessWidget {
  const JobFinancialRefundsListingTile({
  super.key, required this.index, required this.controller,
  });

  final int index; 
  final JobFinancialListingModuleController controller;

  @override
  Widget build(BuildContext context) {
    FinancialListingModel refunds = controller.financialList[index];
    bool isCancelled = refunds.canceled == null ? false : true;

    return Material(
      color: isCancelled ? JPAppTheme.themeColors.inverse.withValues(alpha: 0.4) : JPAppTheme.themeColors.base,
      child: InkWell( 
        onLongPress: (){
          controller.showQuickAction(index: index);
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1,
                color: JPAppTheme.themeColors.dimGray)) 
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    JPText(
                      text:DateTimeHelper.convertHyphenIntoSlash(refunds.date!),
                      textColor: isCancelled ?
                        JPAppTheme.themeColors.text.withValues(alpha: 0.7):
                        JPAppTheme.themeColors.text,
                      fontWeight: JPFontWeight.medium,
                    ),
                    const SizedBox(height: 7,),
                    JPText(
                      text: Helper.isValueNullOrEmpty(refunds.method) ?
                        refunds.financialAccountName! :
                        '${JobFinancialHelper.getMethodType(refunds.method ?? '')} | ${refunds.financialAccountName!}',
                      textSize: JPTextSize.heading5,
                      textAlign: TextAlign.left,
                      textColor: isCancelled ?
                        JPAppTheme.themeColors.tertiary.withValues(alpha: 0.7):
                        JPAppTheme.themeColors.tertiary,
                    ),	                
                  ],
                ),
              ),
              const SizedBox(width: 5),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    JPText(
                      text:JobFinancialHelper.getCurrencyFormattedValue(value:refunds.totalAmount!) ,
                      textColor: isCancelled ? 
                        JPAppTheme.themeColors.primary.withValues(alpha: 0.7) :
                        JPAppTheme.themeColors.primary,
                      textSize:JPTextSize.heading2,
                      fontWeight: JPFontWeight.medium,
                      textAlign: TextAlign.left,
                    ), 
                    const SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if(refunds.canceled != null)
                        JPText(
                          text: 'cancelled'.tr, 
                          textColor: JPAppTheme.themeColors.secondary,
                          textSize: JPTextSize.heading5,
                        ),
                        const SizedBox(width: 5,),
                         QuickBookIcon(
                          qbDesktopId: refunds.qbDesktopId,
                          quickbookId: refunds.quickbookId,
                          origin: refunds.origin,
                          status: refunds.quickBookSyncStatus.toString(),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}



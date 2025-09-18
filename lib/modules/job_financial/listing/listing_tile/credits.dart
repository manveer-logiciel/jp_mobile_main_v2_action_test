import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job_financial/financial_listing.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/modules/job_financial/listing/bottom_sheet/credit_detail_bottom_sheet/index.dart';
import 'package:jobprogress/modules/job_financial/listing/controller.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JobFinancialCreditsListingTile extends StatelessWidget {
  const JobFinancialCreditsListingTile({
  super.key, required this.index, required this.controller,
  });

  final int index; 
  final JobFinancialListingModuleController controller;

  @override
  Widget build(BuildContext context) {
    FinancialListingModel credits = controller.financialList[index];
    bool isCancelled = credits.canceled == null ? false : true;

    return Material(
      color: isCancelled ? JPAppTheme.themeColors.inverse.withValues(alpha: 0.4) : JPAppTheme.themeColors.base,
      child: InkWell( 
        onLongPress:(() => controller.showQuickAction(index: index)),
        onTap: (){
          showJPBottomSheet(child: (_) => JobFinancialCreditsDetailBottomSheet(creditsDetail: credits),isScrollControlled: true);
        },
        child: Container(
          decoration: BoxDecoration(
            border:Border(
              bottom: BorderSide(
                width: 1,
                color: JPAppTheme.themeColors.dimGray
              )
            ) 
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: 
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  JPText(
                    text: DateTimeHelper.convertHyphenIntoSlash(credits.date!),
                    fontWeight: JPFontWeight.medium,
                    textColor: isCancelled ? 
                      JPAppTheme.themeColors.text.withValues(alpha: 0.7):
                      JPAppTheme.themeColors.text
                  ),
                  JPText(
                    textAlign: TextAlign.left,
                    text:JobFinancialHelper.getCurrencyFormattedValue(value: credits.totalAmount),
                    textColor: isCancelled?
                      JPAppTheme.themeColors.primary.withValues(alpha: 0.7):
                      JPAppTheme.themeColors.primary,
                    textSize:JPTextSize.heading2,
                    fontWeight: JPFontWeight.medium,
                  ),		                
                ],
              ),
              const SizedBox(height: 7),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: JPText(
                      textAlign: TextAlign.left,
                      text:'${'applied'.tr}: ${JobFinancialHelper.getCurrencyFormattedValue(
                        value: JobFinancialHelper.getRemainingAmount(
                          total: double.parse(credits.totalAmount!),
                          value: double.parse(credits.unAppliedAmount!)
                        )
                      )} | ${'unapplied'.tr}: ${JobFinancialHelper.getCurrencyFormattedValue(value: credits.unAppliedAmount)}' ,
                      textSize: JPTextSize.heading5,
                      textColor:isCancelled?
                      JPAppTheme.themeColors.secondaryText.withValues(alpha: 0.7):
                      JPAppTheme.themeColors.secondaryText
                    ),
                  ),
                  if(credits.canceled != null)
                  JPText(
                    text: 'cancelled'.tr, 
                    textColor: JPAppTheme.themeColors.secondary,
                    textSize: JPTextSize.heading5,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:jobprogress/common/models/job_financial/financial_listing.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/modules/job_financial/listing/bottom_sheet/change_order_bottom_sheet/index.dart';
import 'package:jobprogress/modules/job_financial/listing/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JobFinancialChangeOrderListingTile extends StatelessWidget {
  const JobFinancialChangeOrderListingTile({
    super.key,
    required this.index,
    required this.controller,
  });

  final int index;
  final JobFinancialListingModuleController controller;

  @override
  Widget build(BuildContext context) {
    FinancialListingModel changeOrderList = controller.financialList[index];
    bool isCancelled = changeOrderList.canceled == null ? false : true;

    return Material(
      color: isCancelled ? JPAppTheme.themeColors.inverse.withValues(alpha: 0.4) : JPAppTheme.themeColors.base,
      child: InkWell(
        onTap: (){
          showJPBottomSheet(child: (_) =>JobFinancialChangeOrderBottomSheet(changeOrder: changeOrderList),isScrollControlled: true);
        },
        onLongPress:(() => controller.showQuickAction(index: index)),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  JPText(
                    text:DateTimeHelper.formatDate(changeOrderList.createdAt!, DateFormatConstants.dateOnlyFormat),
                    fontWeight: JPFontWeight.medium,
                    textColor: isCancelled ? 
                      JPAppTheme.themeColors.text.withValues(alpha: 0.7):
                      JPAppTheme.themeColors.text
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 7.5),
                    child: JPText(
                      text: changeOrderList.order != null ? '${'order'.tr} #: ${changeOrderList.order}' : "(${"auto_saved".tr}) ${"order".tr}",
                      textSize: JPTextSize.heading5,
                      textColor: isCancelled
                          ? JPAppTheme.themeColors.tertiary.withValues(alpha: 0.7)
                          : JPAppTheme.themeColors.tertiary,
                    ),
                  )
                ],
              ),
              const SizedBox(width: 5,),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    JPText(
                      text: JobFinancialHelper.getCurrencyFormattedValue(value: JobFinancialHelper.getTaxableTotalAmount(changeOrderList)) ,
                      textColor: isCancelled ?
                        JPAppTheme.themeColors.primary.withValues(alpha: 0.7) :
                        JPAppTheme.themeColors.primary,
                      textSize: JPTextSize.heading2,
                      fontWeight: JPFontWeight.medium,
                      textAlign: TextAlign.left,
                    ),
                    if(changeOrderList.taxable)
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: JPText(
                      text: '(${'inclusive_tax'.tr})',
                      textSize: JPTextSize.heading5,
                      textColor: isCancelled ?
                        JPAppTheme.themeColors.tertiary.withValues(alpha: 0.7) :
                        JPAppTheme.themeColors.tertiary
                      ),
                    ),
                    if(changeOrderList.canceled != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: JPText(
                        text: 'cancelled'.tr, 
                        textColor: JPAppTheme.themeColors.secondary,
                        textSize: JPTextSize.heading5,
                      ),
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

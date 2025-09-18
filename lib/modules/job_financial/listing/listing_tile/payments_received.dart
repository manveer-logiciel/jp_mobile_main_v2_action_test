import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job_financial/financial_listing.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/modules/job_financial/listing/bottom_sheet/payment_detail_bottom_sheet/index.dart';
import 'package:jobprogress/modules/job_financial/listing/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JobFinancialPaymentsReceivedListingTile extends StatelessWidget {
  const JobFinancialPaymentsReceivedListingTile({
    super.key, required this.index, required this.controller,
  });
  final int index;
  final JobFinancialListingModuleController controller;

  @override
  Widget build(BuildContext context) {
    FinancialListingModel paymentsReceived = controller.financialList[index];
    bool isCancelled = paymentsReceived.canceled == null ? false : true;
    return Material(
      color: isCancelled ? JPAppTheme.themeColors.inverse.withValues(alpha: 0.4) : JPAppTheme.themeColors.base,
      child: InkWell(
        onLongPress:(() => controller.showQuickAction(index: index)),
        onTap: (){
          showJPBottomSheet(child: (_) => JobFinancialPaymentDetailBottomSheet(paymentsReceived: paymentsReceived,),isScrollControlled: true);
        },
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  JPText(
                      text: paymentsReceived.date != null ?
                      DateTimeHelper.convertHyphenIntoSlash(paymentsReceived.date!) :
                      DateTimeHelper.formatDate(paymentsReceived.updatedAt!, DateFormatConstants.dateTimeFormatWithoutSeconds),
                      fontWeight: JPFontWeight.medium,
                      textColor: isCancelled ?
                      JPAppTheme.themeColors.text.withValues(alpha: 0.7):
                      JPAppTheme.themeColors.text
                  ),
                  const SizedBox(height: 7),
                  JPText(
                      text: JobFinancialHelper.getPaymentReceivedType(paymentsReceived: paymentsReceived),
                      textSize: JPTextSize.heading5,
                      textColor: isCancelled ?
                      JPAppTheme.themeColors.tertiary.withValues(alpha: 0.7) :
                      JPAppTheme.themeColors.tertiary
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  JPText(
                    text: paymentsReceived.refTo != null ?
                    '-${JobFinancialHelper.getCurrencyFormattedValue(value: paymentsReceived.totalAmount)}' :
                    JobFinancialHelper.getCurrencyFormattedValue(value: paymentsReceived.totalAmount),
                    textColor: isCancelled ?
                    JPAppTheme.themeColors.primary.withValues(alpha: 0.7) :
                    JPAppTheme.themeColors.primary,
                    textSize: JPTextSize.heading2,
                    fontWeight: JPFontWeight.medium,
                  ),
                  const SizedBox(height: 5),
                  JPText(
                    text: paymentsReceived.getPaymentStatus().capitalize!,
                    textColor: paymentsReceived.getPaymentStatusColor(),
                    textSize: JPTextSize.heading5,
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

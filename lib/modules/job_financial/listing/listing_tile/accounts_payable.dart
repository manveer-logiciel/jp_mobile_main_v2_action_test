import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/job_financial/financial_listing.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/global_widgets/quick_book/index.dart';
import 'package:jobprogress/modules/job_financial/listing/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';


class JobFinancialAccountsPayableTile extends StatelessWidget {
  const JobFinancialAccountsPayableTile({
  super.key, required this.index, required this.controller,
  });

  final int index; 
  final JobFinancialListingModuleController controller;

  @override
  Widget build(BuildContext context) {
    FinancialListingModel accountsPayable = controller.financialList[index];

    return Material(
       color:JPAppTheme.themeColors.base,
      child: InkWell( 
        onLongPress:(){
          controller.showQuickAction(index: index);
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1,
                color: JPAppTheme.themeColors.dimGray)) ),
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: JPText(
                            textAlign: TextAlign.start,
                            text: accountsPayable.vendorName!,
                            textColor: JPAppTheme.themeColors.text,
                            fontWeight: JPFontWeight.medium,
                          ),
                        ),
                        const SizedBox(width : 5),
                        if(accountsPayable.attachments!.isNotEmpty)
                        const JPIcon(Icons.attachment_outlined)
                      ],
                    ),
                    const SizedBox(height: 7,),
                    JPText(
                      textAlign: TextAlign.left,
                      text:accountsPayable.billNumber!= null ? 
                      'Bill #: ${accountsPayable.billNumber!} | ${DateTimeHelper.convertHyphenIntoSlash(accountsPayable.date!)}' :
                      DateTimeHelper.convertHyphenIntoSlash(accountsPayable.date!),
                      textSize: JPTextSize.heading5,
                      textColor: JPAppTheme.themeColors.tertiary,
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Column(
                 crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    JPText(
                      text: JobFinancialHelper.getCurrencyFormattedValue(value: accountsPayable.totalAmount), 
                      textColor: JPAppTheme.themeColors.primary,
                      textSize: JPTextSize.heading2,
                      fontWeight: JPFontWeight.medium,
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 5),
                    QuickBookIcon(
                      height: 16,
                      width: 16,
                      qbDesktopId: accountsPayable.qbDesktopId,
                      quickbookId: accountsPayable.quickbookId,
                      origin: accountsPayable.origin,
                      status: accountsPayable.quickBookSyncStatus.toString(),
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
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job_financial/financial_listing.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JobFinancialChangeOrderBottomSheet extends StatelessWidget {
  const JobFinancialChangeOrderBottomSheet({super.key, required this.changeOrder});
  final FinancialListingModel changeOrder;
  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Wrap(
        children: [
          JPSafeArea(
            containerDecoration: BoxDecoration(
              color: JPAppTheme.themeColors.base,
              borderRadius: BorderRadius.circular(12)
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: JPAppTheme.themeColors.base,
                borderRadius: JPResponsiveDesign.bottomSheetRadius,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: JPText(
                            text: '${'change_order'.tr.toUpperCase()} ${'detail'.tr.toUpperCase()}',
                            fontWeight: JPFontWeight.medium,
                            textSize: JPTextSize.heading2,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Material(
                          shape: const CircleBorder(),
                          color: JPAppTheme.themeColors.base,
                          clipBehavior: Clip.hardEdge,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minHeight: 30, minWidth: 30),
                            icon: const JPIcon(
                              Icons.close_outlined,
                            ),
                            onPressed: () {
                              Get.back();
                            },
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 5),
                      child: JPText(text: 'amount'.tr,),
                    ),
                    JPText(
                      text:JobFinancialHelper.getCurrencyFormattedValue(value:JobFinancialHelper.getTaxableTotalAmount(changeOrder)) , 
                      textColor: JPAppTheme.themeColors.tertiary,
                      textSize: JPTextSize.heading5,
                    ),
                    if(changeOrder.taxRate != null)...{
                      Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 5),
                        child: JPText(text: 'tax_rate'.tr),
                      ),          
                      JPText(
                        text: '${changeOrder.taxRate!}%',
                        textColor: JPAppTheme.themeColors.tertiary,
                        textSize: JPTextSize.heading5
                      ),
                    },
                    if(changeOrder.order != null)... {
                      Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 5),
                          child:JPText(text:'${'order'.tr} #')
                      ),
                      JPText(
                        text: changeOrder.order.toString(),
                        textColor: JPAppTheme.themeColors.tertiary,
                        textSize: JPTextSize.heading5,
                      ),
                    },
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 5),
                      child: JPText(text: 'date'.tr,),
                    ),
                    JPText( 
                      text:DateTimeHelper.formatDate(changeOrder.createdAt!, DateFormatConstants.dateOnlyFormat),
                      textColor: JPAppTheme.themeColors.tertiary,
                      textSize: JPTextSize.heading5
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

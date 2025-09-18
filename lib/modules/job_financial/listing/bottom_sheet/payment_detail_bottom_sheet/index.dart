import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job_financial/financial_listing.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JobFinancialPaymentDetailBottomSheet extends StatelessWidget {
   const JobFinancialPaymentDetailBottomSheet({super.key, required this.paymentsReceived});
  final FinancialListingModel paymentsReceived;
 
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
                borderRadius: JPResponsiveDesign.bottomSheetRadius
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        JPText(
                          text: 'payment_detail'.tr.toUpperCase(),
                          fontWeight: JPFontWeight.medium,
                          textSize: JPTextSize.heading2,
                        ),
                        Material(
                          shape: const CircleBorder(),
                          color: JPAppTheme.themeColors.base,
                          clipBehavior: Clip.hardEdge,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints:
                                const BoxConstraints(minHeight: 30, minWidth: 30),
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
                      text:paymentsReceived.refTo != null ? 
                      '-${JobFinancialHelper.getCurrencyFormattedValue(value:paymentsReceived.totalAmount)}' :
                      JobFinancialHelper.getCurrencyFormattedValue(value:paymentsReceived.totalAmount), 
                      textColor: JPAppTheme.themeColors.tertiary,
                      textSize: JPTextSize.heading5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 5),
                      child: JPText(text: 'type'.tr,),
                    ),          
                    JPText(
                      text: JobFinancialHelper.getPaymentReceivedType(paymentsReceived: paymentsReceived),
                      textColor: JPAppTheme.themeColors.tertiary,
                      textSize: JPTextSize.heading5),              
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 5),
                      child: JPText(text: 'date'.tr,),
                    ),
                    JPText( 
                      text:DateTimeHelper.convertHyphenIntoSlash(paymentsReceived.date!),
                      textColor: JPAppTheme.themeColors.tertiary,
                      textSize: JPTextSize.heading5),            
                    if(paymentsReceived.echequeNumber !=null && paymentsReceived.echequeNumber!.isNotEmpty)...{
                      Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 5),
                        child:JPText(text: paymentsReceived.method == 'echeque' ? 'check_number'.tr : 'reference_number'.tr)
                      ),
                      JPText(
                        text: paymentsReceived.echequeNumber!,
                        textColor: JPAppTheme.themeColors.tertiary,
                        textSize: JPTextSize.heading5,),
                    },
                    if(paymentsReceived.cancelNote != null && paymentsReceived.cancelNote!.isNotEmpty)...{
                      Padding(
                        padding: const EdgeInsets.only(top: 15,bottom: 5),
                        child: JPText(
                          text: 'cancellation_reason'.tr)
                      ),     
                      JPText(
                        textAlign: TextAlign.left,
                        text: paymentsReceived.cancelNote!,
                        textColor: JPAppTheme.themeColors.tertiary,
                        textSize: JPTextSize.heading5,
                      ),
                    }
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

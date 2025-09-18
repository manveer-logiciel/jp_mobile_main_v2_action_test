import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job_financial/financial_listing.dart';
import 'package:jobprogress/common/repositories/job_financial.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../../../core/utils/date_time_helpers.dart';
class JobFinancialCreditsDetailBottomSheet extends StatelessWidget {
  const JobFinancialCreditsDetailBottomSheet({super.key, required this.creditsDetail,});
  final FinancialListingModel creditsDetail;
  @override
  Widget build(BuildContext context) {
    return  Wrap(
      children: [
        Container(
          width: Get.width,
          margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: JPAppTheme.themeColors.base,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: JPScreen.isTablet ? const Radius.circular(20) : const Radius.circular(0),
            bottomRight: JPScreen.isTablet ? const Radius.circular(20) : const Radius.circular(0),
          )
        ),
          child: JPSafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    JPText(
                      text: 'credit_detail'.tr.toUpperCase(),
                      fontWeight: JPFontWeight.medium,
                      textSize: JPTextSize.heading2,
                    ),
                    Material(
                      shape: const CircleBorder(),
                      color: JPAppTheme.themeColors.base,
                      clipBehavior: Clip.hardEdge,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minHeight: 30,
                          minWidth: 30),
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
                Container(
                  width: Get.width,
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.85,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15,bottom: 5),
                          child: JPText(text: 'amount'.tr),
                        ),
                        JPText(
                          text:JobFinancialHelper.getCurrencyFormattedValue(value: creditsDetail.totalAmount!) ,
                          textColor: JPAppTheme.themeColors.tertiary,
                          textSize: JPTextSize.heading5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15,bottom: 5),
                          child: JPText(text: 'applied'.tr),
                        ),
                        JPText(
                          text: JobFinancialHelper.getCurrencyFormattedValue(
                            value:  JobFinancialHelper.getRemainingAmount(
                              total: double.parse(creditsDetail.totalAmount!),
                              value: double.parse(creditsDetail.unAppliedAmount!)
                            )
                          ),
                          textColor: JPAppTheme.themeColors.tertiary,
                          textSize: JPTextSize.heading5),
                        Padding(
                          padding: const EdgeInsets.only(top: 15,bottom: 5),
                          child: JPText(text: 'unapplied'.tr),
                        ),
                        JPText(
                          text:JobFinancialHelper.getCurrencyFormattedValue(value: creditsDetail.unAppliedAmount!) ,
                          textColor: JPAppTheme.themeColors.tertiary,
                          textSize: JPTextSize.heading5,
                        ),
                        if(creditsDetail.invoiceNo != null)...{
                          Padding(
                            padding: const EdgeInsets.only(top: 15,bottom: 10),
                            child: JPText(text: 'linked_invoice'.tr),
                          ),
                          JPButton(
                            onPressed: () async{
                             await JobFinancialRepository.openInvoice(modal: creditsDetail);
                             Get.back();
                            },
                            size: JPButtonSize.extraSmall,
                            text: creditsDetail.invoiceNo,
                            type: JPButtonType.outline,
                          ),
                        },
                        Padding(
                          padding: const EdgeInsets.only(top: 15,bottom: 5),
                          child: JPText(text: 'date'.tr,),
                        ),
                        JPText(
                          text:DateTimeHelper.convertHyphenIntoSlash(creditsDetail.date!),
                          textColor: JPAppTheme.themeColors.tertiary,
                          textSize: JPTextSize.heading5,
                        ),
                        if(creditsDetail.note != null)...{
                          Padding(
                            padding: const EdgeInsets.only(top: 15,bottom: 5),
                            child: JPText(text: 'note'.tr,),
                          ),
                          JPReadMoreText(
                            creditsDetail.note!,
                            textAlign: TextAlign.left,
                            textColor: JPAppTheme.themeColors.tertiary,
                            textSize: JPTextSize.heading5,
                            dialogTitle: 'description'.tr.toUpperCase(),
                          ),
                        }
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
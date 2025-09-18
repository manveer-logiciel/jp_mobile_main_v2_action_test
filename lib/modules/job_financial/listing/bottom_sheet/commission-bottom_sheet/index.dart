import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job_financial/financial_listing.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
class JobFinancialCommisionBottomSheet extends StatelessWidget {
  const JobFinancialCommisionBottomSheet({super.key, required this.commission});
  final FinancialListingModel commission;
  @override
  Widget build(BuildContext context) {
    return  Wrap(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: JPAppTheme.themeColors.base,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20)
            )
          ),
          child: JPSafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    JPText(
                      text: '${'commission'.tr.toUpperCase()} ${'detail'.tr.toUpperCase()}',
                      fontWeight: JPFontWeight.medium,
                      textSize: JPTextSize.heading2,
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
                          padding: const EdgeInsets.only(top: 15, bottom: 5),
                          child: JPText(text:'${'paid'.tr} ${'to'.tr}'),
                        ),
                        JPText(
                          textAlign: TextAlign.left,
                          text: commission.paidTo!.fullName ,
                          textColor: JPAppTheme.themeColors.tertiary,
                          textSize: JPTextSize.heading5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 5),
                          child: JPText(text: 'amount'.tr,),
                        ),
                        JPText(
                          text: JobFinancialHelper.getCurrencyFormattedValue(value: commission.totalAmount!) ,
                          textColor: JPAppTheme.themeColors.tertiary,
                          textSize: JPTextSize.heading5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 5),
                          child: JPText(text: '${'amount'.tr} ${'due'.tr.capitalize!}'),
                        ),
                        JPText(
                          text: JobFinancialHelper.getCurrencyFormattedValue(value: commission.dueAmount),
                          textColor: JPAppTheme.themeColors.tertiary,
                          textSize: JPTextSize.heading5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 5),
                          child: JPText(text: 'date'.tr.capitalize!),
                        ),
                        JPText(
                          text: DateTimeHelper.formatDate(commission.createdAt!, DateFormatConstants.dateOnlyFormat),
                          textColor: JPAppTheme.themeColors.tertiary,
                          textSize: JPTextSize.heading5,
                        ),
                        if(commission.description != null)...{
                          Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 5),
                            child: JPText(
                              text: 'description'.tr
                            ),
                          ),
                          JPReadMoreText(
                            commission.description!,
                            textAlign: TextAlign.left,
                            textSize: JPTextSize.heading5,
                            textColor: JPAppTheme.themeColors.tertiary,
                            dialogTitle: 'description'.tr.toUpperCase(),
                          ),
                        },

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class JobFinancialListingJobInvoicesShimmer extends StatelessWidget {
  const JobFinancialListingJobInvoicesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  Column(
                    children: [
                      for (int i = 0; i <= 6; i++)
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 1,
                                color: JPAppTheme.themeColors.dimGray,
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Shimmer.fromColors(
                                      baseColor: JPAppTheme.themeColors.dimGray,
                                      highlightColor: JPAppTheme.themeColors.inverse,
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(vertical: 2),
                                        height: 10,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: JPAppTheme.themeColors.base,
                                        ),
                                        child: JPText(
                                          text: '#526-18',
                                          textColor: JPAppTheme.themeColors.base,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 7),
                                    Shimmer.fromColors(
                                      baseColor: JPAppTheme.themeColors.dimGray,
                                      highlightColor: JPAppTheme.themeColors.inverse,
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(vertical: 2),
                                        height: 10,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: JPAppTheme.themeColors.base,
                                        ),
                                        child: JPText(
                                          text: 'Price: 664.00 | 05/26/2022',
                                          textSize: JPTextSize.heading5,
                                          textColor: JPAppTheme.themeColors.tertiary,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    if (i % 3 != 0)
                                      Column(
                                        children: [
                                          const SizedBox(height: 7),
                                          Shimmer.fromColors(
                                            baseColor: JPAppTheme.themeColors.dimGray,
                                            highlightColor: JPAppTheme.themeColors.inverse,
                                            child: Container(
                                              margin: const EdgeInsets.symmetric(vertical: 2),
                                              height: 10,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                color: JPAppTheme.themeColors.base,
                                              ),
                                              child: JPText(
                                                text: 'Tax: 8.90 (10%) | Taxable: 89.00',
                                                textSize: JPTextSize.heading5,
                                                textColor: JPAppTheme.themeColors.tertiary,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Shimmer.fromColors(
                                    baseColor: JPAppTheme.themeColors.dimGray,
                                    highlightColor: JPAppTheme.themeColors.inverse,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(vertical: 4),
                                      height: 10,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: JPAppTheme.themeColors.base,
                                      ),
                                      child: JPText(
                                        text: JobFinancialHelper.getCurrencyFormattedValue(value: '346.25'),
                                        textColor: JPAppTheme.themeColors.primary,
                                        fontWeight: JPFontWeight.medium,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Shimmer.fromColors(
                                    baseColor: JPAppTheme.themeColors.dimGray,
                                    highlightColor: JPAppTheme.themeColors.inverse,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(vertical: 4),
                                      height: 10,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: JPAppTheme.themeColors.base,
                                      ),
                                      child: JPText(
                                        text: 'open'.tr,
                                        textSize: JPTextSize.heading5,
                                        textColor: JPAppTheme.themeColors.tertiary,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 1,
                          color: JPAppTheme.themeColors.dimGray,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Shimmer.fromColors(
                                baseColor: JPAppTheme.themeColors.dimGray,
                                highlightColor: JPAppTheme.themeColors.inverse,
                                child: Container(
                                  color: JPAppTheme.themeColors.base,
                                  child: JPText(
                                    text: 'job_amount'.tr,
                                    textColor: JPAppTheme.themeColors.base,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 7),
                              Shimmer.fromColors(
                                baseColor: JPAppTheme.themeColors.dimGray,
                                highlightColor: JPAppTheme.themeColors.inverse,
                                child: Container(
                                  color: JPAppTheme.themeColors.base,
                                  child: JPText(
                                    text: 'pending_amount'.tr,
                                    textColor: JPAppTheme.themeColors.tertiary,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 13),
                              Shimmer.fromColors(
                                baseColor: JPAppTheme.themeColors.dimGray,
                                highlightColor: JPAppTheme.themeColors.inverse,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(vertical: 4),
                                  height: 10,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: JPAppTheme.themeColors.base,
                                  ),
                                  child: JPText(
                                    text: 'total_invoice_amount'.tr,
                                    textColor: JPAppTheme.themeColors.tertiary,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Shimmer.fromColors(
                              baseColor: JPAppTheme.themeColors.dimGray,
                              highlightColor: JPAppTheme.themeColors.inverse,
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                height: 10,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: JPAppTheme.themeColors.base,
                                ),
                                child: JPText(
                                  text: JobFinancialHelper.getCurrencyFormattedValue(value: '9466.00'),
                                  textColor: JPAppTheme.themeColors.primary,
                                  fontWeight: JPFontWeight.medium,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Shimmer.fromColors(
                              baseColor: JPAppTheme.themeColors.dimGray,
                              highlightColor: JPAppTheme.themeColors.inverse,
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                height: 10,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: JPAppTheme.themeColors.base,
                                ),
                                child: JPText(
                                  text: '0.000',
                                  textSize: JPTextSize.heading5,
                                  textColor: JPAppTheme.themeColors.tertiary,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Shimmer.fromColors(
                              baseColor: JPAppTheme.themeColors.dimGray,
                              highlightColor: JPAppTheme.themeColors.inverse,
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                height: 10,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: JPAppTheme.themeColors.base,
                                ),
                                child: JPText(
                                  text: '9466.00',
                                  textColor: JPAppTheme.themeColors.tertiary,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

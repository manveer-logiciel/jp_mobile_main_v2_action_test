import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/global_widgets/financial_total_price_tile/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class WorksheetShimmer extends StatelessWidget {
  const WorksheetShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Stack(
        children: [
          Container(
            height: 168,
            color: JPAppTheme.themeColors.secondary,
          ),
          Column(
            children: [
              Shimmer.fromColors(
                baseColor: JPAppTheme.themeColors.dimGray,
                highlightColor: JPAppTheme.themeColors.inverse,
                child: FinancialTotalPriceTile(
                  title: 'list_total'.tr,
                  value: JobFinancialHelper.getCurrencyFormattedValue(value: '0'),
                  trailing: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8
                      ),
                      child: JPIcon(Icons.more_vert_outlined, color: JPAppTheme.themeColors.base),
                    ),
                  ],
                ),
              ),
              header(),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    JPText(text: 'item'.tr, textSize: JPTextSize.heading5, textColor: JPAppTheme.themeColors.secondaryText, ),
                    JPText(text: 'amount'.tr, textSize: JPTextSize.heading5, textColor: JPAppTheme.themeColors.secondaryText,),
                  ],
                ),
              ),

              Material(
                borderRadius: BorderRadius.circular(20),
                child: Shimmer.fromColors(
                  baseColor: JPAppTheme.themeColors.dimGray,
                  highlightColor: JPAppTheme.themeColors.inverse,
                  child: Column(
                    children: [
                      itemTile(),
                      Divider(
                        height: 2,
                        thickness: 1,
                        color: JPAppTheme.themeColors.dimGray,
                      ),
                      itemTile(limitedContent: true),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              summary(),
              const SizedBox(height: 20,),

              Material(
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Shimmer.fromColors(
                    baseColor: JPAppTheme.themeColors.dimGray,
                    highlightColor: JPAppTheme.themeColors.inverse,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        shimmerBox(height: 10, width: 100),
                        const SizedBox(height: 10),
                        shimmerBox(height: 8, width: double.maxFinite),
                        const SizedBox(height: 5),
                        shimmerBox(height: 7, width: double.maxFinite),
                        const SizedBox(height: 5),
                        shimmerBox(height: 6, width: 150),
                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),

        ],
      )
    );
  }

  Widget header() {
    return Material(
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 22
        ),
        child: Shimmer.fromColors(
          baseColor: JPAppTheme.themeColors.dimGray,
          highlightColor: JPAppTheme.themeColors.inverse,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              shimmerBox(height: 12, width: 180),
              const SizedBox(height: 3,),
              shimmerBox(height: 6, width: 200),
              const SizedBox(height: 16,),
              Row(
                children: [
                  Expanded(child: textField()),
                  const SizedBox(width: 16,),
                  Expanded(child: textField()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textField({bool showTwoFields = false}) {
    return Row(
      children: [
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: shimmerBox(height: 6, width: 100),
            ),
            const SizedBox(
              height: 4,
            ),
            shimmerBox(height: 40, width: double.maxFinite, borderRadius: 10)
          ],
        )),

        if(showTwoFields) ...{
          const SizedBox(width: 16),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: shimmerBox(height: 6, width: 100),
              ),
              const SizedBox(
                height: 4,
              ),
              shimmerBox(height: 40, width: double.maxFinite, borderRadius: 10)
            ],
          )),
        }
      ],
    );
  }

  Widget itemTile({bool limitedContent = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 22
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          JPIcon(Icons.drag_indicator_outlined, size: 18, color: JPAppTheme.themeColors.secondaryText,),
          const SizedBox(width: 8,),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                right: 12
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            shimmerBox(height: 6, width: 100),
                            const SizedBox(height: 4,),
                            shimmerBox(height: 10, width: 120)
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            JPText(
                              text: JobFinancialHelper.getCurrencyFormattedValue(value: '0'),
                              height: 0.8,
                            ),
                            const SizedBox(height: 4,),
                            JPText(
                              text: "${JobFinancialHelper.getCurrencyFormattedValue(value: '0')} x 0 Sq/m",
                              textSize: JPTextSize.heading6,
                              height: 0.8,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  shimmerBox(height: 7, width: double.maxFinite),
                  const SizedBox(height: 4),
                  shimmerBox(height: 6, width: double.maxFinite),
                  const SizedBox(height: 4),
                  shimmerBox(height: 6, width: double.maxFinite),
                  const SizedBox(height: 4),
                  shimmerBox(height: 5, width: 100),
                  const SizedBox(height: 12),
                  itemContent(),
                  if (!limitedContent) ...{
                    const SizedBox(height: 10),
                    itemContent(),
                  },
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget itemContent() {
    return Row(
      children: [
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            shimmerBox(height: 7, width: 120),
            const SizedBox(height: 2,),
            shimmerBox(height: 4, width: 90),
          ],
        )),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            shimmerBox(height: 7, width: 100),
            const SizedBox(height: 2,),
            shimmerBox(height: 4, width: 70),
          ],
        )),
      ],
    );
  }

  Widget summary() {
    return Material(
      color: JPAppTheme.themeColors.lightBlue.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(16),
      child: Shimmer.fromColors(
        baseColor: JPAppTheme.themeColors.secondaryText.withValues(alpha: 0.7),
        highlightColor: JPAppTheme.themeColors.inverse,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              summaryTile(),
              const SizedBox(height: 10,),
              summaryTile(width: 150),
              const SizedBox(height: 10,),
              summaryTile(),
              const SizedBox(height: 10,),
              summaryTile(width: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget summaryTile({
    double width = 100,
}) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              shimmerBox(height: 7, width: width),
              const SizedBox(height: 2,),
              shimmerBox(height: 4, width: width - 30),
            ],
          ),
        ),
        const Spacer(),
        JPText(
          text: JobFinancialHelper.getCurrencyFormattedValue(value: '0'),
          textSize: JPTextSize.heading5,
        ),
      ],
    );
  }

  Widget shimmerBox({
    required double height,
    required double width,
    double borderRadius = 4
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: JPAppTheme.themeColors.dimGray,
      ),
    );
  }

}

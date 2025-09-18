import 'package:flutter/material.dart';
import 'package:jobprogress/modules/clock_summary/listing/widgets/show_clock_summary_hours.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class ClockSummaryGroupByListShimmer extends StatelessWidget {
  const ClockSummaryGroupByListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 15,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Shimmer.fromColors(
                  baseColor: JPAppTheme.themeColors.dimGray,
                  highlightColor: JPAppTheme.themeColors.inverse,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: JPAppTheme.themeColors.lightBlue
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 8,
                              width: 150,
                              color: JPAppTheme.themeColors.inverse,
                            ),

                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8
                              ),
                              child: Container(
                                height: 7,
                                width: 80,
                                color: JPAppTheme.themeColors.inverse,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      const ShowClockSummaryHours(
                        isShimmer: true,
                      ),
                    ],
                  ),
                )
              ),
              Divider(
                height: 1,
                thickness: 1,
                indent: 62,
                color: JPAppTheme.themeColors.dimGray,
              ),
            ],
          );
        },
      ),
    );
  }
}

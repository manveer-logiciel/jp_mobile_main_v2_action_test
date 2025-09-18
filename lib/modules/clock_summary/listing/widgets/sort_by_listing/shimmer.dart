import 'package:flutter/material.dart';
import 'package:jobprogress/modules/clock_summary/listing/widgets/show_clock_summary_hours.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class ClockSummarySortByListShimmer extends StatelessWidget {
  const ClockSummarySortByListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 10,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Shimmer.fromColors(
            baseColor: JPAppTheme.themeColors.dimGray,
            highlightColor: JPAppTheme.themeColors.inverse,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 16
                  ),
                  child: Container(
                    width: 170,
                    height: 8,
                    color: JPAppTheme.themeColors.dimGray,
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 15
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 16,
                      ),
                      JPAvatar(
                        height: 42,
                        width: 42,
                        radius: 21,
                        backgroundColor: JPAppTheme.themeColors.success,
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      Container(
                                        width: 150,
                                        height: 8,
                                        color: JPAppTheme.themeColors.dimGray,
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Wrap(
                                        children: [
                                          Container(
                                            width: 50,
                                            height: 7,
                                            color: JPAppTheme.themeColors.dimGray,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Container(
                                            width: 60,
                                            height: 7,
                                            color: JPAppTheme.themeColors.dimGray,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                    ],
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(
                                      top: 10
                                  ),
                                  child: ShowClockSummaryHours(
                                    isShimmer: true,
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                              ],
                            ),
                            Divider(
                              height: 1,
                              thickness: 1,
                              color: JPAppTheme.themeColors.dimGray,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          );
        },
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:jobprogress/modules/clock_summary/listing/widgets/show_clock_summary_hours.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class TimeLogDetailsHeaderShimmer extends StatelessWidget {
  const TimeLogDetailsHeaderShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 16
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
                    Container(
                      height: 12,
                      width: 120,
                      color: JPAppTheme.themeColors.dimGray,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 8,
                      width: 180,
                      color: JPAppTheme.themeColors.dimGray,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              const ShowClockSummaryHours(
                isShimmer: true,
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 6,
            width: double.maxFinite,
            color: JPAppTheme.themeColors.dimGray,
          ),
          const SizedBox(
            height: 4,
          ),
          Container(
            height: 6,
            width: 100,
            color: JPAppTheme.themeColors.dimGray,
          ),
        ],
      ),
    );
  }
}

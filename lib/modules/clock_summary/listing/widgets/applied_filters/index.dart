
import 'package:flutter/material.dart';
import 'package:jobprogress/modules/clock_summary/listing/widgets/applied_filters/shimmer.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ClockSummaryAppliedFiltersList extends StatelessWidget {

  const ClockSummaryAppliedFiltersList({super.key, required this.filters, this.isShimmer = false});

  final List<String> filters; // will contain name of all applied filters

  final bool isShimmer; // used to display shimmer default value is [false]

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 16
      ),
      child: Wrap(
        runSpacing: 5,
        spacing: 5,
        alignment: WrapAlignment.start,
        runAlignment: WrapAlignment.start,
        children: List.generate(filters.length, (index) {

          String filter = filters[index];

          if(isShimmer) {
            return ClockSummaryAppliedFiltersShimmer(
              index: index,
            );
          } else {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                  color: JPAppTheme.themeColors.inverse,
                  borderRadius: BorderRadius.circular(20)
              ),
              child: JPText(
                text: filter,
                textSize: JPTextSize.heading5,
                textAlign: TextAlign.start,
                maxLine: 1,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }
        }),
      ),
    );
  }
}

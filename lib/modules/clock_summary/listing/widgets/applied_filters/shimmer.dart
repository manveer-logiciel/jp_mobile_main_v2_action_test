
import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class ClockSummaryAppliedFiltersShimmer extends StatelessWidget {

  const ClockSummaryAppliedFiltersShimmer({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: JPAppTheme.themeColors.dimGray,
        highlightColor: JPAppTheme.themeColors.inverse,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 5,
        ),
        width: index % 2 == 0 ? 80 : 120,
        height: 25,
        decoration: BoxDecoration(
            color: JPAppTheme.themeColors.inverse,
            borderRadius: BorderRadius.circular(20)
        ),
      )
    );
  }
}

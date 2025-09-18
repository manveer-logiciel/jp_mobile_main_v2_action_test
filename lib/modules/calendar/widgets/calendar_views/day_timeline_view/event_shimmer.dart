
import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class CalendarDayTimelineEventShimmer extends StatelessWidget {
  const CalendarDayTimelineEventShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: JPAppTheme.themeColors.dimGray,
      highlightColor: JPAppTheme.themeColors.inverse,
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 8, 16, 8),
        decoration: BoxDecoration(
          color: JPAppTheme.themeColors.dimGray,
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}

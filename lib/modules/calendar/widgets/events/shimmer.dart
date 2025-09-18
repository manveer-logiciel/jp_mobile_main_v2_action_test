import 'package:flutter/material.dart';
import 'package:jobprogress/modules/calendar/widgets/events/event_tile/shimmer.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class CalendarEventsShimmer extends StatelessWidget {
  const CalendarEventsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Shimmer.fromColors(
        baseColor: JPAppTheme.themeColors.dimGray,
        highlightColor: JPAppTheme.themeColors.inverse,
        child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (_, index) {
            return const CalendarEventShimmerTile();
          },
          separatorBuilder: (_, index) {
            return Divider(
              height: 1,
              thickness: 1,
              color: JPAppTheme.themeColors.dimGray,
            );
          },
          itemCount: 10,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class ScheduleListingShimmer extends StatelessWidget {
  const ScheduleListingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 10,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10, left: 16, right: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: JPAppTheme.themeColors.base,
          ),
          child: Shimmer.fromColors(
              baseColor: JPAppTheme.themeColors.dimGray,
              highlightColor: JPAppTheme.themeColors.inverse,
              child: scheduleTile()),
        );
      },
    );
  }

  Widget scheduleTile() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          shimmerBox(height: 10, width: double.maxFinite),
          const SizedBox(height: 4,),
          shimmerBox(height: 5, width: 250),

          const SizedBox(height: 10,),
          shimmerBox(height: 8, width: double.maxFinite),
          const SizedBox(height: 5,),
          shimmerBox(height: 7, width: double.maxFinite),
          const SizedBox(height: 5,),
          shimmerBox(height: 6, width: double.maxFinite),
          const SizedBox(height: 5,),
          shimmerBox(height: 5, width: 200),

          const SizedBox(height: 10,),

          Row(
            children: [
              shimmerBox(height: 12, width: 12, borderRadius: 7),
              const SizedBox(width: 5),
              shimmerBox(height: 7, width: 60),
              const SizedBox(width: 12),

              shimmerBox(height: 12, width: 12, borderRadius: 7),
              const SizedBox(width: 5),
              shimmerBox(height: 7, width: 60),
              const SizedBox(width: 12),

              shimmerBox(height: 12, width: 12, borderRadius: 7),
              const SizedBox(width: 5),
              shimmerBox(height: 7, width: 60),
            ],
          )
        ],
      ),
    );
  }

  Widget shimmerBox({
    required double height,
    required double width,
    double borderRadius = 3
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
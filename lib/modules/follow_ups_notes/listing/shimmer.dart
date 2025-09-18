
import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';
import 'package:shimmer/shimmer.dart';

class FollowUpsShimmer extends StatelessWidget {
  const FollowUpsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Shimmer.fromColors(
          baseColor: JPAppTheme.themeColors.dimGray,
          highlightColor: JPAppTheme.themeColors.inverse,
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
              itemBuilder: (_, __) => tile(),
              separatorBuilder: (_, __) => Divider(indent: 65, thickness: 1, height: 5, color: JPAppTheme.themeColors.dimGray,),
              itemCount: 12,
          )
      ),
    );
  }

  Widget tile() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          shimmerBox(height: 36, width: 36, borderRadius: 18),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                shimmerBox(height: 10, width: 100),
                const SizedBox(
                  height: 12,
                ),
                shimmerBox(height: 6, width: double.maxFinite),
                const SizedBox(
                  height: 8,
                ),
                shimmerBox(height: 6, width: double.maxFinite),
                const SizedBox(
                  height: 8,
                ),
                shimmerBox(height: 6, width: double.maxFinite),
                const SizedBox(
                  height: 8,
                ),
                shimmerBox(height: 6, width: 150),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    shimmerBox(height: 8, width: 140),
                  ],
                )
              ],
            ),
          ),
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

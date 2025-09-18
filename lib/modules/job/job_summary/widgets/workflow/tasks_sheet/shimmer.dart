import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class JobOverViewTasksShimmer extends StatelessWidget {
  const JobOverViewTasksShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: JPAppTheme.themeColors.dimGray,
      highlightColor: JPAppTheme.themeColors.inverse,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
            itemBuilder: (_, __) {
              return tileShimmer();
            }, itemCount: 2),
      ),
    );
  }

  Widget tileShimmer() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        shimmerBox(height: 30, width: 30, borderRadius: 8),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 5,
              ),
              shimmerBox(height: 10, width: double.maxFinite),
              const SizedBox(
                height: 10,
              ),
              shimmerBox(height: 6, width: 150),
              const SizedBox(
                height: 8,
              ),
              shimmerBox(height: 6, width: double.maxFinite),
              const SizedBox(
                height: 8,
              ),
              shimmerBox(height: 6, width: 200),
              const SizedBox(
                height: 8,
              ),
              shimmerBox(height: 6, width: 120),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  shimmerBox(
                    height: 20,
                    width: 20,
                    borderRadius: 10,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  shimmerBox(height: 8, width: 60),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              shimmerBox(height: 1, width: double.maxFinite),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ],
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
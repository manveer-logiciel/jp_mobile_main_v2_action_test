
import 'package:flutter/material.dart';
import 'package:jobprogress/global_widgets/profile_image_widget/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class AppointmentDetailsCardShimmer extends StatelessWidget {
  const AppointmentDetailsCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(18),
      child: Shimmer.fromColors(
          baseColor: JPAppTheme.themeColors.dimGray,
          highlightColor: JPAppTheme.themeColors.inverse,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 20
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: shimmerBox(height: 14, width: double.maxFinite),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    shimmerBox(height: 24, width: 24, borderRadius: 14),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    shimmerBox(height: 8, width: double.maxFinite),
                    const SizedBox(height: 2,),
                    shimmerBox(height: 8, width: 100),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),

                shimmerBox(height: 14, width: 150),
                const SizedBox(
                  height: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    shimmerBox(height: 8, width: double.maxFinite),
                    const SizedBox(height: 4,),
                    shimmerBox(height: 8, width: double.maxFinite),
                    const SizedBox(height: 4,),
                    shimmerBox(height: 8, width: double.maxFinite),
                    const SizedBox(height: 4,),
                    shimmerBox(height: 8, width: 130),
                  ],
                ),

                const SizedBox(
                  height: 26,
                ),
                detailTileShimmer(),
                const SizedBox(
                  height: 20,
                ),
                detailTileShimmer(),
                const SizedBox(
                  height: 20,
                ),
                detailTileShimmer(),
                const SizedBox(
                  height: 20,
                ),
                detailTileShimmer(),
                const SizedBox(
                  height: 22,
                ),
                attendeesShimmer(),
              ],
            ),
          )
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

  Widget detailTileShimmer() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      textBaseline: TextBaseline.alphabetic,
      children: [
        shimmerBox(height: 28, width: 28, borderRadius: 8),
        const SizedBox(
          width: 14,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              shimmerBox(height: 10, width: double.maxFinite),
              const SizedBox(height: 6,),
              shimmerBox(height: 8, width: 120),
            ],
          ),
        ),
      ],
    );
  }

  Widget attendeesShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        shimmerBox(height: 8, width: 100),
        const SizedBox(
          height: 12,
        ),
        Wrap(
          runSpacing: 6,
          spacing: 5,
          children: List.generate(5, (index) {
              return const JPChip(
                  child: JPProfileImage(
                    initial: 'QQ',
                  )
              );
          }),
        )
      ],
    );
  }
}

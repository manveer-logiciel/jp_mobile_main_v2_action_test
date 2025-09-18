import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class GroupListingShimmer extends StatelessWidget {
  const GroupListingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Shimmer.fromColors(
        baseColor: JPAppTheme.themeColors.dimGray,
        highlightColor: JPAppTheme.themeColors.inverse,
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            vertical: 16
          ),
            itemBuilder: (_, __) {
              return tileShimmer();
            }, itemCount: 20),
      ),
    );
  }

  Widget tileShimmer() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              shimmerBox(height: 42, width: 42, borderRadius: 21),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    shimmerBox(
                      height: 8,
                      width: double.maxFinite,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              shimmerBox(
                                height: 6,
                                width: double.maxFinite,
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              shimmerBox(
                                height: 4,
                                width: 100,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        shimmerBox(
                            height: 18, width: 18, borderRadius: 9)
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Divider(
          color: JPAppTheme.themeColors.dimGray,
          indent: 72,
          thickness: 1,
          height: 25,
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

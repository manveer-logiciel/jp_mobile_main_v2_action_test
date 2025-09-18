
import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class JPNetworkSingleSelectShimmer extends StatelessWidget {
  const JPNetworkSingleSelectShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: JPAppTheme.themeColors.base,
      child: Shimmer.fromColors(
          baseColor: JPAppTheme.themeColors.dimGray,
          highlightColor: JPAppTheme.themeColors.inverse,
          child: ListView.builder(
              itemCount: 20,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_ ,__) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 20
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              shimmerBox(
                                height: 8, width: double.maxFinite,
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              shimmerBox(
                                height: 4, width: 100,
                              ),
                            ],
                          ),
                      ),
                      const SizedBox(
                        width: 100,
                      ),
                    ],
                  ),
                );
              },
            // shrinkWrap: true,
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

  Widget additionalTileShimmer() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                shimmerBox(height: 6, width: 60),
                const SizedBox(
                  height: 8,
                ),
                shimmerBox(height: 9, width: double.maxFinite),
              ],
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

}

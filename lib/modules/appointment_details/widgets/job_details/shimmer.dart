
import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class AppointmentJobDetailsShimmer extends StatelessWidget {
  const AppointmentJobDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(18),
      child: Shimmer.fromColors(
          baseColor: JPAppTheme.themeColors.dimGray,
          highlightColor: JPAppTheme.themeColors.inverse,
          child: Column(
            children: [
              phoneTileShimmer(),
              const Divider(
                thickness: 2,
                height: 2,
              ),
              phoneTileShimmer(),
              const Divider(
                thickness: 2,
                height: 2,
              ),
              emailTileShimmer(),
              const Divider(
                thickness: 2,
                height: 2,
              ),
              additionalTileShimmer(),
              const Divider(
                thickness: 2,
                height: 2,
              ),
              additionalTileShimmer(),
            ],
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

  Widget phoneTileShimmer() {
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
           const Row(
            children: [
              JPIcon(Icons.phone),
              SizedBox(
                width: 12,
              ),
              JPIcon(Icons.sms),
            ],
          ),
        ],
      ),
    );
  }

  Widget emailTileShimmer() {
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
           const Row(
            children: [
              JPIcon(Icons.email),
            ],
          ),
        ],
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

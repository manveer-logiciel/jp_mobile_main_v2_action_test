
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class JobOverViewSecondaryHeaderPlaceholder extends StatelessWidget {
  const JobOverViewSecondaryHeaderPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: JPAppTheme.themeColors.base.withValues(alpha: 0.2),
      highlightColor: JPAppTheme.themeColors.secondary,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 3
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                shimmerBox(
                  height: 6,
                  width: 70,
                ),
                const SizedBox(
                  height: 5,
                ),
                shimmerBox(
                  height: 3,
                  width: 70,
                ),
              ],
            ),
            const JPIcon(
              Icons.arrow_drop_down
            ),
            const Spacer(),

            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                shimmerBox(
                  height: 6,
                  width: Get.width * 0.19,
                ),
                const SizedBox(
                  height: 5,
                ),
                shimmerBox(
                  height: 3,
                  width: Get.width * 0.19,
                ),
              ],
            ),
            const JPIcon(
                Icons.arrow_drop_down
            ),
          ],
        ),
      ),
    );
  }


  Widget shimmerBox(
      {required double height,
        required double width,
        double borderRadius = 3}) {
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


import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class AppointmentDetailsAttachmentShimmer extends StatelessWidget {
  const AppointmentDetailsAttachmentShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(18),
      child: Shimmer.fromColors(
          baseColor: JPAppTheme.themeColors.dimGray,
          highlightColor: JPAppTheme.themeColors.inverse,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
                child: shimmerBox(height: 12, width: 150),
              ),

              attachmentTileShimmer(),
              const Divider(
                thickness: 2,
                height: 2,
                indent: 50,
              ),
              attachmentTileShimmer(),
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

  Widget attachmentTileShimmer() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Row(
        children: [
          shimmerBox(height: 24, width: 24, borderRadius: 6),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                shimmerBox(height: 9, width: double.maxFinite),
              ],
            ),
          ),
          const SizedBox(
            width: 100,
          ),
          const JPIcon(Icons.remove_red_eye_outlined),
        ],
      ),
    );
  }

}

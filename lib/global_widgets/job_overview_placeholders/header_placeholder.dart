import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class JobOverViewHeaderPlaceHolder extends StatelessWidget {
  const JobOverViewHeaderPlaceHolder({
    super.key,
    this.hightlightColor,
    this.baseColor,
    });
  final Color? hightlightColor;
  final Color? baseColor;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? JPAppTheme.themeColors.base.withValues(alpha: 0.2),
      highlightColor:hightlightColor?? JPAppTheme.themeColors.secondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          shimmerBox(
            height: 6,
            width: 180,
          ),
          const SizedBox(
            height: 5,
          ),
          shimmerBox(
            height: 3,
            width: 100,
          ),
        ],
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

import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class TimeLineTileEventShimmer extends StatelessWidget {
  const TimeLineTileEventShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 5
        ),
        margin: const EdgeInsets.only(
          left: 18,
          right: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: JPAppTheme.themeColors.dimGray.withValues(alpha: 0.3),
        ),
        child: Shimmer.fromColors(
          baseColor: JPAppTheme.themeColors.dimGray,
          highlightColor: JPAppTheme.themeColors.inverse,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    shimmerBox(height: 5, width: 200),
                    const SizedBox(height: 2,),
                    shimmerBox(height: 3, width: 150),
                  ],
                ),
              ),
              shimmerBox(height: 5, width: 50),
            ],
          ),
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

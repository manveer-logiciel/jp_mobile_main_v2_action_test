import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/Label/type.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class JPSingleFieldShimmer extends StatelessWidget {

  final double? height;
  final double? width;
  final Widget? child;

  const JPSingleFieldShimmer({
    super.key,
    this.height = 14,
    this.width = 50,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: JPAppTheme.themeColors.dimGray,
      highlightColor: JPAppTheme.themeColors.inverse,
      child: child ?? Container(
        padding: EdgeInsets.zero,
        height: height,
        width: width,
        child:  const JPLabel(
          text: " ",
          type: JPLabelType.lightGray,
        ),
      ),
    );
  }
}

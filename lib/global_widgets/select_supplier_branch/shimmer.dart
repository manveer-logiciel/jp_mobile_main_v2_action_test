
import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class SelectSrsBranchShimmer extends StatelessWidget {
  const SelectSrsBranchShimmer({
    super.key,
    this.showOneField = false,
    this.showThreeField = false,
  });

  final bool showOneField;
  final bool showThreeField;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: JPAppTheme.themeColors.dimGray,
      highlightColor: JPAppTheme.themeColors.inverse,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!showOneField) ...{
            textField(),
          },
          const SizedBox(height: 20),
          textField(),
          if (showThreeField) ...{
            const SizedBox(height: 20),
            textField(),
          },
        ],
      ),
    );
  }

  Widget textField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: shimmerBox(height: 6, width: 100),
        ),
        const SizedBox(
          height: 4,
        ),
        shimmerBox(height: 40, width: double.maxFinite, borderRadius: 10)
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

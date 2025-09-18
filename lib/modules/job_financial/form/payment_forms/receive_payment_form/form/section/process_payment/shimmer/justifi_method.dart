import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';
import 'package:shimmer/shimmer.dart';

class ProcessPaymentJustifiShimmer extends StatelessWidget {
  const ProcessPaymentJustifiShimmer({
    this.isDebitCardSelected = true,
    super.key,
  });

  final bool isDebitCardSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8
      ),
      child: Shimmer.fromColors(
        baseColor: JPAppTheme.themeColors.dimGray,
        highlightColor: JPAppTheme.themeColors.inverse,
        child: Column(
          children: [
            const SizedBox(height: 8),
            justifyField(),
            const SizedBox(height: 16),
            if (isDebitCardSelected) ... {
              Row(
                children: [
                  Expanded(child: justifyField()),
                  const SizedBox(width: 12),
                  Expanded(child: justifyField(),),
                  const SizedBox(width: 12),
                  Expanded(child: justifyField(),),
                ],
              )
            } else ...{
              justifyField(),
            },
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget justifyField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        shimmerBox(height: 10, width: 80, borderRadius: 8),
        const SizedBox(height: 8),
        shimmerBox(height: 40, width: double.maxFinite, borderRadius: 8)
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

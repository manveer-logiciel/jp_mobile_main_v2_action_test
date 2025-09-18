
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class JobOverViewDetailsShimmer extends StatelessWidget {
  const JobOverViewDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: JPAppTheme.themeColors.base,
      child: Shimmer.fromColors(
        baseColor: JPAppTheme.themeColors.dimGray,
        highlightColor: JPAppTheme.themeColors.inverse,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
                bottom: 10,
                right: 12,
                left: 16
              ),
              child: Row(
                children: [
                  Flexible(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Row(
                        children: [
                          Expanded(
                            child: shimmerBox(
                                height: 20, width: double.maxFinite),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: shimmerBox(
                                height: 20, width: double.maxFinite),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: shimmerBox(
                                height: 20, width: double.maxFinite),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(
                    width: 10,
                  ),
                  const JPIcon(Icons.keyboard_arrow_down)
                ],
              ),
            ),
            shimmerBox(height: 1, width: double.maxFinite),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        shimmerBox(height: 6, width: 100),
                        const SizedBox(
                          height: 8,
                        ),
                        shimmerBox(height: 8, width: double.maxFinite),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 80,
                  ),
                  const JPTextButton(
                    icon: Icons.location_on,
                    iconSize: 24,
                    padding: 0,
                  )
                ],
              ),
            ),
            shimmerBox(height: 1, width: double.maxFinite),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  shimmerBox(height: 6, width: 100),
                  const SizedBox(
                    height: 8,
                  ),
                  shimmerBox(height: 8, width: double.maxFinite),
                  const SizedBox(
                    height: 5,
                  ),
                  shimmerBox(height: 8, width: double.maxFinite),
                  const SizedBox(
                    height: 5,
                  ),
                  shimmerBox(height: 8, width: 150),
                ],
              ),
            ),
            shimmerBox(height: 1, width: double.maxFinite),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  JPButton(
                    size: JPButtonSize.extraSmall,
                    text: 'view_more'.tr,
                    textColor: JPAppTheme.themeColors.primary,
                  )
                ],
              ),
            ),
          ],
        ),
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
}

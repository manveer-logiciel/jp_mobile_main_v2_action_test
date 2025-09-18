
import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class PlaceSrsOrderFormShimmer extends StatelessWidget {
  const PlaceSrsOrderFormShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),
          section(
            isOpened: true, 
            child: shimmerBox(height: 100, width: double.maxFinite, borderRadius: 8),
          ),
          const SizedBox(height: 16),
          section(
            isOpened: true,
            child: Column(
              children: [
                textField(),
                const SizedBox(height: 16),
                textField(),
                const SizedBox(height: 16),
                textField(),
                const SizedBox(height: 16),
                textField(),
                const SizedBox(height: 16),
                textField(showTwoFields: true),
              ],
            ),
          ),
          const SizedBox(height: 16),
          section(
            isOpened: true,
            child: textField(),
          ),
          const SizedBox(height: 16),
          section(
            isOpened: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                textField(),
                const SizedBox(height: 16),
                shimmerBox(height: 16, width: 150),
                const SizedBox(height: 16),
                textField(),
                const SizedBox(height: 16),
                textField(),
                const SizedBox(height: 16),
                shimmerBox(height: 16, width: 150),
                const SizedBox(height: 16),
                radioButton(showTwoFields: true),
                const SizedBox(height: 16),
                textField(),
                const SizedBox(height: 16),
                textField(height: 100),
                const SizedBox(height: 8),
              ],
            ),
          ),
          const SizedBox(height: 24),
          shimmerBox(height: 40, width: 150, borderRadius: 25),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget section({bool isOpened = false, Widget? child}) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Shimmer.fromColors(
          baseColor: JPAppTheme.themeColors.dimGray,
          highlightColor: JPAppTheme.themeColors.inverse,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  shimmerBox(height: 15, width: 200),
                  const Spacer(),
                  Icon(isOpened ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                ],
              ),
              if (isOpened && child != null) ...[
                const SizedBox(height: 16),
                Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: child),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget textField({bool showTwoFields = false, double height = 40}) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: shimmerBox(height: 6, width: 100),
              ),
              const SizedBox(height: 4),
              shimmerBox(height: height, width: double.maxFinite, borderRadius: 10)
            ],
          ),
        ),
        if (showTwoFields) ...{
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: shimmerBox(height: 6, width: 100),
                ),
                const SizedBox(height: 4),
                shimmerBox(height: height, width: double.maxFinite, borderRadius: 10)
              ],
            ),
          ),
        }
      ],
    );
  }
  
  Widget radioButton({bool showTwoFields = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: shimmerBox(height: 20, width: 20, borderRadius: 20),
              ),
              shimmerBox(height: 10, width: 100, borderRadius: 10)
            ],
          ),
        ),
        if (showTwoFields) ...{
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: shimmerBox(height: 20, width: 20, borderRadius: 20),
                ),
                const SizedBox(height: 4),
                shimmerBox(height: 10, width: 100, borderRadius: 10)
              ],
            ),
          ),
        }
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

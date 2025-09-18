
import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class CustomerFormShimmer extends StatelessWidget {
  const CustomerFormShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 16,),
          section(),
          const SizedBox(height: 16,),
          section(),
          const SizedBox(height: 16,),
          shimmerBox(height: 50, width: 200, borderRadius: 25)
        ],
      ),
    );
  }

  Widget section() {
    return Material(
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16
        ),
        child: Shimmer.fromColors(
          baseColor: JPAppTheme.themeColors.dimGray,
          highlightColor: JPAppTheme.themeColors.inverse,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          shimmerBox(height: 12, width: 200),
                          const SizedBox(
                            height: 4,
                          ),
                          shimmerBox(height: 6, width: 150),
                        ],
                      ),
                  ),
                  const Icon(Icons.keyboard_arrow_down),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              textField(),
              const SizedBox(
                height: 16,
              ),
              textField(),
              const SizedBox(
                height: 16,
              ),
              textField(showTwoFields: true),
              const SizedBox(
                height: 16,
              ),
              textField(),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textField({bool showTwoFields = false}) {
    return Row(
      children: [
        Expanded(child: Column(
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
        )),

        if(showTwoFields) ...{
          const SizedBox(width: 16),
          Expanded(child: Column(
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
          )),
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

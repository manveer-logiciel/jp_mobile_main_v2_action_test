import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class ProjectFormShimmer extends StatelessWidget {
  const ProjectFormShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          section(),
          const SizedBox(
            height: 16,
          ),
          shimmerBox(height: 50, width: 200, borderRadius: 25)
        ],
      ),
    );
  }

  Widget section() {
    return Material(
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Shimmer.fromColors(
          baseColor: JPAppTheme.themeColors.dimGray,
          highlightColor: JPAppTheme.themeColors.inverse,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              checkBox(showTwoFields: true),
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
              textField(),
              const SizedBox(
                height: 16,
              ),
              textField(),
              const SizedBox(
                height: 16,
              ),
              textField(isMultiLine: true),
              const SizedBox(
                height: 16,
              ),
              textField(),
              const SizedBox(
                height: 16,
              ),
              durationTextField(),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget durationTextField() {
    return Row(
      children: [
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                shimmerBox(height: 6, width: 100),
                const SizedBox(
                  width: 2,
                ),
                const Icon(Icons.info_outline),
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            SizedBox(
              width: double.maxFinite,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  shimmerBox(height: 40, width: 110, borderRadius: 10),
                  shimmerBox(height: 40, width: 110, borderRadius: 10),
                  shimmerBox(height: 40, width: 110, borderRadius: 10),
                ],
              ),
            )
          ],
        )),
      ],
    );
  }

  Widget textField({bool showTwoFields = false, bool isMultiLine = false}) {
    return Row(
      children: [
        if (isMultiLine)
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: shimmerBox(height: 6, width: 100),
              ),
              const SizedBox(
                height: 4,
              ),
              shimmerBox(height: 90, width: double.maxFinite, borderRadius: 10),
              const SizedBox(
                height: 8,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: shimmerBox(height: 6, width: 80, borderRadius: 10),
              )
            ],
          ))
        else
          Expanded(
              child: Column(
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

  Widget checkBox({bool showTwoFields = false}) {
    return SizedBox(
      width: double.maxFinite,
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                shimmerBox(height: 7, width: 100, borderRadius: 10),
                const SizedBox(width: 80,),
                Expanded(
                  child: Row(
                    children: [
                      shimmerBox(height: 20, width: 20),
                      const SizedBox(
                        width: 6,
                      ),
                      Expanded(child: shimmerBox(height: 10, width: 50, borderRadius: 10))
                    ],
                  ),
                ),
                if (showTwoFields) ...{
                  const SizedBox(width: 16),
                  Expanded(
                    child: Row(
                      children: [
                        shimmerBox(height: 20, width: 20),
                        const SizedBox(
                          width: 6,
                        ),
                        Expanded(child: shimmerBox(height: 10, width: 50, borderRadius: 10))
                      ],
                    ),
                  )
                }
              ],
            ),
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

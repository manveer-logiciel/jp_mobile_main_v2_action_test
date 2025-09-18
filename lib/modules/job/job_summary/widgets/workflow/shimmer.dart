
import 'package:flutter/material.dart';
import 'package:jobprogress/global_widgets/listview/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';
import 'card_painter.dart';

class JobOverViewWorkFlowShimmer extends StatelessWidget {
  const JobOverViewWorkFlowShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: JPAppTheme.themeColors.base,
      child: Shimmer.fromColors(
          baseColor: JPAppTheme.themeColors.dimGray,
          highlightColor: JPAppTheme.themeColors.inverse,
        child: Column(
          children: [
            header(),
            stages(),
            Divider(
              thickness: 1,
              height: 1,
              color: JPAppTheme.themeColors.dimGray,
            ),
            count(),
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

  Widget header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        children: [
          /// title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                shimmerBox(
                    height: 8,
                    width: double.maxFinite,
                ),

                const SizedBox(
                  height: 5,
                ),

                shimmerBox(
                  height: 6,
                  width: 100,
                )
              ],
            ),
          ),

          const SizedBox(
            width: 50,
          ),

          /// amount
          shimmerBox(
            height: 25,
            width: 70,
            borderRadius: 20
          )
        ],
      ),
    );
  }

  Widget stages() {
    return SizedBox(
      height: 165,
      child: Stack(
        children: [

          Positioned.fill(
              top: 84,
              child: Column(
                children: [
                  Divider(
                    height: 2,
                    thickness: 2,
                    color: JPAppTheme.themeColors.dimGray,
                  ),
                ],
              )
          ),

          Column(
            children: [
              JPListView(
                listCount: 10,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                    horizontal: 12
                ),
                itemBuilder: (_, index) {
                  return stageCard(index);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget stageCard(int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 66,
          width: 91,
          child: CustomPaint(
            painter: WorkFlowStageCardPainter(JPAppTheme.themeColors.dimGray, true),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  shimmerBox(
                      height: 6,
                      width: 70,

                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  shimmerBox(
                    height: 4,
                    width: 50,
                  )
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        SizedBox(
          width: 105,
          child: Column(
            children: [
              Container(
                height: 14,
                width: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: JPAppTheme.themeColors.base,
                  border: Border.all(
                      color: JPAppTheme.themeColors.dimGray,
                      width: 2
                  ),
                ),
                child: null,
              ),

              const SizedBox(
                height: 12,
              ),

              shimmerBox(
                  height: 6,
                  width: 50,
              ),

              const SizedBox(
                height: 4,
              ),

              if(index == 0)
                JPIcon(
                  Icons.multiple_stop_outlined,
                  color: JPAppTheme.themeColors.dimGray,
                )


            ],
          ),
        )
      ],
    );
  }

  Widget count() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: JPScreen.isMobile ? 400 : 800
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 25,
          ),
          countCard(),
          spacer(),
          countCard(),
          spacer(),
          countCard(),
          spacer(),
          countCard(),
          spacer(),
          countCard(),
          const SizedBox(
            width: 25,
          ),
        ],
      ),
    );
  }

  Widget spacer() => const SizedBox(
    width: 10,
  );

  Widget countCard() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 16),
        child: JPResponsiveBuilder(
          mobile: Column(
            children: [
              /// count
              Padding(
                padding: const EdgeInsets.all(7.0),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: shimmerBox(
                      height: double.maxFinite,
                      width: double.maxFinite,
                      borderRadius: 12
                  ),
                ),
              ),
              /// title
              shimmerBox(height: 6, width: 50)
            ],
          ),
          tablet: SizedBox(
            height: 55,
            child: Row(
              children: [
                /// count
                Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: shimmerBox(
                        height: double.maxFinite,
                        width: double.maxFinite,
                        borderRadius: 12
                    ),
                  ),
                ),

                const SizedBox(
                  width: 5,
                ),
                /// title
                shimmerBox(height: 6, width: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

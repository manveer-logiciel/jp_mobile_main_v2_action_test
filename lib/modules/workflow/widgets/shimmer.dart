import 'package:flutter/material.dart';
import 'package:jobprogress/global_widgets/listview/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class WorkflowShimmer extends StatelessWidget {
  const WorkflowShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    Color shimmerBaseColor = JPAppTheme.themeColors.dimGray;
    Color shimmerHighlightColor = JPAppTheme.themeColors.inverse;

    Widget getStage() {
      return Container(
        margin: const EdgeInsets.only(left: 16, right: 16),
        child: Card(
          elevation: 4,
          shadowColor: JPAppTheme.themeColors.inverse,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6)
          ),
          margin: const EdgeInsets.only(bottom: 10),
          child: InkWell(
            borderRadius: BorderRadius.circular(6),
            child: ClipPath(
              clipper: ShapeBorderClipper(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)
                )
              ),
              child: Shimmer.fromColors(
                baseColor: shimmerBaseColor,
                highlightColor: shimmerHighlightColor,
                child: Container(
                  foregroundDecoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        width: 6,
                        color: shimmerHighlightColor
                      )
                    )
                  ),
                  padding: const EdgeInsets.fromLTRB(22, 16, 15, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Shimmer.fromColors(
                              baseColor: shimmerBaseColor,
                              highlightColor: shimmerHighlightColor,
                              child: shimmerBox(height: 8, width: 60),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Shimmer.fromColors(
                                  baseColor: shimmerBaseColor,
                                  highlightColor: shimmerHighlightColor,
                                  child: shimmerBox(height: 26, width: 80, borderRadius: 50),
                                ),
                                const SizedBox(width: 5,),
                                Shimmer.fromColors(
                                  baseColor: shimmerBaseColor,
                                  highlightColor: shimmerHighlightColor,
                                  child: shimmerBox(height: 26, width: 80, borderRadius: 50),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Shimmer.fromColors(
                        baseColor: shimmerBaseColor,
                        highlightColor: shimmerHighlightColor,
                        child: shimmerBox(height: 10, width: 20)
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      );
    }

    return Column(
      children: [
        const SizedBox(height: 11,),
        JPListView(
          physics: const NeverScrollableScrollPhysics(),
          listCount: 10, 
          itemBuilder: (BuildContext context, int index) { 
            return getStage();  
          },
        )
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
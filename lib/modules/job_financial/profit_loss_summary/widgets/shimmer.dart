import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/Label/type.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class ProfitLossSummaryViewShimmer extends StatelessWidget {
  const ProfitLossSummaryViewShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 3,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: index == 0 ? const EdgeInsets.symmetric(vertical: 15) : const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: JPAppTheme.themeColors.base,
          ),
          child: Shimmer.fromColors(
            baseColor: JPAppTheme.themeColors.dimGray,
            highlightColor: JPAppTheme.themeColors.inverse,
            child: renderShimmerTile(context)),
        );
      });
  }
}

Widget renderShimmerTile(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ///   customer name
        Container(
          padding: EdgeInsets.zero,
          width: 150,
          height: 10,
          child:  const JPLabel(
            text: " ",
            type: JPLabelType.lightGray,
          ),
        ),
        space(),
        space(),
        ///   job price
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.zero,
              width: 120,
              height: 7,
              child:  const JPLabel(
                text: " ",
                type: JPLabelType.lightGray,
              ),
            ),

            Container(
              padding: EdgeInsets.zero,
              width: 70,
              height: 7,
              child:  const JPLabel(
                text: " ",
                type: JPLabelType.lightGray,
              ),
            ),
          ],
        ),
        space(),
        ///   tax
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.zero,
              width: 70,
              height: 7,
              child:  const JPLabel(
                text: " ",
                type: JPLabelType.lightGray,
              ),
            ),

            Container(
              padding: EdgeInsets.zero,
              width: 40,
              height: 7,
              child:  const JPLabel(
                text: " ",
                type: JPLabelType.lightGray,
              ),
            ),
          ],
        ),
        space(),
        ///   change order
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.zero,
              width: 85,
              height: 7,
              child:  const JPLabel(
                text: " ",
                type: JPLabelType.lightGray,
              ),
            ),

            Container(
              padding: EdgeInsets.zero,
              width: 50,
              height: 7,
              child:  const JPLabel(
                text: " ",
                type: JPLabelType.lightGray,
              ),
            ),
          ],
        ),
        space(),
        ///   job price
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.zero,
              width: 120,
              height: 7,
              child:  const JPLabel(
                text: " ",
                type: JPLabelType.lightGray,
              ),
            ),

            Container(
              padding: EdgeInsets.zero,
              width: 60,
              height: 7,
              child:  const JPLabel(
                text: " ",
                type: JPLabelType.lightGray,
              ),
            ),
          ],
        ),
        space(),
        ///   tax
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.zero,
              width: 70,
              height: 7,
              child:  const JPLabel(
                text: " ",
                type: JPLabelType.lightGray,
              ),
            ),

            Container(
              padding: EdgeInsets.zero,
              width: 40,
              height: 7,
              child:  const JPLabel(
                text: " ",
                type: JPLabelType.lightGray,
              ),
            ),
          ],
        ),
        space(),
        ///   change order
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.zero,
              width: 85,
              height: 7,
              child:  const JPLabel(
                text: " ",
                type: JPLabelType.lightGray,
              ),
            ),

            Container(
              padding: EdgeInsets.zero,
              width: 70,
              height: 7,
              child:  const JPLabel(
                text: " ",
                type: JPLabelType.lightGray,
              ),
            ),
          ],
        ),
        space(),
        ///   total price
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.zero,
              width: 110,
              height: 9,
              child:  const JPLabel(
                text: " ",
                type: JPLabelType.lightGray,
              ),
            ),

            Container(
              padding: EdgeInsets.zero,
              width: 50,
              height: 9,
              child:  const JPLabel(
                text: " ",
                type: JPLabelType.lightGray,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget space() => const SizedBox(
  height: 10,
  width: 10,
);

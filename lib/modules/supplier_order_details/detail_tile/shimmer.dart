import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/Label/index.dart';
import 'package:jp_mobile_flutter_ui/Label/type.dart';
import 'package:jp_mobile_flutter_ui/Text/index.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';
import 'package:shimmer/shimmer.dart';

class SrsOrderDetailViewShimmer extends StatelessWidget {
  const SrsOrderDetailViewShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: const EdgeInsets.only(top: 10, bottom: 10, left: 16, right: 16),
          padding: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: JPAppTheme.themeColors.base,
          ),
          child: Shimmer.fromColors(
              baseColor: JPAppTheme.themeColors.dimGray,
              highlightColor: JPAppTheme.themeColors.inverse,
              child: renderShimmerTile(context)),
        );
      },
    );
  }
}
Widget renderShimmerTile(BuildContext context) {
  return Row(
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 20.0,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 16, bottom: 30),
              width: MediaQuery.of(context).size.width - 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.zero,
                        width: 100,
                        height: 18,
                        child:  const JPLabel(
                          text: " ",
                          type: JPLabelType.lightGray,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, bottom: 10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                color: JPAppTheme.themeColors.dimGray,
              ),
              width: 260,
              height: 8,
              child: const JPText(text: ""),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, bottom: 10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                color: JPAppTheme.themeColors.dimGray,
              ),
              width: 240,
              height: 8,
              child: const JPText(text: ""),
            ),
          ],
        ),
      ),
    ],
  );
}


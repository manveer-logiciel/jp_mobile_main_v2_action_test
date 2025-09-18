import 'package:flutter/material.dart';
import 'package:jobprogress/global_widgets/listview/index.dart';
import 'package:jp_mobile_flutter_ui/Label/type.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

//Using this widget to render financial product search listing shimmer loading
class ProductSearchListTileShimmer extends StatelessWidget {
  const ProductSearchListTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        JPListView(
          shrinkWrap: true,
          listCount: 9,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 1),
              decoration: BoxDecoration(
                color: JPAppTheme.themeColors.base,
              ),
              child: Shimmer.fromColors(
                  baseColor: JPAppTheme.themeColors.dimGray,
                  highlightColor: JPAppTheme.themeColors.inverse,
                  child: renderShimmerTile(context)),
            );
          },
        ),
      ],
    );
  }
}

Widget renderShimmerTile(BuildContext context) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 14),
    padding: const EdgeInsets.all(10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.zero,
          width: 200,
          height: 7,
          child:  const JPLabel(
            text: " ",
            type: JPLabelType.lightGray,
          ),
        ),
            const SizedBox(height: 7,),
            Row(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Container(
                padding: EdgeInsets.zero,
                width: 100,
                height: 7,
                child:  const JPLabel(
                  text: " ",
                  type: JPLabelType.lightGray,
                ),
              ),
              const SizedBox(width: 5,),
              JPText(
                text: '|',
                textSize: JPTextSize.heading4,
                textColor: JPAppTheme.themeColors.tertiary,
              ),
              const SizedBox(width: 5,),
              Container(
                padding: EdgeInsets.zero,
                width: 100,
                height: 7,
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

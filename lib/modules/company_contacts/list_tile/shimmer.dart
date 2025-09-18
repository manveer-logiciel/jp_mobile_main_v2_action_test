import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class CompanyContactShimmer extends StatelessWidget {
  const CompanyContactShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: 8,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Container(
            height: 13,
            width: 10,
            margin: EdgeInsets.only(top: index == 0 ? 0 : 20, left: 16),
            color: JPAppTheme.themeColors.dimGray,
          ),
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: JPAppTheme.themeColors.base,
            ),
            child: Shimmer.fromColors(
              baseColor: JPAppTheme.themeColors.dimGray, highlightColor: JPAppTheme.themeColors.inverse,
              child: Column(
                children: [
                  renderShimmerTile(context),
                  renderShimmerTile(context),
                ],
              )),
            )
          ],
        );
      },
    );
  }
}

Widget renderShimmerTile(BuildContext context) {
  return Container(
      padding: const EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width,
      child: Row(children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: JPAppTheme.themeColors.dimGray,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: MediaQuery.of(context).size.width - 250,
              height: 8,
              color: JPAppTheme.themeColors.dimGray,
            ),
            const SizedBox(height: 12),
            Container(
              width: MediaQuery.of(context).size.width - 250,
              height: 8,
              color: JPAppTheme.themeColors.dimGray,
            ),
            const SizedBox(height: 12),
            Container(
              width: MediaQuery.of(context).size.width - 200,
              height: 8,
              color: JPAppTheme.themeColors.dimGray,
            )
          ]),
        )
      ]));
}

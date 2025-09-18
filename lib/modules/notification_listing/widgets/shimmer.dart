import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class NotificationShimmer extends StatelessWidget {
  const NotificationShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 11,
            width: 60,
            margin: const EdgeInsets.only(top: 7, left: 16, bottom: 5),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              color: JPAppTheme.themeColors.dimGray,
            ),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: 20,
            itemBuilder: (BuildContext context, int index) {
              return Shimmer.fromColors(
                baseColor: JPAppTheme.themeColors.dimGray, highlightColor: JPAppTheme.themeColors.inverse,
                child: renderShimmerTile(context, index)
              );
            }
          )
        ],
      ),
    );
  }
}

Widget renderShimmerTile(BuildContext context, int index) {
  return Container(
      padding: const EdgeInsets.only(left: 16,top: 16,bottom:8, right: 16),
      width: MediaQuery.of(context).size.width,
      height: 90,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: JPAppTheme.themeColors.dimGray,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * .75,
                  height: 9,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    color: JPAppTheme.themeColors.dimGray,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: 150,
                  height: 9,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    color: JPAppTheme.themeColors.dimGray,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: 80,
                  height: 9,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    color: JPAppTheme.themeColors.dimGray,
                  ),
                ),
                const SizedBox(height: 12),
              ]
            ),
          )
        ]
      ));
}

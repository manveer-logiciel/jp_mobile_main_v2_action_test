import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/Label/type.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class SearchLocationShimmer extends StatelessWidget {
  const SearchLocationShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 15,
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
    );
  }

  Widget renderShimmerTile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ///   icon
          Container(
            padding: EdgeInsets.zero,
            child: JPIcon(
              Icons.location_on_outlined,
              color: JPAppTheme.themeColors.darkGray,
            ),
          ),

          ///   location
          Expanded(
            flex: 80,
            child: Container(
              padding: const EdgeInsets.only(left: 7.5),
              height: 7,
              child: const JPLabel(
                text: " ",
                type: JPLabelType.lightGray,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class QuickBookSyncErrorShimmer extends StatelessWidget {
  const QuickBookSyncErrorShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 2,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: const EdgeInsets.only(right: 16),
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
          padding: const EdgeInsets.only(top: 10.0,),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [           
              Container(
                margin: const EdgeInsets.only(left: 20, bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  color: JPAppTheme.themeColors.dimGray,
                ),
                width: MediaQuery.of(context).size.width-70,
                height: 8,
                child: const JPText(text: ""),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  color: JPAppTheme.themeColors.dimGray,
                ),
                width: MediaQuery.of(context).size.width-100,
                height: 8,
                child: const JPText(text: ""),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  color: JPAppTheme.themeColors.dimGray,
                ),
                width: MediaQuery.of(context).size.width-120,
                height: 8,
                child: const JPText(text: ""),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  color: JPAppTheme.themeColors.dimGray,
                ),
                width: MediaQuery.of(context).size.width-200,
                height: 8,
                child: const JPText(text: ""),
              )           
            ],
          ),
        ),
      ],
    );
  }

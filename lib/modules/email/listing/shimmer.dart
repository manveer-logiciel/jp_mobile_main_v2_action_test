import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class EmailShimmer extends StatelessWidget {
  const EmailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Container(
            height: 10,
            width: 60,
            margin: const EdgeInsets.only(top: 5, left: 10, bottom: 5),
            color: JPAppTheme.themeColors.dimGray,
          ),
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: JPAppTheme.themeColors.base,
            ),
            child: Column(
              children: [
                Shimmer.fromColors(
                  baseColor: JPAppTheme.themeColors.dimGray, highlightColor: JPAppTheme.themeColors.inverse,
                  child: renderShimmerTile(context)),
                Shimmer.fromColors(
                  baseColor: JPAppTheme.themeColors.dimGray, highlightColor: JPAppTheme.themeColors.inverse,
                  child: renderShimmerTile(context)),
              ],
            ),
            )
          ],
        );
      },
    );
  }
}

Widget renderShimmerTile(BuildContext context) {
  return Row(
    children: [
      Expanded(
        child: Container(
            padding: const EdgeInsets.only(left: 10,top: 16,bottom:8),
            height: 115,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Container(
                width: 42,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: JPAppTheme.themeColors.dimGray,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.only(
                            right: 250
                          ),
                          height: 10,
                          color: JPAppTheme.themeColors.dimGray,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    margin: const EdgeInsets.only(
                      right: 85
                    ),
                    height: 10,
                    color: JPAppTheme.themeColors.dimGray,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    margin: const EdgeInsets.only(
                        right: 85
                    ),
                    height: 10,
                    color: JPAppTheme.themeColors.dimGray,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    margin: const EdgeInsets.only(
                        right: 85
                    ),
                    height: 10,
                    color: JPAppTheme.themeColors.dimGray,
                  ),
                ]),
              )
            ])),
      ),
    ],
  );
}

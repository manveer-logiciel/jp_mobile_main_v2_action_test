import 'package:flutter/material.dart';
import 'package:jobprogress/global_widgets/listview/index.dart';
import 'package:jp_mobile_flutter_ui/Avatar/index.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';
import 'package:shimmer/shimmer.dart';

class ThirdPartyToolsShimmer extends StatelessWidget {
  const ThirdPartyToolsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Shimmer.fromColors(
                baseColor: JPAppTheme.themeColors.dimGray,
                highlightColor: JPAppTheme.themeColors.inverse,
                child: Container(
                  height: 14,
                  width: MediaQuery.of(context).size.width * 0.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: JPAppTheme.themeColors.inverse,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        JPListView(
          listCount: 20,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (_, index) {
            return Column(
              children: [
                const SizedBox(
                  height: 14,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 16,
                    ),
                    Shimmer.fromColors(
                      baseColor: JPAppTheme.themeColors.dimGray,
                      highlightColor: JPAppTheme.themeColors.inverse,
                      child: JPAvatar(
                        height: 42,
                        width: 42,
                        radius: 21,
                        backgroundColor: JPAppTheme.themeColors.inverse,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Shimmer.fromColors(
                                  baseColor: JPAppTheme.themeColors.dimGray,
                                  highlightColor: JPAppTheme.themeColors.inverse,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 10,
                                        width: MediaQuery.of(context).size.width * 0.3,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(18),
                                            color: JPAppTheme.themeColors.inverse,
                                          ),
                                      ),
                                      const SizedBox(
                                        height: 7,
                                      ),
                                      Container(
                                        height: 8,
                                        width: MediaQuery.of(context).size.width * 0.5,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(18),
                                            color: JPAppTheme.themeColors.inverse,
                                          ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: JPAppTheme.themeColors.dimGray,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

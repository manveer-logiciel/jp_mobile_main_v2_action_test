import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class CompanyFilesListingListShimmer extends StatelessWidget {
  const CompanyFilesListingListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 20,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: JPAppTheme.themeColors.base,
            ),
            child: Shimmer.fromColors(
                baseColor: JPAppTheme.themeColors.dimGray,
                highlightColor: JPAppTheme.themeColors.inverse,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          const JPThumbFolder(
                            size: ThumbSize.small,
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 10,
                                  width: 200,
                                  color: JPAppTheme.themeColors.darkGray,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  height: 5,
                                  width: 100,
                                  color: JPAppTheme.themeColors.darkGray,
                                ),
                              ],
                            ),
                          ),
                          const JPIcon(Icons.more_horiz)
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Divider(
                        indent: 48,
                        height: 1,
                        color: JPAppTheme.themeColors.secondaryText,
                      ),
                    ],
                  ),
                )),
          );
        },
      ),
    );
  }
}

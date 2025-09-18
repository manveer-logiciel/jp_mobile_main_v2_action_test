import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class FilesGridShimmer extends StatelessWidget {

  const FilesGridShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 240,
          mainAxisSpacing: 18,
          crossAxisSpacing: 18,
          childAspectRatio: 0.92,
        ),
        itemCount: 20,
        itemBuilder: (_, index) {
          return const FilesGridShimmerTile();
        },
      ),
    );
  }
}

class FilesGridShimmerTile extends StatelessWidget {

  const FilesGridShimmerTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: JPAppTheme.themeColors.dimGray,
        ),
      ),
      child: Shimmer.fromColors(
        baseColor: JPAppTheme.themeColors.dimGray,
        highlightColor: JPAppTheme.themeColors.inverse,
        child: SizedBox(
          height: 163,
          width: 163,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Center(
                    child: JPThumbFolder(
                      size: ThumbSize.large,
                    ),
                  ),
                ),
                Container(
                  height: 8,
                  width: 150,
                  color: JPAppTheme.themeColors.dimGray,
                ),
                const SizedBox(
                  height: 4,
                ),
                Container(
                  height: 5,
                  width: 70,
                  color: JPAppTheme.themeColors.dimGray,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

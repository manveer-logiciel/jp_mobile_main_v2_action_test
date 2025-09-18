
import 'package:flutter/material.dart';
import 'package:jobprogress/modules/files_listing/widgets/files_grid_shimmer.dart';

class RecentFilesShimmer extends StatelessWidget {
  const RecentFilesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 165,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
            horizontal: 16
          ),
          itemBuilder: (_, __) => const FilesGridShimmerTile(),
          separatorBuilder: (_, __) => const SizedBox(width: 20,),
          itemCount: 5,
      ),
    );
  }
}

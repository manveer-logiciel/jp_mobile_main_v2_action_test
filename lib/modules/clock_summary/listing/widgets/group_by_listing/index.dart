import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/listview/index.dart';
import 'package:jobprogress/global_widgets/no_data_found/index.dart';
import 'package:jobprogress/modules/clock_summary/listing/controller.dart';
import 'package:jobprogress/modules/clock_summary/listing/widgets/group_by_listing/list_tile.dart';
import 'package:jobprogress/modules/clock_summary/listing/widgets/group_by_listing/shimmer.dart';
import 'package:jobprogress/modules/clock_summary/listing/widgets/show_clock_summary_hours.dart';
import 'package:jp_mobile_flutter_ui/AnimatedSpinKit/fading_circle.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';

class ClockSummaryGroupByListing extends StatelessWidget {

  const ClockSummaryGroupByListing({
    super.key,
    required this.controller,
  });

  final ClockSummaryController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// total hours
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ShowClockSummaryHours(
                title: '${'total_hours'.tr}:',
                time: controller.totalHours,
                isShimmer: controller.isLoading,
              ),
            ],
          ),
        ),

        if (controller.isLoading) ...{
          /// list shimmer
          const ClockSummaryGroupByListShimmer(),
        }
        else if (controller.timeLogs.isEmpty) ...{
          /// empty data placeholder
          Expanded(
            child: NoDataFound(
              icon: Icons.pending_actions_outlined,
              title: 'no_history_found'.tr.capitalize,
            ),
          ),
        }
        else ...{
          /// time logs list view
          JPListView(
            listCount: controller.timeLogs.length,
            onRefresh: controller.refreshList,
            onLoadMore: controller.canShowLoadMore ? controller.loadMore : null,
            itemBuilder: (_, index) {
              if (index < controller.timeLogs.length) {
                return ClockSummaryGroupByTile(
                  data: controller.timeLogs[index],
                  index: index,
                  type: controller.selectedGroupByFilter,
                  onTap: () {
                    controller.openEntries(index);
                  },
                );
              }
              else if (controller.canShowLoadMore) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FadingCircle(
                      color: JPAppTheme.themeColors.primary,
                      size: 25,
                    ),
                  ),
                );
              }
              else {
                return const SizedBox.shrink();
              }
            },
          ),
        }

      ],
    );
  }
}

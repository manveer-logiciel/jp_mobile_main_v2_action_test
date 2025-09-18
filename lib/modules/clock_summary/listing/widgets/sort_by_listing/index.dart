import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/listview/index.dart';
import 'package:jobprogress/global_widgets/no_data_found/index.dart';
import 'package:jobprogress/modules/clock_summary/listing/controller.dart';
import 'package:jobprogress/modules/clock_summary/listing/widgets/show_clock_summary_hours.dart';
import 'package:jobprogress/modules/clock_summary/listing/widgets/sort_by_listing/list_tile.dart';
import 'package:jobprogress/modules/clock_summary/listing/widgets/sort_by_listing/shimmer.dart';
import 'package:jp_mobile_flutter_ui/AnimatedSpinKit/fading_circle.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';

class ClockSummarySortByListing extends StatelessWidget {

  const ClockSummarySortByListing({super.key, required this.controller});

  final ClockSummaryController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 20,
              bottom: 12
          ),
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
          const ClockSummarySortByListShimmer(),
        }
        else if (controller.timeEntries.isEmpty) ...{
          /// empty data placeholder
          Expanded(
            child: NoDataFound(
              icon: Icons.pending_actions_outlined,
              title: 'no_history_found'.tr.capitalize,
            ),
          ),
        }
        else...{
            JPListView(
              listCount: controller.timeEntries.length,
              onRefresh: controller.refreshList,
              onLoadMore: controller.canShowLoadMore ? controller.loadMore : null,
              itemBuilder: (_, index) {
                if (index < controller.timeEntries.length) {
                  return ClockSummarySortByTile(
                    data: controller.timeEntries[index],
                    index: index,
                    onTap: () {
                      controller.openLogDetails(index);
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

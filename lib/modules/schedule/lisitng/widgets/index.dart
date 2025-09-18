
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/listview/index.dart';
import 'package:jobprogress/global_widgets/no_data_found/index.dart';
import 'package:jobprogress/modules/schedule/lisitng/controller.dart';
import 'package:jobprogress/modules/schedule/lisitng/widgets/shimmer.dart';
import 'package:jobprogress/modules/schedule/lisitng/widgets/tile/tile.dart';
import 'package:jp_mobile_flutter_ui/AnimatedSpinKit/fading_circle.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ScheduleListing extends StatelessWidget {
  const ScheduleListing({
    super.key,
    required this.controller
  });

  final SchedulesListingController controller;

  bool get doShowPlaceHolder => !controller.isLoading && controller.schedules.isEmpty;

  @override
  Widget build(BuildContext context) {

    if (controller.isLoading) {
      return const Expanded(child: ScheduleListingShimmer());
    } else if (doShowPlaceHolder) {
      return Expanded(
        child: NoDataFound(
          icon: Icons.calendar_today,
          title: 'schedule_not_created'.tr.capitalize,
        ),
      );
    }

    return JPListView(
      listCount: controller.schedules.length,
      onLoadMore: controller.canShowMore ? controller.loadMore : null,
      onRefresh: controller.refreshList,
      itemBuilder: (_, index) {
        if (index < controller.schedules.length) {
          return ScheduleListingTile(
            schedule: controller.schedules[index],
            canShowConfirmation: controller.canShowConfirmationStatus,
            onTap: () => controller.onTapSchedule(index),
            onAccept: () => controller.onTapConfirmation(index),
            onDecline: () => controller.onTapConfirmation(index, accept: false),
          );
        } else if (controller.canShowMore) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FadingCircle(
                size: 25,
                color: JPAppTheme.themeColors.primary,
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );

  }
}

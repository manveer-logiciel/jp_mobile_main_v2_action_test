import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/AnimatedSpinKit/fading_circle.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../../common/enums/cj_list_type.dart';
import '../../../../../common/enums/page_type.dart';
import '../../../../../common/models/job/job.dart';
import '../../../../../global_widgets/details_listing_tile/index.dart';
import '../../../../../global_widgets/listview/index.dart';
import '../../../../../global_widgets/no_data_found/index.dart';
import '../../../../job/listing/widgets/list_tile/shimmer.dart';
import '../controller.dart';

class JobScheduleList extends StatelessWidget {
  const JobScheduleList({
    super.key,
    required this.controller
  });

  final JobScheduleListingController controller;

  @override
  Widget build(BuildContext context) {
    return controller.isLoading
        ?  Expanded(child: JobListTileShimmer(listType: controller.listType))
        : controller.jobList.isEmpty
        ? Expanded(
            child: NoDataFound(
              icon: Icons.work_outline,
              title: 'no_job_or_project_to_schedule'.tr.capitalize,
            ),
          )
        : JPListView(
      listCount: controller.jobList.length,
      onLoadMore: controller.canShowLoadMore ? controller.loadMore : null,
      onRefresh: controller.refreshList,
      itemBuilder: (context, index) {
        if (index < controller.jobList.length) {
          return Column(
            children: [
              Visibility(
                  visible: (controller.listType == CJListType.projectJobs && index == 0),
                  child: const SizedBox(height: 15,)
              ),

              CustomerJobDetailListingTile(
                listType: controller.listType,
                job: controller.jobList[index],
                navigateToJobDetailScreen: controller.navigateToEditSchedule,
                openJobQuickActions: ({JobModel? job, int? index}){},
                customerIndex: index,
                pageType: PageType.scheduledListing,
              ),
              const SizedBox(height: 10,)
            ],
          );
        } else if (controller.canShowLoadMore) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Center(
                child: FadingCircle(
                    color: JPAppTheme.themeColors.primary,
                    size: 25)),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

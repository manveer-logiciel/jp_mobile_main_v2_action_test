import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/global_widgets/job_switcher/header.dart';
import 'package:jobprogress/global_widgets/job_switcher/shimmer.dart';
import 'package:jobprogress/global_widgets/job_switcher/tile.dart';
import 'package:jobprogress/global_widgets/listview/index.dart';
import 'package:jobprogress/global_widgets/no_data_found/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/modules/cutomer_job_list/controller.dart';
import 'package:jp_mobile_flutter_ui/AnimatedSpinKit/fading_circle.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../common/enums/page_type.dart';

class CustomerJobListing extends StatelessWidget {

  final bool? isWithJob;
  final bool closeSheetWhileNavigation;
  final int? customerId;
  final int? parentJobId;
  final String? title;
  final String? multiJobTitle;
  final List<JobModel>? jobs;
  final PageType? pageType;
  final Function(JobModel)? callback;

  const CustomerJobListing({
    super.key,
    this.isWithJob,
    this.customerId,
    this.parentJobId,
    this.title,
    this.multiJobTitle,
    this.jobs,
    this.pageType,
    this.callback,  
    this.closeSheetWhileNavigation = false,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CustomerJobListingController(
        customerJobId: customerId, parentJobId: parentJobId, jobs: jobs,
      pageType: pageType, callback: callback,));
    return GetBuilder<CustomerJobListingController>(
      builder: (_) {
        return Container(
          decoration: BoxDecoration(
            color: JPAppTheme.themeColors.base,
            borderRadius: JPResponsiveDesign.bottomSheetRadius,
          ),
          child: JPSafeArea(
            child: ClipRRect(
              borderRadius: JPResponsiveDesign.bottomSheetRadius,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  JobSwitcherListingHeader(
                    isBackArrowVisible: (controller.parentJobId != null) && !(isWithJob ?? false),
                    title: controller.parentJobId != null
                      ? multiJobTitle ?? "projects".tr.toUpperCase()
                      : title ?? 'jobs'.tr.toUpperCase(),
                      onBackPress : controller.onBackPress
                  ),
                  Flexible(
                    child: AnimatedContainer(
                      width: MediaQuery.of(context).size.width,
                      constraints: BoxConstraints(
                        maxHeight: controller.isLoading? MediaQuery.of(context).size.height * 0.30 : MediaQuery.of(context).size.height * 0.80,
                      ),
                      duration: const Duration(milliseconds: 200),
                      child: controller.isLoading ? const JobSwitcherShimmer() : controller.jobListing.isNotEmpty ?
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            JPListView(
                              padding: EdgeInsets.zero,
                              listCount: controller.jobListing.length,
                              onLoadMore: controller.canShowLoadMore ? controller.loadMore : null,
                              itemBuilder: (_, index) {
                                if (index < controller.jobListing.length) {
                                  return Material(
                                    color: JPAppTheme.themeColors.base,
                                    child: InkWell(
                                      onTap: (){
                                        if(closeSheetWhileNavigation){
                                          Get.back();
                                        }
                                        controller.navigateToJobDetailScreen(
                                          jobID: controller.jobListing[index].id, 
                                          currentIndex: index
                                        );
                                      },
                                      child: JobSwitcherTileView(
                                        job:controller.jobListing[index],
                                      ),
                                    ),
                                  );
                                } else if (controller.canShowLoadMore) {
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
                            ),
                          ],
                        ):
                      NoDataFound(
                        icon: Icons.task,
                        title: "no_job_found".tr.capitalize,
                      ) ,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
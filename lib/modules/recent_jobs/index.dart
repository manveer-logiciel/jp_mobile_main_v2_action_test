import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/page_type.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/global_widgets/job_switcher/header.dart';
import 'package:jobprogress/global_widgets/job_switcher/shimmer.dart';
import 'package:jobprogress/global_widgets/job_switcher/tile.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/modules/recent_jobs/controller.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../core/constants/navigation_parms_constants.dart';
import '../../global_widgets/no_data_found/index.dart';

class RecentJobBottomSheet extends StatelessWidget {

  const RecentJobBottomSheet({
    super.key,
    this.currentJob,
    this.pageType = PageType.home,
    this.callback,
  });

  final JobModel? currentJob;

  final PageType? pageType;

  final void Function({JobModel? jobModel})? callback;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecentJobController>(
        global: false,
        init: RecentJobController(),
        builder: (controller) {
      return Container(
        width: MediaQuery.of(context).size.width,
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
                    title: '${'recent'.tr.toUpperCase()} ${'jobs'.tr.toUpperCase()}'),
                Flexible(
                  child: AnimatedContainer(
                    width: MediaQuery.of(context).size.width,
                    constraints: BoxConstraints(
                      maxHeight: controller.isLoading
                          ? MediaQuery.of(context).size.height * 0.30
                          : MediaQuery.of(context).size.height * 0.80,
                    ),
                    duration: const Duration(milliseconds: 200),
                    child: controller.isLoading
                      ? const JobSwitcherShimmer()
                      : controller.recentJobList.isNotEmpty
                         ? Padding(
                             padding: JPScreen.isTablet || JPScreen.isDesktop ? const EdgeInsets.only(bottom: 17) : EdgeInsets.zero,
                             child: ListView.builder(
                               key: const ValueKey(WidgetKeys.recentJobs),
                               shrinkWrap: true,
                               itemCount: controller.recentJobList.length,
                               itemBuilder: ((context, index) => Material(
                                 child: InkWell(
                                   key: ValueKey('${WidgetKeys.recentJobs}[$index]'),
                                   onTap: () {
                                     Get.back();
                                     switch (pageType) {
                                       case PageType.fileListing:
                                       case PageType.selectJob:
                                       case PageType.shareTo:
                                       case PageType.linkToJob:
                                         callback!(jobModel: controller.recentJobList[index]);
                                       break;
                                       default:
                                         if (currentJob == null || currentJob!.id != controller.recentJobList[index].id) {
                                           if(Get.currentRoute == '/EmailListingView' || Get.currentRoute == Routes.jobNoteListing) {
                                             Get.back();
                                           }
                                           Get.toNamed(Routes.jobSummary, arguments: {
                                             NavigationParams.jobId: controller.recentJobList[index].id,
                                             NavigationParams.customerId: controller.recentJobList[index].customerId
                                           }, preventDuplicates: false);
                                         }
                                     }
                                   },
                                   child: JobSwitcherTileView(
                                       job: controller.recentJobList[index])),
                                 ))),
                            )
                         : Center(
                            child: NoDataFound(
                              icon: Icons.task,
                              title: "no_job_found".tr.capitalize,
                            ),
                          ),
                  ),
                ),

              ],
            ),
          ),
        ),
      );
    });
  }
}

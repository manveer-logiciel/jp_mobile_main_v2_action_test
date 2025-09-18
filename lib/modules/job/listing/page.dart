import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/cj_list_type.dart';
import 'package:jobprogress/global_widgets/main_drawer/index.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jp_mobile_flutter_ui/AnimatedSpinKit/fading_circle.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../common/enums/page_type.dart';
import '../../../common/models/job/job.dart';
import '../../../core/constants/widget_keys.dart';
import '../../../global_widgets/details_listing_tile/index.dart';
import '../../../global_widgets/listview/index.dart';
import '../../../global_widgets/no_data_found/index.dart';
import '../../../global_widgets/observer_builder/index.dart';
import '../../../global_widgets/replace_job_id_with_company_setting/job_name_with_company_setting.dart';
import '../../../global_widgets/safearea/safearea.dart';
import 'controller.dart';
import 'widgets/list_tile/shimmer.dart';
import 'widgets/secondary_header.dart';

class JobListingView extends StatelessWidget {
  const JobListingView({super.key});

  @override
  Widget build(BuildContext context) {

    Widget getJobList(JobListingController controller) {
      return  controller.isLoading
        ?  Expanded(child: JobListTileShimmer(listType: controller.listType))
        : controller.jobList.isEmpty
          ? Expanded(
              child: NoDataFound(
                icon: Icons.work_outline,
                title: controller.listType == CJListType.projectJobs
                    ? 'no_project_found'.tr.capitalize : 'no_job_found'.tr.capitalize,
              ),
            )
          : JPListView(
              key: const ValueKey(WidgetKeys.jobKey),
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
                        listType: controller.listType!,
                        job: controller.jobList[index],
                        navigateToJobDetailScreen: controller.navigateToDetailScreen,
                        openJobQuickActions: controller.openQuickActions,
                        openDescDialog: ({JobModel? job, int? index,}) => controller.openDescDialog(job: job, index: index,),
                        customerIndex: index,
                        isLoadingMetaData: controller.isMetaDataLoading(index),
                        onProjectCountPressed: controller.onProjectCountPressed,
                        pageType: PageType.jobListing,
                        onTapJobSchedule: () => controller.openJobSchedule(index),
                        onTapProgressBoard: () => controller.openProgressBoard(index),
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

    return GetObserverBuilder<JobListingController>(
      init: JobListingController(),
      onResume: (controller) => controller.onResume(),
      builder: (JobListingController controller) {
      return JPWillPopScope(
        onWillPop: controller.onWillPopup,
        child: JPScaffold(
          appBar: JPHeader(
            title: controller.getTitleText(),
            titleWidget: (controller.listType == CJListType.projectJobs && controller.jobModel != null)
                ? JobNameWithCompanySetting(
                job: controller.jobModel!,
                textColor: JPAppTheme.themeColors.base,
                fontWeight: JPFontWeight.medium)
                : null,
            onBackPressed: controller.onWillPopup,
            actions: [
              IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => controller.scaffoldKey.currentState!.openEndDrawer(),
                  icon: JPIcon(
                    Icons.menu,
                    color: JPAppTheme.themeColors.base,
                  )),
            ],
          ),
          scaffoldKey: controller.scaffoldKey,
          endDrawer: JPMainDrawer(selectedRoute: controller.listType == CJListType.nearByJobs ? 'near_by_job' : 'customer_manager',
            onRefreshTap: () {
            controller.refreshList(showLoading: true);
            }),
          floatingActionButton: Visibility(
            visible: controller.listType == CJListType.projectJobs,
            child: JPButton(
              size: JPButtonSize.floatingButton,
              iconWidget: JPIcon(
                Icons.add,
                color: JPAppTheme.themeColors.base,
              ),
              onPressed: controller.navigateToAddProjectScreen,
            ),
          ),
          body: JPSafeArea(
            top: false,
            containerDecoration: BoxDecoration(color: JPAppTheme.themeColors.base),
            child: Container(
              color: JPAppTheme.themeColors.inverse,
              child: Column(
                children: [
                  Visibility(
                    visible: controller.listType != CJListType.projectJobs,
                    child: JobListSecondaryHeader(
                        stages: controller.stages,
                        groupedStages: controller.groupedStages,
                        jobController: controller,
                    )),
                  getJobList(controller),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

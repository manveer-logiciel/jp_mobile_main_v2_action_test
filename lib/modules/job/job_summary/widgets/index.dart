
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/core/constants/file_uploder.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/from_launch_darkly/index.dart';
import 'package:jobprogress/global_widgets/has_permission/index.dart';
import 'package:jobprogress/global_widgets/no_data_found/index.dart';
import 'package:jobprogress/global_widgets/recent_files/index.dart';
import 'package:jobprogress/global_widgets/single_child_scroll_view.dart/index.dart';
import 'package:jobprogress/modules/job/job_summary/controller.dart';
import 'package:jobprogress/modules/job/job_summary/widgets/details/index.dart';
import 'package:jobprogress/modules/job/job_summary/widgets/lost_job/index.dart';
import 'package:jobprogress/modules/job/job_summary/widgets/workflow/index.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/Constants/responsive_design.dart';
import 'shimmer.dart';

class JobOverView extends StatelessWidget {

  const JobOverView({
    super.key,
    required this.controller
  });

  final JobSummaryController controller;

  @override
  Widget build(BuildContext context) {

    if(controller.isLoading) {
      return const JobOverViewShimmer();
    } else if(controller.job == null || controller.workFlowStagesParams == null) {
      return NoDataFound(
        icon: Icons.work_history_outlined,
        title: 'job_not_found'.tr.capitalize,
      );
    } else {
      return Column(
        children: [
          JPSingleChildScrollView(
            onRefresh: () => controller.refreshPage(refreshRecentListing: true),
            item: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                /// lost job card
                if(!Helper.isValueNullOrEmpty(controller.workFlowStagesParams?.job.jobLostDate))...{
                  JobOverViewLostJobCard(
                    status: controller.workFlowStagesParams!.job.followUpStatus,
                    onTapReinstate: controller.reinstateJobConfirmation,
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                },

                /// workflow stages
                JobOverViewWorkFlow(
                  workFlowParams: controller.workFlowStagesParams,
                  refreshJob: controller.refreshPage,
                  onTapCount: controller.onTapCount,
                  users: controller.users,
                  onTapAwarded: controller.awardedStageConfirmation,
                  onTapTotalJobPrice: controller.onTapTotalJobPrice,
                ),
                const SizedBox(
                  height: 20,
                ),

                /// job details, customer info, contact person
                JobOverViewDetails(
                  emailCount: controller.recurringEmailCount,
                  tabController: controller.tabController,
                  job: controller.job!,
                  onTapDescription: controller.onTapDescription,
                  onTapViewMore: controller.navigateToJobDetails,
                  customerInfo: controller.customerInfo,
                  onTapCallLog: controller.showCallLogs,
                  contactPerson: controller.job?.contactPerson ?? [],
                  onTapShare: controller.shareCustomerWebPage,
                  isJobDetailExpanded: controller.isJobDetailExpanded,
                  onDetailExpansionChanged: controller.toggleIsJobExpanded,
                  updateScreen: controller.refreshPage,
                  onTapEmailHistory: controller.navigateToEmailHistory,
                  onTapEdit: controller.openDescDialog,
                  sectionItems: controller.sectionItems,
                ),

                const SizedBox(
                  height: 10,
                ),

                /// recent photos & documents
                RecentFiles(
                  title: 'recent_photos_documents'.tr,
                  job: controller.job!,
                  type: FLModule.jobPhotos,
                  tag: FileUploadType.photosAndDocs + controller.jobId.toString(),
                  jobSummaryController: controller,
                ),

                /// recent estimates
                HasPermission(
                  permissions: const [PermissionConstants.manageEstimates],
                  child: FromLaunchDarkly(
                    flagKey: LDFlagKeyConstants.salesProForEstimate,
                    showHideOnly: false,
                    child: (flag) {
                      if(!Helper.isTrue(flag.value)) {
                        return RecentFiles(
                          title: 'recent_estimates'.tr,
                          job: controller.job!,
                          type: FLModule.estimate,
                          tag: FileUploadType.estimations + controller.jobId.toString(),
                          jobSummaryController: controller,
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ),

                /// recent proposals
                if(controller.job?.parentId == null)... {
                  HasPermission(
                    permissions: const [PermissionConstants.viewProposals, PermissionConstants.manageProposals],
                    child: RecentFiles(
                      title: 'recent_forms_proposals'.tr,
                      job: controller.job!,
                      type: FLModule.jobProposal,
                      tag: FileUploadType.formProposals + controller.jobId.toString(),
                      jobSummaryController: controller,
                    ),
                  )
                },
                
                const SizedBox(
                  height: JPResponsiveDesign.floatingButtonSize,
                ),
              ],
            ),
          ),
        ],
      );
    }
  }
}

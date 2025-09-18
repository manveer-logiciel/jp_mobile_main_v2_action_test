import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/job_switcher.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/global_widgets/job_switcher/shimmer.dart';
import 'package:jobprogress/global_widgets/listview/index.dart';
import 'package:jobprogress/global_widgets/no_data_found/index.dart';
import 'package:jobprogress/global_widgets/job_switcher/controller.dart';
import 'package:jobprogress/global_widgets/job_switcher/tile.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jp_mobile_flutter_ui/AnimatedSpinKit/fading_circle.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'header.dart';


class JobSwitcherBottomSheet extends StatelessWidget {
  final JobModel currentJob;
  final int customerId;
  final JobSwitcherType type;
  final Function(int)? onJobPressed;

  const JobSwitcherBottomSheet({
    super.key,
    required this.currentJob,
    required this.customerId,
    required this.type,
    this.onJobPressed
  });

  @override
  Widget build(BuildContext context) {
    JobSwitcherController controller = Get.put(JobSwitcherController(currentJob: currentJob, customerId: customerId, type : type));

    return GetBuilder<JobSwitcherController>(
      builder: (_) {
        return Container(
          decoration: BoxDecoration(
              color: JPAppTheme.themeColors.base,
              borderRadius: JPResponsiveDesign.bottomSheetRadius,
          ),
          child: ClipRRect(
            borderRadius: JPResponsiveDesign.bottomSheetRadius,
            child: JPSafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  JobSwitcherListingHeader(title: 'jobs'.tr.toUpperCase()),
                  Flexible(
                    child: AnimatedContainer(
                      width: MediaQuery.of(context).size.width,
                      constraints: BoxConstraints(
                        maxHeight: controller.isLoading? MediaQuery.of(context).size.height * 0.30 : MediaQuery.of(context).size.height * 0.80,
                      ),
                      duration: const Duration(milliseconds: 200),
                      child: controller.isLoading ? const JobSwitcherShimmer() : controller.mainList.isNotEmpty ?
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            JPListView(
                                padding: EdgeInsets.zero,
                                listCount: controller.mainList.length,
                                onLoadMore: controller.canShowLoadMore || controller.canShowLoadMoreProject ? controller.loadMore : null,
                                itemBuilder: (_, index) {
                                  if (index < controller.mainList.length) {
                                    return Material(
                                      color: JPAppTheme.themeColors.base,
                                      child: InkWell(
                                        onTap: controller.mainList[index].id == controller.currentJob!.id ? (){ Get.back(); } : () {
                                          onJobPressed!(controller.mainList[index].id);
                                          Get.back();
                                        },
                                        child: JobSwitcherTileView(
                                          job:controller.mainList[index],
                                          canRemoveCustomerName: true,
                                          currentJob : controller.currentJob!,
                                          type : type
                                        ),
                                      ),
                                    );
                                  } else if (controller.canShowLoadMoreProject || controller.canShowLoadMore) {
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
                        ),
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
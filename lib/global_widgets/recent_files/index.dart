
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/global_widgets/recent_files/controller.dart';
import 'package:jobprogress/global_widgets/recent_files/list_shimmer.dart';
import 'package:jobprogress/modules/job/job_summary/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../no_data_found/index.dart';
import 'files_list.dart';

class RecentFiles extends StatelessWidget {
  const RecentFiles({
    super.key,
    required this.title,
    required this.job,
    required this.type,
    required this.tag,
    required this.jobSummaryController
  });

  /// title used to display title
  final String title;

  /// job is used to store job data
  final JobModel job;

  /// type is used to specify type of listing to be displayed
  final FLModule type;

  /// tag is used to differentiate different controllers, also helps in refreshing list
  final String tag;

  final JobSummaryController jobSummaryController;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecentFilesController>(
      init: RecentFilesController(job, type, jobSummaryController),
      tag: tag,
      builder: (controller) {
        return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10
            ),
            child: Material(
              color: JPAppTheme.themeColors.base,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 11, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: JPText(
                              text: title.toUpperCase(),
                              textAlign: TextAlign.start,
                              fontWeight: JPFontWeight.medium,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          JPTextButton(
                            text: 'view_all'.tr,
                            onPressed: () => controller.viewAllFiles(tag: tag),
                            textSize: JPTextSize.heading4,
                            color: JPAppTheme.themeColors.primary,
                            fontWeight: JPFontWeight.medium,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    controller.isLoading
                        ? const RecentFilesShimmer()
                        : controller.resourceList.isEmpty
                        ? Center(
                          child: SizedBox(
                            height: 165,
                            child: NoDataFound(
                              icon: controller.getRecentFilesPlaceHolderIcon(type),
                              iconSize : 30,
                              title: controller.getRecentFilesPlaceTitle(type),
                              textSize: JPTextSize.heading4,
                              textColor: JPAppTheme.themeColors.tertiary,
                            ),
                          ),
                        )
                        : JobOverViewFilesList(
                      type: controller.type,
                      files: controller.resourceList,
                      onLongPressResource: (index) => controller.showQuickAction(index: index),
                      onTapResource: controller.onTapResource,
                      onTapSuffix: (index) => controller.showQuickAction(index: index),
                      onTapViewAll: () => controller.viewAllFiles(tag: tag),
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

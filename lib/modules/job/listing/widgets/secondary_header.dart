import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/utils/single_select_helper.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jp_mobile_flutter_ui/HierarchicalMultiSelect/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../common/enums/cj_list_type.dart';
import '../../../../common/models/job/job_listing_filter.dart';
import '../controller.dart';
import 'filter_dialog/index.dart';

class JobListSecondaryHeader extends StatelessWidget {

  const JobListSecondaryHeader({
    super.key,
    required this.stages,
    required this.jobController,
    required this.groupedStages,
  });

  final List<JPMultiSelectModel> stages;
  final List<JPHierarchicalSelectorGroupModel> groupedStages;
  final JobListingController jobController;

  void openCustomFilters() {
    showJPGeneralDialog(
        child:(controller) => JobListingFilterDialog(
          selectedFilters: jobController.filterKeys,
          defaultFilters: jobController.defaultFilters,
          stages: stages,
          groupedStages: groupedStages,
          onApply: (JobListingFilterModel params) {
            jobController.applyFilters(params);
          },
        )
    );
  }

  void openSortBy() {
    SingleSelectHelper.openSingleSelect(
        jobController.sortByList,
        jobController.filterKeys.sortBy,
        'sort_by'.tr,
            (value) {
          jobController.applySortFilters(value);
          Get.back();
        },
        isFilterSheet: true
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 11, top: 10, bottom: 11),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ///   Sort By
          Material(
            color: JPAppTheme.themeColors.inverse,
            child: JPTextButton(
                color: JPAppTheme.themeColors.tertiary,
                onPressed: () => openSortBy(),
                fontWeight: JPFontWeight.medium,
                textSize: JPTextSize.heading5,
                text: "${"sort_by".tr}: ${jobController.filterKeys.selectedItem ?? ""}",
                icon: Icons.keyboard_arrow_down_outlined
            ),
          ),
          ///   Filters
          if(jobController.listType != CJListType.nearByJobs)
          JPFilterIcon(
            onTap: stages.isEmpty ? null : () => openCustomFilters(),
          ),
        ],
      ),
    );
  }
}
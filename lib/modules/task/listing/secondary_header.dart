import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/task_listing/task_listing_filter.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/core/utils/single_select_helper.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/modules/task/custom_fliter_dialog/index.dart';
import 'package:jobprogress/modules/task/listing/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class TaskListSecondaryHeader extends StatelessWidget {
  const TaskListSecondaryHeader({
    super.key,
    required this.taskController
  });

  final TaskListingController taskController;

  openCustomFilters() {
    showJPDialog(
      child: (_) => TaskListingDialouge(
          selectedFilters: taskController.filterKeys,
          jobId : taskController.jobId,
          onApply: (TaskListingFilterModel params) {
            taskController.applyFilters(params);
          },
          userList: taskController.userList
      )
    );
  }

  openFilters() {
    SingleSelectHelper.openSingleSelect(
      taskController.filterByList,
      taskController.selectedFilterByOptions,
      'Filter By',
      (value) {
        taskController.selectedFilterByOptions = value;

        taskController.updateSortByList(value);

        Get.back();
        if (taskController.selectedFilterByOptions == 'custom') {
          openCustomFilters();
        } else {
          taskController.applyFilters(null);
        }
      },
      isFilterSheet: true
    );
  }

  openSortBy() {
    SingleSelectHelper.openSingleSelect(
      taskController.sortByList,
      taskController.filterKeys.sortBy,
      'Sort By', (value) {
        taskController.filterKeys.sortBy = value;
        taskController.update();
        Get.back();
        taskController.applySortFilters();
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
          Material(
            color: JPAppTheme.themeColors.inverse,
            child: JPTextButton(
                key: const Key(WidgetKeys.taskListingFilterKey),
                color: JPAppTheme.themeColors.tertiary,
                onPressed: () {
                  openFilters();
                },
                fontWeight: JPFontWeight.medium,
                textSize: JPTextSize.heading5,
                text: SingleSelectHelper.getSelectedSingleSelectValue(taskController.filterByList, taskController.selectedFilterByOptions),
                icon: Icons.keyboard_arrow_down_outlined),
          ),
          Row(
            children: [
              Material(
                color: JPAppTheme.themeColors.inverse,
                child: JPTextButton(
                  key: const Key(WidgetKeys.taskListingSortFilterKey),
                  color: JPAppTheme.themeColors.tertiary,
                  onPressed: () {
                    openSortBy();
                  },
                  fontWeight: JPFontWeight.medium,
                  textSize: JPTextSize.heading5,
                  text: taskController.filterKeys.sortBy != 'completed' ? SingleSelectHelper.getSelectedSingleSelectValue(taskController.sortByList, taskController.filterKeys.sortBy) : 'Completed Date',
                  icon: Icons.keyboard_arrow_down_outlined
                ),
              ),
              Material(
                key: const Key(WidgetKeys.taskListingSortOrderKey),
                color: JPAppTheme.themeColors.inverse,
                child: InkWell(
                  onTap: () {
                    taskController.sortListing();
                  },
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    child: taskController.filterKeys.sortOrder == 'ASC' ? SvgPicture.asset('assets/svg/sort_asc.svg') : SvgPicture.asset('assets/svg/sort_desc.svg'),
                  )
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/clock_summary.dart';
import 'package:jobprogress/core/utils/single_select_helper.dart';
import 'package:jobprogress/modules/clock_summary/listing/controller.dart';
import 'package:jobprogress/modules/clock_summary/listing/widgets/applied_filters/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ClockSummarySecondaryHeader extends StatelessWidget {

  const ClockSummarySecondaryHeader({super.key, required this.controller});

  final ClockSummaryController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
              right: 13,
              left: 12,
              top: 8,
              bottom: 12
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              JPTextButton(
                padding: 4,
                  color: JPAppTheme.themeColors.tertiary,
                  onPressed: () {
                  if(controller.listingType == ClockSummaryListingType.groupBy) {
                    controller.openGroupByFilter();
                  } else {
                    controller.openSortByFilter();
                  }
                  },
                  fontWeight: JPFontWeight.medium,
                  textSize: JPTextSize.heading5,
                  text: getFilterTitle(),
                  icon: Icons.keyboard_arrow_down_outlined),
              JPFilterIcon(
                  onTap: () {
                    controller.showFilterDialog();
                  }
              )

            ],
          ),
        ),

        ClockSummaryAppliedFiltersList(filters: controller.appliedFiltersList),

      ],
    );
  }

  String getFilterTitle() {
    if(controller.listingType == ClockSummaryListingType.groupBy) {
      return '${'group_by'.tr} : ${SingleSelectHelper.getSelectedSingleSelectValue(controller.groupByFilter, controller.selectedGroupByFilter)}';
    } else {
      return '${'sort_by'.tr} : ${controller.sortByFilter.isEmpty ? "" : SingleSelectHelper.getSelectedSingleSelectValue(controller.sortByFilter, controller.selectedSortByFilter)}';
    }
  }

}


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../../core/utils/single_select_helper.dart';
import '../../../../../global_widgets/single_field_shimmer/index.dart';
import '../controller.dart';


class JobScheduleListingSecondaryHeader extends StatelessWidget {
  const JobScheduleListingSecondaryHeader({
    super.key,
    required this.controller
  });

  final JobScheduleListingController controller;

  void openSortBy() {
    SingleSelectHelper.openSingleSelect(
      controller.stages!,
      controller.selectedStage?.id ?? "",
      'select_stage'.tr,
      controller.applySortFilters,
      isFilterSheet: false
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 11, top: 20, bottom: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ///   job count
          controller.totalScheduleJobs == null
            ? const JPSingleFieldShimmer(width: 200,)
            : JPText(
            text : "${"scheduled".tr} - ${controller.totalScheduleJobs}  I  ${"to_be_scheduled".tr} - ${controller.totalUnScheduleJobs}",
            textColor: JPAppTheme.themeColors.text,
            fontWeight: JPFontWeight.medium,
            textSize: JPTextSize.heading5,
          ),

          const SizedBox(
            width: 20,
          ),

          ///   Sort By stage
          controller.stages == null
            ? const JPSingleFieldShimmer(width: 100,)
            : Flexible(
              child: Material(
                color: JPAppTheme.themeColors.inverse,
                child: JPTextButton(
                color: JPAppTheme.themeColors.tertiary,
                isExpanded: false,
                onPressed: () => openSortBy(),
                fontWeight: JPFontWeight.medium,
                textSize: JPTextSize.heading5,
                text: controller.selectedStage?.label ?? "",
                icon: Icons.keyboard_arrow_down_outlined
              )),
            ),
        ],
      ),
    );
  }
}
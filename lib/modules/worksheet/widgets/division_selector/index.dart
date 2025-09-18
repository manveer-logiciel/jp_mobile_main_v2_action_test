import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job/job_division.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jobprogress/modules/worksheet/widgets/division_selector/controller.dart';
import 'package:jobprogress/modules/worksheet/widgets/division_selector/widgets/division_tile.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

/// A widget that represents a division selector in the worksheet.
///
/// This widget displays a dialog with options to select a division from the job or a favourite division.
/// It uses the [WorksheetDivisionSelectorTile] widget to display each division option.
class WorksheetDivisionSelector extends StatelessWidget {
  const WorksheetDivisionSelector({
    this.jobDivision,
    this.favouriteDivision,
    super.key,
  });

  /// [jobDivision] The division model for the job.
  final DivisionModel? jobDivision;

  /// [favouriteDivision] The division model for the favourite division.
  final DivisionModel? favouriteDivision;

  @override
  Widget build(BuildContext context) {
    return JPWillPopScope(
      onWillPop: () async => false,
      child: JPSafeArea(
        child: AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 12),
          contentPadding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: Builder(
            builder: (context) {
              return GetBuilder<WorksheetDivisionSelectorController>(
                init: WorksheetDivisionSelectorController(
                    jobDivision: jobDivision,
                    favouriteDivision: favouriteDivision,
                ),
                global: false,
                builder: (controller) {
                  return Container(
                    padding: const EdgeInsets.only(
                      top: 16,
                      bottom: 18,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 2,
                        ),
                        /// Title
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          child: JPText(
                            text: 'select_division'.tr.toUpperCase(),
                            fontWeight: JPFontWeight.medium,
                            textSize: JPTextSize.heading3,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        /// Sub Title / Description
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          child: JPText(
                            text: 'division_mismatch_desc'.tr,
                            textColor: JPAppTheme.themeColors.tertiary,
                            textSize: JPTextSize.heading5,
                            textAlign: TextAlign.start,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        /// Division from Job
                        WorksheetDivisionSelectorTile(
                          label: 'division_from_job'.tr,
                          selectedDivisionId: controller.selectedDivisionId,
                          division: controller.jobDivision,
                          defaultDivision: controller.defaultDivision,
                          onChanged: controller.onTapDivision,
                        ),
                        Divider(
                          height: 2,
                          indent: 16,
                          endIndent: 16,
                          color: JPAppTheme.themeColors.lightestGray,
                        ),
                        /// Division from Favourite
                        WorksheetDivisionSelectorTile(
                          label: 'division_from_favourite'.tr,
                          selectedDivisionId: controller.selectedDivisionId,
                          division: controller.favouriteDivision,
                          defaultDivision: controller.defaultDivision,
                          onChanged: controller.onTapDivision,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        /// Buttons
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              /// Cancel
                              Expanded(
                                flex: JPResponsiveDesign.popOverButtonFlex,
                                child: JPButton(
                                  text: 'cancel'.toUpperCase(),
                                  onPressed: controller.onTapCancel,
                                  fontWeight: JPFontWeight.medium,
                                  size: JPButtonSize.small,
                                  colorType: JPButtonColorType.lightGray,
                                  textColor: JPAppTheme.themeColors.tertiary,
                                ),
                              ),
                              const SizedBox(width: 15),
                              /// Apply
                              Expanded(
                                flex: JPResponsiveDesign.popOverButtonFlex,
                                child: JPButton(
                                  onPressed: controller.onTapApply,
                                  text: 'apply'.tr.toUpperCase(),
                                  fontWeight: JPFontWeight.medium,
                                  size: JPButtonSize.small,
                                  colorType: JPButtonColorType.tertiary,
                                  textColor: JPAppTheme.themeColors.base,
                                  disabled: controller.isApplyButtonDisabled,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

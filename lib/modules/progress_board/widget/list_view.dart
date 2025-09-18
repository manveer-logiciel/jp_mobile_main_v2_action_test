import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/IconButton/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../core/constants/work_flow_stage_color.dart';
import '../../../core/utils/color_helper.dart';
import '../../../global_widgets/details_listing_tile/widgets/label_value_tile.dart';
import '../../../global_widgets/progress_board_list_view/index.dart';
import '../../../global_widgets/replace_job_id_with_company_setting/job_name_with_company_setting.dart';
import '../controller.dart';

class ProgressBoardList extends StatelessWidget {
  const ProgressBoardList({
    super.key,
    required this.controller
  });

  final ProgressBoardController controller;

  @override
  Widget build(BuildContext context) {
    return JPProgressBoardList(
      controller: controller,
      headerHeight: 20,
      noOfRows: controller.boardList.length,
      noOfColumns: controller.tabList.length,
      headerWidget: headerWidget,
      separatorWidget: separatorWidget,
      contentWidget: contentWidget,
    );
  }

  Widget headerWidget(int columnIndex) => Padding(
    padding: const EdgeInsets.only(left: 9),
    child: JPText(
      text: controller.tabList[columnIndex].name?.capitalize ?? "",
      textAlign: TextAlign.start,
      textColor: JPAppTheme.themeColors.darkGray,
      textSize: JPTextSize.heading5,
    ),
  );

  Widget separatorWidget(int rowsIndex) => Padding(
    padding:  const EdgeInsets.fromLTRB(10, 3, 10, 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 7),
          child: JPText(
            text: "${rowsIndex + 1}.",
            textColor: JPAppTheme.themeColors.tertiary,
            textSize: JPTextSize.heading5,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: JobNameWithCompanySetting(
                          isClickable : true,
                          job: controller.boardList[rowsIndex],
                          textColor: JPAppTheme.themeColors.primary,
                          textSize: JPTextSize.heading5,
                          fontWeight: JPFontWeight.medium),
                      ),
                    ),
                    Row(
                      children: [
                        JPIconButton(
                          onTap: () => controller.updateExpendableWidget(rowsIndex),
                          backgroundColor: JPColor.transparent,
                          icon: controller.boardList[rowsIndex].isExpended ?? false
                              ? Icons.expand_less : Icons.expand_more,
                          iconColor: JPAppTheme.themeColors.primary,
                        ),
                        if(controller.isUserHaveEditPermission)...{
                          JPIconButton(
                            onTap: () => controller.archiveJob(rowsIndex),
                            backgroundColor: JPColor.transparent,
                            icon: controller.boardList[rowsIndex].archived
                                ?.isEmpty ?? true
                                ? Icons.archive_outlined : Icons
                                .unarchive_outlined,
                            iconColor: JPAppTheme.themeColors.primary,
                          ),
                          JPIconButton(
                            onTap: () => controller.deleteJob(rowsIndex),
                            backgroundColor: JPColor.transparent,
                            icon: Icons.delete_outline,
                            iconColor: JPAppTheme.themeColors.primary,
                          ),
                        },
                      ],
                    ),
                  ],
                ),
                ///   Job Type
                JPText(
                  text: controller.boardList[rowsIndex].jobTypesString ?? "",
                  textColor: JPAppTheme.themeColors.tertiary,
                  textSize: JPTextSize.heading5,
                  textAlign: TextAlign.start,
                ),
                ///   Address
                Visibility(
                  visible: controller.boardList[rowsIndex].isExpended ?? false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: controller.boardList[rowsIndex].addressString?.isNotEmpty ?? false,
                        child: const SizedBox(height: 5,)),
                      LabelValueTile(
                        visibility: controller.boardList[rowsIndex].addressString?.isNotEmpty ?? false,
                        label: "${"address".tr}: ",
                        value: controller.boardList[rowsIndex].addressString ?? "",
                        textSize: JPTextSize.heading5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Wrap(
                          alignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          children: [
                            JPRichText(
                              text: JPTextSpan.getSpan(
                                "${"salesman_customer_rep".tr}: ",
                                textColor: JPAppTheme.themeColors.secondaryText,
                                textAlign: TextAlign.right,
                                textSize: JPTextSize.heading5,
                                children: [
                                  JPTextSpan.getSpan(
                                    (controller.boardList[rowsIndex].reps?.isEmpty ?? true)
                                      ? "unassigned".tr
                                      : controller.boardList[rowsIndex].reps?[0].fullName.toString() ?? "",
                                    maxLine: 3,
                                    height: 1.2,
                                    textSize: JPTextSize.heading5,
                                    overflow: TextOverflow.ellipsis,
                                    textColor: JPAppTheme.themeColors.tertiary)
                                  ]
                              ),
                            ),
                            const SizedBox(width: 10,),
                            JPRichText(
                              text: JPTextSpan.getSpan(
                                "${"stage".tr}: ",
                                textColor: JPAppTheme.themeColors.secondaryText,
                                textAlign: TextAlign.right,
                                textSize: JPTextSize.heading5,
                                children: [
                                  JPTextSpan.getSpan(
                                    controller.boardList[rowsIndex].currentStage?.name ?? "",
                                    maxLine: 3,
                                    height: 1.2,
                                    textSize: JPTextSize.heading5,
                                    overflow: TextOverflow.ellipsis,
                                    textColor: WorkFlowStageConstants.colors[controller.boardList[rowsIndex].currentStage!.color],)
                                ]
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    ),
  );

  Widget contentWidget(int rowIndex, int columnIndex) => Material(
    color: ColorHelper.getHexColor(controller.boardList[rowIndex].pbEntries?.isNotEmpty ?? false
        ? ((controller.boardList[rowIndex].pbEntries?.length ?? 0) > columnIndex)
        ? controller.boardList[rowIndex].pbEntries![columnIndex]?.color ?? "" : "" : ""),
    child: InkWell(
      onTap: controller.isProgressBoardManageable()
        ? () => controller.editProgressBoard(controller.boardList[rowIndex], rowIndex, columnIndex)
        : null,
      child: Container(
        width: 140,
        alignment: Alignment.center,
        child: Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, (controller.boardList[rowIndex].pbEntries?[columnIndex]?.task != null) ? 15 : 10),
                  child: controller.getBoardWidget(controller.boardList[rowIndex].pbEntries, columnIndex),
                )
              )
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Visibility(
                visible: controller.boardList[rowIndex].pbEntries?[columnIndex]?.task != null,
                child: JPIconButton(
                  onTap: () => controller.navigateToTaskDetailScreen(rowIndex, columnIndex),
                  icon: Icons.dataset_linked_outlined,
                  iconColor: JPAppTheme.themeColors.primary,
                  backgroundColor: JPColor.transparent,
                  iconSize: 17,
                ),
              )),
          ],
        ),
      ),
    ),
  );
}
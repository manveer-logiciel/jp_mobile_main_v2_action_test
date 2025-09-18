import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/core/constants/phases_visibility.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/IconButton/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../common/enums/progressboard_listing.dart';
import '../../../../common/models/progress_board/progress_board_entries.dart';
import '../../../../core/constants/progress_board.dart';
import '../../../../core/utils/color_helper.dart';
import '../../../../global_widgets/loader/index.dart';
import '../../../../global_widgets/replace_job_id_with_company_setting/job_name_with_company_setting.dart';
import '../../../../global_widgets/safearea/safearea.dart';
import '../../../../global_widgets/task_tile/index.dart';
import 'controller.dart';

class EditPBDialog extends StatelessWidget {
  const EditPBDialog({
    super.key,
    this.jobModel,
    this.rowIndex,
    this.columnIndex,
    this.columnId,
    this.colorList,
    this.onApply,
    this.onCancel,
    this.pbElement,
  });

  final JobModel? jobModel;
  final int? rowIndex;
  final int? columnIndex;
  final int? columnId;
  final List<String>? colorList;
  final Function(ProgressBoardEntriesModel progressBoardEntriesModel)? onApply;
  final Function(ProgressBoardEntriesModel progressBoardEntriesModel)? onCancel;
  final ProgressBoardEntriesModel? pbElement;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Helper.hideKeyboard(),
      child: JPSafeArea(
        child: GetBuilder<EditPBDialogController>(
          global: false,
          init: EditPBDialogController(jobModel: jobModel, rowIndex: rowIndex, columnIndex: columnIndex,
              colorList: colorList, columnId: columnId, pbElement: pbElement),
          builder: (controller) => AlertDialog(
              insetPadding: const EdgeInsets.all(10),
              contentPadding: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
              content: Builder(builder: (context) => SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///   header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 13, 13, 0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            JPText(
                              text: "choose_option".tr.toUpperCase(),
                              textSize: JPTextSize.heading3,
                              fontWeight: JPFontWeight.medium,
                            ),
                            Row(
                              children: [
                                Visibility(
                                  visible: controller.pbElement?.task == null && PhasesVisibility.canShowSecondPhase,
                                  child: JPButton(
                                    text: 'create_task'.tr,
                                    onPressed: () => controller.navigateToCreateTask(task: controller.pbElement?.task),
                                    fontWeight: JPFontWeight.regular,
                                    size: JPButtonSize.extraSmall,
                                    colorType: JPButtonColorType.primary,
                                    textColor: JPAppTheme.themeColors.tertiary,
                                  ),
                                ),
                                JPIconButton(
                                  isDisabled: controller.isLoading,
                                  onTap: ()  {
                                    Helper.hideKeyboard();
                                    onCancel!(controller.pbElement!);
                                  },
                                  backgroundColor: JPColor.transparent,
                                  icon: Icons.clear,
                                  iconColor: JPAppTheme.themeColors.text,
                                  iconSize: 24,
                                ),
                              ],
                            ),
                          ]
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 13, 20),
                      child: JobNameWithCompanySetting(
                        job: controller.jobModel!,
                        textColor: JPAppTheme.themeColors.darkGray,
                        textSize: JPTextSize.heading4,
                        fontWeight: JPFontWeight.regular,
                        textDecoration: TextDecoration.underline,
                        isClickable: true,
                      ),
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Form(
                          key: controller.editPBFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ///   Radio Buttons
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 0, 13, 5),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 50,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ///   Follow-up Radio Buttons
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 10),
                                            child: JPRadioBox(
                                              groupValue: controller.radioGroup,
                                              onChanged: (val) => controller.updateRadioValue(val),
                                              radioData: [JPRadioData(
                                                  value: PBChooseOptionKey.none,
                                                  label: PBConstants.getPBChooseOptionLabel(PBChooseOptionKey.none))],
                                            ),
                                          ),
                                          ///   Lost Job Radio Buttons
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 10),
                                            child: JPRadioBox(
                                              groupValue: controller.radioGroup,
                                              onChanged: (val) => controller.updateRadioValue(val),
                                              radioData: [JPRadioData(
                                                  value: PBChooseOptionKey.date,
                                                  label: PBConstants.getPBChooseOptionLabel(PBChooseOptionKey.date))],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 50,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ///   Undecided Radio Buttons
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 10),
                                            child: JPRadioBox(
                                              groupValue: controller.radioGroup,
                                              onChanged: (val) => controller.updateRadioValue(val),
                                              radioData: [JPRadioData(
                                                  value: PBChooseOptionKey.markAsDone,
                                                  label: PBConstants.getPBChooseOptionLabel(PBChooseOptionKey.markAsDone))],
                                            ),
                                          ),
                                          ///   No Action Required Radio Buttons
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 10),
                                            child: JPRadioBox(
                                              groupValue: controller.radioGroup,
                                              onChanged: (val) => controller.updateRadioValue(val),
                                              radioData: [JPRadioData(
                                                  value: PBChooseOptionKey.addNote,
                                                  label: PBConstants.getPBChooseOptionLabel(PBChooseOptionKey.addNote))],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ///
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ///   note
                                  Visibility(
                                    visible: controller.radioGroup == PBChooseOptionKey.addNote,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                                      child: JPInputBox(
                                        controller: controller.noteTextController,
                                        fillColor: JPColor.white,
                                        type: JPInputBoxType.withLabel,
                                        label: "note".tr.capitalize,
                                        readOnly: false,
                                        maxLines: 5,
                                        maxLength: 500,
                                        validator: (val) => (val?.isEmpty ?? true) ? "please_enter_note".tr : "",
                                      ),
                                    ),
                                  ),
                                  ///   date
                                  Visibility(
                                    visible: controller.radioGroup == PBChooseOptionKey.date,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                                      child: JPInputBox(
                                        onPressed: () => controller.selectDate(),
                                        controller: controller.dateTextController,
                                        fillColor: JPColor.white,
                                        type: JPInputBoxType.withLabel,
                                        label: "date".tr.capitalize,
                                        hintText: "select_date".tr.capitalize,
                                        readOnly: true,
                                        validator: (val) => (val?.isEmpty ?? true) ? "please_select_date".tr : "",
                                      ),
                                    ),
                                  ),
                                  Divider(color: JPAppTheme.themeColors.inverse, thickness: 1,),
                                  ///   Toggle button
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(20, 20, 15, 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        JPText(
                                          text: "set_color".tr.toUpperCase(),
                                          textSize: JPTextSize.heading4,
                                          fontWeight: JPFontWeight.medium,
                                        ),
                                        JPTextButton(
                                          onPressed: () => controller.resetSelectedColor(),
                                          icon: Icons.restart_alt_outlined,
                                          color: JPAppTheme.themeColors.primary,
                                          iconSize: 14,
                                          iconPosition: JPPosition.start,
                                          text: " " + "reset".tr,
                                          textSize: JPTextSize.heading5,
                                          fontWeight: JPFontWeight.medium,
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(20, 0, 10, 16),
                                    child: Wrap(
                                      crossAxisAlignment: WrapCrossAlignment.start,
                                      alignment: WrapAlignment.start,
                                      runAlignment: WrapAlignment.start,
                                      children: [
                                        for(int i = 0; i < (controller.colorList?.length ?? 0); i++) Padding(
                                          padding: const EdgeInsets.only(top: 10, right: 5),
                                          child: Material(
                                            color: ColorHelper.getHexColor(controller.colorList?[i] ?? ""),
                                            borderRadius: BorderRadius.circular(100),
                                            child: InkWell(
                                              onTap: () => controller.updateColorSelection(controller.colorList![i]),
                                              borderRadius: BorderRadius.circular(100),
                                              child: JPAvatar(
                                                borderColor: JPAppTheme.themeColors.dimGray,
                                                borderWidth: 1,
                                                size: JPAvatarSize.size_30x30,
                                                child: controller.colorList![i] == controller.selectedColor
                                                  ? JPIconButton(
                                                    backgroundColor: JPColor.transparent,
                                                    icon: Icons.check,
                                                    iconColor: JPAppTheme.themeColors.primary,
                                                    iconSize: 14,
                                                  ) : const SizedBox.shrink(),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: controller.pbElement?.task != null,
                                    child: Divider(color: JPAppTheme.themeColors.inverse, thickness: 1,)),
                                  ///   Task
                                  Visibility(
                                    visible: controller.pbElement?.task != null,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(20, 20, 10, 0),
                                          child: JPText(
                                            text: "task".tr.toUpperCase(),
                                            textSize: JPTextSize.heading4,
                                            fontWeight: JPFontWeight.medium,
                                          ),
                                        ),
                                        InkWell(
                                          child: controller.pbElement?.task != null
                                            ? Padding(
                                              padding: const EdgeInsets.only(left: 8, right: 7),
                                              child: DailyPlanTasksListTile(
                                                taskItem: controller.pbElement!.task!,
                                                showBorder: false,
                                                showCheckBox: false,
                                                showTaskAlertIcon: false,
                                              ),
                                            ) : null,
                                          onTap: () => controller.navigateToTaskDetailScreen()
                                        )
                                      ],
                                    )
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    ///   bottom buttons
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: JPResponsiveDesign.popOverButtonFlex,
                              child: JPButton(
                                text: 'cancel'.tr.toUpperCase(),
                                onPressed: () {
                                  Helper.hideKeyboard();
                                  onCancel!(controller.pbElement!);
                                },
                                disabled: controller.isLoading,
                                fontWeight: JPFontWeight.medium,
                                size: JPButtonSize.small,
                                colorType: JPButtonColorType.lightGray,
                                textColor: JPAppTheme.themeColors.tertiary,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              flex: JPResponsiveDesign.popOverButtonFlex,
                              child: JPButton(
                                onPressed: () => controller.validateAndSave(onApply),
                                text: controller.isLoading ? "" : 'save'.tr.toUpperCase(),
                                fontWeight: JPFontWeight.medium,
                                size: JPButtonSize.small,
                                colorType: JPButtonColorType.primary,
                                textColor: JPAppTheme.themeColors.base,
                                iconWidget: showJPConfirmationLoader(show: controller.isLoading),
                                disabled: controller.isLoading,
                              ),
                            )
                          ]
                      ),
                    ),
                  ],
                ),
              ))
          )
        ),
      ),
    );
  }
}

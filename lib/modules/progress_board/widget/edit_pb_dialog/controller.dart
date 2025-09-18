import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/progress_board/progress_board_entries.dart';
import '../../../../common/enums/progressboard_listing.dart';
import '../../../../common/enums/task_form_type.dart';
import '../../../../common/models/job/job.dart';
import '../../../../common/models/task_listing/task_listing.dart';
import '../../../../common/repositories/progress_board.dart';
import '../../../../common/services/task/quick_actions.dart';
import '../../../../core/constants/date_formats.dart';
import '../../../../core/constants/navigation_parms_constants.dart';
import '../../../../core/constants/progress_board.dart';
import '../../../../core/utils/date_time_helpers.dart';
import '../../../../routes/pages.dart';

class EditPBDialogController extends GetxController {

  final GlobalKey<FormState> editPBFormKey = GlobalKey<FormState>();

  TextEditingController dateTextController = TextEditingController();
  TextEditingController noteTextController = TextEditingController();

  PBChooseOptionKey? radioGroup;

  final JobModel? jobModel;
  final ProgressBoardEntriesModel? pbElement;

  final int? rowIndex;
  final int? columnIndex;
  final int? columnId;

  String selectedColor = "";
  String? selectedDate;

  bool isLoading = false;

  final List<String>? colorList;

  EditPBDialogController({
    this.jobModel,
    this.rowIndex,
    this.columnIndex,
    this.colorList,
    this.columnId,
    this.pbElement
  });

  @override
  void onInit() {
    super.onInit();
    radioGroup = PBChooseOptionKey.none;
    initData();
  }

  void initData(){

    if(((jobModel?.pbEntries?.length ?? 0) > (columnIndex ?? 0))
      && (jobModel?.pbEntries?[columnIndex!]?.color?.isNotEmpty ?? false)) {
      selectedColor = jobModel!.pbEntries![columnIndex!]!.color!;
    }
    if(((jobModel?.pbEntries?.length ?? 0) > (columnIndex ?? 0))
        && (jobModel?.pbEntries?[columnIndex!]?.data?["type"]?.isNotEmpty ?? false)) {
      radioGroup = PBConstants.getPBChooseOptionKey(jobModel!.pbEntries![columnIndex!]!.data!["type"]);
    }

    if(((jobModel?.pbEntries?.length ?? 0) > (columnIndex ?? 0))
        && (jobModel?.pbEntries?[columnIndex!]?.data?["value"] ?? 0) is! int
        && (jobModel?.pbEntries?[columnIndex!]?.data?["value"]?.isNotEmpty ?? false)) {
      switch(radioGroup) {
        case PBChooseOptionKey.date:
          selectedDate = jobModel!.pbEntries![columnIndex!]!.data!["value"];
          dateTextController.text = DateTimeHelper.convertHyphenIntoSlash(jobModel!.pbEntries![columnIndex!]!.data!["value"]);
          break;
        case PBChooseOptionKey.addNote:
          noteTextController.text = jobModel!.pbEntries![columnIndex!]!.data!["value"];
          break;
        default:
          break;
      }
    }
    update();
  }

  void updateRadioValue(PBChooseOptionKey val) {
    radioGroup = val;
    update();
  }

  void updateColorSelection(String color) {
    selectedColor = color;
    update();
  }

  void resetSelectedColor() {
    selectedColor = "";
    update();
  }

  void selectDate() {
    DateTimeHelper.openDatePicker(
      initialDate: selectedDate,
      helpText: "select_date".tr).then((dateTime) {
        if(dateTime != null) {
          selectedDate = DateTimeHelper.format(dateTime.toString(), DateFormatConstants.dateServerFormat);
          dateTextController.text = DateTimeHelper.format(dateTime.toString(), DateFormatConstants.dateOnlyFormat);
        }
        update();
      });
  }

  void validateAndSave(Function(ProgressBoardEntriesModel progressBoardEntriesModel)? onApply) {
    if(editPBFormKey.currentState?.validate() ?? false) {
      editPBFormKey.currentState!.save();
      updateLoading();
      saveProgressBoardData(onApply);
    }
  }

  void saveProgressBoardData(Function(ProgressBoardEntriesModel progressBoardEntriesModel)? onApply) async {
    try {
      String value = "";
      switch(radioGroup){
        case PBChooseOptionKey.date:
          value = selectedDate!;
          break;
        case PBChooseOptionKey.addNote:
          value = noteTextController.text.trim();
          break;
        default:
          value = "1";
      }

      Map<String, dynamic> params = {
        "column_id": columnId,
        "data": jsonEncode({
          "type": PBConstants.getPBChooseOptionConstants(radioGroup!),
          "value": value
        }),
        "job_id": jobModel?.id,
        "color": selectedColor,
        "task_id": pbElement?.task?.id,
      };
      Map<String, dynamic> response = await ProgressBoardRepository().editProgressBoardEntries(params);
      if(onApply != null) {
        onApply(response["data"]);
      }
      update();
    } catch (e) {
      rethrow;
    } finally {
      if(onApply != null) {
        updateLoading();
      }
    }
  }

  void updateLoading() {
    isLoading = !isLoading;
    update();
  }

  Future<void> navigateToCreateTask({TaskListModel? task}) async {

    await Get.toNamed(Routes.createTaskForm, arguments: {
      NavigationParams.task: task,
      NavigationParams.jobModel: jobModel,
      NavigationParams.pageType: task == null ? TaskFormType.progressBoardCreate : TaskFormType.progressBoardEdit,
    }, preventDuplicates: false)?.then((result) {
      if(result != null && result["status"]) {
        pbElement?.task = result["data"];
        update();
        result = null;
        saveProgressBoardData(null);
        update();
      }
    });
  }

  void handleQuickActionUpdate(TaskListModel task, String action) {

    switch (action) {
      case 'mark_as_complete':
        pbElement?.task?.completed = task.completed;
        break;

      case 'edit':
        navigateToCreateTask(task: task);
        break;

      case 'delete':
        pbElement!.task = null;
        break;

      case 'add_to_daily_plan':
        pbElement?.task?.dueDate = task.dueDate;
        break;
      default:
    }

    update();
  }

  @override
  void dispose() {
    dateTextController.dispose();
    noteTextController.dispose();
    super.dispose();
  }

  void navigateToTaskDetailScreen() => TaskService.openTaskdetail(
    task: pbElement?.task,
    callback: handleQuickActionUpdate
  );

}
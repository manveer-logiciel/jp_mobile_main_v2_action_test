import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/extensions/mix_panel/extension.dart';
import 'package:jobprogress/core/constants/mix_panel/titles.dart';
import 'package:jobprogress/global_widgets/has_permission/index.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';
import 'package:jp_mobile_flutter_ui/IconButton/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../common/enums/task_form_type.dart';
import '../../common/models/job/job.dart';
import '../../common/models/progress_board/production_board_column.dart';
import '../../common/models/progress_board/progress_board_entries.dart';
import '../../common/models/progress_board/progress_board_filter_model.dart';
import '../../common/models/progress_board/progress_board_moadel.dart';
import '../../common/models/task_listing/task_listing.dart';
import '../../common/repositories/progress_board.dart';
import '../../common/services/permission.dart';
import '../../common/services/task/quick_actions.dart';
import '../../core/constants/date_formats.dart';
import '../../core/constants/navigation_parms_constants.dart';
import '../../core/constants/permission.dart';
import '../../core/utils/date_time_helpers.dart';
import '../../core/utils/helpers.dart';
import '../../global_widgets/bottom_sheet/controller.dart';
import '../../global_widgets/bottom_sheet/index.dart';
import '../../global_widgets/loader/index.dart';
import '../../global_widgets/single_field_shimmer/index.dart';
import '../../routes/pages.dart';
import 'widget/edit_pb_dialog/index.dart';

class ProgressBoardController extends GetxController {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  ProgressBoardFilterModel filterKeys = ProgressBoardFilterModel();
  ProgressBoardFilterModel defaultFilters = ProgressBoardFilterModel();

  List<JobModel> boardList = [];
  List<String> colorList = [];

  int rowCount = 10;
  int pagination = 0;

  bool isLoading = true;
  bool isLoadMore = false;
  bool canShowLoadMore = false;
  bool isUserHaveEditPermission = true;

  List<ProductionBoardColumn> tabList = [];
  List<JPSingleSelectModel> pbList = [];
  String? jobNumber = Get.arguments?['job_number'];

  @override
  void onInit() {
    super.onInit();
    fetchColorList();
    fetchProgressBoardList();

    isUserHaveEditPermission = PermissionService.hasUserPermissions([PermissionConstants.manageProgressBoard]);
  }

  ////////////////////////   FETCH PROGRESS BOARD LIST   ///////////////////////

  Future<void> fetchProgressBoardList() async {
    try {
      filterKeys.jobNumber ??= jobNumber;
      Map<String, dynamic> response = await ProgressBoardRepository().fetchProgressBoardList(filterKeys.progressBardListToJson());
      List<ProgressBoardModel> list = response["list"];
      pbList = [];
      for (var pbItem in list) {
        pbList.add(JPSingleSelectModel(
          id: pbItem.id!.toString(), label: pbItem.name!));
      }
      // ignore: sdk_version_since
      filterKeys.boardId ??= int.tryParse(Get.arguments?[NavigationParams.id]?.toString() ?? "") ?? int.tryParse(pbList.firstOrNull?.id ?? '');
      filterKeys.selectedPB ??= pbList.firstWhereOrNull((element) => (int.parse(element.id) == (filterKeys.boardId ?? 0)))?.label;

      defaultFilters = ProgressBoardFilterModel.copy(filterKeys);
    } catch (e) {
      rethrow;
    } finally {
      update();
      fetchProgressBoardColumns();
    }
  }

  ///////////////////////   CHANGE PROGRESS BOARD LIST   ///////////////////////

  void updateProgressBoard(String value, List<JPSingleSelectModel> list) {
    filterKeys.boardId = int.parse(value);
    filterKeys.selectedPB = list.firstWhereOrNull((element) => (element.id == filterKeys.boardId.toString()))?.label;
    defaultFilters = ProgressBoardFilterModel.copy(filterKeys);
    refreshList(showShimmer: true).trackUpdateEvent(MixPanelEventTitle.progressBoardSwitch);
    Get.back();
  }

  ///////////////////////   FETCH PROGRESS BOARD COLUMNS   /////////////////////

  Future<void> fetchProgressBoardColumns() async {
    try {
      if(filterKeys.boardId != null) {
        Map<String, dynamic> response = await ProgressBoardRepository().fetchProgressBoardColumns(
            filterKeys.progressBardColumnsToJson());
        List<ProductionBoardColumn> list = response["list"];
        tabList = [];
        tabList.addAll(list);
      } else {
        tabList = [];
      }
    } catch (e) {
      rethrow;
    } finally {
      update();
      fetchJobProgressBoard();
    }
  }

  ///////////////////////////   FETCH PROGRESS BOARD   /////////////////////////

  Future<void> fetchJobProgressBoard() async {
    try {
      if(filterKeys.boardId != null) {
        Map<String, dynamic> response = await ProgressBoardRepository().fetchJobProgressBoardList(filterKeys.toJson());
        List<JobModel> list = sortPBEntries(response["list"]);
        if (!isLoadMore) {
          boardList = [];
        }
        boardList.addAll(list);
        pagination = (response["pagination"].total ?? 0);
        canShowLoadMore = boardList.length < pagination;
      } else {
        boardList = [];
      }
      update();
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      isLoadMore = false;
      update();
    }
  }

  ///////////////////////////   FETCH COLOR LIST   /////////////////////////////

  Future<void> fetchColorList() async {
    try {
      Map<String, dynamic> response = await ProgressBoardRepository().fetchColorList(filterKeys.progressBardColorJson());
      List<String> list = response["list"];
      colorList = [];
      colorList.addAll(list);
    } catch (e) {
      rethrow;
    } finally {
      update();
    }
  }

  //////////////////////////////   REFRESH LIST   //////////////////////////////

  ///showLoading is used to show shimmer if refresh is pressed from main drawer
  Future<void> refreshList({bool? showShimmer}) async {
    filterKeys.page = 1;
    ///   show shimmer if showLoading = true
    isLoading = showShimmer ?? false;
    await fetchProgressBoardColumns();
  }

  ////////////////////////////   FETCH NEXT PAGE   /////////////////////////////

  Future<void> loadMore() async {
    filterKeys.page += 1;
    isLoadMore = true;
    await fetchJobProgressBoard();
    update();
  }

  /////////////////////////    EDIT PROGRESS BOARD    //////////////////////////

  void editProgressBoard(JobModel jobModel, int rowIndex, int columnIndex) {
    showJPGeneralDialog(
      isDismissible: false,
        child:(controller) => EditPBDialog(
          jobModel: jobModel,
          pbElement: boardList[rowIndex].pbEntries![columnIndex],
          rowIndex: rowIndex,
          columnIndex: columnIndex,
          colorList: colorList,
          columnId: tabList[columnIndex].id,
          onApply: (ProgressBoardEntriesModel progressBoardEntriesModel) {
            Get.back();
            if(boardList[rowIndex].pbEntries?.isNotEmpty ?? false) {
              boardList[rowIndex].pbEntries![columnIndex] = progressBoardEntriesModel;
            } else {
              boardList[rowIndex].pbEntries = [];
              for(int i = 0; i < tabList.length; i++) {
                if(columnIndex == i) {
                  boardList[rowIndex].pbEntries!.add(progressBoardEntriesModel);
                } else {
                  boardList[rowIndex].pbEntries!.add(ProgressBoardEntriesModel());
                }
              }
            }
            update();
          },
          onCancel: (ProgressBoardEntriesModel progressBoardEntriesModel) {
            Get.back();
            boardList[rowIndex].pbEntries?[columnIndex]?.task = progressBoardEntriesModel.task;
            update();
          },
        )
    );
  }

  /////////////////////////////    ARCHIVE JOB    //////////////////////////////

  void archiveJob(int rowsIndex) {
    bool isArchived = boardList[rowsIndex].archived?.isEmpty ?? true;
    showJPBottomSheet(
        child: (JPBottomSheetController controller) {
          return JPConfirmationDialog(
            icon: isArchived ? Icons.archive_outlined : Icons.unarchive_outlined,
            title: "confirmation".tr,
            subTitle: isArchived ? "job_archive_conformation".tr : "job_unarchive_conformation".tr,
            prefixBtnText: "no".tr,
            suffixBtnText: isArchived ? 'archive'.tr : 'yes'.tr,
            disableButtons: controller.isLoading,
            suffixBtnIcon: showJPConfirmationLoader(show: controller.isLoading),
            onTapSuffix: () {
              controller.toggleIsLoading();
              archiveJobOnServer(boardList[rowsIndex].id, isArchived, rowsIndex,controller.toggleIsLoading);
            },
          );
        });
  }

  Future<void> archiveJobOnServer(int jobId, bool isArchived, int rowsIndex, VoidCallback toggleLoading) async {
    try {
      var response = await ProgressBoardRepository().archiveJob(filterKeys.progressBardArchiveJson(jobId, isArchived)).trackArchiveEvent(MixPanelEventTitle.progressBoardJobArchive);
      if (int.parse(response["data"].toString()) == 200) {
        Helper.showToastMessage(isArchived ? "job_archived".tr : "job_unarchived".tr );
        if(filterKeys.isArchivedJobsVisible ?? false) {
          if(isArchived) {
            boardList[rowsIndex].archived = DateTimeHelper.formatDate(
                DateTime.now().toString(), DateFormatConstants.dateTimeFormatWithoutSeconds);
          } else {
            boardList[rowsIndex].archived = null;
          }
        } else {
          boardList.removeAt(rowsIndex);
        }
        update();
      }
       Get.back();
    } catch (e) {
      rethrow;
    } finally {
      toggleLoading();
     
    }
  }

  //////////////////////////////    DELETE JOB    //////////////////////////////

  void deleteJob(int rowsIndex) {
    showJPBottomSheet(
        isDismissible: false,
        child: (JPBottomSheetController controller) {
          return JPConfirmationDialog(
            icon: Icons.delete_outline,
            title: "confirmation".tr,
            subTitle: "remove_job_message".tr,
            prefixBtnText: "no".tr,
            suffixBtnText: 'delete'.tr,
            disableButtons: controller.isLoading,
            suffixBtnIcon: showJPConfirmationLoader(show: controller.isLoading),
            onTapSuffix: () {
              controller.toggleIsLoading();
              deleteJobOnServer(boardList[rowsIndex].id, rowsIndex,controller.toggleIsLoading).trackDeleteEvent(MixPanelEventTitle.progressBoardJobDelete);
            },
          );
        });
  }

  Future<void> deleteJobOnServer(int jobId, int rowsIndex, VoidCallback toggleIsLoading) async {
    try {
      var response = await ProgressBoardRepository().deleteJob(filterKeys.progressBardDeleteJson(jobId));
      if (int.parse(response["data"].toString()) == 200) {
        Helper.showToastMessage("job_deleted".tr );
        boardList.removeAt(rowsIndex);
        update();
        Get.back();
      }
    } catch (e) {
      rethrow;
    } finally {
      toggleIsLoading();
    }
  }

  /////////////////////////////   FILTER LIST   ////////////////////////////////

  void applyFilters(ProgressBoardFilterModel params) {
    filterKeys = params;
    filterKeys.page = 1;
    isLoading = true;
    update();
    fetchJobProgressBoard().trackFilterEvents();
  }

  /////////////////////////////   TASK ACTIONS   ///////////////////////////////

  void navigateToTaskDetailScreen(int rowIndex, int columnIndex) => TaskService.openTaskdetail(
    task: boardList[rowIndex].pbEntries?[columnIndex]?.task,
    callback: (TaskListModel task, String action) => handleQuickActionUpdate(task, action, rowIndex, columnIndex),
    isUserHaveEditPermission: isUserHaveEditPermission
  );

  void handleQuickActionUpdate(TaskListModel task, String action, int rowIndex, int columnIndex) {

    switch (action) {
      case 'mark_as_complete':
        boardList[rowIndex].pbEntries?[columnIndex]?.task?.completed = task.completed;
        break;

      case 'edit':
        update();
        Get.back();
        navigateToCreateTask(task: task, rowIndex: rowIndex, columnIndex: columnIndex);
        break;

      case 'delete':
        boardList[rowIndex].pbEntries?[columnIndex]?.task = null;
        break;

      case 'add_to_daily_plan':
        boardList[rowIndex].pbEntries?[columnIndex]?.task?.dueDate = task.dueDate;
        break;
      default:
    }

    update();
  }

  Future<void> navigateToCreateTask({TaskListModel? task, int? rowIndex, int? columnIndex}) async {

    dynamic result = await Get.toNamed(Routes.createTaskForm, arguments: {
      NavigationParams.task: task,
      NavigationParams.jobModel: boardList[rowIndex!],
      NavigationParams.pageType: task == null ? TaskFormType.progressBoardCreate : TaskFormType.progressBoardEdit,
    });

    if(result != null && result["status"]) {
      boardList[rowIndex].pbEntries?[columnIndex!]?.task = result["data"];
      result = null;
      update();
    }
  }

  //////////////////////////////////////////////////////////////////////////////

  List<JobModel> sortPBEntries(List<JobModel> list) {
    List<ProgressBoardEntriesModel?>? tempEntries = [];

    for (int i = 0; i < list.length; i++) {
      tempEntries = [];
      for (var tab in tabList) {

        int? index = list[i].pbEntries?.indexOf(list[i].pbEntries?.firstWhereOrNull(
                (element) => element?.productionBoardColumn?.id == tab.id));

        if(index != null && index >= 0) {
          tempEntries.add(list[i].pbEntries![index]);
        } else {
          tempEntries.add(ProgressBoardEntriesModel());
        }
      }

      list[i].pbEntries = tempEntries;
    }
    return list;
  }

  Widget getBoardWidget(List<ProgressBoardEntriesModel?>? pbEntries, int columnIndex) {
    if((pbEntries?.isNotEmpty ?? false) && ((pbEntries?.length ?? 0) > columnIndex)) {
      switch (pbEntries![columnIndex]?.data?["type"]) {
        case "input_field":
          return JPReadMoreText(
            pbEntries[columnIndex]?.data!["value"] ?? "--",
            dialogTitle: tabList[columnIndex].name,
            textAlign: TextAlign.start,
            textSize: JPTextSize.heading5,
            textColor: JPAppTheme.themeColors.tertiary,
            trimLines: pbEntries[columnIndex]?.task != null ? 5 : 6,
            height: 1.3,
            showDialogOnReadMore: true,
          );
        case "date":
          return JPText(
            text: DateTimeHelper.convertHyphenIntoSlash(pbEntries[columnIndex]?.data?["value"] ?? ""),
            textSize: JPTextSize.heading5,
            textColor: JPAppTheme.themeColors.tertiary,
          );
        case "markAsDone":
          return JPIconButton(
            backgroundColor: JPAppTheme.themeColors.success,
            borderRadius: 100,
            iconWidget: Padding(
              padding: const EdgeInsets.all(2),
              child: JPIcon(
                Icons.check,
                color: JPAppTheme.themeColors.base,
                size: 18,
              ),
            ),
          );
        default:
          return JPText(
            text: "--",
            textSize: JPTextSize.heading5,
            textColor: JPAppTheme.themeColors.tertiary,
          );
      }
    } else {
      return JPText(
        text: "--",
        textSize: JPTextSize.heading5,
        textColor: JPAppTheme.themeColors.tertiary,
      );
    }
  }

  void updateExpendableWidget(int rowsIndex) {
    boardList[rowsIndex].isExpended = !(boardList[rowsIndex].isExpended ?? false);
    update();
  }

  bool isProgressBoardManageable() => PermissionService.hasUserPermissions([PermissionConstants.manageProgressBoard]);

  void navigateToReorderingJobListing() async {
    dynamic jobList = await Get.toNamed(Routes.reorderAbleJobListing, arguments: {
      NavigationParams.list : boardList,
      NavigationParams.tabList : tabList,
      NavigationParams.filterModel : filterKeys,
      NavigationParams.canShowLoadMore : canShowLoadMore,
    });
    if((jobList?.isNotEmpty ?? false) && (jobList is List<JobModel>)) {
      boardList = jobList;
      canShowLoadMore = boardList.length < pagination;
      update();
    }
  }

  Future<void> printProgressBoard() async {

    if(filterKeys.boardId == null) return;

    try {
      showJPLoader(msg: 'downloading'.tr);
      await ProgressBoardRepository().printProgressBoard(filterKeys.boardId.toString());
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  List<Widget>? getActionButtons() {
    List<Widget>? widgetList = [];

    widgetList.addIf((filterKeys.selectedPB?.isNotEmpty ?? false), HasPermission(
      permissions: const [PermissionConstants.allowDataExports],
      child: Padding(
        padding: const EdgeInsets.only(right: 4),
        child: Center(
          child: JPIconButton(
            backgroundColor: JPColor.transparent,
            onTap: isLoading
                ? null
                : printProgressBoard,
            icon: Icons.print_outlined,
            iconSize: 24,
            iconColor: isLoading
                ? JPAppTheme.themeColors.inverse
                : JPAppTheme.themeColors.base,
          ),
        ),
      ),
    ));

    ///   Reordering Job List Button
    if(isLoading) {
      widgetList.add(JPSingleFieldShimmer(
        child: JPIconButton(
          backgroundColor: JPColor.transparent,
          icon: Icons.auto_awesome_motion_outlined,
          iconSize: 24,
          iconColor: JPAppTheme.themeColors.inverse,
        )));
    } else if(boardList.isNotEmpty && PermissionService.hasUserPermissions([PermissionConstants.manageProgressBoard])) {
      widgetList.add(JPIconButton(
        backgroundColor: JPColor.transparent,
        onTap: navigateToReorderingJobListing,
        icon: Icons.auto_awesome_motion_outlined,
        iconSize: 24,
        iconColor: JPAppTheme.themeColors.base,
      ));
    } else {
      widgetList.add(const SizedBox.shrink());
    }
    ///   Menu Button
    widgetList.add(Padding(
      padding: const EdgeInsets.only(right: 13),
      child: Center(
        child: JPIconButton(
          backgroundColor: JPColor.transparent,
          onTap: () => scaffoldKey.currentState!.openEndDrawer(),
          icon: Icons.menu,
          iconSize: 24,
          iconColor: JPAppTheme.themeColors.base,
        ),
      ),
    ));

    return widgetList;
  }
}
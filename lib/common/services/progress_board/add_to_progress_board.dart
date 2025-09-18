import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/SingleSelect/index.dart';
import 'package:jp_mobile_flutter_ui/SingleSelect/model.dart';

import '../../../core/constants/navigation_parms_constants.dart';
import '../../../core/constants/widget_keys.dart';
import '../../../core/utils/helpers.dart';
import '../../../global_widgets/bottom_sheet/index.dart';
import '../../../global_widgets/loader/index.dart';
import '../../../global_widgets/profile_image_widget/index.dart';
import '../../../routes/pages.dart';
import '../../enums/job_quick_action_callback_type.dart';
import '../../models/job/job.dart';
import '../../models/job/job_production_board.dart';
import '../../repositories/job.dart';

class AddToProgressBoardHelper {

  List<JPMultiSelectModel> progressBoardsList = [];

  final void Function({JobModel? job, int? currentIndex, JobQuickActionCallbackType? callbackType})? onCallback;
  final JobModel jobModel;
  final int index;


  AddToProgressBoardHelper.addInProgressBoard({
    required this.onCallback,
    required this.jobModel,
    required this.index,
  }) {fetchProgressBoards(jobModel, index);}

  AddToProgressBoardHelper.inProgressBoard({
    required this.onCallback,
    required this.jobModel,
    required this.index,
  }) {selectInProgressBoards(jobModel, index);}

  //////////////////////////   FETCH PROGRESS BOARDS   /////////////////////////

  Future<void> fetchProgressBoards (JobModel job, int index) async {
    showJPLoader(msg: "fetching_progress_boards".tr);
    try {
      Map<String, dynamic> params = {
        "limit" : 0,
      };
      if(job.division?.id != null) {
        params.addEntries({"division_ids[0]" : job.division?.id}.entries);
      } else {
        params.addEntries({"unassigned_division" : 1}.entries);
      }
      params.removeWhere((dynamic key, dynamic value) => (key == null ||  value == null));

      var response = await JobRepository.fetchProgressBoards(params);
      if (response is List<JobProductionBoardModel> && response.isNotEmpty) {
        progressBoardsList.clear();
        for (var element in response) {
          progressBoardsList.add(JPMultiSelectModel(
            id: element.id.toString(),
            label: element.name ?? "",
            isSelect: false,
          ));
        }
      }

      Get.back();
      selectProgressBoards(job, index);
    } catch (e) {
      Get.back();
      rethrow;
    }
  }

  //////////    ADD TO PROGRESS BOARD JOB    /////////

  Future<void> selectProgressBoards(JobModel jobModel, int index) async {
    List<int> progressBoardIDs = [];
    for(int i = 0; i < progressBoardsList.length; i++) {
      int? id = jobModel.productionBoards?.firstWhereOrNull((element) => progressBoardsList[i].id == element.id.toString())?.id;
      if(id != null) {
        progressBoardIDs.add(id);
      }
    }
    for(int i = 0; i < progressBoardIDs.length; i++) {
      progressBoardsList.removeWhere((element) => element.id == progressBoardIDs[i].toString());
    }

    if(progressBoardsList.isEmpty) {
      Helper.showToastMessage("no_more_progress_boards_available".tr);
    } else {
      showJPBottomSheet(isScrollControlled: true, child: ((controller) {
        return JPMultiSelect(
          key: const ValueKey(WidgetKeys.multiselect),
          mainList: progressBoardsList,
          inputHintText: 'search'.tr,
          title: "select_boards".tr.toUpperCase(),
          canDisableDoneButton: false,
          doneIcon: showJPConfirmationLoader(show: controller.isLoading),
          disableButtons: controller.isLoading,
          onDone: (List<JPMultiSelectModel>? selectedTrades) async {
            if(jobModel.productionBoards?.isEmpty ?? true){
              jobModel.productionBoards = [];
            }

            for (var element in selectedTrades!) {
              if(element.isSelect) {
                progressBoardIDs.add(int.parse(element.id));
                jobModel.productionBoards?.add(
                    JobProductionBoardModel(id: int.parse(element.id), name: element.label,)
                );
              }
            }

            if(progressBoardIDs.isEmpty) {
              jobModel.productionBoards == null;
            }

            controller.toggleIsLoading();
            await updateProgressBoardsOnServer(progressBoardIDs: progressBoardIDs, job: jobModel, currentIndex: index);
            controller.toggleIsLoading();
            Get.back();
          },
        );
      }));
    }
  }

  //////////    IN-PROGRESS BOARD    /////////

  Future<void> selectInProgressBoards(JobModel jobModel, int index) async {
    List<JPSingleSelectModel> inProgressBoardsList = [];
    bool hasManageProgressPermission = PermissionService.hasUserPermissions([PermissionConstants.manageProgressBoard]);

    for(int i = 0; i < jobModel.productionBoards!.length; i++) {
      inProgressBoardsList.add(JPSingleSelectModel(
          label: jobModel.productionBoards![i].name!,
          id: jobModel.productionBoards![i].id!.toString(),
          child: JPProfileImage(
            initial: (i+1).toString(),
          )
      ));
    }

    if(inProgressBoardsList.isEmpty){
      Helper.showToastMessage("no_more_progress_boards_available".tr);
    } else {
      showJPBottomSheet(isScrollControlled: true, child: ((controller) {
        return JPSingleSelect(
          mainList: inProgressBoardsList,
          inputHintText: "search_progress_board".tr,
          title: "progress_boards".tr.toUpperCase(),
          canShowIconButton: hasManageProgressPermission,
          iconButtonIconSize: 18,
          onIconButtonTap: () {
            Get.back();
            fetchProgressBoards(jobModel, index);
          },
          onItemSelect: (val) async {
            Get.back();
            await Get.toNamed(Routes.progressBoard, preventDuplicates: false, arguments: {
              NavigationParams.id: val,
              NavigationParams.jobNumber : jobModel.number.toString()
            });
            // informs that progress board is page is closed
            onCallback!(job: jobModel, currentIndex: index, callbackType: JobQuickActionCallbackType.openProgressBoardCallback);
          },
        );
      }));
    }
  }

  //////////    UPDATE-PROGRESS BOARD ON SERVER    /////////

  Future<void> updateProgressBoardsOnServer ({List<int>? progressBoardIDs, JobModel? job, int? currentIndex}) async {
    Map<String, dynamic> queryParams = {
      "job_id": job?.id ?? "",
    };
    for(int i = 0; i < (progressBoardIDs?.length ?? 0) ; i++) {
      queryParams.addEntries({"board_ids[$i]" : progressBoardIDs![i]}.entries);
    }

    await JobRepository.updateProgressBoards(queryParams).then((response) {
      if(response == 200) {
        Helper.showToastMessage("added_to_progress_boards".tr);
        for (var element in progressBoardsList) {element.isSelect = false;}
        onCallback!(job: job, currentIndex: currentIndex, callbackType: JobQuickActionCallbackType.addToProgressBoard);
      }
    }).catchError((onError) {Get.back();});
  }

}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../common/models/job/job.dart';
import '../../../common/models/progress_board/production_board_column.dart';
import '../../../common/models/progress_board/progress_board_entries.dart';
import '../../../common/models/progress_board/progress_board_filter_model.dart';
import '../../../common/repositories/progress_board.dart';
import '../../../core/constants/navigation_parms_constants.dart';

class ReorderAbleJobListingController extends GetxController {

  late final ScrollController infiniteScrollController;

  List<JobModel>? jobList;
  List<ProductionBoardColumn>? tabList;
  ProgressBoardFilterModel? filterKeys;
  bool? canShowLoadMore;

  bool isLoading = true;
  bool isLoadMore = false;

  @override
  void onInit() {
    super.onInit();

    jobList = jobList ?? Get.arguments[NavigationParams.list] ?? [];
    tabList = tabList ?? Get.arguments[NavigationParams.tabList] ?? [];
    filterKeys = filterKeys ?? Get.arguments[NavigationParams.filterModel];
    canShowLoadMore = canShowLoadMore ?? Get.arguments[NavigationParams.canShowLoadMore] ?? false;

    infiniteScrollController = ScrollController();

    infiniteScrollController.addListener(() async {
      if((infiniteScrollController.position.pixels + JPResponsiveDesign.floatingButtonSize + 50)
          >= infiniteScrollController.position.maxScrollExtent
          && !isLoadMore) {
        await onLoadMore();
      }
    });
  }

  ///////////////////////////   FETCH PROGRESS BOARD   /////////////////////////

  Future<void> fetchJobProgressBoard() async {
    try {
      if(filterKeys?.boardId != null) {
        Map<String, dynamic> response = await ProgressBoardRepository().fetchJobProgressBoardList(filterKeys?.toJson() ?? {});
        List<JobModel> list = sortPBEntries(response["list"]);
        if (!isLoadMore) {
          jobList = [];
        }
        jobList?.addAll(list);
        canShowLoadMore = (jobList?.length ?? 0) < (response["pagination"].total ?? 0);
      } else {
        jobList = [];
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

  ////////////////////////////   FETCH NEXT PAGE   /////////////////////////////

  Future<void> onLoadMore() async {
    filterKeys?.page += 1;
    isLoadMore = true;
    await fetchJobProgressBoard();
    update();
  }

  /////////////////////////////   RE-ORDER LIST   //////////////////////////////

  void onListItemReorder(int oldIndex, int newIndex) {
    if (oldIndex <= newIndex) {
      newIndex -= 1;
    }
    if(oldIndex == newIndex) return;

    reorderJobListOnServer(oldIndex, newIndex);
  }

  Future<void> reorderJobListOnServer(int oldIndex, int newIndex) async {
    try {
      reorderItem(oldIndex, newIndex);
      showJPLoader(msg: "updating_job_order".tr);
      Map<String, dynamic> params = {
        "order": newIndex,
        "job_id": jobList?[newIndex].id,
        "board_id": filterKeys?.boardId,
      };
      bool response = await ProgressBoardRepository().reorderJob(params);
      if (response) {
        Helper.showToastMessage("updated_jod_order".tr);
      }
    } catch (e) {
      reorderItem(newIndex, oldIndex);
      rethrow;
    } finally {
      Get.back();
    }
  }

  void reorderItem(int oldIndex, int newIndex) {
    JobModel? temp = jobList?.removeAt(oldIndex);
    if(temp != null) {
      jobList?.insert(newIndex, temp);
    }
    update();
  }

  //////////////////////////////////////////////////////////////////////////////

  List<JobModel> sortPBEntries(List<JobModel> list) {
    List<ProgressBoardEntriesModel?>? tempEntries = [];

    for (int i = 0; i < list.length; i++) {
      tempEntries = [];
      if(tabList != null) {
        for (var tab in tabList!) {

          int? index = list[i].pbEntries?.indexOf(list[i].pbEntries?.firstWhereOrNull(
                  (element) => element?.productionBoardColumn?.id == tab.id));

          if(index != null && index >= 0) {
            tempEntries.add(list[i].pbEntries![index]);
          } else {
            tempEntries.add(ProgressBoardEntriesModel());
          }
        }
      }

      list[i].pbEntries = tempEntries;
    }
    return list;
  }

  void toggleIsLoadingMore() {
    isLoadMore = !isLoadMore;
  }

  @override
  void dispose() {
    infiniteScrollController.dispose();
    super.dispose();
  }

}
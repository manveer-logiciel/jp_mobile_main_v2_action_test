import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_upload.dart';
import 'package:jobprogress/common/enums/note_listing.dart';
import 'package:jobprogress/common/extensions/mix_panel/extension.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/note_list/note_listing.dart';
import 'package:jobprogress/common/models/note_list/note_listing_param.dart';
import 'package:jobprogress/common/models/sql/uploader/file_uploader_params.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/models/workflow_stage.dart';
import 'package:jobprogress/common/repositories/follow_ups_note.dart';
import 'package:jobprogress/common/repositories/job.dart';
import 'package:jobprogress/common/services/note_actions/quick_actions.dart';
import 'package:jobprogress/common/services/upload.dart';
import 'package:jobprogress/core/constants/file_uploder.dart';
import 'package:jobprogress/core/constants/follow_ups_note.dart';
import 'package:jobprogress/core/constants/mix_panel/titles.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/note_details/index.dart';
import 'package:jobprogress/modules/follow_ups_notes/listing/widgets/add_edit_followup_note/index.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';

import '../../../common/models/follow_up_note/add_edit_model.dart';
import '../../../common/models/pagination_model.dart';
import '../../../global_widgets/bottom_sheet/controller.dart';

class FollowUpsNotesListingController extends GetxController {

  bool isLoading = true;
  bool isLoadMore = false;
  bool canShowLoadMore = false;
  bool isDeleting = false;
  bool? isReOpenRequest;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  
  int followUpNoteListOfTotalLength = 0;
  int? jobId = Get.arguments == null ? null : Get.arguments['jobId'];  
  int customerId = Get.arguments == null ? -1 : Get.arguments['customerId'];
  int? followUpNoteId = Get.arguments?[NavigationParams.followUpNoteId];

  String controllerTag = '';
  
  List<NoteListModel> followUpNoteList = [];
  List<UserModel> userList = [];
  
  NoteListingParamModel noteParamKey = NoteListingParamModel();

  JobModel? job;
  
  WorkFlowStageModel? selectedStage;

  Future<void> getJob() async {
    try {
      isReOpenRequest = null;
      update();
      final jobsCountParams = <String, dynamic>{
        'id': jobId,
        'includes[0]': ['count:with_ev_reports(true)'],
        'includes[1]': ['job_message_count'],
        'includes[2]': ['upcoming_appointment_count'],
        'includes[3]': ['Job_note_count'],
        'includes[4]': ['job_task_count'],
        'includes[5]': ['upcoming_appointment'],
        'includes[6]': ['workflow'],
        'includes[7]': ['contact'],
        'includes[8]': ['contacts.phones'],
        'includes[9]': ['customer'],
        'incomplete_task_lock_count': 1,
        'track_job': 1
      };
    
    job = (await JobRepository.fetchJob(jobId!, params: jobsCountParams))['job'];

      if(job?.followUpStatus?.mark == "completed") {
        isReOpenRequest = true;
      } else {
        isReOpenRequest = false;
      }
    
    } catch (e) {
      rethrow;
    } finally {
      update();
    }
  }

  bool isFollowUpCompleted(int index){
    return followUpNoteList[index].mark == FollowUpsNotesConstants.completed;
  }

  Future<void> fetchFollowUpNotList() async {
    try {
      noteParamKey.jobId = jobId;
      final followUpNoteParams = <String, dynamic>{
       'includes[0]': ['stage'],
       'includes[1]': ['created_by'],
       'includes[2]': ['mentions'],
        ...noteParamKey.toJson()
      };

      Map<String, dynamic> response = await FollowUpsNoteListingRepository().fetchFollowUpNotesList(followUpNoteParams);
      setFollowUpNoteList(response);
    } catch (e) {
      rethrow;
    } finally {
      isLoadMore = false;
      isLoading = false;
      update();
    }
  }

  void setFollowUpNoteList(Map<String, dynamic> response) {
    List<NoteListModel> list = response['list'];

    PaginationModel pagination = response['pagination'];

    followUpNoteListOfTotalLength = pagination.total!;

    if (!isLoadMore) {
      followUpNoteList = [];
    }

    followUpNoteList.addAll(list);

    canShowLoadMore = followUpNoteList.length < followUpNoteListOfTotalLength;
  }

   Future<void> loadMore() async {
    noteParamKey.page += 1;
    isLoadMore = true;
    await fetchFollowUpNotList();
  }

  /// showLoading is used to show shimmer if refresh is pressed from main drawer
  Future<void> refreshList({bool? showLoading}) async {
    noteParamKey.page = 1;

  /// show shimmer if showLoading = true
    isLoading = showLoading ?? false;
    update();
    await getJob();
    await fetchFollowUpNotList();
  }

  void handleQuickActionUpdate(NoteListModel followUpNote, String action) {
    switch (action) {
      case 'view':
        NoteService.openNoteDetail(
          note: followUpNote,
          callback: handleQuickActionUpdate,
          type: NoteListingType.followUpNote
        );
        break;
        
      case 'delete':
          showJPBottomSheet(
            isScrollControlled: true,
            child: ((controller) {
              return JPConfirmationDialog(
                icon: Icons.report_problem_outlined,
                title: "confirmation".tr,
                subTitle:  "you_are_about_to_delete_this_follow_up_note".tr.capitalizeFirst.toString() + 'press_confirm_to_proceed'.tr.capitalizeFirst.toString(),
                suffixBtnText: 'delete'.tr,
                disableButtons: isDeleting,
                suffixBtnIcon: showJPConfirmationLoader(show: isDeleting),
                onTapPrefix: () {
                  Get.back();
                },
                onTapSuffix: () {
                  controller.toggleIsLoading();
                    deleteFollowUpsNote(followUpNote);
                  controller.toggleIsLoading();
                },
              );
            }));
        break;
      default:
    }

    update();
  }

  void deleteFollowUpsNote(NoteListModel followUpNote) async {
    isDeleting = true;
    update();

    try {       
      await FollowUpsNoteListingRepository().deleteFollowUpsNote(followUpNote.id!).trackDeleteEvent(MixPanelEventTitle.followUpNoteDelete);

      int index = followUpNoteList.indexWhere((element) => element.id == followUpNote.id);
      followUpNoteList.removeAt(index);
      Get.back(); //Closing loader
      Helper.showToastMessage('note_deleted'.tr);
      followUpNoteListOfTotalLength -= 1;
      update();
    } catch (e) {
      Get.back(); //Closing loader
    } finally {
      isDeleting = false;
      update();
    }
  }

  void openNoteDetail(NoteListModel followUpNote) {
    showJPBottomSheet(child: (_) =>
      NoteDetail(note: followUpNote, type: NoteListingType.followUpNote),
      isScrollControlled: true,
    );
  }

  void sortFollowUpListing() {
    noteParamKey.page = 1;
    noteParamKey.sortBy = 'created_at';
    noteParamKey.sortOrder = noteParamKey.sortOrder == 'desc' ? 'asc' : 'desc';
    isLoading = true;
    update();
    fetchFollowUpNotList();
  }

  void handleChangeJob(int id){
    jobId = id;
    getJob();
    refreshList(showLoading: true);
  }

  void uploadFile({UploadFileFrom from = UploadFileFrom.popup}) async {

    final params = FileUploaderParams(
      type: FileUploadType.photosAndDocs,
      job: job,
      parentId: int.parse(job?.meta?.resourceId ?? '0'),
    );

    UploadService.uploadFrom(from: from, params: params);
  }

  @override
  void onInit() async {
    super.onInit();
    controllerTag = 'followups-$jobId';
    initData();
  }

  Future<void> initData() async {

    await fetchFollowUpNotList();
    getJob();

    if(followUpNoteId != null) searchAndDisplayFollowUpNote();

  }



  /////////////////////////   ADD / EDIT FOLLOWUP NOTE   ///////////////////////

  void openAddEditFollowUpDialogBox({NoteListModel? followUpNote}) {
    if(isReOpenRequest ?? false) {
      showJPBottomSheet(
        isDismissible: true,
        child: (JPBottomSheetController controller) {
          return JPConfirmationDialog(
            icon: Icons.report_problem_outlined,
            title: "confirmation".tr,
            subTitle:  "follow_ups_are_close_you_need_to_re_open_to_proceed".tr,
            suffixBtnText: 'reopen'.tr,
            disableButtons: isDeleting,
            suffixBtnIcon: showJPConfirmationLoader(show: isDeleting),
            onTapPrefix: () {
              Get.back();
            },
            onTapSuffix: () {
              isDeleting = true;
              Get.back();
              update();
              reOpenFollowup(isReOpenRequest : isReOpenRequest ?? false).whenComplete(() {
                isDeleting = false;
                update();
                openAddEditFollowUpDialogBox();
              });
            },
          );
        }
      );
    } else {

      List<Map<String, dynamic>> data = NoteService.getSuggestionsList(job);

      showJPGeneralDialog(
          isDismissible: false,
          child: (dialogController) {
            return AbsorbPointer(
              absorbing: dialogController.isLoading,
              child: AddEditFollowUpNote(
                onApply: addEditDialogCallBack,
                suggestions: data,
                job: job,
                addEditFollowUpModel: AddEditFollowUpModel(
                    jobId: followUpNote?.jobId ?? jobId,
                    stageCode: followUpNote?.stageCode ??
                        job?.currentStage?.code,
                    customerId: customerId,
                    mark: followUpNote?.mark,
                    note: followUpNote?.note,
                    taskDueDate: followUpNote?.task?.dueDate,
                    taskAssignTo: followUpNote?.task?.participants?.map((
                        taskAssignTo) => taskAssignTo.id).toList()
                ),
              ),
            );
          }
      );
    }
  }

  void addEditDialogCallBack () {
    refreshList(showLoading: true);
  }

  void searchAndDisplayFollowUpNote() {

    final jobNote = followUpNoteList.firstWhereOrNull((note) => note.id == followUpNoteId);
    NoteService.openNoteDetail(
        note: jobNote,
        callback: handleQuickActionUpdate,
        type: NoteListingType.followUpNote
    );
  }

  Future<void> reOpenFollowup({required bool isReOpenRequest}) async {
    try {
      isLoading = true;
      update();
      Map<String, dynamic> params = {"job_id": jobId};
      dynamic response;
      if (isReOpenRequest) {
        response =
        await FollowUpsNoteListingRepository().reopenFollowUpsNote(params);
        if (response) {
          this.isReOpenRequest = false;
          await fetchFollowUpNotList();
          Helper.showToastMessage("marked_as_reopen".tr);
        } else {
          this.isReOpenRequest = isReOpenRequest;
        }
      } else {
        response =
        await FollowUpsNoteListingRepository().closeFollowUpsNote(params);
        if (response) {
          this.isReOpenRequest = true;
          await fetchFollowUpNotList();
          Helper.showToastMessage("marked_as_closed".tr);
        } else {
          this.isReOpenRequest = isReOpenRequest;
          update();
        }
      }
    } catch (e) {
      rethrow;
    } finally {
      if(this.isReOpenRequest == null) {
        this.isReOpenRequest = false;
      }
      isLoading = false;
      update();
    }
  }
}

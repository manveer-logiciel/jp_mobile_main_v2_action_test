import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_upload.dart';
import 'package:jobprogress/common/enums/note_listing.dart';
import 'package:jobprogress/common/extensions/mix_panel/extension.dart';
import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/note_list/note_listing.dart';
import 'package:jobprogress/common/models/note_list/note_listing_param.dart';
import 'package:jobprogress/common/models/sql/uploader/file_uploader_params.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/models/workflow_stage.dart';
import 'package:jobprogress/common/repositories/job.dart';
import 'package:jobprogress/common/repositories/job_note.dart';
import 'package:jobprogress/common/services/mixpanel/index.dart';
import 'package:jobprogress/common/services/note_actions/quick_actions.dart';
import 'package:jobprogress/common/services/upload.dart';
import 'package:jobprogress/core/constants/file_uploder.dart';
import 'package:jobprogress/core/constants/mix_panel/event/add_events.dart';
import 'package:jobprogress/core/constants/mix_panel/event/edit_events.dart';
import 'package:jobprogress/core/constants/mix_panel/titles.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/constants/work_flow_stage_color.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/controller.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/note_details/index.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';
import 'package:jp_mobile_flutter_ui/FlutterMention/flutter_mentions.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../common/models/pagination_model.dart';
import '../add_edit_dialog_box/index.dart';

class JobNoteListingController extends GetxController {

  AnnotationEditingController? noteController;
  JobModel? job;
  WorkFlowStageModel? selectedStage;

  bool isLoading = true;
  bool isLoadMore = false;
  bool canShowLoadMore = false;
  bool isDeleting = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  
  int jobNoteListOfTotalLength = 0;
  int? jobId = Get.arguments?['jobId'];
  int customerId = Get.arguments?['customerId'] ?? -1;
  int? jobNoteId = Get.arguments?[NavigationParams.jobNoteId];

  String controllerTag = '';
   
  bool isValidate = false;
  
  List<NoteListModel> jobNoteList = [];
  List<UserModel> userList = [];

  String jobNotes = '';
   
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  NoteListingParamModel paramKeys = NoteListingParamModel();

  Future<void> getJob() async {
    try {
      final jobsCountParams = <String, dynamic>{
        'id': jobId,
        'includes[0]': ['count:with_ev_reports(true)'],
        'includes[1]': ['job_message_count'],
        'includes[2]': ['upcoming_appointment_count'],
        'includes[3]': ['Job_note_count'],
        'includes[4]': ['job_task_count'],
        'includes[5]': ['upcoming_appointment'],
        'includes[6]': ['workflow'],
        'incomplete_task_lock_count': 1,
        'track_job': 1
      };
    
    job = (await JobRepository.fetchJob(jobId!, params: jobsCountParams))['job'];
    } catch (e) {
      rethrow;
    } finally {
      update();
    }
  }


  Future<void> fetchNoteList() async {
    try {
      paramKeys.jobId = jobId;
      paramKeys.sortBy = 'updated_at';
      final jobNotParam = <String, dynamic>{
       'includes[0]': ['stage'],
       'includes[1]': ['created_by'],
       'includes[2]': ['attachments'],
       'includes[3]': ['mentions'],
        ...paramKeys.toJson()
      };

      Map<String, dynamic> response = await JobNoteListingRepository().fetcJobNotesList(jobNotParam);
      setJobNoteList(response);
    } catch (e) {
      rethrow;
    } finally {
      isLoadMore = false;
      isLoading = false;
      update();
    }
  }

  Future<void> addEditJobNotes({
    NoteListModel? jobNote,
    bool isEdit = false,
    required List<AttachmentResourceModel> attachments,
    List<int>? deletedAttachments,
    VoidCallback? onApply
  }) async{

    try {
      final addEditJobNoteParams = <String, dynamic> {
        'job_id': jobId,
        'note': jobNotes.toString(),
        'stage_code':job!.currentStage!.code,
        'attachments' : List.generate(attachments.length, (index) => {
          "type": attachments[index].type,
          "value": attachments[index].id
        }).toList(),
        if(deletedAttachments != null && deletedAttachments.isNotEmpty)...{
          'delete_attachments' : deletedAttachments,
        }
      };

      if(isEdit) addEditJobNoteParams['id'] = jobNote!.id;

      JobNoteListingRepository jobNoteListingRepository = JobNoteListingRepository();

      if(isEdit) {
        await  jobNoteListingRepository.editJobNote(editJobNoteParams: addEditJobNoteParams, id:jobNote!.id!);
      } else {
        await jobNoteListingRepository.addJobNote(addjobNoteParams: addEditJobNoteParams);
        onApply?.call();
      }
      MixPanelService.trackEvent(event: isEdit ? MixPanelEditEvent.jobNote : MixPanelAddEvent.jobNote);

    } catch (e) {
      rethrow;
    } finally {
      refreshList(showLoading: true);
      Get.back();
      reset();
      
      isEdit ? Helper.showToastMessage(job?.parentId != null ?
      'project_note_updated'.tr : 'job_note_updated'.tr) : Helper.showToastMessage(job?.parentId != null ?
      'project_note_added'.tr : 'job_note_added'.tr);
    }
  }

  void setJobNoteList(Map<String, dynamic> response) {
    List<NoteListModel> list = response['list'];

    PaginationModel pagination = response['pagination'];

    jobNoteListOfTotalLength = pagination.total!;

    if (!isLoadMore) {
      jobNoteList = [];
    }

    jobNoteList.addAll(list);

    canShowLoadMore = jobNoteList.length < jobNoteListOfTotalLength;
  }

   Future<void> loadMore() async {
    paramKeys.page += 1;
    isLoadMore = true;
    await fetchNoteList();
  }

  /// showLoading is used to show shimmer if refresh is pressed from main drawer
  Future<void> refreshList({bool? showLoading}) async {
    paramKeys.page = 1;

  /// show shimmer if showLoading = true
    isLoading = showLoading ?? false;
    update();
    await fetchNoteList();
    await getJob();
  }

  void handleQuickActionUpdate(NoteListModel jobNote, String action) {
    jobNotes = jobNote.note ?? "";
    switch (action) {
      case 'edit':
        openAddEditNoteDialogBox(isEdit: true, jobNote: jobNote);
        break;

      case 'view':
        NoteService.openNoteDetail(
          note: jobNote,
          callback: handleQuickActionUpdate,
          type: NoteListingType.jobNote
        );
        break;

      case 'delete':
         showJPBottomSheet(
          isScrollControlled: true,
          child: ((controller) {
          return JPConfirmationDialog(
            icon: Icons.report_problem_outlined,
            title: "confirmation".tr,
            subTitle: "you_are_about_to_delete_this_job_note".tr,
            suffixBtnText: 'delete'.tr,
            disableButtons: isDeleting,
            suffixBtnIcon: showJPConfirmationLoader(show: isDeleting),
            onTapPrefix: () {
              Get.back();
            },
            onTapSuffix: () {
              controller.toggleIsLoading();
                 deleteJobNotes(jobNote);
              controller.toggleIsLoading();
            },
          );
        }));
        break;
      default:
    }

    update();
  }

  void deleteJobNotes(NoteListModel jobNote) async {
    isDeleting = true;
    update();

    try {       
      await JobNoteListingRepository().deleteJobNote(jobNote.id!).trackDeleteEvent(MixPanelEventTitle.jobNoteDelete);

      int index = jobNoteList.indexWhere((element) => element.id == jobNote.id);
      jobNoteList.removeAt(index);
      Get.back(); //Closing loader
      Helper.showToastMessage('note_deleted'.tr);
      jobNoteListOfTotalLength -= 1;
      update();
    } catch (e) {
      Get.back(); //Closing loader
    } finally {
      isDeleting = false;
      update();
    }
  }

  void openNoteDetail(NoteListModel jobNote) {
    showJPBottomSheet(child: (_) =>
      NoteDetail( note: jobNote, type: NoteListingType.jobNote),
      isScrollControlled: true,
    );
  }

  void sortJobNoteListing() {
    paramKeys.page = 1;
    paramKeys.sortOrder = paramKeys.sortOrder == 'asc' ? 'desc' : 'asc';
    isLoading = true;
    update();
    fetchNoteList();
  }

  void filterJobNoteListByStage() {
    List<JPSingleSelectModel> newStageList = [JPSingleSelectModel(label: 'all'.tr, id: 'all', color: JPAppTheme.themeColors.darkGray)];  

    for (WorkFlowStageModel  stageCode in job!.stages!) {
      newStageList.add(JPSingleSelectModel(
            color: WorkFlowStageConstants.colors[stageCode.color],
            label: stageCode.name.toString().capitalizeFirst ?? '',
            id: stageCode.code.toString()));
    }
     showJPBottomSheet(isScrollControlled: true, child: ((controller) {
        return JPSingleSelect(
          title: 'select_stage'.tr,
          inputHintText: 'search_stage'.tr,
          mainList: newStageList,
          selectedItemId: selectedStage != null ? selectedStage!.code :  'all',
          onItemSelect: (value) {
            jobNoteListByStage(value);
            Get.back();
          });
      }));
  }

   void reset (){
    isValidate = false;
  }

  String? validateNote(String value) {
    if (value.isEmpty) {
      return "please_enter_note".tr;
    }
    return '';
  }

  bool validateNoteForm(GlobalKey<FormState> formKey) {
    return formKey.currentState!.validate();
  }

  void saveData ({
    required JPBottomSheetController dialogController,
    required JobModel? jobModel,
    NoteListModel? jobNote,
    bool isEdit = false,
    required List<AttachmentResourceModel> attachments,
    required List<int> deletedAttachments,
    VoidCallback? onApply
  }) async {

    if (jobModel != null) {
      job = jobModel;
      jobId = jobModel.id;
    }

      if (!validateNoteForm(formKey)) {
        isValidate = true;
        return;
      }
      isValidate = false;
      formKey.currentState!.save();
      dialogController.toggleIsLoading();
      if(isEdit) {
        await addEditJobNotes(jobNote: jobNote, isEdit: isEdit, attachments: attachments, deletedAttachments: deletedAttachments);
      } else {
        await addEditJobNotes(attachments: attachments, onApply: onApply);
    }
      dialogController.toggleIsLoading();
    }

  void openAddEditNoteDialogBox({NoteListModel? jobNote, bool isEdit  = false}){
    showJPGeneralDialog(
        isDismissible: false,
        child: (dialogController) {
          return AbsorbPointer(
            absorbing: dialogController.isLoading,
            child: AddEditJobNoteDialogBox(
              jobModel: job,
              controller: this,
              dialogController: dialogController,
              jobNote: jobNote,
              isEdit: isEdit,
              jobId: jobId!,
            ),
          );
        }
    );
  }

  void jobNoteListByStage(String selectedStageCode) async {
    selectedStage = null;
    paramKeys.stageCode = null;
    
    if(selectedStageCode != 'all') {
      selectedStage = job!.stages!.firstWhere((stage) => stage.code == selectedStageCode);
      paramKeys.stageCode = selectedStageCode.toString();
    }

    paramKeys.page = 1;
    isLoading = true;
    update();
    fetchNoteList();
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

  void searchAndDisplayJobNote() {

    final jobNote = jobNoteList.firstWhereOrNull((note) => note.id == jobNoteId);

    if(jobNote != null) {
      NoteService.openNoteDetail(
          note: jobNote,
          callback: handleQuickActionUpdate,
          type: NoteListingType.jobNote
      );
    }
  }

  @override
  void onInit() {
    super.onInit();
    controllerTag = 'jobnote-$jobId';
    initData();
  }

  Future<void> initData() async {
    await fetchNoteList();
    getJob();
    if(jobNoteId != null) searchAndDisplayJobNote();
  }
}

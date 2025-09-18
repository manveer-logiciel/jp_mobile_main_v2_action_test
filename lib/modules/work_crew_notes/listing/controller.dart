import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_upload.dart';
import 'package:jobprogress/common/enums/note_listing.dart';
import 'package:jobprogress/common/extensions/mix_panel/extension.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/note_list/note_listing.dart';
import 'package:jobprogress/common/models/note_list/note_listing_param.dart';
import 'package:jobprogress/common/models/pagination_model.dart';
import 'package:jobprogress/common/models/sql/uploader/file_uploader_params.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/common/repositories/job.dart';
import 'package:jobprogress/common/repositories/work_crew_notes_listing.dart';
import 'package:jobprogress/common/services/note_actions/quick_actions.dart';
import 'package:jobprogress/common/services/upload.dart';
import 'package:jobprogress/core/constants/file_uploder.dart';
import 'package:jobprogress/core/constants/mix_panel/titles.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/note_details/index.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';
import 'package:jp_mobile_flutter_ui/FlutterMention/flutter_mentions.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../core/utils/color_helper.dart';
import '../../../global_widgets/bottom_sheet/controller.dart';
import '../../../global_widgets/network_image/index.dart';
import '../add_edit_note_dialog_box/index.dart';

class WorkCrewNotesListingController extends GetxController {

  AnnotationEditingController? noteController;
  
  bool isLoading = true;
  bool isValidate = false;
  bool isLoadMore = false;
  bool canShowLoadMore = false;
  bool isDeleting = false;
  
  List<Map<String, dynamic>> data =[];
  
  List <int> repIds = [];
  List <int> subIds = [];
  
  List<NoteListModel> workCrewNotesList = [];

  List<UserModel> userList = [];
  
  List<JPMultiSelectModel> companyCrewList = [];
  List<JPMultiSelectModel> subcontractorList = [];

  String initialcompanyCrewValue = '';
  String initialsubContractorsValue = '';
  String notes = '';
  
  TextEditingController companyCrewController = TextEditingController();
  TextEditingController subController = TextEditingController(); 
  NoteListingParamModel paramkeys = NoteListingParamModel();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  int workCrewListOfTotalLength = 0;
  int? jobId = Get.arguments == null ? null : Get.arguments['jobId'];
  int customerId = Get.arguments == null ? -1 : Get.arguments['customerId'];
  int? workCrewNoteId = Get.arguments?[NavigationParams.workCrewNoteId];
  bool isInSelectMode = Get.arguments?[NavigationParams.isInSelectMode] ?? false;
  List<NoteListModel> selectedWorkCrewNotesList = Get.arguments?[NavigationParams.list] ?? [];

  String controllerTag = '';
  int searchDataCount = 0;
 
  JobModel? job;

  bool get doShowFloatingActionButton => !(isInSelectMode
      || job == null
      || isLoading
  );

  bool get canShowSecondaryHeader => !isInSelectMode;

  Future<void> getJob() async {
    try {
      final jobsCountParams = <String, dynamic> {
        'id': jobId,
        'includes[0]': ['count:with_ev_reports(true)'],
        'includes[1]': ['job_message_count'],
        'includes[2]': ['upcoming_appointment_count'],
        'includes[3]': ['Job_note_count'],
        'includes[4]': ['job_task_count'],
        'includes[5]': ['upcoming_appointment'],
        'incomplete_task_lock_count': 1,
        'track_job': 1
      };
    
    job = (await JobRepository.fetchJob(jobId!, params: jobsCountParams))['job'];
      for (var i = 0; i < job!.reps!.length; i++) {
        UserLimitedModel jobData = job!.reps![i];
        companyCrewList.add(
          JPMultiSelectModel(
            label: Helper.getWorkCrewName(jobData), 
            id: jobData.id.toString(), 
            isSelect: false,
            child: JPAvatar(
              size: JPAvatarSize.small,
              borderColor: jobData.color != null ? ColorHelper.getHexColor(jobData.color.toString()) : JPAppTheme.themeColors.darkGray ,
              borderWidth: jobData.profilePic != null ?2 : 1,
              backgroundColor: jobData.color != null ? ColorHelper.getHexColor(jobData.color.toString()) : JPAppTheme.themeColors.darkGray ,
              child:jobData.profilePic != null ? JPNetworkImage(
                src: jobData.profilePic,
                placeHolder: Center(
                  child: JPText(
                    text: jobData.intial ?? '',
                    textColor: JPAppTheme.themeColors.base,
                    textSize: JPTextSize.heading6
                  ),
                ),
              ):
              JPText(
                text:jobData.intial!,
                textColor: JPAppTheme.themeColors.base,
                textSize: JPTextSize.heading6
              )
                  ),
            
          )
        );
    }

    for (var i = 0; i < job!.subContractors!.length; i++) {
        UserLimitedModel jobData= job!.subContractors![i];
        subcontractorList.add(
          JPMultiSelectModel(
            label: Helper.isValueNullOrEmpty(jobData.companyName) ? Helper.getWorkCrewName(jobData) :  (jobData.fullName + ' (' + jobData.companyName !+ ')'), 
            id: jobData.id.toString(), 
            isSelect: false,
            child:JPAvatar(
              size: JPAvatarSize.small,
              borderColor: jobData.color!=null ? ColorHelper.getHexColor(jobData.color.toString()):JPAppTheme.themeColors.darkGray,
              borderWidth: jobData.profilePic!=null?2:1,
              backgroundColor: jobData.color!=null ? ColorHelper.getHexColor(jobData.color.toString()):JPAppTheme.themeColors.darkGray ,
              child:jobData.profilePic!=null? JPNetworkImage(
                src: jobData.profilePic,
                placeHolder: Center(
                  child: JPText(
                    text: jobData.intial ?? '',
                    textColor: JPAppTheme.themeColors.base,
                    textSize: JPTextSize.heading6
                  ),
                ),
              ):
              JPText(
                text: jobData.intial ?? '',
                textColor: JPAppTheme.themeColors.base,
                textSize: JPTextSize.heading6
              )
            ),
            
          )
        );
    }
  
    } catch (e) {
      rethrow;
    } finally {
      update();
    }
  }

  void reset (){    
    isValidate = false;
    initialcompanyCrewValue ='';
    initialsubContractorsValue ='';
    subController.clear();
    companyCrewController.clear();
    repIds.clear();
    subIds.clear();
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


  Future<void> fetchWorkCrewNotesList() async {
    try {
      paramkeys.jobId = jobId;
      final workCrewNotesParams = <String, dynamic>{
        ' includes[0]': ['sub_contractors'],
        ' includes[1]': ['reps'],
        ' includes[2]': ['reps.divisions'],
        ' includes[3]': ['mentions'],
        ' includes[4]': ['sub_contractors.divisions'],
        ...paramkeys.toJson()
      };

      Map<String, dynamic> response = await WorkCrewNotesListingRepository().fetchWorkCrewNotesList(workCrewNotesParams);
      setWorkCrewNotesList(response);
    } catch (e) {
      rethrow;
    } finally {
      isLoadMore = false;
      isLoading = false;
      update();
    }
  }

  void setWorkCrewNotesList(Map<String, dynamic> response) {
    List<NoteListModel> list = response['list'];
    PaginationModel pagination = response['pagination'];
    workCrewListOfTotalLength = pagination.total!;
    if (!isLoadMore) {
      workCrewNotesList = [];
      searchDataCount = 0;
    }
    workCrewNotesList.addAll(list);

    if(selectedWorkCrewNotesList.isNotEmpty)  {
      for(int i = searchDataCount; i < workCrewNotesList.length; i++) {
        for(int j = 0; j < selectedWorkCrewNotesList.length; j++) {
          if(workCrewNotesList[i].id == selectedWorkCrewNotesList[j].id) {
            workCrewNotesList[i].isSelected = true;
            break;
          }
        }
      }
      searchDataCount = workCrewNotesList.length;
    }

    canShowLoadMore = workCrewNotesList.length < workCrewListOfTotalLength;
  }

  Future<void> loadMore() async {
    paramkeys.page += 1;
    isLoadMore = true;
    await fetchWorkCrewNotesList();
  }

  /// showLoading is used to show shimmer if refresh is pressed from main drawer
  Future<void> refreshList({bool? showLoading}) async {
    paramkeys.page = 1;
    companyCrewList = [];
    subcontractorList = [];
  /// show shimmer if showLoading = true
    isLoading = showLoading ?? false;
    update();
    await fetchWorkCrewNotesList();
    await getJob();
  }

 void handleQuickActionUpdate(NoteListModel note, String action) {
    switch (action) {
      case 'edit':
        openAddEditNoteDialogBox(isEdit: true,note: note);
        break;
      case 'view':
        NoteService.openNoteDetail(
          note: note, 
          callback: handleQuickActionUpdate, 
          type: NoteListingType.workCrewNote
        );
        break;
      case 'delete':
        showJPBottomSheet(
          isScrollControlled: true,
          child: ((controller) {
          return JPConfirmationDialog(
            icon: Icons.warning_amber_outlined,
            title: "confirmation".tr,
            subTitle: "are_you_sure_you_want_to_delete_note".tr,
            suffixBtnText: 'delete'.tr,
            disableButtons: controller.isLoading,
            suffixBtnIcon: showJPConfirmationLoader(show: controller.isLoading),
            onTapPrefix: () {
              Get.back();
            },
            onTapSuffix: () async {
              controller.toggleIsLoading();
              await  deleteNotes(note);
              controller.toggleIsLoading();
            },
          );
        }));
        break;
      default:
    }
    update();
  }

  deleteNotes(NoteListModel note) async {
    isDeleting = true;
    update();

    try {  
      final deleteNoteParam = <String, dynamic>{
        'id': note.id,
        'job_id': jobId
      };         
      await WorkCrewNotesListingRepository().deleteNote(note.id!,deleteNoteParam).trackDeleteEvent(MixPanelEventTitle.workCrewNoteDelete);

      int index = workCrewNotesList.indexWhere((element) => element.id == note.id);
      workCrewNotesList.removeAt(index);
      Get.back(); //Closing loader
      Helper.showToastMessage('note_deleted'.tr);
      workCrewListOfTotalLength -= 1;
      update();
    } catch (e) {
      Get.back(); //Closing loader
    } finally {
      isDeleting = false;
      update();
    }
  }
  
  Future<void> addEditCompanyContactNotes({NoteListModel? note, bool isEdit = false}) async{
    try {
      final addEditWorkCrewNoteParams = <String, dynamic> {
        'job_id': jobId,
        'note': notes,
        'rep_ids': repIds,
        'sub_contractor_ids': subIds,
      };

      if(isEdit) addEditWorkCrewNoteParams['id'] = note!.id;

      for(int i = 0; i < repIds.length; i++) {
        addEditWorkCrewNoteParams['rep_ids[$i]'] = repIds[i];
      }

      for(int i=0; i<subIds.length; i++) {
        addEditWorkCrewNoteParams['sub_contractor_ids[$i]'] = subIds[i];
      }

      WorkCrewNotesListingRepository workCrewRepository = WorkCrewNotesListingRepository();

      NoteListModel addEditWorkCrewNote = isEdit ? await workCrewRepository.editWorkCrewNote(note!.id!, addEditWorkCrewNoteParams) : await workCrewRepository.addWorkCrewNote(addEditWorkCrewNoteParams);

      if(isEdit) {
        int workCrewEditIndex = workCrewNotesList.indexWhere((element) => element.id == addEditWorkCrewNote.id);
        workCrewNotesList[workCrewEditIndex] = addEditWorkCrewNote;
        update();
      } else {
        workCrewNotesList.insert(0, addEditWorkCrewNote);
        workCrewListOfTotalLength += 1;
        update();
      }

    } catch (e) {
      rethrow;
    } finally {
      Get.back();
      reset();
      update();
      isEdit ? Helper.showToastMessage('work_crew_note_updated'.tr) : Helper.showToastMessage('work_crew_note_added'.tr);
    }
  }

 

  void openNoteDetail(NoteListModel note) {
    showJPBottomSheet(child: (_) =>
      NoteDetail( note: note, type: NoteListingType.workCrewNote),
      isScrollControlled: true,
    );
  }

  String getInputFieldText(List<JPMultiSelectModel> selectedValuesList, {bool withMention = false}) {
    if(selectedValuesList.isEmpty) return '';
    String text = selectedValuesList.map((data) => withMention ? '@${data.label}' : data.label).join(withMention ? ' ' : ', ');
    return text;
  }
  

  void showCompanyCrewSelectionSheet() {
    for (JPMultiSelectModel item in companyCrewList) {
      item.isSelect = false;

      for (int id in repIds) {
        if(id.toString() == item.id) {
          item.isSelect = true;
        }
      }
    }

    showJPBottomSheet(isScrollControlled: true, child: (controller) {
      return JPMultiSelect(
        mainList: companyCrewList,
        inputHintText: 'search_here'.tr,
        title: '${'select'.tr.toUpperCase()} ${'company_crew'.tr.toUpperCase()}',
        onDone: (list) {
          final selectedValuesList = list.where((element) => element.isSelect).toList();
          repIds = selectedValuesList.map((e) => int.parse(e.id)).toList();
          companyCrewController.text = getInputFieldText(selectedValuesList);
          noteController!.text = '${noteController!.text} ${getInputFieldText(selectedValuesList, withMention: true)}';
          update();
          Get.back();
        },
      );
    });
  }

   
  void showLabourAndSubSelectionSheet() {
    for (JPMultiSelectModel item in subcontractorList) {
      item.isSelect = false;

      for (int id in subIds) {
        if(id.toString() == item.id) {
          item.isSelect = true;
        }
      }
    }

    showJPBottomSheet(isScrollControlled: true, child: (controller) {
      return JPMultiSelect(
        mainList: subcontractorList,
        inputHintText: 'search_here'.tr,
        title: '${'select'.tr.toUpperCase()} ${'labour'.tr.toUpperCase()} / ${'sub'.tr.toUpperCase()}',
        onDone: (list) {
          final selectedValuesList = list.where((element) => element.isSelect).toList();
          subIds = selectedValuesList.map((e) => int.parse(e.id)).toList();
          noteController!.text = '${noteController!.text} ${getInputFieldText(selectedValuesList, withMention: true)}' ;
          subController.text = getInputFieldText(selectedValuesList);
          update();
          Get.back();
        },
      );
    });
  }
  
  void addPreviousData(NoteListModel note){
    if(note.reps != null) {
      companyCrewController.text =  note.reps!.map((data) => data.fullName).join(', ');
      repIds = note.reps!.map((e) => (e.id)).toList();
    }

    if(note.subContractors != null){
      subController.text = note.subContractors!.map((data) => data.companyName).join(', ');
      subIds = note.subContractors!.map((e) => (e.id)).toList();
    }
  }


  void openAddEditNoteDialogBox({NoteListModel? note,  bool isEdit  = false}) {
    data = NoteService.getSuggestionsList(job);

    showJPGeneralDialog(
        isDismissible: false,
        child: (dialogController) {
          return AbsorbPointer(
            absorbing: dialogController.isLoading,
            child: AddEditWorkCrewNoteDialogBox(
              jobId: jobId ?? job?.id ?? 0,
              companyCrewList: companyCrewList,
              subcontractorList: subcontractorList,
              suggestionList: data,
              note: note,
              dialogController: dialogController,
              isEdit: isEdit,
              onFinish: (workCrewRepository) async => await fetchWorkCrewNotesList(),
            ));
        }
      ); 
    }

    void saveData({required JPBottomSheetController dialogController,  bool isEdit = false, NoteListModel? note}) async{
      if (!validateNoteForm(formKey)) {
        isValidate = true;
        return;
      }

      isValidate = false;
      formKey.currentState!.save();
      dialogController.toggleIsLoading(); 
      
      if(isEdit) {
        await addEditCompanyContactNotes(note:note, isEdit:true);
      } else{
        await addEditCompanyContactNotes();
      }

      dialogController.toggleIsLoading();
    }

  void sortWorkCrewNoteListing() {
    paramkeys.page = 1;
    paramkeys.sortBy = 'created_at';
    paramkeys.sortOrder = paramkeys.sortOrder == 'desc' ? 'asc' : 'desc';
    isLoading = true;
    getSelectedList();
    update();
    fetchWorkCrewNotesList();
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

  void searchAndDisplayWorkFlowNote() {

    final workCrewNote = workCrewNotesList.firstWhereOrNull((note) => note.id == workCrewNoteId);

    if(workCrewNote != null) {
      NoteService.openNoteDetail(
          note: workCrewNote,
          callback: handleQuickActionUpdate,
          type: NoteListingType.workCrewNote
      );
    }
  }

  @override
  void onInit() {
    super.onInit();
    initData();
  }

  Future<void> initData() async {
    await fetchWorkCrewNotesList();
    getJob();
    if(workCrewNoteId != null) searchAndDisplayWorkFlowNote();
  }



  void onSelectComplete() {
    getSelectedList();
    Get.back(result: selectedWorkCrewNotesList);
  }

  void selectNote(int index) {
    workCrewNotesList[index].isSelected = !workCrewNotesList[index].isSelected;
    update();
  }

  void getSelectedList() {
    selectedWorkCrewNotesList = [];
    for (var element in workCrewNotesList) {
      if(element.isSelected) {
        element.isSelected = false;
        selectedWorkCrewNotesList.add(element);
      }
    }
  }
}

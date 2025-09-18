import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/mixpanel/index.dart';
import 'package:jobprogress/core/constants/mix_panel/event/add_events.dart';
import 'package:jobprogress/core/constants/mix_panel/event/edit_events.dart';
import 'package:jp_mobile_flutter_ui/FlutterMention/flutter_mentions.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import '../../../common/models/note_list/note_listing.dart';
import '../../../common/repositories/work_crew_notes_listing.dart';
import '../../../core/utils/helpers.dart';
import '../../../global_widgets/bottom_sheet/index.dart';

class AddEditWorkCrewNoteDialogController extends GetxController {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController companyCrewController = TextEditingController();
  TextEditingController subController = TextEditingController();
  AnnotationEditingController? noteController;

  bool isLoading = true;
  bool isValidate = false;

  String notes = '';
  int jobId;

  final NoteListModel? note;
  final bool? isEdit;

  List<Map<String, dynamic>> suggestionList =[];
  List<JPMultiSelectModel> companyCrewList = [];
  List<JPMultiSelectModel> subcontractorList = [];
  List <int> repIds = [];
  List <int> subIds = [];

  Function(NoteListModel noteListModel) onFinish;

  AddEditWorkCrewNoteDialogController({
    required this.companyCrewList,
    required this.subcontractorList,
    required this.jobId,
    required this.onFinish,
    required this.suggestionList,
    this.note,
    this.isEdit,
  });

  @override
  void onInit(){
    if(isEdit ?? false){
      initData();
    }
    super.onInit();
  }

  void initData(){
    if(note?.reps != null){
      note?.reps?.forEach((rep) { 
        repIds.add(rep.id);
      });
    }
    for (JPMultiSelectModel item in companyCrewList) {
      item.isSelect = repIds.contains(int.tryParse(item.id));
    }
    final selectedCompanyCrewList = companyCrewList.where((element) => element.isSelect).toList();
    companyCrewController.text = getInputFieldText(selectedCompanyCrewList);

    if(note?.subContractors != null){
      note?.subContractors?.forEach((subContractor) { 
        subIds.add(subContractor.id);
      });
    }
    for (JPMultiSelectModel item in subcontractorList) {
      item.isSelect = subIds.contains(int.tryParse(item.id));
    }
    final selectedSubcontractorList = subcontractorList.where((element) => element.isSelect).toList();
    subController.text = getInputFieldText(selectedSubcontractorList);
    notes = note?.note?? '';
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

      NoteListModel noteListModel = isEdit
          ? await WorkCrewNotesListingRepository().editWorkCrewNote(note!.id!, addEditWorkCrewNoteParams)
          : await WorkCrewNotesListingRepository().addWorkCrewNote(addEditWorkCrewNoteParams);

      MixPanelService.trackEvent(event: isEdit ? MixPanelEditEvent.workCrewNote : MixPanelAddEvent.workCrewNote);

      onFinish(noteListModel);
    } catch (e) {
      rethrow;
    } finally {
      reset();
      update();
      isEdit ? Helper.showToastMessage('work_crew_note_updated'.tr) : Helper.showToastMessage('work_crew_note_added'.tr);
    }
  }

  void reset (){
    isValidate = false;
    subController.clear();
    companyCrewController.clear();
    Get.back();
  }
}
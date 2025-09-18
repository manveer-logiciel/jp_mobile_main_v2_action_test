
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/repositories/work_crew.dart';
import 'package:jobprogress/common/services/forms/value_selector.dart';
import 'package:jobprogress/common/services/mixpanel/index.dart';
import 'package:jobprogress/core/constants/mix_panel/event/add_events.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/InputBox/controller.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/Theme/form_ui_helper.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';
import '../../../common/models/note_list/note_listing.dart';

class AddEditWorkCrewDialogBoxController extends GetxController {

  // Define input box controllers for company crew and labor contractors
  JPInputBoxController companyCrewController = JPInputBoxController();
  JPInputBoxController labourContractorsController = JPInputBoxController();
  
  // Provides necessary values for paddings, margins, and form section spacing
  final FormUiHelper formUiHelper = JPAppTheme.formUiHelper;

  Function(NoteListModel noteListModel) onFinish; // callback function when operation is finished
  JobModel? jobModel; // unique identifier for the job
  
  List<int> repIds = []; // list of representative IDs
  List<int> subIds = []; // list of subcontractor IDs
  List<JPMultiSelectModel> companyCrewList = []; // list of company crew members
  List<JPMultiSelectModel> subcontractorList = []; // list of subcontractors
  List<JPMultiSelectModel>? tagList = []; // list of company crew members
  
  // Get the selected company crew members
  List<JPMultiSelectModel> get selectedCompanyCrew => FormValueSelectorService.getSelectedMultiSelectValues(companyCrewList);
  
  // Get the selected labor contractors
  List<JPMultiSelectModel> get selectedLaborContractors => FormValueSelectorService.getSelectedMultiSelectValues(subcontractorList);
  
  AddEditWorkCrewDialogBoxController({
    required this.companyCrewList,
    required this.subcontractorList, 
    this.jobModel, 
    required this.onFinish,
    this.tagList
  });
  
  @override
  void onInit() {
    setData();
    super.onInit();
  }

  /// Sets data for selected company crew and subcontractors
  void setData(){
    repIds.clear();
    subIds.clear();

    repIds.addAll(selectedCompanyCrew.map((rep) => int.parse(rep.id)));
    subIds.addAll(selectedLaborContractors.map((rep) => int.parse(rep.id)));
  }

  /// Opens a multi-select form for selecting company crew members
  void selectCompanyCrew() {
    FormValueSelectorService.openMultiSelect(
      tags: tagList,
      list: companyCrewList,
      title: 'company_crew'.tr,
      controller: companyCrewController,
      onSelectionDone: () {
        setData();
        update();
      },
    );
  }

  // A function that handles the onTapSave event.
  Future<void> onTapSave() async{
    await addEditWorkCrew(isEdit: true);
  }

  /// Removes the selected work crew member with the given ID
  void removeSelectedWorkCrew(String id) {
    subIds.remove(int.parse(id));
    repIds.remove(int.parse(id));
    update();
  }
   
  /// Opens a multi-select form for selecting labor subcontractors
  void selectLabourContractors() {
    FormValueSelectorService.openMultiSelect(
      list: subcontractorList,
      title: 'labor_sub_contractors'.tr,
      controller: labourContractorsController,
      onSelectionDone: () {
        setData();
        update();
      },
    );
  }

  // Returns the parameters for adding or editing a work crew, including the job ID, representative IDs, and subcontractor IDs. 
  Map<String, dynamic> getAddEditWorkCrewParams({bool isEdit = false}) {

    final addEditWorkCrewParams = <String, dynamic> {
      'job_id': jobModel?.id,
      'rep_ids[]': '',
      'sub_contractor_ids[]': '',
    };
      
    if(isEdit) addEditWorkCrewParams['id'] = jobModel?.id;

    for(int i = 0; i < repIds.length; i++) {
      addEditWorkCrewParams['rep_ids[$i]'] = repIds[i];
    }

    for(int i= 0; i< subIds.length; i++) {
      addEditWorkCrewParams['sub_contractor_ids[$i]'] = subIds[i];
    }

    return addEditWorkCrewParams;
  }
  
  /// Adds or edits a work crew note
  Future<void> addEditWorkCrew({bool isEdit = false}) async{
    try {
      // gets the params for adding or editing a work crew note using the [getAddEditWorkCrewParams] function.
      final addEditWorkCrewParams = getAddEditWorkCrewParams(isEdit: isEdit);

      NoteListModel noteListModel = await WorkCrewRepository().addWorkCrewNote(jobModel?.id ?? 0, addEditWorkCrewParams);
      MixPanelService.trackEvent(event: MixPanelAddEvent.workCrew);
      Helper.showToastMessage('job_updated'.tr);
      onFinish(noteListModel);
    } catch (e) {
      rethrow;
    } finally {
      reset();
      update();
    }
  }

  /// Resets the state and navigates back
  void reset (){
    Get.back();
  }
}
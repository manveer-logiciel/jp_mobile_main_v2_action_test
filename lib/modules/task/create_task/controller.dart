import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/task_listing/task_listing.dart';
import 'package:jobprogress/common/services/task/create_task_form.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';
import 'package:jp_mobile_flutter_ui/Theme/form_ui_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../common/enums/task_form_type.dart';
import '../../../common/models/forms/create_task/create_task_form_param.dart';
import '../../../common/models/job/job.dart';
import '../../../common/repositories/job.dart';

class CreateTaskFormController extends GetxController {

  CreateTaskFormController({
    this.createTaskFormParam,
  });

  final formKey = GlobalKey<FormState>(); // used to validate form

  final FormUiHelper formUiHelper = JPAppTheme.formUiHelper; // provides necessary values for paddings, margins and form section spacing
  late CreateTaskFormService service;

  bool isSavingForm = false; // used to disable user interaction with ui
  bool validateFormOnDataChange = false; // helps in continuous validation after user submits form
  bool isAdditionalDetailsExpanded = false; // used to manage/control expansion state of additional details section
  bool isReminderNotificationExpanded = false; // used to manage/control expansion state of reminder notification section
  bool isLockStageExpanded = false; // used to manage lock stage expansion state 
  bool isReminderInfoVisible = false;  // used to hide/show reminder notification info

  final CreateTaskFormParam? createTaskFormParam;
  TaskListModel? task; // helps in retrieving task from previous page
  JobModel? jobModel; // helps in retrieving job from previous page
  TaskFormType? pageType; // helps in manage form privileges


  String get pageTitle => pageType != TaskFormType.createForm && pageType != TaskFormType.progressBoardCreate
      ? 'update_task'.tr.toUpperCase() : 'create_task'.tr.toUpperCase();

  String get saveButtonText => pageType != TaskFormType.createForm && pageType != TaskFormType.progressBoardCreate
      ? 'update'.tr.toUpperCase() : 'create'.tr.toUpperCase();

  Function(dynamic val)? onUpdate;

  bool get isReminderNotificationVisible => (jobModel != null && jobModel?.parentId == null) || ((jobModel?.stages?.length ?? 0) >= 1);

  @override
  void onInit() {
    init();
    super.onInit();
  }

  // init(): will set up form service and form data
  Future<void> init({TaskListModel? taskFromTemplate}) async {
    task ??= taskFromTemplate ?? createTaskFormParam?.task ?? Get.arguments?[NavigationParams.task];
    jobModel ??= createTaskFormParam?.jobModel ?? task?.job ?? Get.arguments?[NavigationParams.jobModel];
    pageType ??= createTaskFormParam?.pageType ?? Get.arguments?[NavigationParams.pageType];
    onUpdate = createTaskFormParam?.onUpdate;
    
    // setting up service
    service = CreateTaskFormService(
      update: update,
      validateForm: () => onDataChanged(''),
      task: task,
      jobModel: jobModel,
      pageType: pageType,
    );
    service.controller = this;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if(jobModel?.id != null) await fetchJob();
      await service.initForm(); // setting up form data
      onReminderNotificationExpansionChanged(service.isReminderNotificationSelected);
    });

  }

  Future<void> fetchJob() async {

    showJPLoader();

    try {
      Map<String, dynamic> params = {
        "includes[0]": "customer",
        "includes[1]": "division",
        "includes[2]": "workflow",
        "includes[3]": "flags.color",
        "id": jobModel!.id,
      };

      await JobRepository.fetchJob(jobModel!.id, params: params).then((Map<String, dynamic> response) {
        service.jobModel = response["job"];
      });
    } catch (e) {
      ///   handling case - job not found in edit task condition
      if(e.toString().contains("404")) service.isJobNotFound = true;
    } finally {
      Get.back();
      update();
    }
  }

  // createTask() : will save form data on validations completed otherwise scroll to error field
  Future<void> createTask() async {
    validateFormOnDataChange = true; // setting up form validation as soon as user updates field data
    bool isValid = validateForm(); // validating form

    if (isValid) {
      saveForm(onUpdate: onUpdate);
    } else {
      service.scrollToErrorField();
    }
  }

  void navigateToTaskTemplateList() async {
    dynamic  taskFromTemplate =  await(Get.toNamed(Routes.taskTemplateList));
    if(!Helper.isValueNullOrEmpty(taskFromTemplate)) {
      service.task = taskFromTemplate;
      await service.initForm(isTaskTemplate: true);
      validateForm();
      update();
    }
  }

  // onDataChanged() : will validate form as soon as data in input field changes
  void onDataChanged(dynamic val, {bool doUpdate = false}) {
    // realtime changes will take place only once after user tried to submit form
    if (validateFormOnDataChange) {
      validateForm();
    }

    if(doUpdate) update();
  }

  // validateForm(): validates form and returns result
  bool validateForm() {
    bool isValid = formKey.currentState?.validate() ?? false;
    return isValid;
  }

  // onAdditionalOptionsExpansionChanged(): toggles additional options section expansion state
  void onAdditionalOptionsExpansionChanged(bool val) {
    isAdditionalDetailsExpanded = val;
    service.onAdditionalOptionsExpansionChanged(val);
  }

  // onReminderNotificationExpansionChanged(): toggles reminder notification expansion state
  void onReminderNotificationExpansionChanged(bool val) {
    isReminderNotificationExpanded = val;
    service.toggleIsReminderNotificationSelected(val);
    update();
  }

  // onLockStageExpansionChanged(): toggles lock stage state
  void onLockStageExpansionChanged(bool val) {
    isLockStageExpanded = val;
    service.toggleIsLockStageSelected(val);
    service.onJobLockedChanged(isLockStageExpanded);
    update();
  }

  // toggleReminderInfo(): will hide/show reminder notification info
  void toggleReminderInfo() {
    isReminderInfoVisible = !isReminderInfoVisible;
    update();
  }

  void toggleIsSavingForm() {
    isSavingForm = !isSavingForm;
    update();
  }

  // saveForm(): will submit form only when changes in form are made
  Future<void> saveForm({Function(dynamic val)? onUpdate}) async {

    bool isNewDataAdded = service.checkIfNewDataAdded(); // checking for changes
    if(!isNewDataAdded) {
      Helper.showToastMessage('no_changes_made'.tr);
    } else {
      try {
        toggleIsSavingForm();
        await service.saveForm(onUpdate: onUpdate);
      } catch (e) {
        rethrow;
      } finally {
        toggleIsSavingForm();
      }
    }
  }

  // onWillPop(): will check if any new data is added to form and takes decisions
  //              accordingly whether to show confirmation or navigate back directly
  Future<bool> onWillPop() async {

    bool isNewDataAdded = service.checkIfNewDataAdded();

    if(isNewDataAdded) {
      showUnsavedChangesConfirmation();
    } else {
      Helper.hideKeyboard();
      Get.back();
    }

    return false;

  }

  // showUnsavedChangesConfirmation(): displays confirmation dialog
  void showUnsavedChangesConfirmation() {
    showJPBottomSheet(
        child: (_) => JPConfirmationDialog(
          title: 'unsaved_changes'.tr,
          subTitle: 'unsaved_changes_desc'.tr,
          icon: Icons.warning_amber_outlined,
          suffixBtnText: 'dont_save'.tr.toUpperCase(),
          prefixBtnText: 'wait'.tr.toUpperCase(),
          onTapSuffix: () {
            Get.back();
            Get.back();
          },
        ),
    );
  }

}

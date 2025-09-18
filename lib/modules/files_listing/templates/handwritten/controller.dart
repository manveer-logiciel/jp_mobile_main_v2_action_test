import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/enums/templates.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/templates/handwritten/editor.dart';
import 'package:jobprogress/common/models/templates/handwritten/page.dart';
import 'package:jobprogress/common/models/templates/handwritten/template.dart';
import 'package:jobprogress/common/repositories/estimations.dart';
import 'package:jobprogress/common/repositories/job.dart';
import 'package:jobprogress/common/services/file_picker.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/calculator/calculator.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/QuickEditDialog/type.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../../common/enums/unsaved_resource_type.dart';
import '../../../../core/constants/sql/auto_save_duration.dart';
import '../../../../core/utils/form/db_helper.dart';
import '../../../../core/utils/form/unsaved_resources_helper/unsaved_resources_helper.dart';
import 'widgets/drawing_editor/controller.dart';
import 'widgets/template_editor/controller.dart';

class HandwrittenTemplateController extends GetxController {

  JobModel? job; // helps in storing job details to fill out db elements
  HandwrittenTemplateModel? template; // holds template data

  String jobName = ""; // holds the job name

  bool isSavingForm = false; // helps in disabling user interaction while saving form
  bool isSavedOnTheGo = false; // helps in deciding whether to refresh proposal listing
  bool isLoading = true;

  int? jobId = Get.arguments?[NavigationParams.jobId];
  String? templateId = Get.arguments?[NavigationParams.templateId];
  EstimateTemplateFormType formType = Get.arguments?[NavigationParams.handwrittenTemplateType] ?? EstimateTemplateFormType.add;

  List<HandwrittenEditorModel> editors = []; // used to editor controllers

  int currentPage = 0;
  int? unsavedResourceId = Get.arguments?[NavigationParams.dbUnsavedResourceId];
  int? dbUnsavedResourceId;

  StreamSubscription<void>? stream;

  Map<String, dynamic>? unsavedResourceJson;

  String get customerName => job?.customer?.fullName ?? job?.name ?? 'template'.tr.capitalizeFirst!;

  bool get isEditForm => formType == EstimateTemplateFormType.edit;
  bool get hasError => !isLoading && (job == null || editors.isEmpty);
  bool get doShowPageSwitcher => editors.length > 1;
  bool get isFirstPage => currentPage == 0;
  bool get isLastPage => currentPage == editors.length - 1;

  @override
  void onInit() async {
    // Initial delay to avoid animation lags
    if(unsavedResourceId != null) {
      await fetchUnsavedResourcesData();
    }
    Future.delayed(const Duration(milliseconds: 500), initTemplate);
    super.onInit();
  }

  // [initTemplate] sets up template and it's data
  Future<void> initTemplate() async {
    try {
      showJPLoader();
      // fetching template details to show form
      if(dbUnsavedResourceId == null) await fetchTemplate();
      // setting up html content
      await fetchJob();
      // setting up drawing and template controllers
      initializeEditors();
      // auto saving form data
      stream = Stream.periodic(AutoSaveDuration.delay, (val) => saveDataInLocalDB()).listen((count) {});
      update();
    } catch (e) {
      rethrow;
    } finally {
      // additional delay for HTML editors to set up content
      await Future<void>.delayed(const Duration(seconds: 2));
      isLoading = false;
      update();
      Get.back();
    }
  }

  /// Network Calls -----------------------------------------------------------

  // [fetchJob] loads job from the server
  Future<void> fetchJob() async {
    try {
      if (job != null) return;

      Map<String, dynamic> jobParams = {
        "id": jobId,
        "includes[0]": "customer",
        "includes[1]": "customer.referred_by",
        "includes[2]": "financial_details",
        "includes[3]": "customer.contacts",
        "includes[4]": "contact",
        "includes[5]": "contacts",
        "includes[6]": "contacts.emails",
        "includes[7]": "contacts.phones",
        "includes[8]": "contacts.address",
        "includes[9]": "projects",
        "includes[10]": "insurance_details",
        "includes[11]": "delivery_dates",
        "includes[12]": "division",
        "includes[13]": "flags.color",
      };

      Map<String, dynamic> upcomingAppointmentScheduleParams = {
        "id": jobId,
        "includes[]": "attendees",
        "upcoming_appointment": 1,
        "upcoming_schedule": 1,
      };

      final response = await Future.wait([
        JobRepository.fetchJob(jobId!, params: jobParams),
        JobRepository.fetchUpcomingJobAppointmentSchedule(upcomingAppointmentScheduleParams),
      ]);

      job = response[0]["job"];
      job?.upcomingAppointment = response[1]['appointment'];
      job?.upcomingSchedules = response[1]['schedule'];
      jobName = Helper.getJobName(job!);
    } catch (e) {
      rethrow;
    }
  }

  // [fetchTemplate] loads template from server
  Future<void> fetchTemplate() async {
    try {
      Map<String, dynamic> params = {
        'id': templateId,
        'includes[0]': 'pages',
        'multi_page': 1
      };
      template = await EstimatesRepository.fetchHandwrittenTemplate(params, forEdit: isEditForm);
    } catch (e) {
      rethrow;
    }
  }

  // [saveTemplate] can be used to save or update template
  Future<void> saveTemplate({String? name}) async {
    try {
      toggleIsSavingForm();
      List<Map<String, dynamic>> pages = [];

      // preparing editor pages
      for (var editor in editors) {
        final json = await editor.toJson();
        pages.add(json);
      }

      final params = {
        if (isEditForm) 'id': templateId,
        "is_mobile": '1',
        "job_id": jobId.toString(),
        "page_type": template?.pageType,
        "title": name ?? template?.title,
        "pages": pages
      };

      final response = await EstimatesRepository.saveHandwrittenTemplate(params, forEdit: isEditForm);

      if (!isEditForm) {
        templateId = response.id;
        template = HandwrittenTemplateModel(title: name);
        formType = EstimateTemplateFormType.edit;
      }
      isSavedOnTheGo = true;
      // clearing previous changes so that once template saved
      // user can't undo previously drawn elements
      clearPreviousChanges();
      Helper.showToastMessage('estimate_saved'.tr);
    } catch (e) {
      rethrow;
    } finally {
      toggleIsSavingForm();
    }
  }

  /// Helpers -----------------------------------------------------------------

  // [onTapSave] - decides whether any changes made before saving or not
  // whether to ask for estimate name or not and do required action on tapping save
  void onTapSave() {
    // checking if any changes are there to save
    bool isAnythingToSave = checkIfAnyChangesMade();
    // simply showing toast if there are not
    if (!isAnythingToSave && unsavedResourceId == null) {
      Helper.showToastMessage('no_changes_made'.tr);
      return;
    }
    // in case of edit for saving changes directly otherwise opening name dialog
    if (isEditForm) {
      saveTemplate();
    } else {
      showSaveDialog();
    }
  }

  // [checkIfAnyChangesMade] - helps in checking whether any new changes are there
  bool checkIfAnyChangesMade() {
    bool isAnyChangeMade = false;
    // iterating through each editor and checking if any drawable is added
    for (HandwrittenEditorModel editor in editors) {
      isAnyChangeMade = editor.drawingController.isAnyChangeMade();
      if (isAnyChangeMade) break;
    }
    return isAnyChangeMade;
  }

  // [clearPreviousChanges] - helps in clearing previous changes on saving estimate
  void clearPreviousChanges() {
    for (HandwrittenEditorModel editor in editors) {
      editor.drawingController.clearAllActions();
    }
    deleteUnsavedResource();
    unsavedResourceId = null;
    dbUnsavedResourceId = null;
  }

  // [switchPage] - helps in switching between pages back nd forth
  Future<void> switchPage({bool toNext = true}) async {
    int oldIndex = currentPage;
    int newIndex = toNext ? currentPage + 1 : currentPage - 1;
    await mapDrawingToolSettings(oldIndex, newIndex);
    update();
  }

  // [mapDrawingToolSettings] - helps to map settings on selected drawing editor
  // to switched drawing editor
  Future<void> mapDrawingToolSettings(int oldIndex, int newIndex) async {
    currentPage = newIndex;
    final oldController = editors[oldIndex].drawingController;
    final newController = editors[newIndex].drawingController;
    newController.mapController(oldController);
    // additional delay for mapping controller
    await Future<void>.delayed(const Duration(milliseconds: 150));
    oldController.resetZoom();
  }

  void navigateToSnippets() {
    Get.toNamed(Routes.snippetsListing, preventDuplicates: false);
  }

  void toggleIsSavingForm() {
    isSavingForm = !isSavingForm;
    update();
  }

  // [initializeEditors] - helps in initializing the editors with data
  void initializeEditors() {
    for (HandwrittenTemplatePageModel page in template?.pages ?? []) {
      // setting up drawing controller
      final drawingController = HandwrittenDrawingController(
        templateCover: (unsavedResourceId != null || isEditForm) ? page.editableContent : null,
        pageSize: template?.pageType
      );
      // setting up page controller
      final pageController = HandwrittenTemplateEditorController(
        pageType: template?.pageType,
        job: job,
        templatePage: page
      );

      final editor = HandwrittenEditorModel(drawingController, pageController);
      editors.add(editor);
    }
  }

  /// Dialogs & Sheets --------------------------------------------------------

  // [showSaveDialog] - opens up the name dialog to enter estimate name
  Future<void> showSaveDialog({String? initialValue}) async {
    FocusNode renameDialogFocusNode = FocusNode();

    showJPGeneralDialog(
        child: (controller){
          return JPQuickEditDialog(
            type: JPQuickEditDialogType.inputBox,
            label: 'estimate_name'.tr,
            fillValue: initialValue,
            title: 'save_estimate'.tr.toUpperCase(),
            suffixIcon: showJPConfirmationLoader(show: controller.isLoading),
            disableButton: controller.isLoading,
            errorText: 'please_enter_estimate_name'.tr,
            onCancel: controller.isLoading ? null : Get.back<void>,
            onSuffixTap: (val) async {
              controller.toggleIsLoading();
              await saveTemplate(name: val).then((value) {
                controller.toggleIsLoading();
              }).catchError((e) {
                controller.toggleIsLoading();
              });
              Get.back();
            },
            focusNode: renameDialogFocusNode,
            suffixTitle: controller.isLoading ? '' : 'save'.tr.toUpperCase(),
            maxLength: 50,
          );
        },
        isDismissible: false
    );

    await Future<void>.delayed(const Duration(milliseconds: 400));

    renameDialogFocusNode.requestFocus();
  }

  void showCalculator() {
    showJPGeneralDialog(
        isDismissible: false,
        child:(_)=> const FloatingCalculator(),
    );
  }

  Future<void> editImage() async {
    final path = await FilePickerService.takePhoto();

    if (path == null) return;

    final result = await Get.toNamed(Routes.imageEditor, arguments: {
      'module': FLModule.templates,
      'jobId': jobId,
      NavigationParams.parentId: job?.meta?.resourceId,
      NavigationParams.localImagePath: path,
    });

    if (result != null) {
      Helper.showToastMessage('photo_saved'.tr);
    }
  }

  /// Auto saved hand written template  ---------------------------------------

  Future<void> fetchUnsavedResourcesData() async {
    try {
      final response = await FormsDBHelper.getUnsavedResources(unsavedResourceId);
      setUnsavedFromTemplate(response);
    } catch (e) {
      rethrow;
    } finally {
      update();
    }
  }
  // setUnsavedFromTemplate(): will read unsaved form details from local DB
  void setUnsavedFromTemplate(Map<String, dynamic>? response) {
    unsavedResourceJson = FormsDBHelper.getUnsavedResourcesJsonData(response);

    template = HandwrittenTemplateModel.fromJson(unsavedResourceJson?["template"]);

    template?.pages = <HandwrittenTemplatePageModel>[];
    unsavedResourceJson?['pages'].forEach((dynamic page) {
      template?.pages?.add(HandwrittenTemplatePageModel.fromUnsavedResourceJson(page));
    });

    formType = unsavedResourceJson?["isEditForm"] ?? false ? EstimateTemplateFormType.edit : EstimateTemplateFormType.add;

    dbUnsavedResourceId = unsavedResourceId;
    update();
  }

  // saveDataInLocalDB(): will save unsaved form in local DB
  Future<void> saveDataInLocalDB() async {
    if(Get.routing.current != Routes.handWrittenTemplate) return;

    List<Map<String, dynamic>> pages = [];

    // preparing editor pages
    for (var editor in editors) {
      final json = await editor.toUnsavedResourceJson();
      pages.add(json);
    }

    final params = {
      if (isEditForm) 'id': templateId,
      "is_mobile": '1',
      "job_id": jobId.toString(),
      'template': template,
      "page_type": template?.pageType,
      "title": template?.title,
      "isEditForm": isEditForm,
      "pages": pages
    };

    Map<String, dynamic> resource = {
      "type": UnsavedResourcesHelper.getUnsavedResourcesString(UnsavedResourceType.handWrittenTemplate),
      "job_id": jobId,
      "data": json.encode(params),
    };

    dbUnsavedResourceId = await UnsavedResourcesHelper().insertOrUpdate(dbUnsavedResourceId, resource);
    update();
  }

  // deleteUnsavedResource(): will delete unsaved form from local DB
  void deleteUnsavedResource() {
    if(dbUnsavedResourceId != null) {
      UnsavedResourcesHelper.deleteUnsavedResource(id: dbUnsavedResourceId!);
      dbUnsavedResourceId = dbUnsavedResourceId = null;
      update();
    }
  }

  // onWillPop(): will check if any new data is added to form and takes decisions
  //              accordingly whether to show confirmation or navigate back directly
  Future<bool> onWillPop({bool hasUnsavedChanges = false}) async {

    if (hasError) {
      Get.back();
      return true;
    }

    bool isNewDataAdded = checkIfAnyChangesMade();

    if(isNewDataAdded || unsavedResourceId != null) {
      Helper.showUnsavedChangesConfirmation(unsavedResourceId: dbUnsavedResourceId);
    } else {
      Helper.hideKeyboard();
      if(unsavedResourceId == null) deleteUnsavedResource();
      Get.back(result: isSavedOnTheGo);
    }

    return false;
  }

  @override
  Future<void> dispose() async {
    await stream?.cancel();
    HandwrittenDrawingController().resetOrientation();
    super.dispose();
  }

}
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:jobprogress/common/enums/hover.dart';
import 'package:jobprogress/common/enums/job.dart';
import 'package:jobprogress/common/enums/parent_form_type.dart';
import 'package:jobprogress/common/enums/snippet_trade_script.dart';
import 'package:jobprogress/common/models/forms/common/params.dart';
import 'package:jobprogress/common/models/forms/hover_order_form/params.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/project/index.dart';
import 'package:jobprogress/common/repositories/job.dart';
import 'package:jobprogress/common/services/forms/value_selector.dart';
import 'package:jobprogress/common/services/project/project_form/bind_validator.dart';
import 'package:jobprogress/core/constants/forms/project_form.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/utils/form/db_helper.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/modules/files_listing/forms/hover_order_form/form/index.dart';
import 'package:jobprogress/modules/project/project_form/controller.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/SingleSelect/model.dart';

/// [ProjectFormService] used to manage form data. It is responsible for all the data additions, deletions and updates
/// - This service directly deal with form data independent of controller
class ProjectFormService extends ProjectFormData {
  ProjectFormService({
    required this.fields,
    required super.update,
    required this.validateForm,
    required this.onDataChange,
    required super.formType,
    required this.divisionCode,
    required this.showCompanyCam,
    required this.parenrFormType,
    this.showHover,
    super.customer,
    super.job,
  });

  VoidCallback validateForm; // helps in performing validation in service
  Function(String) onDataChange;
  List<InputFieldParams> fields;
  String divisionCode;
  late ProjectFormBindValidator bindValidatorService;
  ProjectFormController? _controller; // helps in managing controller without passing object
  bool? showHover, showCompanyCam;
  ParentFormType parenrFormType;

  ProjectFormController get controller =>_controller ?? ProjectFormController(fields, divisionCode, showCompanyCam, showHover,parenrFormType);

  Future<void> initForm() async {
    // delay to prevent navigation animation lags
    // because as soon as we enter form page a request to local DB is made
    // resulting in ui lag. This delay helps to avoid running both tasks in parallel
    await Future<void>.delayed(const Duration(milliseconds: 200));

    try {
      if(job?.id != null) {
        await fetchJob(job!.id);
      }

      await getLocalData();

      await getProjectStatus();
      setUpFields();
      // binding validators with fields
      bindValidatorService = ProjectFormBindValidator(this);
      bindValidatorService.bind();
      setFormData();
      selectedJobDivisionCode = (parenrFormType == ParentFormType.inherited ? controller.divisionCode : job!.divisionCode)!;

      if (selectedProjectStatus.isEmpty && projectStatusList.isNotEmpty) {
        selectedProjectStatus = projectStatusList.first.id;
        projectStatusController.text = FormValueSelectorService.getSelectedSingleSelectValue(projectStatusList, selectedProjectStatus);
      }
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      update();
      // additional delay for all widgets to get rendered and setup data
      await Future.delayed(const Duration(milliseconds: 500), setInitialJson);
    }
  }

  /// [setUpFields] loads fields from company settings & parse them to sections
  void setUpFields() {
    if (fields.isEmpty) {
      allFields = getCompanySettingProjectFields();
    } else {
      allFields = fields;
    }
    for (InputFieldParams field in allFields) {
      // binding data listener with fields
      field.onDataChange = onDataChange;
    }
    checkAndRemoveFields();
    allFields.removeWhere((field) => !field.showFieldValue);
  }

  /// [checkAndRemoveFields] removes fields which are not to be displayed
  /// based on certain conditions
  void checkAndRemoveFields() {
    canShowCompanyCam = doShowCompanyCam();
    canShowHover = doShowHover();

    // Removing sync with section if hover or company cam both not connected
    if (!canShowCompanyCam && (!canShowHover || isHoverJobCompleted)) {
      allFields.removeWhere((field) => field.key == ProjectFormConstant.syncWith);
    }
  }

  Future<void> getLocalData() async {
    try {
      List<String> estimatorIds = [];
      if (formType == JobFormType.edit) {
        estimatorIds = job?.estimators?.map((user) => user.id.toString()).toList() ?? [];
      } else {
        // setting up default rep / estimator for new project
        estimatorIds = getDefaultProjectRep();
      }
      // setting up rep / estimator
      projectRepEstimatorList = await FormsDBHelper.getAllUsers(estimatorIds,withSubContractorPrime: false);
      tagList = await FormsDBHelper.getAllTags();
    } catch (e) {
      rethrow;
    }
  }

  bool validateProjectAllFields({bool scrollOnValidate = true}) {
    bool validationFailed = false;
    bool scrollOnValidate = false;
    InputFieldParams? errorField;
    validateForm;
    dynamic Function(InputFieldParams)? scrollAndFocus;
    for (InputFieldParams field in allFields) {
      field.scrollOnValidate = scrollOnValidate;
      field.onDataChange = onDataChange;
      final isNotValid = validators[field.key]?.call(field) ?? false;
      if (isNotValid && !validationFailed) {
        scrollAndFocus ??= validators[field.key];
        validationFailed = isNotValid;
        scrollOnValidate = false;
        errorField ??= field;
      }
      if (validationFailed) {
        errorField?.scrollOnValidate = true;
        scrollAndFocus?.call(errorField!);
      }
    }
    return validationFailed;
  }

  void showUpdateFieldConfirmation() {
    if (!checkIfFieldDataChange()) return;
    showJPBottomSheet(
        child: (_) {
          return JPConfirmationDialog(
            title: 'confirmation'.tr,
            icon: Icons.info_outline,
            subTitle: "form_fields_refresh_desc".tr,
            suffixBtnText: "apply".tr,
            onTapPrefix: Get.back<void>,
            onTapSuffix: () {
              updateFields(false);
            },
          );
        },
        isDismissible: false);
  }

  Future<void> updateFields(bool isLocal) async {
    if (!isLocal) {
      Get.back();
    }
    showJPLoader();
    allFields.clear();
    validators.clear();
    setUpFields();
    bindValidatorService.bind();
    update();
    // Fake delay
    await Future<void>.delayed(const Duration(milliseconds: 500));
    Get.back();
  }

  bool validateProjectDescription(InputFieldParams field) {
    bool validationFailed = false;
    if (field.isRequired) {
      validationFailed = FormValidator.requiredFieldValidator(projectDescriptionController.text) != null;
      if (field.scrollOnValidate) projectDescriptionController.scrollAndFocus();
    }
    return validationFailed;
  }

  bool validateTradeWorkTypes(InputFieldParams field) {
    bool validationFailed = false;
    if (field.isRequired) {
      validationFailed = tradeWorkTypeFormKey.currentState?.validate(scrollOnValidate: field.scrollOnValidate) ?? false;
    }
    return validationFailed;
  }

  bool validateProjectRepEstimator(InputFieldParams field) {
    bool validationFailed = false;
    if(field.isRequired) {
      validationFailed = selectedProjectRepEstimators.isEmpty;
      if (validationFailed) projectRepEstimatorController.scrollAndFocus();
    }
    return validationFailed;
  }

  /// [getProjectStatus] loads project status from server
  Future<void> getProjectStatus() async {
    try {
      final response = await JobRepository.fetchProjectStatus();
      //local parsing as no global use of categories
      for (dynamic projectStatus in response) {
        projectStatusList.add(JPSingleSelectModel(label: projectStatus["name"] ?? '',id: projectStatus["id"].toString()),);
      }
    } catch (e) {
      rethrow;
    }
  }

  void selectProjectStatus(String name) {
    FormValueSelectorService.openSingleSelect(
      title: "${'select'.tr} $name",
      list: projectStatusList,
      selectedItemId: selectedProjectStatus,
      controller: projectStatusController,
      onValueSelected: (val) {
        selectedProjectStatus = val;
        update();
      },
    );
  }

  void selectTradeScript() {
    Get.toNamed(Routes.snippetsListing, preventDuplicates: false, arguments: {
      NavigationParams.type: STArg.tradeScript,
      NavigationParams.pageType: STArgType.copyDescription,
    })?.then((value) {
      if (value?.toString().isNotEmpty ?? false) {
        String previousText = projectDescriptionController.text;
        String newAddedText = previousText.isNotEmpty ? "\n$value" : value;
        projectDescriptionController.text = previousText + newAddedText;
      }
      validateForm();
    });
  }

  void selectProjectRepEstimator(String name) {
    FormValueSelectorService.openMultiSelect(
        title: "${'select'.tr} $name",
        list: projectRepEstimatorList,
        tags: tagList,
        onSelectionDone: () {
          update();
        });
  }

  void toggleSyncWithCompanyCam(bool val) {
    syncWithCompanyCam = !val;
    update();
  }

  void toggleSyncWithHover(bool val) {
    if (!val) {
      // opening hover bottom sheet if value is false
      selectHover();
    } else {
      // removing linked hover
      hoverJob = null;
      hoverJson = null;
      syncWithHover = false;
    }

    update();
  }

  void selectHover() {
    showJPBottomSheet(
      child: (_) => HoverOrderForm(
        params: HoverOrderFormParams(
            jobId: job?.id,
            hoverUser: job?.hoverJob?.hoverUser,
            customer: job?.customer,
            formType: HoverFormType.linkWithJob,
            hoverJob: hoverJob,
            onHoverLinked: (job, json) {
              hoverJob = job;
              hoverJson = json;
              syncWithHover = true;
              update();
            }),
      ),
      isDismissible: false,
      isScrollControlled: true,
      ignoreSafeArea: false,
    );
  }

  List<JPMultiSelectModel> get selectedProjectRepEstimators => FormValueSelectorService.getSelectedMultiSelectValues(projectRepEstimatorList);

  /// [saveForm] helps in saving form
  Future<void> saveForm() async {
    try {
      final params = projectFormJson();
      Map<String, dynamic> additionalParams = {
        'customer_id': job?.customerId,
        'parent_id': job?.parentId ?? job?.id,
        'division_code': job?.divisionCode,
        'division_id': job?.division?.id,
      };
      params.addAll(additionalParams);
      if (formType == JobFormType.edit) {
        final response = await JobRepository.updateJob(job!.id, params);
        onFormSaved(response);
      } else {
        final response = await JobRepository.addJob(params);
        onFormSaved(response);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// helpers ------------------------------------------------------------------

  void onFormSaved(JobModel? responseJob) {
    if (responseJob == null) return;

    if (formType == JobFormType.add) {
      Helper.showToastMessage("project_saved".tr);
      Get.back(result: true);
    } else {
      Helper.showToastMessage("project_updated".tr);
      Get.back(result: true);
      Get.back();
    }

    Get.toNamed(Routes.jobSummary, preventDuplicates: false, arguments: {
      NavigationParams.jobId: responseJob.id,
      NavigationParams.customerId: responseJob.customerId,
    });
  }

  Future<void> fetchJob(int id) async {
    try {
      Map<String, dynamic> params = {
        'id': id,
        'includes[0]': 'customer',
        'includes[1]': 'address',
        'includes[2]': 'duration',
        'includes[3]': 'reps',
        'includes[4]': 'flags',
        'includes[5]': 'sub_contractors',
        'includes[6]': 'scheduled_trade_ids',
        'includes[7]': 'scheduled_work_type_ids',
        'includes[8]': 'division',
        'includes[9]': 'contact',
        'includes[10]': 'contacts',
        'includes[11]': 'contacts.emails',
        'includes[12]': 'contacts.phones',
        'includes[13]': 'contacts.address',
        'includes[14]': 'projects',
        'includes[15]': 'insurance_details',
        'includes[16]': 'custom_fields.options.sub_options.linked_parent_options',
        'includes[17]': 'hover_job',
        'includes[18]': 'hover_job.hover_user',
        'includes[19]': 'reps.divisions',
        'includes[20]': 'sub_contractors.divisions',
        'includes[21]': 'flags.color'
      };
      await JobRepository.fetchJob(id,params: params).then((Map<String, dynamic> response) {
        job = response["job"];
      });
    } catch (e) {
      rethrow;
    }
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/job.dart';
import 'package:jobprogress/common/models/address/address.dart';
import 'package:jobprogress/common/models/company_contacts.dart';
import 'package:jobprogress/common/models/company_trades/company_trades_model.dart';
import 'package:jobprogress/common/models/custom_fields/custom_fields.dart';
import 'package:jobprogress/common/models/custom_fields/custom_form_fields/index.dart';
import 'package:jobprogress/common/models/files_listing/hover/job.dart';
import 'package:jobprogress/common/models/forms/common/params.dart';
import 'package:jobprogress/common/models/forms/common/section.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job/job_type.dart';
import 'package:jobprogress/common/models/project/fields.dart';
import 'package:jobprogress/common/models/sql/flag/flag.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/common/services/connected_third_party.dart';
import 'package:jobprogress/common/services/feature_flag.dart';
import 'package:jobprogress/common/services/forms/value_selector.dart';
import 'package:jobprogress/common/services/launch_darkly/index.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/connected_third_party_constants.dart';
import 'package:jobprogress/core/constants/feature_flag_constant.dart';
import 'package:jobprogress/core/constants/forms/job_form.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/forms/custom_fields/index.dart';
import 'package:jobprogress/modules/job/job_form/form/sections/trade_work_type/index.dart';
import 'package:jobprogress/modules/project/project_form_tab/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../customer/customer.dart';
import 'fields.dart';

class JobFormData {
  // Controller
  JPInputBoxController jobRepEstimatorController = JPInputBoxController();
  JPInputBoxController jobDivisionController = JPInputBoxController();
  JPInputBoxController jobNameController = JPInputBoxController();
  JPInputBoxController jobAltIdController = JPInputBoxController();
  JPInputBoxController leadNumberController = JPInputBoxController();
  JPInputBoxController categoryController = JPInputBoxController();
  JPInputBoxController companyCrewController = JPInputBoxController();
  JPInputBoxController laborSubController = JPInputBoxController();
  JPInputBoxController jobDescriptionController = JPInputBoxController();
  JPInputBoxController jobDurationDayController = JPInputBoxController();
  JPInputBoxController jobDurationHourController = JPInputBoxController();
  JPInputBoxController jobDurationMinController = JPInputBoxController();
  JPInputBoxController otherTradeDescriptionController = JPInputBoxController();
  JPInputBoxController canvasserController = JPInputBoxController();
  JPInputBoxController otherCanvasserController = JPInputBoxController();

  bool syncWithCompanyCam = true;
  bool syncWithHover = false;
  bool showInsuranceClaim = false;
  bool isLoading = true;
  bool isContactPersonSameAsCustomer = true;
  bool canShowCompanyCam = false;
  bool isMultiProject = false;

  int? customerId;
  String? updatedStageCode;

  // Hover handlers
  bool isHoverConnected = false;
  bool isHoverOwnerIdChanged = false;
  bool isHoverJobCompleted = false;
  bool canShowHover = false;
  bool disableHoverToggle = false;

  // Form helpers
  AddressModel address = AddressModel(id: -1);
  HoverJob? hoverJob;

  List<CustomFormFieldsModel> customFormFields = [];

  // Selection IDs
  String selectedJobDivisionId = "";
  String selectedCategoryId = "";
  String selectedProjectStatus = "";
  String selectedJobDivisionCode = "";
  String canvasserId = '';
  String canvasserType = 'user';

  // Selection Lists
  List<JPSingleSelectModel> jobDivisionList = [];
  List<JPSingleSelectModel> categoryList = [];
  List<JPMultiSelectModel> jobRepEstimatorList = [];
  List<JPMultiSelectModel> laborSubList = [];
  List<JPMultiSelectModel> companyCrewList = [];
  List<JPMultiSelectModel> allFlags = [];
  List<JPMultiSelectModel> tagList = [];
  List<JPSingleSelectModel> canvasserList = [];

  List<CompanyTradesModel> tradesList = [];
  List<JobTypeModel> workTypesList = [];

  List<Map<String, dynamic>> projectsFormData = [];
  List<JobModel> projectList = [];

  // Section separator helpers
  List<FormSectionModel> allSections = [];
  List<InputFieldParams> allFields = [];
  List<InputFieldParams> projectFields = [];
  List<InputFieldParams> initialFieldsData = [];
  List<InputFieldParams> initialProjectFieldsData = [];
  List<InputFieldParams> sectionFields = [];
  List<CompanyContactListingModel> contactPersons = [];
  List<int> deletedContactPersonIds = []; // hold deleted contact person id which will be sent to server

  final customFieldsFormKey = GlobalKey<CustomFieldsFormState>();
  final tradeWorkTypeFormKey = GlobalKey<JobTradeWorkTypeInputsState>();
  final projectFormKey = GlobalKey<ProjectFormTabState>();

  Map<String, dynamic> initialJson = {}; // holds initial json for comparison
  Map<String, bool> fieldsToAdd = {}; // holds fields which will be sent to server
  Map<String, Function(InputFieldParams)> validators = {}; // holds list of validators
  Map<String, dynamic>? hoverJson; // holds hover order json
  Map<String, dynamic>? insuranceDetailsJson; // holds insurance details json for comparison to route add/edit insurance form
  JobModel? job; // holds customer data and helps in setting up fields
  JobModel? parentJobData;
  JobFormType formType; // helps in deciding form type and set-up data accordingly

  VoidCallback update; // helps in updating data

  CustomerModel? customer;

  JobFormData({required this.update,required this.formType,this.job,this.customerId});

  /// A job will be considered as parent job under following conditions:
  /// 1. Job Form is opened for editing, as at the time of adding job
  ///    job can either be single job or multiple project job but, can never be
  ///    parent job.
  /// 2. Job form is not opened for editing a project.
  /// 3. Job has multiple projects, linked to it.
  bool get isProjectParentJob => formType == JobFormType.edit
      && !(Helper.isTrue(job?.isProject))
      && Helper.isTrue(job?.isMultiJob);

  /// [setFormData] set-up initial data for form
  void setFormData() {
    if (job != null && formType == JobFormType.edit) {
      final JobModel? currentJob;
      isMultiProject = job?.parent != null || (job?.isMultiJob ?? false);
      
      // Job Division
        selectedJobDivisionId = (job?.division?.id ?? "").toString();
        selectedJobDivisionCode = (job?.division?.code ?? "").toString();
        jobDivisionController.text = FormValueSelectorService.getSelectedSingleSelectValue(
                jobDivisionList, selectedJobDivisionId);
      if (job?.isProject ?? false) {
        currentJob = parentJobData;      
      } 
      else {
        currentJob = job;
      }

      jobNameController.text = currentJob?.name ?? "";
      // Sync With
      syncWithHover = currentJob?.syncOnHover ?? false;
      if (currentJob?.hoverJob?.id != null) {
        hoverJob = currentJob?.hoverJob;
      }
      jobAltIdController.text = (currentJob?.altId ?? "").replaceFirst("$selectedJobDivisionCode-", "");
      // Serial Numbers
      leadNumberController.text = currentJob?.leadNumber ?? "";
      // Job Description
      jobDescriptionController.text = currentJob?.description ?? "";
      // Category
      final category = currentJob?.jobTypes ?? [];
      if(Helper.isValueNullOrEmpty(category)) {
        selectedCategoryId = "";
        categoryController.text = "none".tr;
        showInsuranceClaim  = false;
      } else {
        selectedCategoryId = (category.first?.id ??'').toString();
        categoryController.text = category.first?.name ?? "";
        showInsuranceClaim = category.first?.isInsuranceClaim ?? false;
      }
      // Job Duration
      final days = Helper.splitDurationintoMap('day', currentJob?.duration ?? "");
      final hours = Helper.splitDurationintoMap('hour', days['remainingData']!);
      final minutes = Helper.splitDurationintoMap('minute', hours['remainingData']!);
      jobDurationDayController.text = days['result'] ?? "";
      jobDurationHourController.text = hours['result'] ?? "";
      jobDurationMinController.text = minutes['result'] ?? "";
      // Custom Fields
      for (CustomFieldsModel? field in currentJob?.customFields ?? []) {
        CustomFormFieldsModel? formField = customFormFields.firstWhereOrNull((formField) => formField.id == field?.id);

        if (formField == null || field == null) continue;

        formField.fromCustomFieldModel(field);
      }

      // Trade type / work type
      if (!(currentJob?.isMultiJob ?? false)) {
        tradesList.addAll(currentJob?.trades ?? []);
        currentJob?.workTypes?.removeWhere((type) => type == null);
        currentJob?.workTypes?.forEach((type) {
          workTypesList.add(type!);
        });
      }

      // Address
      bool isJobAddressSameAsCustomer = currentJob?.customer?.address?.id == currentJob?.address?.id;
      if (!isJobAddressSameAsCustomer) {
        address = (currentJob?.address ?? address)
          ..sameAsDefault = isJobAddressSameAsCustomer;
      }

      // Canvasser
      canvasserType = job?.canvasserType ?? JobFormConstants.user;
      canvasserId = (job?.canvasser?.id ?? "").toString();
      canvasserId = canvasserType == JobFormConstants.user ? canvasserId : CommonConstants.otherOptionId;
      canvasserController.text = FormValueSelectorService.getSelectedSingleSelectValue(canvasserList, canvasserId);
      otherCanvasserController.text = job?.canvasserString ?? "";

      // Contact Person
      isContactPersonSameAsCustomer = currentJob?.isContactSameAsCustomer ?? true;
      contactPersons = currentJob?.contactPerson?.where((contactPersonModel) => contactPersonModel.id != currentJob?.customerId).toList() ?? [];

      // Other Trade Description
      otherTradeDescriptionController.text = job?.otherTradeTypeDescription ?? "";
    }
    if (canvasserId.isEmpty && canvasserList.isNotEmpty) {
      canvasserId = canvasserList.first.id;
      canvasserController.text = FormValueSelectorService.getSelectedSingleSelectValue(canvasserList, canvasserId);
    }
  }

  void setInitialJson() {
    initialJson = jobFormJson();
    initialFieldsData = getCompanySettingFields();
    initialProjectFieldsData = getCompanySettingProjectFields();
  }

  Map<String, dynamic> jobFormJson({bool addAllFields = true}) {
    Map<String, dynamic> json = {};

    // Sync with
    // Hover synced/un-synced will not be sent is case of multiple project job
    if (!isMultiProject) json['sync_on_hover'] = syncWithHover ? 1 : 0;
    json['sync_on_companycam'] = syncWithCompanyCam ? 1 : 0;

    // Job name
    json['name'] = jobNameController.text;

    // Job serial numbers
    json['alt_id'] = jobAltIdController.text;
    json['lead_number'] = leadNumberController.text;

    // Description
    json['description'] = jobDescriptionController.text;
    if (isMultiProject  && formType == JobFormType.add) {
      json['multi_job'] = 1;

      for (int i = 0; i < projectsFormData.length; i++) {
        json["projects[$i][duration]"] = projectsFormData[i]["duration"];
        json["projects[$i][status]"] = projectsFormData[i]["status"];
        json["projects[$i][sync_on_companycam]"] = projectsFormData[i]["sync_on_companycam"];
        json["projects[$i][other_trade_type_description]"] = projectsFormData[i]["other_trade_type_description"];
        //json["projects[$i][sync_on_hover]"] = projectsFormData[i]["sync_on_hover"];
        if(projectsFormData[i].containsKey('hover_capture_request')){
          json["projects[$i][sync_on_hover]"] = 0;
          json["projects[$i][hover_capture_request][customer_name]"] = projectsFormData[i]["hover_capture_request"]["customer_name"];
          json["projects[$i][hover_capture_request][customer_email]"] = projectsFormData[i]["hover_capture_request"]["customer_email"];
          json["projects[$i][hover_capture_request][hover_user_id]"] = projectsFormData[i]["hover_capture_request"]["hover_user_id"];
          json["projects[$i][hover_capture_request][hover_user_email]"] = projectsFormData[i]["hover_capture_request"]["hover_user_email"];
          json["projects[$i][hover_capture_request][customer_phone]"] = projectsFormData[i]["hover_capture_request"]["customer_phone"];
          json["projects[$i][hover_capture_request][job_address]"] = projectsFormData[i]["hover_capture_request"]["job_address"];
          json["projects[$i][hover_capture_request][job_address_line_2]"] = projectsFormData[i]["hover_capture_request"]["job_address_line_2"];
          json["projects[$i][hover_capture_request][job_city]"] = projectsFormData[i]["hover_capture_request"]["job_city"];
          json["projects[$i][hover_capture_request][job_zip_code]"] = projectsFormData[i]["hover_capture_request"]["job_zip_code"];
          json["projects[$i][hover_capture_request][deliverable_id]"] = projectsFormData[i]["hover_capture_request"]["deliverable_id"];
          json["projects[$i][hover_capture_request][country_id]"] = projectsFormData[i]["hover_capture_request"]["country_id"];
          json["projects[$i][hover_capture_request][state_id]"] = projectsFormData[i]["hover_capture_request"]["state_id"];
        }
        else if(projectsFormData[i].containsKey('hover_user_id')){
          json["projects[$i][sync_on_hover]"] = 1;
          json["projects[$i][hover_deliverable_id]"] = projectsFormData[i]["hover_deliverable_id"];
          json["projects[$i][hover_user_id]"] = projectsFormData[i]["hover_user_id"];
        }
        json["projects[$i][alt_id]"] = projectsFormData[i]["alt_id"];
        json["projects[$i][description]"] = projectsFormData[i]["description"];
        json["projects[$i][estimator_ids][]"] = projectsFormData[i]["estimator_ids[]"];
        json["projects[$i][work_types][]"] = projectsFormData[i]["work_types[]"];
        json["projects[$i][trades][]"] = projectsFormData[i]["trades[]"];
        json["projects[$i][division_code]"] = selectedJobDivisionCode;
      }
    } else if (isProjectParentJob) {
      json['multi_job'] = 1;
      json['tradesError'] = false;
      json['desError'] = false;
    } else {
      json['multi_job'] = 0;
      bool isAnyOtherTradeSelected = false;
      final selectedTradeIds = tradesList.map((trade) {
        // checking whether 'OTHER' trade is part of selected trades
        if (trade.name?.toLowerCase() == CommonConstants.otherOptionId) {
          isAnyOtherTradeSelected = true;
        }
        return trade.id;
      }).toList();
      json['trades[]'] = selectedTradeIds;
      json['other_trade_type_description'] = isAnyOtherTradeSelected ? otherTradeDescriptionController.text : null;
    }

    final selectedWorkTypeIds = workTypesList.map((type) => type.id).toList();
    json['work_types[]'] = selectedWorkTypeIds;

    // Contacts
    if (contactPersons.isNotEmpty) {
      json['contacts'] = contactPersons.map((contactPersonModel) => contactPersonModel.toJobContactJson()).toList();
    } else {
      isContactPersonSameAsCustomer = true;
    }
    if (deletedContactPersonIds.isNotEmpty) {
      json['delete_contact_ids[]'] = deletedContactPersonIds;
    }
    json['contact_same_as_customer'] = isContactPersonSameAsCustomer ? 1 : 0;

    // Custom fields
    List<Map<String, dynamic>> customFieldJson = [];
    for (var field in customFormFields) {
      customFieldJson.add(field.toJson());
    }
    customFieldJson.removeWhere((element) => element.isEmpty);
    json['custom_fields'] = customFieldJson;

    // Division Code
    json['division_code'] = selectedJobDivisionCode;

    // Insurance Claim
    json['insurance'] = showInsuranceClaim ? 1 : 0;

    // Job Duration
    json['duration'] = "${jobDurationDayController.text}:${jobDurationHourController.text}:${jobDurationMinController.text}";

    final selectedRepEstimatorIds = FormValueSelectorService.getSelectedMultiSelectIds(jobRepEstimatorList);
    json['estimator_ids[]'] = selectedRepEstimatorIds.isEmpty ? null : selectedRepEstimatorIds;

    final selectedCompanyCrewIds = FormValueSelectorService.getSelectedMultiSelectIds(companyCrewList);
    json['rep_ids[]'] = selectedCompanyCrewIds.isEmpty ? null : selectedCompanyCrewIds;

    final selectedSubContractorIds = FormValueSelectorService.getSelectedMultiSelectIds(laborSubList);
    json['sub_contractor_ids[]'] = selectedSubContractorIds.isEmpty ? null : selectedSubContractorIds;

    // Job Flags
    final selectedFlagIds = FormValueSelectorService.getSelectedMultiSelectIds(allFlags);
    json['flag_ids[]'] = selectedFlagIds;

    json['division_id'] = selectedJobDivisionId;

    // Job Address
    json['same_as_customer_address'] = address.sameAsDefault! ? 1 : 0;
    if (!address.sameAsDefault! || job != null) {
      final addressJson = address.toFormJson();
      addressJson.removeWhere((key, value) => value.toString().isEmpty || value == null);

      if (formType == JobFormType.edit) {
        json['address'] = addressJson;
      } else {
        json.addAll(addressJson);
      }
    }

    // Category Id
    json['job_types[]'] = selectedCategoryId;

    // Additional Flags
    bool isCallRequiredFlagAdded = selectedFlagIds.any((id) => id == FlagModel.callRequiredFlag.id.toString());
    bool isAppointmentRequiredFlagAdded = selectedFlagIds.any((id) => id == FlagModel.appointmentRequiredFlag.id.toString());
    json['call_required'] = isCallRequiredFlagAdded ? 1 : 0;
    json['appointment_required'] = isAppointmentRequiredFlagAdded ? 1 : 0;

    // insurance details
    if(showInsuranceClaim) {
      // In case of Job Add form, If Insurance data is not bind to Job or parent Job, Using
      // Insurance details Json created on the go to save Insurance details
      json['insurance_details'] = ((job?.isProject ?? false) ? parentJobData : job)?.insuranceDetails?.toJson() ?? insuranceDetailsJson ?? {};
    }

    // Customer Id
    json['customer_id'] = job?.customerId ?? customerId;

    // Hover
    if (hoverJson?.isNotEmpty ?? false) {
      if (hoverJob?.isCaptureRequest ?? false) {
        json['hover_capture_request'] = hoverJson!;
      } else {
        json.addAll(hoverJson!);
      }
    }

    // Canvasser
    if (!Helper.isValueNullOrEmpty(canvasserId)) {
      json["canvasser"] = otherCanvasserController.text;
      json["canvasser_id"] = canvasserId == CommonConstants.otherOptionId ? "" : int.tryParse(canvasserId);
      json["canvasser_type"] = canvasserId == CommonConstants.otherOptionId ? "other" : "user";
    }

    if (!Helper.isValueNullOrEmpty(updatedStageCode)) {
      json['stage'] = updatedStageCode;
    }

    return json;
  }

  // checkIfNewDataAdded(): used to compare form data changes
  bool checkIfNewDataAdded() {
    // In case of edit job if company cam option can be shown, we enable it by default
    // which means company cam was not connected before but it's available to connect now
    // so considering it as a change, done programmatically
    if (formType == JobFormType.edit && canShowCompanyCam) {
      return true;
    }
    final currentJson = jobFormJson();
    return initialJson.toString() != currentJson.toString();
  }

  /// [checkIfFieldDataChange] will helps in identifying when field data is
  /// actually changed
  bool checkIfFieldDataChange() {
    if (isMultiProject) {
      final data = getCompanySettingFields();
      final projectData = getCompanySettingProjectFields();
      if (data.length != initialFieldsData.length || projectData.length != initialProjectFieldsData.length) {
        return true;
      }
      for (int i = 0; i < initialFieldsData.length; i++) {
        // if any of the field value isn't matching then data is changed
        if (data[i] != initialFieldsData[i]) {
          return true;
        }
      }
      for (int i = 0; i < initialProjectFieldsData.length; i++) {
        // if any of the field value isn't matching then data is changed
        if (data[i] != initialProjectFieldsData[i]) {
          return true;
        }
      }
      return false;
    } else {
      final data = getCompanySettingFields();
      if (data.length != initialFieldsData.length) {
        return true;
      }

      for (int i = 0; i < initialFieldsData.length; i++) {
        // if any of the field value isn't matching then data is changed
        if (data[i] != initialFieldsData[i]) {
          return true;
        }
      }
      return false;
    }
  }

  /// [getCompanySettingFields] is a helper which will return fields from company settings
  /// if present otherwise, it will return customized list of fields
  List<InputFieldParams> getCompanySettingFields() {
    List<InputFieldParams> fields = [];
    bool isProductionFeatureAllowed = FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.production]);
    final data = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.prospectCustomize);
    if (data is Map) {
      if (!isMultiProject) {
        if(data['JOB'] != null) {
          for (dynamic field in (data['JOB'] ?? [])) {
            final rawField = InputFieldParams.fromJson(field);
            fields.add(rawField);
            update;
          }
          if(!isProductionFeatureAllowed){
            fields.removeWhere((element) => element.key == JobFormConstants.laborSub);
            update;
          }
          bool isCustomFieldRequired = customFormFields.any((customField) => customField.isRequired ?? false);
          // adding custom fields
          if(isCustomFieldRequired) {
            fields.firstWhere((field) => field.key == JobFormConstants.customFields).showFieldValue = true;
          }
        } else {
          return JobFormFieldsData.fields;
        }
      } else {
        for (dynamic field in (data['MULTI_JOB']['PARENT_JOB'] ?? [])) {
          final rawField = InputFieldParams.fromJson(field);
          fields.add(rawField);
          update;
        }

        // Manually inserting system field, if does not exists
        bool isSyncWithSectionExists = fields.any((field) => field.key == JobFormConstants.syncWith);
        if (!isSyncWithSectionExists) {
          fields.insert(0, InputFieldParams(key: JobFormConstants.syncWith, name: 'sync_with'.tr));
        }

        int customFieldIndex = fields.indexWhere((field) => field.key == JobFormConstants.customFields);
        if (customFieldIndex <= 0) {
          fields.add(InputFieldParams(key: JobFormConstants.project, name: 'project'.tr));
        } else {
          fields.insert(customFieldIndex - 1, InputFieldParams(key: JobFormConstants.project, name: 'project'.tr));
        }
      }

      return fields;
    }
    return JobFormFieldsData.fields;
  }

  List<InputFieldParams> getCompanySettingProjectFields() {
    List<InputFieldParams> fields = [];
    final data = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.prospectCustomize);
    if (data is Map) {
      for (dynamic field in (data['MULTI_JOB']['PROJECT'] ?? [])) {
        final rawField = InputFieldParams.fromJson(field);
        fields.add(rawField);
      }
      return fields;
    }
    return ProjectFormFieldsData.fields;
  }

  /// [doShowCompanyCam] helps in checking whether to show company cam or not
  bool doShowCompanyCam() {
    bool isCompanyCamConnected = ConnectedThirdPartyService.getConnectedPartyKey(ConnectedThirdPartyConstants.companyCam) ?? false;
    bool isCompanyNotCamLinkedWithJob = true;
    // Preforming extra check (company cam linked with job) only in case of
    // edit form as in case of add company cam will not be linked with job
    if (formType == JobFormType.edit) {
      isCompanyNotCamLinkedWithJob = job?.meta?.companyCamId == null;
    }
    return isCompanyCamConnected && isCompanyNotCamLinkedWithJob;
  }

  /// [doShowHover] helps in deciding whether to show hover or not
  bool doShowHover() {
    // In case of editing parent job hover can not be shown
    // Hover can also not be shown in case of multi-project job
    if (isProjectParentJob || isMultiProject) {
      return false;
    }

    Map<String, dynamic>? hover = ConnectedThirdPartyService.getConnectedPartyKey(ConnectedThirdPartyConstants.hover);

    isHoverConnected = hover != null;

    if (formType == JobFormType.edit) {
      isHoverOwnerIdChanged = job?.hoverJob?.ownerId != null && hover?[ConnectedThirdPartyConstants.hoverOwnerId] != job?.hoverJob?.ownerId;
      isHoverJobCompleted = job?.hoverJob?.state == "completed";
      disableHoverToggle = job?.hoverJob?.id != null;
    }

    return isHoverConnected && !isHoverOwnerIdChanged;
  }

  /// Returns a list containing the job representative ID if the company setting
  /// `jobRepDefaultToCustomerSalesRep` is enabled and the customer has a representative ID.
  /// Otherwise, returns an empty list.
  List<String> getDefaultJobRep() {
    // Check if the company setting to use customer sales rep as job rep is enabled
    bool useJobRepFromCustomerRep = Helper.isTrue(CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.jobRepDefaultToCustomerSalesRep));

    String? repId = job?.customer?.repId ?? customer?.repId;

    // Check if the customer representative ID is available
    bool isCustomerRepAvailable = !Helper.isValueNullOrEmpty(repId);

    // If both conditions are met, return the customer representative ID
    if (isCustomerRepAvailable && useJobRepFromCustomerRep) {
      return [repId!];
    }

    // Otherwise, return an empty list
    return [];
  }

  /// Determines whether to show workflow switch confirmation dialog
  /// This method evaluates if the user should be prompted about workflow impacts
  /// when changing a job's division during the editing process
  ///
  /// Business Logic:
  /// - Workflow confirmation is only needed when editing existing jobs
  /// - Division changes in new job creation don't require workflow confirmation
  /// - Only actual division changes (not same division selection) trigger confirmation
  /// - Feature flag must be enabled for division-based workflow functionality
  ///
  /// Returns true if workflow confirmation should be shown, false otherwise
  bool doShowWorkflowSwitchConfirmation() {
    // Feature flag check: only show workflow confirmation if division-based workflows are enabled
    if (!LDService.hasFeatureEnabled(LDFlagKeyConstants.divisionBasedMultiWorkflows)) {
      return false;
    }

    // Only show confirmation for job editing (not new job creation)
    // AND when the selected division actually differs from current division
    return formType == JobFormType.edit && selectedJobDivisionId != (job?.division?.id ?? "").toString();
  }
}



import 'package:flutter/material.dart';
import 'package:jobprogress/common/enums/job.dart';
import 'package:jobprogress/common/models/company_trades/company_trades_model.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/files_listing/hover/job.dart';
import 'package:jobprogress/common/models/forms/common/params.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job/job_type.dart';
import 'package:jobprogress/common/models/project/fields.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/common/services/connected_third_party.dart';
import 'package:jobprogress/common/services/forms/value_selector.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/connected_third_party_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/modules/job/job_form/form/sections/trade_work_type/index.dart';
import 'package:jp_mobile_flutter_ui/InputBox/controller.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/SingleSelect/model.dart';

class ProjectFormData {
  //Controllers
  JPInputBoxController projectRepEstimatorController = JPInputBoxController();
  JPInputBoxController projectAltIdController = JPInputBoxController();
  JPInputBoxController projectStatusController = JPInputBoxController();
  JPInputBoxController projectDescriptionController = JPInputBoxController();
  JPInputBoxController projectDurationDayController = JPInputBoxController();
  JPInputBoxController projectDurationHourController = JPInputBoxController();
  JPInputBoxController projectDurationMinController = JPInputBoxController();
  JPInputBoxController otherTradeDescriptionController = JPInputBoxController();

  List<InputFieldParams> allFields = [];
  HoverJob? hoverJob;

  bool canShowCompanyCam = false;
  bool syncWithCompanyCam = true;
  bool syncWithHover = false;
  bool isHoverConnected = false;
  bool isHoverOwnerIdChanged = false;
  bool isHoverJobCompleted = false;
  bool canShowHover = false;
  bool disableHoverToggle = false;

  bool isLoading = true;

  JobModel? job; // holds customer data and helps in setting up fields
  JobFormType formType;
  CustomerModel? customer; // holds only the customer data to fill in default values from customer

  // Selection IDs
  String selectedProjectStatus = "";
  String selectedJobDivisionCode = "";

  Map<String, dynamic> initialDataJson = {};
  Map<String, dynamic>? hoverJson; // holds hover order json

  //Selection Lists
  List<JPSingleSelectModel> projectStatusList = [];
  List<JPMultiSelectModel> projectRepEstimatorList = [];
  List<JPMultiSelectModel> tagList = [];
  List<CompanyTradesModel> tradesList = [];
  List<JobTypeModel> workTypesList = [];

  VoidCallback update; // helps in updating data

  ProjectFormData({
    required this.update,
    required this.formType,
    this.job,
    this.customer
  });

  final tradeWorkTypeFormKey = GlobalKey<JobTradeWorkTypeInputsState>();

  List<InputFieldParams> getCompanySettingProjectFields() {
    List<InputFieldParams> fields = [];
    final data = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.prospectCustomize);
    if (data is Map && (data['MULTI_JOB']['PROJECT'] != null)) {
      for (dynamic field in (data['MULTI_JOB']['PROJECT'] ?? [])) {
        final rawField = InputFieldParams.fromJson(field);
        fields.add(rawField);
      }
      return fields;
    }
    return ProjectFormFieldsData.fields;
  }

  void setInitialJson() {
    initialDataJson = projectFormJson();
  }

  // checkIfNewDataAdded(): used to compare form data changes
  bool checkIfNewDataAdded() {
    // In case of edit job if company cam option can be shown, we enable it by default
    // which means company cam was not connected before but it's available to connect now
    // so considering it as a change, done programmatically
    if (formType == JobFormType.edit && canShowCompanyCam) {
      return true;
    }
    final currentJson = projectFormJson();
    return initialDataJson.toString() != currentJson.toString();
  }

  /// [checkIfFieldDataChange] will helps in identifying when field data is
  /// actually changed
  bool checkIfFieldDataChange() {
    final data = getCompanySettingProjectFields();
    // if length is not matching then data is changed
    if (data.length != initialDataJson.length) {
      return true;
    }

    for (int i = 0; i < initialDataJson.length; i++) {
      // if any of the field value isn't matching then data is changed
      if (data[i] != initialDataJson[i]) {
        return true;
      }
    }

    return false;
  }

  void setFormData() {

    if (job != null && formType == JobFormType.edit) {
      syncWithHover = job?.syncOnHover ?? false;
      if (job?.hoverJob?.id != null) {
        hoverJob = job?.hoverJob;
      }
      selectedJobDivisionCode = job?.division?.code ?? "";

      projectAltIdController.text = (job?.altId ?? "").replaceFirst("$selectedJobDivisionCode-", "");

      // Project Description
      projectDescriptionController.text = job?.description ?? "";

      // Project Duration
      final days = Helper.splitDurationintoMap('day', job?.duration ?? "");
      final hours = Helper.splitDurationintoMap('hour', days['remainingData']!);
      final minutes = Helper.splitDurationintoMap('minute', hours['remainingData']!);
      projectDurationDayController.text = days['result'] ?? "";
      projectDurationHourController.text = hours['result'] ?? "";
      projectDurationMinController.text = minutes['result'] ?? "";

      // Trade type / work type
      tradesList.addAll(job?.trades ?? []);
      job?.workTypes?.removeWhere((type) => type == null);
      job?.workTypes?.forEach((type) {
        workTypesList.add(type!);
      });

      // Other Trade Description
      otherTradeDescriptionController.text = job?.otherTradeTypeDescription ?? "";
    }
  }

  Map<String, dynamic> projectFormJson({bool addAllFields = true}) {
    Map<String, dynamic> json = {};
    json['alt_id'] = projectAltIdController.text;
    final selectedRepEstimatorIds = FormValueSelectorService.getSelectedMultiSelectIds(projectRepEstimatorList);
    json['estimator_ids[]'] = selectedRepEstimatorIds;
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

    final selectedWorkTypeIds = workTypesList.map((type) => type.id).toList();
    json['work_types[]'] = selectedWorkTypeIds;

    json['description'] = projectDescriptionController.text;
    if (formType == JobFormType.add) json['status'] = selectedProjectStatus;
    json['sync_on_companycam'] = syncWithCompanyCam ? 1 : 0;
    json['sync_on_hover'] = syncWithHover ? 1 : 0;
    if (hoverJson?.isNotEmpty ?? false) {
      if (hoverJob?.isCaptureRequest ?? false) {
        json['hover_capture_request'] = hoverJson!;
      } else {
        json.addAll(hoverJson!);
      }
    }
    json['duration'] = "${projectDurationDayController.text}:${projectDurationHourController.text}:${projectDurationMinController.text}";
    return json;
  }

  Map<String, Function(InputFieldParams)> validators = {};

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
    Map<String, dynamic>? hover = ConnectedThirdPartyService.getConnectedPartyKey(ConnectedThirdPartyConstants.hover);

    isHoverConnected = hover != null;

    if (formType == JobFormType.edit) {
      isHoverOwnerIdChanged = job?.hoverJob?.ownerId != null 
      && hover?[ConnectedThirdPartyConstants.hoverOwnerId] != job?.hoverJob?.ownerId;
      isHoverJobCompleted = job?.hoverJob?.state == "completed";
      disableHoverToggle = job?.hoverJob?.id != null;
    }

    return isHoverConnected && !isHoverOwnerIdChanged;
  }

  /// Returns a list containing the job representative ID if the company setting
  /// `jobRepDefaultToCustomerSalesRep` is enabled and the customer has a representative ID.
  /// Otherwise, returns an empty list.
  List<String> getDefaultProjectRep() {
    final defaultRepId = job?.customer?.repId ?? customer?.repId;
    // Check if the company setting to use customer sales rep as job rep is enabled
    bool useJobRepFromCustomerRep = Helper.isTrue(CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.jobRepDefaultToCustomerSalesRep));

    // Check if the customer representative ID is available
    bool isCustomerRepAvailable = !Helper.isValueNullOrEmpty(defaultRepId);

    // If both conditions are met, return the customer representative ID
    if (isCustomerRepAvailable && useJobRepFromCustomerRep) {
      return [defaultRepId!];
    }

    // Otherwise, return an empty list
    return [];
  }
}

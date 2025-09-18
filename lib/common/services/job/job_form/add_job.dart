import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/company_contact_form_type.dart';
import 'package:jobprogress/common/enums/division_unmatch.dart';
import 'package:jobprogress/common/enums/hover.dart';
import 'package:jobprogress/common/enums/job.dart';
import 'package:jobprogress/common/enums/snippet_trade_script.dart';
import 'package:jobprogress/common/models/company_contacts.dart';
import 'package:jobprogress/common/models/custom_fields/custom_fields.dart';
import 'package:jobprogress/common/models/custom_fields/custom_form_fields/index.dart';
import 'package:jobprogress/common/models/email.dart';
import 'package:jobprogress/common/models/forms/common/params.dart';
import 'package:jobprogress/common/models/forms/common/section.dart';
import 'package:jobprogress/common/models/forms/hover_order_form/params.dart';
import 'package:jobprogress/common/models/forms/job/data.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job/job_type.dart';
import 'package:jobprogress/common/models/insurance/insurance_model.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/common/repositories/job.dart';
import 'package:jobprogress/common/repositories/job_type.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/common/services/forms/value_selector.dart';
import 'package:jobprogress/common/services/job/job_form/bind_validator.dart';
import 'package:jobprogress/common/services/launch_darkly/index.dart';
import 'package:jobprogress/common/services/workflow_stages/index.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/forms/job_form.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/utils/form/db_helper.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/division_unmatch/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/modules/files_listing/forms/hover_order_form/form/index.dart';
import 'package:jobprogress/modules/job/job_form/controller.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../repositories/customer.dart';

/// [JobFormService] used to manage form data. It is responsible for all the data additions, deletions and updates
/// - This service directly deal with form data independent of controller
class JobFormService extends JobFormData {
  JobFormService(
      {required super.update,
      required this.validateForm,
      required this.onDataChange,
      required this.forEditInsurance,
      required super.formType,
      super.job,
      super.customerId});

  bool forEditInsurance; // if user come for editInsurance

  VoidCallback validateForm; // helps in performing validation in service

  JobFormController?
      _controller; // helps in managing controller without passing object

  JobFormController get controller => _controller ?? JobFormController();

  late JobFormBindValidator bindValidatorService;

  Function(String) onDataChange;

  set controller(JobFormController value) {
    _controller = value;
  }

  // initForm(): initializes form data
  Future<void> initForm() async {
    // delay to prevent navigation animation lags
    // because as soon as we enter form page a request to local DB is made
    // resulting in ui lag. This delay helps to avoid running both tasks in parallel
    await Future<void>.delayed(const Duration(milliseconds: 200));
    try {
      if (job?.isProject ?? false) {
        await fetchJob(job?.parentId);
      } else if (job?.id != null) {
        await fetchJob(job?.id);
      }

      if (customerId != null) {
        await getCustomer();
      }

      // setting up custom fields data
      await getCustomFields();

      // setting up data from local DB
      await getLocalData();
      // setting up serial numbers with initial values, only in add case
      if (formType == JobFormType.add) await getSerialNumbers();
      // fetching categories from server
      await getCategories();

      // parsing dynamic fields
      setUpFields();

      // binding validators with fields
      bindValidatorService = JobFormBindValidator(this);
      bindValidatorService.bind();

      // filling form data
      setFormData();
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      update();

      // additional delay for all widgets to get rendered and setup data
      await Future.delayed(const Duration(milliseconds: 500), setInitialJson);
    }
  }

  Map<String, dynamic> get customerParams => {
    'id': customerId,
    "includes[0]": "phones",
    "includes[1]": "address",
    "includes[2]": "billing",
    "includes[3]": "referred_by",
    "includes[4]": "rep",
    "includes[5]": "flags",
    "includes[6]": "flags.color",
    "includes[7]": "contacts",
    "includes[8]": "custom_fields",
    "includes[9]": "divisions",
    "includes[10]": "canvasser",
    "includes[11]": "call_center_rep",
    "includes[12]": "custom_fields.options.sub_options.linked_parent_options",
  };

  Map<String, dynamic> jobParams(int? id) => {
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
    'includes[21]': 'flags.color',
    'includes[22]': 'custom_fields.users',
    if(LDService.hasFeatureEnabled(LDFlagKeyConstants.jobCanvaser))
    'includes[23]': 'canvasser',
  };

  
  Future<void> fetchJob(int? id) async {
    try {
      await JobRepository.fetchJob(id!, params: jobParams(id))
          .then((Map<String, dynamic> response) {
        if (Helper.isTrue(job?.isProject) || Helper.isTrue(job?.isMultiJob)) {
          parentJobData = response["job"];
        }
        job = response["job"];
        job?.customFields?.forEach((CustomFieldsModel? field) {
          if (field != null) {
            customFormFields
                .add(CustomFormFieldsModel.fromCustomFieldsModel(field));
          }
        });
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getCustomer() async {
    try {
      customer = await CustomerRepository.getCustomer(customerParams);
    } catch (e) {
      rethrow;
    }
  }

  /// Fields Set-up -----------------------------------------------------------

  /// [updateFields] will update fields as soon as company settings update
  /// and rebind validators
  Future<void> updateFields(bool isLocal) async {
    if (!isLocal) {
      Get.back();
    }
    showJPLoader();
    allFields.clear();
    sectionFields.clear();
    projectFields.clear();
    validators.clear();
    setUpFields();
    bindValidatorService.bind();
    initialFieldsData = getCompanySettingFields();

    // Fake delay
    await Future<void>.delayed(const Duration(milliseconds: 200));
    Get.back();
  }

  /// [getCustomFields] loads custom fields from server
  Future<void> getCustomFields() async {
    try {
      final params = {
        "model_type": "job",
        "limit": 150,
        "includes[0]": "options",
        "active": 1,
      };
      final List<CustomFormFieldsModel> listOfCustomFields = await CustomerRepository.getCustomFields(params);

      setCustomFormFieldsData(listOfCustomFields);
    } catch (e) {
      rethrow;
    }
  }

  /// [setCustomFormFieldsData] loads fields from company settings & job details & parse them to sections
  void setCustomFormFieldsData(List<CustomFormFieldsModel> listOfCustomFields) {
    if (customFormFields.isNotEmpty &&  formType == JobFormType.edit) {
      for (final customField in customFormFields) {
        final index = listOfCustomFields.indexWhere((existingField) => existingField.id == customField.id);

        if (index != -1) {
          if (customField.isDropdown) {
            // Retain the options if customField has them; otherwise, take them from listOfCustomFields
            customField.options ??= [];
            listOfCustomFields[index].options?.forEach((option) {
              if (!customField.options!.any((element) => element.id == option.id)) {
                customField.options!.add(option);
              }
            });
          }
          // Update the field in listOfCustomFields with the updated customField
          listOfCustomFields[index] = customField;
        } else {
          // If customField doesn't exist in listOfCustomFields, add it
          listOfCustomFields.add(customField);
        }
      }
    }
    customFormFields = listOfCustomFields;
    customFormFields.where((element) => element.isUserField).forEach((element) async {
      List<String>? selectedUsersId;
      if(formType == JobFormType.edit) {
        int? id = job?.customFields?.firstWhereOrNull((customfield) => customfield?.id == element.id)?.id;
        selectedUsersId = job?.customFields?.firstWhereOrNull((customField) => customField?.id == id)?.usersList?.map((user) => user.id.toString()).toList();
      }
      element.usersList = await FormsDBHelper.getAllUsers(selectedUsersId ?? [], withSubContractorPrime: true, divisionIds: [job?.division?.id]);
      element.controller = JPInputBoxController(text: element.usersList?.where((element) => element.isSelect).map((user) => user.label).join(', '));
    });
    update();
  }

  /// [setUpFields] loads fields from company settings & parse them to sections
  void setUpFields() {
    // reading
    final data = getCompanySettingFields();
    final projectData = getCompanySettingProjectFields();
    allFields.clear();
    projectFields.clear();

    for (InputFieldParams field in data) {
      // binding data listener with fields
      field.onDataChange = onDataChange;
      allFields.add(field);
    }
    for (InputFieldParams field in projectData) {
      // binding data listener with fields
      field.onDataChange = onDataChange;
      projectFields.add(field);
    }
    // Manually pushing flags section
    bool isFlagFieldExists = allFields.any((field) => field.key == JobFormConstants.flags);
    if(!isFlagFieldExists) {
      allFields.insert(0, InputFieldParams(key: JobFormConstants.flags, name: 'flags'.tr));
    }
    // Manually pushing project field if does not exists
    bool isProjectFieldExists = allFields.any((field) => field.key == JobFormConstants.project);
    bool doAddProjectFields = !isProjectFieldExists && isMultiProject;
    if (doAddProjectFields) {
      allFields.add(InputFieldParams(key: JobFormConstants.project, name: 'project'.tr));
    }
    // removing fields
    checkAndRemoveFields();

    // parsing fields
    parseToSections();
    update();
  }

  /// [checkAndRemoveFields] removes fields which are not to be displayed
  /// based on certain conditions
  void checkAndRemoveFields() {
    canShowCompanyCam = doShowCompanyCam();
    canShowHover = doShowHover();

    // Removing sync with section if hover or company cam both not connected
    if (!canShowCompanyCam && (!canShowHover || isHoverJobCompleted)) {
      allFields.removeWhere((field) => field.key == JobFormConstants.syncWith);
    }

    // Removing prime subcontractor field if it exists
    allFields
        .removeWhere((field) => field.key == JobFormConstants.primeContractor);

    // Removing trade type in case of multi project job
    if (isProjectParentJob) {
      allFields
          .removeWhere((field) => field.key == JobFormConstants.tradeWorkType);
    }
  }

  /// [parseToSections] parse fields to sections. Sections are in the order
  /// - Job Information
  /// - Job Address
  /// - Other Information
  /// - Contact Person
  /// - Custom Fields
  void parseToSections() {
    allFields.removeWhere((field) => !field.showFieldValue);
    projectFields.removeWhere((field) => !field.showFieldValue);
    sectionFields.clear();
    sectionFields.addAll(allFields);

    // separating fields having separate sections
    FormSectionModel? jobAddressSection =
        getSectionAndRemoveField(JobFormConstants.jobAddress);
    FormSectionModel? contactPersonSection = getSectionAndRemoveField(
        JobFormConstants.contactPerson,
        wrapInExpansion: true,
        avoidContentPadding: true);
    FormSectionModel? customFieldsSection =
        getSectionAndRemoveField(JobFormConstants.customFields);
    FormSectionModel? projectFieldsSection =
        getSectionAndRemoveField(JobFormConstants.project);

    // dividing fields on into basic & other information section
    int otherInformationIndex = sectionFields
        .indexWhere((field) => field.key == JobFormConstants.otherInformation);
    otherInformationIndex = otherInformationIndex == -1
        ? (sectionFields.length)
        : otherInformationIndex + 1;

    // separated basic information fields
    final basicInformation = sectionFields.sublist(0, otherInformationIndex);

    final otherInformationSection =
        sectionFields.sublist(otherInformationIndex);

    final sections = [
      //basic information section is always going to be there
      FormSectionModel(
          name: "job_information".tr.toUpperCase(),
          fields: basicInformation,
          isExpanded: true),
      // customer address section
      if (jobAddressSection != null) jobAddressSection,
      // other information section depends whether there are any fields in it or not
      if (otherInformationSection.isNotEmpty)
        FormSectionModel(
            name: "other_information".tr.toUpperCase(),
            fields: otherInformationSection),
      if (projectFieldsSection != null &&
          isMultiProject &&
          formType == JobFormType.add)
        projectFieldsSection,
      // contact person section
      if (contactPersonSection != null) contactPersonSection,
      // custom fields section
      if (customFieldsSection != null && customFormFields.isNotEmpty)
        customFieldsSection,
    ];

    sections.removeWhere((section) => section.fields.isEmpty);

    allSections.clear();
    allSections.addAll(sections);
  }

  /// [getSectionAndRemoveField] will remove parse field to section and remove it from sections list
  FormSectionModel? getSectionAndRemoveField(
    String key, {
    bool wrapInExpansion = false,
    bool avoidContentPadding = false,
  }) {
    FormSectionModel? section;
    final fieldIndex = sectionFields.indexWhere((field) => field.key == key);
    if (fieldIndex > 0) {
      section = FormSectionModel(
          name: sectionFields[fieldIndex].name,
          fields: [sectionFields[fieldIndex]],
          wrapInExpansion: wrapInExpansion,
          avoidContentPadding: avoidContentPadding);
      sectionFields.removeAt(fieldIndex);
    }
    return section;
  }

  /// getters -----------------------------------------------------------------

  List<JPMultiSelectModel> get selectedFlags =>
      FormValueSelectorService.getSelectedMultiSelectValues(allFlags);

  List<JPMultiSelectModel> get selectedJobRepEstimators =>
      FormValueSelectorService.getSelectedMultiSelectValues(
          jobRepEstimatorList);

  List<JPMultiSelectModel> get selectedCompanyCrews =>
      FormValueSelectorService.getSelectedMultiSelectValues(companyCrewList);

  List<JPMultiSelectModel> get selectedLaborSubs =>
      FormValueSelectorService.getSelectedMultiSelectValues(laborSubList);

  /// [getSerialNumbers] helps in initializing job alt id & lead number with default values
  Future<void> getSerialNumbers() async {
    String leadNumber = '';
    String jobNumber = '';

    String stageLeadNumber = '';
    String stageJobNumber = '';

    try {
      // fetching job alt id & lead number from company settings
      final settings = CompanySettingsService.getCompanySettingByKey(
          CompanySettingConstants.autoIncrementNumberStage);
      // setting up values if they exist
      if (settings is Map) {
        stageJobNumber = settings[CompanySettingConstants.jobNumberStage] ?? "";
        stageLeadNumber = settings[CompanySettingConstants.jobLeadNumberStage] ?? "";
      }

      // setting up params if values from company settings are null or empty
      final params = {
        if (stageJobNumber.isEmpty) 'type[0]': 'job_alt_id',
        if (stageLeadNumber.isEmpty) 'type[1]': 'job_lead_number',
      };
      // making a api call only if there are some requested params
      if (params.isNotEmpty) {
        final response = await JobRepository.generateSerialNumber(params);
        if(!Helper.isValueNullOrEmpty(response.jobAltId)){
          jobNumber = response.jobAltId!;
        }
        if(!Helper.isValueNullOrEmpty(response.jobLeadNumber)){
          leadNumber = response.jobLeadNumber!;
        }
      }
    } catch (e) {
      rethrow;
    } finally {
      leadNumberController.text = leadNumber;
      jobAltIdController.text = jobNumber;
    }
  }

  /// [getCategories] loads categories from server
  Future<void> getCategories() async {
    try {
      final response = await JobTypeRepository.fetchCategories({});
      List<JobTypeModel> tempCategories = response['list'];

      categoryList.insert(0,
          JPSingleSelectModel(label: 'none'.tr, id: '', additionalData: false));
      // local parsing as no global use of categories
      for (JobTypeModel category in tempCategories) {
        categoryList.add(JPSingleSelectModel(
            label: category.name ?? '',
            id: category.id.toString(),
            additionalData: category.isInsuranceClaim ?? false));
      }
    } catch (e) {
      rethrow;
    }
  }

  /// [getLocalData] loads data from local DB and set-up selection list
  Future<void> getLocalData() async {
    try {
      List<String> estimatorIds = [];
      List<String> crewIds = [];
      List<String> laborSubIds = [];
      List<String> selectedFlagIds = [];
      final JobModel finalJob;
      if (formType == JobFormType.edit) {
        if (job?.isProject ?? false) {
          finalJob = parentJobData!;
        } else {
          finalJob = job!;
        }
        selectedFlagIds =
            finalJob.flags?.map((flag) => flag!.id.toString()).toList() ?? [];
        estimatorIds =
            finalJob.estimators?.map((user) => user.id.toString()).toList() ??
                [];
        crewIds =
            finalJob.workCrew?.map((user) => user.id.toString()).toList() ?? [];
        laborSubIds = finalJob.subContractors
                ?.map((user) => user.id.toString())
                .toList() ??
            [];
      } else {
        // setting up default job rep / estimator in case of add job
        estimatorIds = getDefaultJobRep();
      }

      // setting up rep / estimator
      jobRepEstimatorList = await FormsDBHelper.getAllUsers(estimatorIds,
          withSubContractorPrime: false);

      // setting up tagList
      tagList = await FormsDBHelper.getAllTags();

      // setting up company crews
      companyCrewList = await FormsDBHelper.getAllUsers(crewIds,
          withSubContractorPrime: false);

      // setting up labor sub
      laborSubList = await FormsDBHelper.getAllUsers(laborSubIds,
          onlySub: true, useCompanyName: true);

      // setting up flags
      allFlags = await FormsDBHelper.getAllFlags(selectedFlagIds, forJob: true);

      // setting up divisions
      jobDivisionList = await FormsDBHelper.getAllDivisions(
          forUser: false, includeNone: true);

      // setting up canvassers user
      canvasserList = await FormsDBHelper.getUsersToSingleSelect(
        [],
        withSubContractorPrime: false,
        includeOtherOption: true,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// selectors to select form data (users, jobs etc) --------------------------

  void selectHover() {
    showJPBottomSheet(
      child: (_) => HoverOrderForm(
        params: HoverOrderFormParams(
            jobId: job?.id,
            hoverUser: job?.hoverJob?.hoverUser,
            customer: job?.customer ?? customer,
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

  void selectFlags() {
    FormValueSelectorService.openMultiSelect(
        title: "select_flags".tr,
        list: allFlags,
        onSelectionDone: () {
          update();
        });
  }

  String? phonesToJsonString(List<PhoneModel>? phones) =>
      phones?.map((phone) => phone.toJson()).toString();
  String? emailsToJsonString(List<EmailModel>? emails) =>
      emails?.map((email) => email.toJson()).toString();

  int existContactPersonIndex(CompanyContactListingModel contactModel) {
    return contactPersons
        .indexWhere((CompanyContactListingModel contactPerson) {
      return contactPerson.firstName == contactModel.firstName &&
          contactPerson.lastName == contactModel.lastName &&
          contactPerson.companyName == contactModel.companyName &&
          phonesToJsonString(contactPerson.phones) ==
              phonesToJsonString(contactModel.phones) &&
          emailsToJsonString(contactPerson.emails) ==
              emailsToJsonString(contactModel.emails) &&
          contactPerson.address?.address == contactModel.address?.address &&
          contactPerson.address?.addressLine1 ==
              contactModel.address?.addressLine1 &&
          contactPerson.address?.zip == contactModel.address?.zip;
    });
  }

  void onAddEditContactPerson({int? index}) async {
    final result = await Get.toNamed(Routes.createCompanyContact, arguments: {
      NavigationParams.pageType: index != null
          ? CompanyContactFormType.jobContactPersonEditForm
          : CompanyContactFormType.jobContactPersonCreateForm,
      if (index != null) NavigationParams.dataModel: contactPersons[index],
    });
    if (result != null && result is Map<String, dynamic>) {
      final contactModel =
          CompanyContactListingModel.fromJobFormContactJson(result);

      if (contactModel.isPrimary) {
        /// if set as primary is true then other contact person primary will be false
        for (CompanyContactListingModel contactPerson in contactPersons) {
          contactPerson.isPrimary = false;
        }
      }

      if (contactPersons.isEmpty) {
        /// if contact person is empty then default will be set as primary is true
        contactModel.isPrimary = true;
      } else if (!contactModel.isPrimary &&
          index != null &&
          contactPersons[index].isPrimary) {
        /// if current contact person primary was true then it changes to false so default first contact person set as true
        if (index == 0) {
          contactModel.isPrimary = true;
        } else {
          contactPersons.first.isPrimary = true;
        }
      }

      int existingIndex = existContactPersonIndex(contactModel);

      if (existingIndex == -1 && index == null) {
        /// contact person is not exist in contactPersons
        isContactPersonSameAsCustomer = false;
        contactPersons.add(contactModel);
      } else if (existingIndex != -1 &&
          index != null &&
          existingIndex != index) {
        /// if contact person is already exist in contactPersons then it will replace with existing and removed current contact person
        if (contactPersons[existingIndex].isPrimary) {
          contactModel.isPrimary = true;
        }
        contactPersons[existingIndex] = contactModel;
        onDeleteContactPerson(index: index);
      } else if (index != null) {
        contactPersons[index] = contactModel;
      }

      update();
    }
  }

  void onDeleteContactPerson({required int index}) {
    bool isPrimary = contactPersons[index].isPrimary;
    if (contactPersons[index].id != null) {
      deletedContactPersonIds.add(contactPersons[index].id!);
    }
    contactPersons.removeAt(index);
    if (isPrimary && contactPersons.isNotEmpty) {
      contactPersons.first.isPrimary = true;
    }
    if (contactPersons.isEmpty) {
      isContactPersonSameAsCustomer = true;
    }
    update();
  }

  void selectJobDivision(String name) {
    FormValueSelectorService.openSingleSelect(
      title: "${'select'.tr} $name",
      list: jobDivisionList,
      selectedItemId: selectedJobDivisionId,
      controller: jobDivisionController,
      onValueSelected: (val) async {
        await onDivisionChanged(val);
        
      },
    );
  }

  void selectJobRepEstimator(String name) {
    FormValueSelectorService.openMultiSelect(
      title: "${'select'.tr} $name",
      list: jobRepEstimatorList,
      tags: tagList,
      onSelectionDone: () {
        update();
      }
    );
  }

  void selectCompanyCrew(String name) {
    FormValueSelectorService.openMultiSelect(
        title: "${'select'.tr} $name",
        list: companyCrewList,
        tags: tagList,
        onSelectionDone: () {
          update();
        });
  }

  void selectLaborSub(String name) {
    FormValueSelectorService.openMultiSelect(
        title: "${'select'.tr} $name",
        list: laborSubList,
        onSelectionDone: () {
          update();
        });
  }

  void selectCategory(String name) {
    FormValueSelectorService.openSingleSelect(
      title: "${'select'.tr} $name",
      list: categoryList,
      selectedItemId: selectedCategoryId,
      controller: categoryController,
      onValueSelected: (val) {
        selectedCategoryId = val;
        final selectedItem =
            FormValueSelectorService.getSelectedSingleSelect(categoryList, val);
        showInsuranceClaim = selectedItem.additionalData;
        update();
      },
    );
  }

  void selectInsuranceClaim() async {
    final result =
        controller.type == JobFormType.add && insuranceDetailsJson == null;
    InsuranceModel? insuranceModel;
    if (parentJobData != null) {
      insuranceModel = result ? null : parentJobData?.insuranceDetails;
    } else {
      insuranceModel = result ? null : job?.insuranceDetails;
    }

    // Setting up insurance details from, Insurance Details Json in case of add Job
    if (Helper.isValueNullOrEmpty(insuranceModel)) {
      insuranceModel = InsuranceModel.fromJson(insuranceDetailsJson ?? {});
    }

    final insuranceDetails = await Get.toNamed(
      Routes.insuranceDetailsForm,
      arguments: {
        NavigationParams.insuranceDetails: insuranceModel,
      },
    );
    if (insuranceDetails != null && insuranceDetails is InsuranceModel) {
      insuranceDetailsJson = insuranceDetails.toJson();
      parentJobData?.insuranceDetails = insuranceDetails;
      job?.insuranceDetails = insuranceDetails;
    }
  }

  void selectTradeScript() {
    Get.toNamed(Routes.snippetsListing, preventDuplicates: false, arguments: {
      NavigationParams.type: STArg.tradeScript,
      NavigationParams.pageType: STArgType.copyDescription,
    })?.then((value) {
      if (value?.toString().isNotEmpty ?? false) {
        String previousText = jobDescriptionController.text;
        String newAddedText = previousText.isNotEmpty ? "\n$value" : value;
        jobDescriptionController.text = previousText + newAddedText;
      }
      validateForm();
    });
  }

  /// helpers ------------------------------------------------------------------

  Future<void> onDivisionChanged(String divisionId) async {
    showJPLoader();

    // updating division selection
    selectedJobDivisionId = divisionId;
    final selectedItem = FormValueSelectorService.getSelectedSingleSelect(
        jobDivisionList, divisionId);
    selectedJobDivisionCode = selectedItem.additionalData;

    final divisionIds = [int.tryParse(divisionId)];

    // Updating rep estimator as per division Id
    List<String> tempSelectedJobRepEstimator =
        FormValueSelectorService.getSelectedMultiSelectIds(
            selectedJobRepEstimators);
    jobRepEstimatorList = await FormsDBHelper.getAllUsers(
      tempSelectedJobRepEstimator,
      withSubContractorPrime: false,
      divisionIds: divisionIds,
    );

    // Updating company crew as per division id
    List<String> tempSelectedCompanyCrew =
        FormValueSelectorService.getSelectedMultiSelectIds(
            selectedCompanyCrews);
    companyCrewList = await FormsDBHelper.getAllUsers(tempSelectedCompanyCrew,
        withSubContractorPrime: false, divisionIds: divisionIds);
     
    // Updating custom fields as per division id
    customFormFields.where((element) => element.isUserField).forEach((element) async {
      List<String>? selectedUsersId = FormValueSelectorService.getSelectedMultiSelectValues(element.usersList ?? []).map((e) => e.id.toString()).toList();
      element.usersList = await FormsDBHelper.getAllUsers(selectedUsersId, withSubContractorPrime: true, divisionIds: divisionIds);
    });
    Get.back();
    await Future.delayed(const Duration(milliseconds: 500), (){
      update();
    });
  }

  Future<void> changeFormType(dynamic val) async {
    isMultiProject = val;
    Helper.hideKeyboard();
    if (!Get.testMode) updateFields(true);

    // additional delay for ui to get updated
    await Future<void>.delayed(const Duration(milliseconds: 100));
    onDataChange("");
  }

  /// form validators ----------------------------------------------------------

  bool validateJobDescription(InputFieldParams field) {
    bool validationFailed = false;
    if (field.isRequired) {
      validationFailed = FormValidator.requiredFieldValidator(
            jobDescriptionController.text,
          ) !=
          null;
      if (field.scrollOnValidate) jobDescriptionController.scrollAndFocus();
    }
    return validationFailed;
  }

  bool validateTradeWorkTypes(InputFieldParams field) {
    bool validationFailed = false;
    if (field.isRequired) {
      validationFailed = tradeWorkTypeFormKey.currentState
              ?.validate(scrollOnValidate: field.scrollOnValidate) ??
          false;
    }
    return validationFailed;
  }

  bool validateCustomFields(InputFieldParams field) {
    bool validationFailed = false;
    validationFailed = customFieldsFormKey.currentState
            ?.validate(scrollOnValidate: field.scrollOnValidate) ??
        false;
    return validationFailed;
  }

  bool validateCanvasserNote(InputFieldParams field) {
    bool validationFailed = false;
    if(canvasserId == CommonConstants.otherOptionId) {
      validationFailed = FormValidator.requiredFieldValidator(otherCanvasserController.text) != null;
      if (validationFailed) otherCanvasserController.scrollAndFocus();
    }
    return validationFailed;
  }

  bool validateJobRepEstimator(InputFieldParams field) {
    bool validationFailed = false;
    if(field.isRequired) {
      validationFailed = selectedJobRepEstimators.isEmpty;
      if (validationFailed) jobRepEstimatorController.scrollAndFocus();
    }
    return validationFailed;
  }

  bool validateProjectFields(InputFieldParams field) {
    bool validationFailed = false;
    validationFailed = projectFormKey.currentState
            ?.validate(scrollOnValidate: field.scrollOnValidate) ??
        false;
    return !validationFailed;
  }

  /// toggles to update form (checkboxes, radio-buttons, etc.) -----------------

  void toggleLoading(bool val) {
    isLoading = val;
    update();
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

  void toggleContactSameAsCustomer(bool val) {
    if (val && contactPersons.isEmpty) {
      onAddEditContactPerson();
    } else if (!val && contactPersons.isNotEmpty) {
      showRemoveContactPersonsConfirmationSheet();
    }
    update();
  }

  void showRemoveContactPersonsConfirmationSheet() {
    showJPBottomSheet(child: (_) {
      return JPConfirmationDialog(
        icon: Icons.report_problem_outlined,
        title: 'confirmation'.tr,
        subTitle: "remove_contact_persons_confirmation_desc".tr,
        suffixBtnText: 'yes'.tr,
        onTapSuffix: () {
          removeAllContactPersons();
          Get.back();
        },
      );
    });
  }

  void removeAllContactPersons() {
    for (CompanyContactListingModel contactPerson in contactPersons) {
      if (contactPerson.id != null) {
        deletedContactPersonIds.add(contactPerson.id!);
      }
    }
    contactPersons = [];
    isContactPersonSameAsCustomer = true;
    update();
  }

  /// [saveForm] helps in saving form
  Future<void> saveForm() async {

    try {
      projectFormKey.currentState?.data();

      final params = jobFormJson();
      if (formType == JobFormType.edit) {
        final JobModel response;
        if (job?.isProject ?? false) {
          response = await JobRepository.updateJob(parentJobData!.id, params);
        } else {
          response = await JobRepository.updateJob(job!.id, params);
        }

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

  void onFormSaved(JobModel? responseJob) async {
    if (responseJob == null) return;

    if (formType == JobFormType.add) {
      Helper.showToastMessage("job_saved".tr);
      Get.back();
    } else {
      Helper.showToastMessage("job_updated".tr);
      if (!forEditInsurance) Get.back();
      Get.back();
    }

    await handleStageUpdate();

    Get.toNamed(Routes.jobSummary, preventDuplicates: false, arguments: {
      NavigationParams.jobId: responseJob.id,
      NavigationParams.customerId: responseJob.customerId,
      NavigationParams.showSaleAutomationScreen: formType == JobFormType.add,
    });
  }

  /// [showUpdateFieldConfirmation] displays confirmation dialog to take new changes
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

  void showDivisionFailedDialog(
      List<JPMultiSelectModel> userFromAnotherDivision) {
    showJPGeneralDialog(
      child: (_) => DivisionUnMatchAlert(
        jobs: [job!],
        type: DivisionUnMatchType.job,
        usersFromAnotherDivision: userFromAnotherDivision,
      ),
    );
  }

  /// [focusField] helps in focusing field (eg. referral note etc.)
  Future<void> focusField(JPInputBoxController controller) async {
    // additional detail for ui to get updated
    await Future<void>.delayed(const Duration(milliseconds: 500));
    controller.scrollAndFocus();
  }

  /// [validateUserDivision] helps in validating whether all users belong to same division
  bool validateUserDivision() {
    if (job?.division?.id == null) return true;

    List<JPMultiSelectModel> usersFromAnotherDivision =
        FormValidator.validateAllUsersBelongToSameDivision(
      selectedUsers: [...selectedJobRepEstimators, ...selectedCompanyCrews],
      currentDivisionId: job?.division?.id,
    );

    if (usersFromAnotherDivision.isEmpty) {
      return true;
    } else {
      showDivisionFailedDialog(usersFromAnotherDivision);
      return false;
    }
  }

  /// [validateAllFields] validates all fields in a sequence manner
  Future<bool> validateAllFields() async {
    bool validationFailed = false;
    bool scrollOnValidate = false;
    FormSectionModel? errorSection;
    InputFieldParams? errorField;
    dynamic Function(InputFieldParams)? scrollAndFocus;

    validateForm(); // helps in displaying field error
    for (InputFieldParams field in allFields) {
      field.scrollOnValidate = scrollOnValidate;
      // validating individual fields
      final isNotValid = validators[field.key]?.call(field) ?? false;

      // This condition helps in only tracking details of very first failed section/field
      // Loop will validate all the fields but focus will be on error field only
      if (isNotValid && !validationFailed) {
        // setting up error field details
        scrollAndFocus ??= validators[field.key];
        validationFailed = isNotValid;
        scrollOnValidate = false;
        errorSection ??= allSections
            .firstWhereOrNull((section) => section.fields.contains(field));
        errorField ??= field;
      }
    }

    if (validationFailed && errorSection != null) {
      // helps in expanding section if not expanded
      await expandErrorSection(errorSection);
      errorField?.scrollOnValidate = true;
      scrollAndFocus?.call(errorField!);
    }

    return validationFailed;
  }

  /// [expandErrorSection] expands section of which field has error
  Future<void> expandErrorSection(FormSectionModel? section) async {
    // expanding section only if it's nt expanded before
    if (section == null || section.isExpanded || !section.wrapInExpansion) {
      return;
    }

    section.isExpanded = true;
    update();

    // additional delay for section to get expanded
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  bool canEditLeadNumber() {
    final val = CompanySettingsService.companySettings[CompanySettingConstants.updateJobInfo]?['value']?['lead_number'];
    return Helper.isTrue(val);
  }

  bool canEditJobNumber() {
    final val = CompanySettingsService.companySettings[CompanySettingConstants.updateJobInfo]?['value']?['alt_id'];
    return Helper.isTrue(val);
  }

  void selectCanvasser(String name) {
    FormValueSelectorService.openSingleSelect(
      title: "${'select'.tr} $name",
      selectedItemId: canvasserId,
      list: canvasserList,
      controller: canvasserController,
      onValueSelected: (val) {
        canvasserId = val;
        update();
        if(val == CommonConstants.otherOptionId) focusField(otherCanvasserController);
      },
    );
  }


  /// Manages workflow stage updates when job division is changed during form editing
  /// This method handles the workflow implications of division changes within the job form context
  ///
  /// Business Logic:
  /// - Only triggered when editing existing jobs with actual division changes
  /// - Follows the same workflow update process as the job detail screen
  /// - Integrates with the form submission process to ensure consistency
  /// - Stores the updated stage code for later processing after form save
  ///
  /// Returns true if workflow stage update was successful or not needed, false on failure
  Future<bool> confirmAndSetUpdatedStage() async {
    // Feature flag check: only proceed with workflow updates if feature is enabled
    if (!LDService.hasFeatureEnabled(LDFlagKeyConstants.divisionBasedMultiWorkflows)) {
      return true;
    }

    // Check if workflow confirmation is needed based on form state and division change
    if (!doShowWorkflowSwitchConfirmation()) return true;
    
    try {
      // Reset any previous stage code to ensure clean state
      updatedStageCode = null;
      
      // Step 1: Get user confirmation about workflow implications
      // This matches the confirmation process used in job detail screen
      bool doUpdateDivisionAndWorkFlow = await WorkFlowStagesService.divisionImpactWorkflowConfirmation();
      
      // Step 2: If user confirmed, proceed with stage selection
      if (doUpdateDivisionAndWorkFlow) {
        // Set up workflow controller with the new division context
        // Uses selectedJobDivisionId from the form to configure available stages
        await WorkFlowStagesService.setUpController(jobId: job?.id ?? -1, divisionId: selectedJobDivisionId);
        
        // Present stage selection UI and capture user's choice
        // The selected stage will be applied after the form is successfully saved
        updatedStageCode = await WorkFlowStagesService.showStageSwitcher(jobId: job?.id);
      }
      
      // Return success if a stage was selected (or workflow update wasn't needed)
      return !Helper.isValueNullOrEmpty(updatedStageCode);
    } catch (e) {
      // Handle workflow update errors within form context
      Helper.showToastMessage('failed_to_update_workflow_stage'.tr);
      return false;
    }
  }

  /// Applies the workflow stage update after successful form submission
  /// This method completes the division-related workflow update process
  /// that was initiated during form editing
  ///
  /// Business Logic:
  /// - Only executed after successful form save to ensure data consistency
  /// - Only applies to job editing scenarios (not new job creation)
  /// - Only executes if a stage was previously selected during confirmAndSetUpdatedStage
  /// - Triggers the final stage transition with task completion and automation
  /// 
  Future<void> handleStageUpdate() async {
    // Feature flag check: only proceed with workflow updates if feature is enabled
    if (!LDService.hasFeatureEnabled(LDFlagKeyConstants.divisionBasedMultiWorkflows)) {
      return;
    }

    // Only process stage updates for job editing with a valid selected stage
    // This ensures workflow updates only happen when needed and after successful form save
    if (formType == JobFormType.edit && !Helper.isValueNullOrEmpty(updatedStageCode)) {
      // Execute the final workflow stage update
      // This handles incomplete tasks, automation, and controller cleanup
      await WorkFlowStagesService.handleStageUpdate(jobId: job?.id);
    }
  }
}

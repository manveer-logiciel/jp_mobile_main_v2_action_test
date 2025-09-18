import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/attach_file.dart';
import 'package:jobprogress/common/enums/templates.dart';
import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/templates/form_proposal/more_action.dart';
import 'package:jobprogress/common/models/templates/form_proposal/template.dart';
import 'package:jobprogress/common/models/templates/table/data.dart';
import 'package:jobprogress/common/repositories/job.dart';
import 'package:jobprogress/common/repositories/job_proposal.dart';
import 'package:jobprogress/common/repositories/templates.dart';
import 'package:jobprogress/common/repositories/user.dart';
import 'package:jobprogress/common/repositories/worksheet.dart';
import 'package:jobprogress/common/services/email/handle_db_elements.dart';
import 'package:jobprogress/common/services/file_attachment/quick_actions.dart';
import 'package:jobprogress/common/services/run_mode/index.dart';
import 'package:jobprogress/common/services/templates/form_proposal/index.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/constants/templates/classes.dart';
import 'package:jobprogress/core/constants/templates/functions.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/global_widgets/add_signature_dialog/index.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/template_editor/controller.dart';
import 'package:jobprogress/modules/files_listing/templates/form_proposal/widget/attachments.dart';
import 'package:jobprogress/modules/files_listing/templates/form_proposal/widget/table/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../common/enums/unsaved_resource_type.dart';
import '../../../../core/constants/sql/auto_save_duration.dart';
import '../../../../core/utils/form/db_helper.dart';
import '../../../../core/utils/form/unsaved_resources_helper/unsaved_resources_helper.dart';
import '../../../../routes/pages.dart';

class FormProposalTemplateController extends JPTemplateEditorController {

  FormProposalTemplateController();

  FormProposalTemplateController.merge({
    this.isMergeTemplate = true,
    this.jobId,
    this.type = ProposalTemplateFormType.add,
    this.dbUnsavedResourceId,
  });

  JobModel? job; // helps in storing job details to fill out db elements
  FormProposalTemplateModel? template; // holds template data

  String jobName = ""; // holds the job name

  bool isSavingForm = false; // helps in disabling user interaction while saving form
  bool isSavedOnTheGo = false; // helps in deciding whether to refresh proposal listing
  bool isMergeTemplate = false;

  FormProposalTemplateService? service;
  late FormProposalParamsModel requestParams;

  List<String> clickableElements = [
    TemplateClassConstants.jpSignature,
    TemplateClassConstants.dynamicImage,
    TemplateClassConstants.multiChoice,
    TemplateClassConstants.dropDownElement,
    TemplateClassConstants.arithmeticTableProposal,
  ]; // list of HTML classes on which click event has to be performed

  int? jobId = Get.arguments?[NavigationParams.jobId];
  int? dbUnsavedResourceId = Get.arguments?[NavigationParams.dbUnsavedResourceId];

  String? templateId = Get.arguments?[NavigationParams.templateId];

  Map<String, dynamic>? unsavedResourceJson;

  ProposalTemplateFormType type = Get.arguments?[NavigationParams.templateType] ?? ProposalTemplateFormType.add;

  String get customerName => job?.customer?.fullName ?? job?.name ?? 'template'.tr.capitalizeFirst!;

  bool get isEditForm => type == ProposalTemplateFormType.edit;

  bool get canShowAttachmentIcon => html != null && (requestParams.attachments.isNotEmpty);

  bool get hasError => !isLoading && (job == null || html == null);

  @override
  Future<void> onWebViewInitialized() async {
    super.onWebViewInitialized();
    if (isMergeTemplate) return;

    if(dbUnsavedResourceId != null) {
      await fetchUnsavedResourcesData();
    }
    initService();
    initTemplate();
  }

  @override
  void onElementTapped(int index, String className) {
    selectedIndex = index;
    selectedClassName = className;
    handleElementClick(job: job);
  }

  // [initTemplate] sets up template and it's data
  Future<void> initTemplate() async {
    try {
      showJPLoader();
      // fetching template details to show form
      if(service?.dbUnsavedResourceId == null) await fetchTemplate();
      // setting up html content
      await setHtmlContent();
      // loading job data to fill in title & db-elements
      await fetchJob();
      // filling in HTML elements
      await fillHtmlElements();
      // auto saving form data
      service?.stream = Stream.periodic(AutoSaveDuration.delay, (val) => saveDataInLocalDB()).listen((count) {});
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      update();
      Get.back();
    }
  }

  void initService({int? dbResourceId, StreamSubscription<void>? stream}) {
    requestParams = FormProposalParamsModel(
        jobId: jobId!,
        templateId: templateId,
        isEditForm: isEditForm,
        onTapSaveAs: () => onTapSave(saveAs: true)
    );
    if(dbUnsavedResourceId != null) setUnsavedAttachments();

    service = FormProposalTemplateService(requestParams, update: update, dbUnsavedResourceId: dbResourceId ?? dbUnsavedResourceId, stream : stream);
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
  Future<void> fetchTemplate({bool isProposalPage = false, bool isWorksheet = false}) async {
    try {
      final templateType = determineFetchTemplateType(isWorksheet: isWorksheet);

      Map<String, dynamic> params = requestParams.getTemplateParams(isMergeTemplate);

      switch (templateType) {
        case FetchTemplateType.proposalTemplate:
          final response = await JobProposalRepository.getProposalTemplate(
            params,
            isMergeTemplate: isMergeTemplate,
            isTemporaryTemplate: requestParams.tempTemplateId != null,
          );
          setTemplateFromProposal(response);
          break;

        case FetchTemplateType.worksheetTemplate:
          final response = await WorksheetRepository.fetchTemplate(
            params,
            isTemporaryTemplate: requestParams.tempTemplateId != null,
            isWorksheet: isWorksheet,
          );
          template = response;
          break;

        case FetchTemplateType.defaultTemplate:
          final response = await TemplatesRepository.fetchTemplate(
            params,
            isMergeTemplate: isMergeTemplate,
            isTemporaryTemplate: requestParams.tempTemplateId != null,
            isProposalPage: isProposalPage,
          );
          template = response;
          break;
      }

      html = template?.content;
    } catch (e) {
      rethrow;
    }
  }

  void setTemplateFromProposal(FilesListingModel proposal) {
    template = proposal.proposalTemplatePages?[0];
    template?.pageType = proposal.pageType;
    template?.title = proposal.name;
    template?.proposalSerialNumber = int.tryParse(proposal.proposalSerialNumber ?? "");

    requestParams.uploadedAttachments.addAll(proposal.attachments ?? []);
    requestParams.attachments.addAll(requestParams.uploadedAttachments);
  }

  // [getSignature] helps in loading user signature and returns base64 string to fill in data
  Future<String?> getSignature(int? id) async {
    if (id == null) return null;

    try {
      final params = {"user_ids[]": id};
      final response = await UserRepository.viewSignature<String>(params, rawSignature: true);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // [getAttachmentUrl] returns the Attachment Url to put inside HTML element
  Future<String> getAttachmentUrl(List<AttachmentResourceModel> attachments) async {
    try {
      showJPLoader();
      final response = await TemplatesRepository.getAttachmentUrl(attachments);
      return response.first ?? "";
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  Future<void> saveTemplateForm({
    String? title,
    bool saveAs = false,
  }) async {
    try {
      toggleIsSavingForm();

      final html = await getHtml();

      Map<String, dynamic> params = requestParams.getApiParams(
          template,
          saveAs: saveAs,
          title: title,
          content: html,
      );

      bool updateForm = isEditForm && !saveAs;

      final result = await TemplatesRepository.saveTemplate(params, updateForm: updateForm);

      if (result) {
        await deleteUnsavedResource();
        if (updateForm) {
          Helper.showToastMessage('proposal_updated'.tr);
          isSavedOnTheGo = true;
          setInitialHtml();
          // updating attachments
          requestParams.uploadedAttachments.clear();
          requestParams.uploadedAttachments.addAll(requestParams.attachments);
        } else {
          Get.back();
          Helper.showToastMessage('proposal_added'.tr);
          Get.back(result: result);
        }
      }

    } catch (e) {
      rethrow;
    } finally {
      toggleIsSavingForm();
    }
  }

  /// HTML Content Updaters -----------------------------------------------

  Future<void> setHtmlContent() async {
    await setHtml(
        pageType: template?.pageType ?? "",
        clickableElements: clickableElements
    );
  }

  Future<void> fillHtmlElements() async {
    // filling in DB elements
    await addDBElements();
    // filling in proposal counter
    setProposalCounter();
    // filling in signatures
    await fillInSignature();
    // inserting toggles in HTML
    await insertTogglesInHtml();
    // setting-up initial HTML
    await setInitialHtml();
    // setting up table calculations
    // additional delay for HTML to render properly
    Future.delayed(const Duration(seconds: 1), () => setUpTableCalculations());
  }

  // [addDBElements] reads HTML content and fills in data elements
  Future<void> addDBElements() async {
    // No need to fill DB elements in edit mode
    if (isEditForm) return;

    String functionString = EmailDbElementService.setSoucreString(
      customer: job?.customer,
      job: job,
      content: html,
      type: DbElementType.formProposal
    );
    await webViewController?.evaluateJavascript(source: functionString);
  }

  // [setProposalCounter] used to fill proposal serial number in HTML data
  void setProposalCounter() {

    if (isEditForm) return;

    executeJs(TemplateFunctionConstants.setProposalSerialNumber, args: {
      'number': template?.proposalSerialNumber ?? "",
    });
  }

  // [setUpTableCalculations] fills the table with initial calculations
  void setUpTableCalculations() {
    // No need to perform calculations in edit mode
    if (isEditForm && !isMergeTemplate) return;
    executeJs(TemplateFunctionConstants.setTableCalculations);
  }

  // [fillInSignature] fills in signature elements with corresponding signatures
  Future<void> fillInSignature() async {
    // extracting necessary id's from job data
    int? jobEstimatorId = !Helper.isValueNullOrEmpty(job?.estimators) ? job!.estimators!.first.id : null;
    int? customerRepId = job?.customer?.rep != null ? job!.customer!.rep!.id : null;

    // binding signature (base64) with class name
    Map<String, dynamic> signaturesToFillIn = {
      TemplateClassConstants.jpSignatureJobEstimator : await getSignature(jobEstimatorId),
      TemplateClassConstants.jpSignatureCustomerRep : await getSignature(customerRepId)
    };

    // removing nullable or empty data
    signaturesToFillIn.removeWhere((key, value) => Helper.isValueNullOrEmpty(value));

    // filling in HTML elements with signature data
    signaturesToFillIn.forEach((key, signature) async {
      updateSignatureElement(signature, className: key, fillAll: true);
    });
  }

  // [updateSignatureElement] updates signature HTML elements
  // [fillAll] when true, fills all signature elements with the given className on first load
  // when false, fills only a specific element at the given index
  Future<void> updateSignatureElement(String signature, {String? className, bool fillAll = false}) async {
    if (signature.isEmpty) return;

    String date = DateTimeHelper.formatDate(DateTimeHelper.now().toString(), DateFormatConstants.dateOnlyFormat);

    executeJs(TemplateFunctionConstants.fillSignature, args: {
      "index": fillAll ? null : (className == null ? selectedIndex : 0),
      "className": className ?? selectedClassName,
      "signature": signature,
      "date": date
    });
  }

  // [updateDynamicImage] updates dynamic image HTML element
  Future<void> updateDynamicImage({JobModel? job}) async {
    await FileAttachService.openQuickActions(
      type: AttachmentOptionType.dynamicImage,
      dirWithImageOnly: true,
      maxSize: CommonConstants.maxAllowedFileSize,
      companyCamProjectId: job?.meta?.companyCamId,
      onFilesSelected: (selectedAttachments) async {
        String url = await getAttachmentUrl(selectedAttachments);
        executeJs(TemplateFunctionConstants.updateDynamicImage, args: {
          'index': selectedIndex,
          'className': selectedClassName,
          'image': url
        });
      },
      jobId: jobId ?? job?.id,
      allowMultiple: false,
    );
  }


  /// HTML content readers ----------------------------------------------------

  // [getSingleSelectFromDropdown] reads HTML dropdown list and parse it to [JPSingleSelectModel]
  Future<List<JPSingleSelectModel>> getSingleSelectFromDropdown(int index) async {
    final response = await executeJs(TemplateFunctionConstants.getDropDownList, args: {
      'index': index
    });

    return decodeDropDownList(jsonDecode(response?.value ?? "{}"));
  }

  // [decodeDropDownList] is responsible for decoding JSON list to single select
  List<JPSingleSelectModel> decodeDropDownList(Map<String, dynamic>? value) {
    List<JPSingleSelectModel> list = [];

    // list of options extracted from element's attributes
    List<dynamic> options = value?['options'] ?? [];
    // any item falling with in this or below index, can't be edited
    int nonEditableItemIndex = value?['index'] ?? 0;

    for (int i = 0; i < options.length; i++) {
      list.add(JPSingleSelectModel(
          id: i.toString(),
          label: options[i].toString(),
          isEditable: i > nonEditableItemIndex));
    }

    return list;
  }

  // [getMultiSelectListFormMultiChoice] reads HTML dropdown list and parse it to [JPMultiSelectModel]
  Future<List<JPMultiSelectModel>> getMultiSelectListFormMultiChoice(int index) async {
    List<JPMultiSelectModel> list = [];

    final response = await executeJs(TemplateFunctionConstants.getMultiChoiceList, args: {
      'index': index,
    });

    response?.value?.forEach((dynamic data) {
      list.add(JPMultiSelectModel(
          id: list.length.toString(),
          label: data['name'],
          isSelect: data['checked'] ?? false));
    });

    return list;
  }

  /// Helpers -----------------------------------------------------------------

  // [handleElementClick] is responsible for handling click on HTML elements
  Future<void> handleElementClick({JobModel? job}) async {
    switch (selectedClassName) {
      case TemplateClassConstants.jpSignature:
        showSignatureDialog();
        break;

      case TemplateClassConstants.dynamicImage:
        updateDynamicImage(job: job);
        break;

      case TemplateClassConstants.multiChoice:
        showEditableMultiSelect();
        break;

      case TemplateClassConstants.dropDownElement:
        showEditableSingleSelect();
        break;

      case TemplateClassConstants.arithmeticTableProposal:
        showTableDialog(selectedIndex);
        break;
    }
  }

  // [parseSingleSelectToDropDown] convert a list of type [JPSingleSelectModel] to
  // a [String] so can be passed in HTML element's attribute
  String parseSingleSelectToDropDown(List<JPSingleSelectModel> list) {
    List<String> selectedItems = list.map((choice) => choice.label).toList();
    final encodedList = jsonEncode(selectedItems);
    return encodedList;
  }

  // [parseMultiSelectToMultiChoice] convert a list of type [JPMultiSelectModel] to
  // a [String] so can be passed in HTML element's attribute
  String parseMultiSelectToMultiChoice(List<JPMultiSelectModel> list) {
    List<Map<String, dynamic>> selectedItems = list
        .map((choice) => {
      "name": choice.label,
      "checked": choice.isSelect,
    }).toList();

    final encodedList = jsonEncode(selectedItems);
    return encodedList;
  }

  void toggleIsSavingForm() {
    isSavingForm = !isSavingForm;
    update();
  }

  /// Dialogs & Sheets --------------------------------------------------------

  // [showEditableSingleSelect] opens up editable single select to update data
  Future<void> showEditableSingleSelect() async {
    List<JPSingleSelectModel> list = await getSingleSelectFromDropdown(selectedIndex);
    // extracting selected item from HTML
    final response = await executeJs(TemplateFunctionConstants.getDropDownValue, args: {
      'index': selectedIndex
    });

    // fetching selected item's id from label
    String selectedLabel = response?.value ?? "";
    String selectedId = list.firstWhereOrNull((item) => item.label == selectedLabel)?.id ?? "";

    showJPBottomSheet(child: (_) => JPEditableSingleSelect(
      mainList: list,
      selectedItemId: selectedId,
      searchHint: 'search_here'.tr,
      title: 'select'.tr,
      onUpdate: (list, item) async {
        // updating dropdown element
        final encodedList = parseSingleSelectToDropDown(list);
        executeJs(TemplateFunctionConstants.setDropDownValue, args: {
          'index': selectedIndex,
          'label': item?.label,
          'encodedList': encodedList
        });
      },
    ),
      isScrollControlled: true,
    );
  }

  // [showEditableMultiSelect] opens up editable multiselect to update data
  Future<void> showEditableMultiSelect() async {

    List<JPMultiSelectModel> list = await getMultiSelectListFormMultiChoice(selectedIndex);

    showJPBottomSheet(
      child: (_) => JPEditableMultiSelect(
        mainList: list,
        searchHint: 'search_here'.tr,
        title: 'select'.tr,
        onUpdate: (list) async {
          final encodedList = parseMultiSelectToMultiChoice(list);
          // updating elements data
          await executeJs(TemplateFunctionConstants.updateMultiSelect, args: {
                'index': selectedIndex,
                'encodedList': encodedList,
              });
        },
      ),
      isScrollControlled: true,
    );
  }

  // [showTableDialog] loads HTML table data into editable table flutter dialog
  Future<void> showTableDialog(int index) async {
    // fetching table data from html
    // It basically reads HTML content and returns json data
    final response = await executeJs(TemplateFunctionConstants.getTableData, args: {
      'index': index,
    });

    if (response?.value != null) {
      // parsing table json to model
      TemplateFormTableModel table = TemplateFormTableModel.fromJson(jsonDecode(response?.value));
      showJPGeneralDialog(
        child: (_) => TemplateTableView(
          table: table,
          onSave: (String html) async {
            // updating TABLE HTML
            await executeJs(TemplateFunctionConstants.setTableData, args: {
              "index": selectedIndex,
              "html": html,
            });
            insertTogglesInHtml();

          },
        ),
        isDismissible: false,
      );
    }
  }

  // [showSignatureDialog] displays signature dialog to put signature in
  void showSignatureDialog() {
    showJPDialog(child: (_) {
      return AddViewSignatureDialog(
        viewOnly: false,
        onAddSignature: updateSignatureElement,
      );
    });
  }

  Future<void> showSaveDialog({String? initialValue}) async {
    service?.showSaveDialog(
      isEditForm: isEditForm,
      initialValue: initialValue,
      onTapSuffix: (val, isSaveAs) => saveTemplateForm(title: val, saveAs: isSaveAs),
    );
  }

  void showAttachmentSheet() {
    showJPBottomSheet(
        child: (_) => FormProposalAttachments(controller: this),
        isScrollControlled: true
    );
  }

  Future<void> onTapSave({bool saveAs = false}) async {
    bool isNewDataAdded = await checkIfNewDataAdded();
    isNewDataAdded = isNewDataAdded || !listEquals(requestParams.uploadedAttachments, requestParams.attachments);

    if (!isNewDataAdded && isEditForm && !saveAs) {
      Helper.showToastMessage('no_changes_made'.tr);
      return;
    }

    if (saveAs) {
      showSaveDialog(initialValue: template?.title);
    } else if (isEditForm) {
      saveTemplateForm();
    } else {
      showSaveDialog();
    }
  }

  // onWillPop(): will check if any new data is added to form and takes decisions
  //              accordingly whether to show confirmation or navigate back directly
  Future<bool> onWillPop({bool hasUnsavedChanges = false}) async {

    if (hasError) {
      Get.back();
      return true;
    }

    bool isNewDataAdded = await checkIfNewDataAdded();
    isNewDataAdded = isNewDataAdded || !listEquals(requestParams.uploadedAttachments, requestParams.attachments) || hasUnsavedChanges;

    if(isNewDataAdded || dbUnsavedResourceId != null) {
      Helper.showUnsavedChangesConfirmation(unsavedResourceId: service?.dbUnsavedResourceId);
    } else {
      Helper.hideKeyboard();
      if(dbUnsavedResourceId == null || service?.dbUnsavedResourceId != null) await deleteUnsavedResource();
      Get.back(result: isSavedOnTheGo);
    }

    await service?.stream?.cancel();

    return false;
  }

  Future<void> reloadTemplate() async {

    final html = await getHtml();

    await setHtml(
        content: html,
        pageType: template?.pageType ?? "",
        clickableElements: clickableElements
    );

    await insertTogglesInHtml();

    resetScale();
  }

  Future<void> insertTogglesInHtml() async {

    webViewController?.addJavaScriptHandler(
      handlerName: 'formatAmount',
      callback: (dynamic arguments) {
        final amount = double.tryParse(arguments[0].toString()) ?? 0.00;
        return JobFinancialHelper.getCurrencyFormattedValue(value: amount);
      },
    );

    await executeJs(TemplateFunctionConstants.setUpYesNoToggles);
  }

  // setUnsavedFromProposal(): will read unsaved form details from local DB
  void setUnsavedFromProposal(Map<String, dynamic>? response) {

    if(response?["created_through"] == "v1") {
      unsavedResourceJson = FormsDBHelper.getOldAppUnsavedResourcesJsonData(response);
    } else {
      unsavedResourceJson = FormsDBHelper.getUnsavedResourcesJsonData(response);
    }
    Map<String, dynamic> pageJson = unsavedResourceJson?["pages"]?[0] ?? unsavedResourceJson?["pages[0]"];
    templateId = unsavedResourceJson?["template_id"].toString();
    type = unsavedResourceJson?["isEditForm"] ?? false ? ProposalTemplateFormType.edit : ProposalTemplateFormType.add;
    template = FormProposalTemplateModel(
        id: pageJson["id"],
        image: pageJson["image"],
        thumb: pageJson["thumb"],
        isProposalPage: pageJson["is_proposal_page"] ?? !Helper.isTrue(pageJson["insurance_estimate"]),
        content: pageJson["template"] ?? pageJson["content"],
        tables: pageJson["tables"],
        pageType: unsavedResourceJson?["page_type"],
        title: unsavedResourceJson?["title"],
    );
    html = template?.content;
  }

  void setUnsavedAttachments() {
    requestParams.attachments = [];
    requestParams.uploadedAttachments = [];
    (unsavedResourceJson?["attachments"] as List?)?.forEach((element) =>
      requestParams.attachments.add(AttachmentResourceModel.fromJson(element)));
    (unsavedResourceJson?["delete_attachments"] as List?)?.forEach((element) =>
      requestParams.uploadedAttachments.add(AttachmentResourceModel.fromJson(element)));
    update();
  }

  Future<void> fetchUnsavedResourcesData() async {
    try {
      final response = await FormsDBHelper.getUnsavedResources(dbUnsavedResourceId);
      setUnsavedFromProposal(response);
    } catch (e) {
      rethrow;
    } finally {
      update();
    }
  }

  // saveDataInLocalDB(): will save unsaved form in local DB
  Future<void> saveDataInLocalDB() async {
    if(Get.routing.current != Routes.formProposalTemplate) return;
    final html = await getHtml();

    Map<String, dynamic> params = requestParams.getApiParams(
      template,
      saveAs: false,
      content: html,
      isForUnsavedDB: true,
    );

    params.addEntries({
      "template_id": templateId,
      "template_title": template?.title,
      "isEditForm": isEditForm,}.entries);

    UnsavedResourceType unsavedResourcesType = isMergeTemplate ? UnsavedResourceType.mergeTemplate : UnsavedResourceType.proposalForm;

    Map<String, dynamic> resource = {
      "type": UnsavedResourcesHelper.getUnsavedResourcesString(unsavedResourcesType),
      "job_id": jobId,
      "data": json.encode(params),
    };

    service?.dbUnsavedResourceId = await UnsavedResourcesHelper().insertOrUpdate(service?.dbUnsavedResourceId, resource);
    update();
  }

  // deleteUnsavedResource(): will delete unsaved form from local DB
  Future<void> deleteUnsavedResource() async {
    if(service?.dbUnsavedResourceId != null && !RunModeService.isUnitTestMode) {
      await UnsavedResourcesHelper.deleteUnsavedResource(id: service!.dbUnsavedResourceId!);
      service?.dbUnsavedResourceId = dbUnsavedResourceId = null;
      update();
    }
  }

  /// [determineFetchTemplateType] Determines the type of template to fetch based on the given parameters.
  ///
  /// Returns:
  /// - FetchTemplateType: The type of template to fetch.
  FetchTemplateType determineFetchTemplateType({bool isWorksheet = false}) {
    if (isEditForm && !isMergeTemplate) {
      if (requestParams.tempTemplateId != null) {
        // If it's an edit form and not a merge template,
        // and the tempTemplateId is not null,
        // return FetchTemplateType.worksheetTemplate.
        return FetchTemplateType.worksheetTemplate;
      } else {
        // If it's an edit form and not a merge template,
        // and the tempTemplateId is null,
        // return FetchTemplateType.proposalTemplate.
        return FetchTemplateType.proposalTemplate;
      }
    } else if (isWorksheet && requestParams.tempTemplateId == null) {
      // If it's a worksheet and the tempTemplateId is null,
      // return FetchTemplateType.worksheetTemplate.
      return FetchTemplateType.worksheetTemplate;
    } else {
      // Otherwise, return FetchTemplateType.defaultTemplate.
      return FetchTemplateType.defaultTemplate;
    }
  }

  @override
  Future<void> dispose() async {
    await service?.stream?.cancel();
    super.dispose();
  }

}

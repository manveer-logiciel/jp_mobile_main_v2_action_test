import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/attach_file.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/enums/templates.dart';
import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/templates/form_proposal/template.dart';
import 'package:jobprogress/common/models/worksheet/worksheet_model.dart';
import 'package:jobprogress/common/repositories/job_financial.dart';
import 'package:jobprogress/common/repositories/job_proposal.dart';
import 'package:jobprogress/common/repositories/templates.dart';
import 'package:jobprogress/common/repositories/worksheet.dart';
import 'package:jobprogress/common/services/forms/value_selector.dart';
import 'package:jobprogress/common/services/run_mode/index.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/file_uploder.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/constants/templates.dart';
import 'package:jobprogress/core/constants/templates/functions.dart';
import 'package:jobprogress/core/constants/templates/html.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/modules/files_listing/page.dart';
import 'package:jobprogress/modules/files_listing/templates/form_proposal/controller.dart';
import 'package:jobprogress/modules/files_listing/templates/merge/widget/manage_pages/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../../common/enums/unsaved_resource_type.dart';
import '../../../../core/constants/sql/auto_save_duration.dart';
import '../../../../core/utils/form/db_helper.dart';
import '../../../../core/utils/form/unsaved_resources_helper/unsaved_resources_helper.dart';
import '../../../../routes/pages.dart';
import 'widget/unvisit_dialog/index.dart';

/// [FormProposalMergeTemplateController] is a wrapper over [FormProposalTemplateController] which extends
/// it's functionality to handle multiple pages
class FormProposalMergeTemplateController extends FormProposalTemplateController {

  // initializing constructor with values
  FormProposalMergeTemplateController() : super.merge(
    isMergeTemplate: true,
    jobId: Get.arguments?[NavigationParams.jobId],
    type: Get.arguments?[NavigationParams.proposalType] ?? ProposalTemplateFormType.add,
    dbUnsavedResourceId: Get.arguments?[NavigationParams.dbUnsavedResourceId],
  );

  int selectedPageIndex = 0; // stores the index of selected page
  int? proposalId = Get.arguments?[NavigationParams.id]; // used to load proposal details in case of edit

  String? selectedTemplateTitle; // used to hold template title
  String? selectedPageType; // holds page-type which is common for all the pages

  bool changesMade = false; // used to track whether changes made in any of the page

  WorksheetModel? workSheet;

  List<FormProposalTemplateModel> pages = []; // hold all the template pages
  Map<String, List<FormProposalTemplateModel>> groupPages = {}; // hold all the group pages
  List<FilesListingModel> files = Get.arguments?[NavigationParams.list] ?? []; // holds selected files that will be parsed to get pages
  int? worksheetId = Get.arguments?[NavigationParams.worksheetId]; // used to load proposal details in case of edit
  bool worksheetPagesExists = Get.arguments?[NavigationParams.worksheetPagesExist] ?? false; // helps in differentiating api calls for worksheet

  bool get disableNextButton => pages.isEmpty || selectedPageIndex == pages.length - 1; // decides disabling of next button
  bool get disablePrevButton => pages.isEmpty || selectedPageIndex == 0; // decides disabling of previous button
  bool get isWorksheetTemplate => worksheetId != null;
  bool get skipLoadProposal => proposalId == null && worksheetId == null;

  @override
  void onInit() async {
    await setupUnsavedResources();
    // Initializing requestParams service to get request params
    initService();
    // Initial delay to avoid animation lags
    Future.delayed(const Duration(milliseconds: 500), setUpPages);
    super.onInit();
  }

  /// Network Calls -----------------------------------------------------------

  /// [setUpPages] - will load pages according to the type of form and sets up initial HTML
  Future<void> setUpPages() async {
    try {
      showJPLoader();
      // In case of edit form loading proposal to get proposal pages
      if (isEditForm) await loadProposal();
      // In case of add filtering group id's and fetching template pages
      if (!isEditForm) await getTemplatesByGroups();

      // setting up pages from proposal file / files without group
      await setPagesFromProposalFile();
      // loading selected page's content
      await fetchSelectedPage();
      // setting up html content and binding listeners
      await setHtmlContent();
      // fetching job details
      await fetchJob();
      // filling in HTML elements
      await fillHtmlElements();
      // auto saving form data
      service?.stream = Stream.periodic(AutoSaveDuration.delay, (val) => saveDataMergeTemplateInLocalDB()).listen((count) {});
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      update();
      Get.back();
    }
  }

  /// [loadProposal] - loads proposal data in case of edit
  Future<void> loadProposal() async {
    // No need to load if proposal id is null
    if (skipLoadProposal) return;

    try {
      Map<String, dynamic> params = requestParams.proposalPagesParams(
          proposalId: proposalId,
          worksheetId: worksheetId,
          worksheetPagesExist: worksheetPagesExists
      );

      if (isWorksheetTemplate) {
        final response = await JobProposalRepository.getWorksheetTemplate(params, companyTemplates: !worksheetPagesExists);

        // adding loaded proposal file to files, which will be parsed by [setPagesFromProposalFile]
        // to extract templates from proposal file
        files.add(response);
        // setting up page type in case it's null
        selectedPageType ??= response.pageType;
      } else {
        final response = await JobProposalRepository.getProposalTemplate(params);
        // adding loaded proposal file to files, which will be parsed by [setPagesFromProposalFile]
        // to extract templates from proposal file
        files.add(response);
        // setting up page type in case it's null
        selectedPageType ??= response.pageType;
      }
    } catch (e) {
      rethrow;
    }
  }

  /// [getGroupIdsFromFiles] helps in extracting group ids from files
  List<String?> getGroupIdsFromFiles() {
    return files.where((file) => file.groupId != null).map((template) => template.groupId).toList();
  }

  /// [addProposalTemplatePagesToFile] finds the file from the list of selected files
  /// and add proposal template pages to the grouped file
  void addProposalTemplatePagesToFile(List<FilesListingModel> tempTemplates) {
    for (FilesListingModel tempTemplate in tempTemplates) {
      final index = files.indexWhere((file) => file.groupId == tempTemplate.groupId);
      if (index >= 0) {
        files[index].proposalTemplatePages ??= [];
        files[index].proposalTemplatePages?.addAll(tempTemplate.proposalTemplatePages ?? []);
      }
    }
  }

  /// [getTemplatesByGroups] - loads templates pages from group id
  Future<void> getTemplatesByGroups() async {
    // extracting group ids from selected files
    final groups = getGroupIdsFromFiles();
    // No need to proceed further if there are no grouped files
    if (Helper.isValueNullOrEmpty(groups)) return;

    try {
      Map<String, dynamic> params = requestParams.templateByGroup(groups);
      final tempTemplates = await TemplatesRepository.getTemplatesByGroups(params);
      // filling in pages
      addProposalTemplatePagesToFile(tempTemplates);
    } catch (e) {
      rethrow;
    }
  }

  /// [fetchSelectedPage] - is responsible for loading selected individual page's data
  Future<void> fetchSelectedPage() async {

    if (pages.isEmpty) return;

    try {
      FormProposalTemplateModel selectedTemplate = pages[selectedPageIndex];

      selectedTemplateTitle = selectedTemplate.title;
      selectedPageType ??= selectedTemplate.pageType;

      // in case of selling price sheet manually filling in HTML
      if (selectedTemplate.isEmptySellingPriceSheet) {
        selectedTemplate.content = TemplateFormHtmlConstants.getSellingPriceSheet(job, workSheet);
        html = selectedTemplate.content;
        selectedTemplate.isVisitRequired = false;
        return;
      }

      // in case of image sheet from unsaved resources manually filling in HTML
      if (selectedTemplate.id != null && dbUnsavedResourceId != null && (selectedTemplate.content?.isNotEmpty ?? false)) {
        html = selectedTemplate.content;
        selectedTemplate.isVisitRequired = false;
        return;
      }

      // setting up values to request params
      templateId = selectedTemplate.id.toString();
      // setting up service for updated request params
      initService(dbResourceId : service?.dbUnsavedResourceId, stream: service?.stream);
      // If page is temporarily saved then loading temporarily saved template
      requestParams.tempTemplateId = selectedTemplate.tempSaveId;
      bool isProposalPage = selectedTemplate.isProposalPage && isEditForm;
      bool isWorksheetPage = worksheetPagesExists && isEditForm;
      // avoiding api call in unit testing
      if (!RunModeService.isUnitTestMode) {
        await fetchTemplate(isProposalPage: isProposalPage, isWorksheet: isWorksheetPage);
      }
      // Once a template is visited, no further visit is required
      selectedTemplate.isVisitRequired = false;
    } catch (e) {
      rethrow;
    }
  }

  /// [tempSaveTemplate] - helps in saving current page temporarily
  Future<void> tempSaveTemplate({FormProposalTemplateModel? page}) async {
    try {
      bool saveCurrentPage = page == null;
      FormProposalTemplateModel selectedTemplate = page ?? pages[selectedPageIndex];
      // updating content of selected page
      if (saveCurrentPage)  selectedTemplate.content = await getHtml();
      Map<String, dynamic> params = requestParams.getTemporarySaveParams(selectedTemplate);
      // If template is already temporarily saved then just updating it
      bool updateForm = selectedTemplate.tempSaveId != null;
      final id = await TemplatesRepository.temporarySaveMergeTemplate(params, updateForm: updateForm);
      // updating temp save id of template which will be used to update it in future
      selectedTemplate.tempSaveId = id;
      // checking if there were any changes made or not
      if (!changesMade) changesMade = await checkIfNewDataAdded();
    } catch (e) {
      rethrow;
    }
  }

  /// [saveMergeTemplate] - saves or updates the proposal template depending on
  /// the type. Here [name] is name of the file to be saved with and [showLoader]
  /// decides whether to display loader or not
  Future<void> saveMergeTemplate({String? name, bool showLoader = false}) async {
    try {
      if (showLoader) showJPLoader();
      // Saving current template temporarily
      await tempSaveTemplate();

      Map<String, dynamic> params = requestParams.getMergeTemplateSaveParams(
          selectedPageType!, pages,
          name: name,
          proposalId: proposalId,
          worksheetId: worksheetId,
          forEdit: isEditForm,
          isForWorksheet: isWorksheetTemplate
      );

      if (isWorksheetTemplate) {
        final file = await WorksheetRepository.saveTemplate(params, updateForm: isEditForm);
        await onProposalSaved(file);
      } else {
        final proposal = await TemplatesRepository.saveMergeTemplate(params, updateForm: isEditForm);
        await onProposalSaved(proposal);
      }
    } catch (e) {
      rethrow;
    } finally {
      update();
      Get.back();
    }
  }

  ///[fetchWorkSheet] - helps in loading worksheet details in case of
  /// selling price template
  Future<void> fetchWorkSheet() async {
    try {
      if (workSheet != null || job?.hasSellingPriceWorksheet == null) return;
      Map<String, dynamic> params = {
        'id': job?.hasSellingPriceWorksheet,
      };
      final response = await JobFinancialRepository.fetchWorkSheet(params);
      workSheet = response;
    } catch (e) {
      rethrow;
    }
  }

  /// [deleteImage] - helps in removing image from server here [url] is
  /// the url of uploaded image
  Future<bool> deleteImage(String url) async {
    try {
      showJPLoader();
      Map<String, dynamic> params = {
        "url": url
      };
      final result = await TemplatesRepository.deleteImage(params);
      return result;
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  /// Helpers -----------------------------------------------------------------

  /// [setPagesFromProposalFile]
  /// Case Add: Will read [files] which are without group and will extract template pages from them
  /// Case Edit: Will read proposal file and will extract proposal pages from it
  Future<void> setPagesFromProposalFile() async {
    final allTempPages = files.where((file) => !Helper.isValueNullOrEmpty(file.proposalTemplatePages));
    for (FilesListingModel tempPages in allTempPages) {
      for (FormProposalTemplateModel page in (tempPages.proposalTemplatePages ?? [])) {
        switch (page.id) {
          case -1:
            await tempSaveTemplate(page: page);
            break;

          case -2:
            await fetchJob();
            await fetchWorkSheet();
            break;
        }
        page.pageType ??= tempPages.pageType;
        pages.add(page);
      }
    }
  }

  /// [nextPage] - switches to next page
  void nextPage() {
    unFocus();
    int index = selectedPageIndex + 1;
    if(dbUnsavedResourceId != null) {
      switchPage(index, tempSave: pages[index].tempSaveId == null);
    } else {
      switchPage(index);
    }
  }

  /// [prevPage] - switches to previous page
  void prevPage() {
    unFocus();
    int index = selectedPageIndex - 1;
    if(dbUnsavedResourceId != null) {
      switchPage(index, tempSave: pages[index].tempSaveId == null);
    } else {
      switchPage(index);
    }
  }

  /// [switchPage] - switches the page on the basis on [index] provided to it
  /// the second parameter [tempSave] decides whether to save current page temporarily
  /// before switching to new page. It's default value is [true]
  Future<void> switchPage(int newPageIndex, {bool tempSave = true}) async {
    if (RunModeService.isUnitTestMode) return;
    try {
      showJPLoader();
      // saving current page temporarily
      if (tempSave) await tempSaveTemplate();
      selectedPageIndex = newPageIndex;
      // fetching newly selected page
      await fetchSelectedPage();
      // resetting scale as same web-view is used to view template with different HTML
      resetScale();
      // setting up new HTML content
      await setHtmlContent();
      // filling in HTML elements
      await fillHtmlElements();
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
      update();
    }
  }

  /// [handleMoreActions] - used to handle click on more actions and performs
  /// action accordingly
  void handleMoreActions() {
    unFocus();
    FormProposalTemplateModel selectedTemplate = pages[selectedPageIndex];
    service?.handleMergeTemplateMoreActions(
      showAddImages: selectedTemplate.isImageTemplate,
      showAddPages: !isWorksheetTemplate,
      addPages: addPages,
      onTapSaveAction: onTapSaveAction,
      reloadTemplate: reloadTemplate,
      showAddImagesSheet: showAddImagesSheet,
      showManagePagesSheet: showManagePagesSheet
    );
  }

  /// [onTapSaveAction] - handles click on save action. Depending on the proposal state
  /// it performs action. In case of edit directly saves template. In case of add opens
  /// dialog and ask for name
  void onTapSaveAction() {
    bool hasUnVisitPages = checkAndShowUnVisitDialog();
    if (hasUnVisitPages) return;

    if (isEditForm) {
      saveMergeTemplate(showLoader: true);
    } else {
      showSaveMergeTemplateDialog();
    }
  }

  /// [onProposalSaved] - displays toast on basis of type and do necessary variable
  /// updates
  Future<void> onProposalSaved(FilesListingModel proposal) async {
    if (isEditForm) {
      String message = isWorksheetTemplate ? 'worksheet_template_pages_saved'.tr : 'proposal_updated'.tr;
      Helper.showToastMessage(message);
    } else {
      Helper.showToastMessage('proposal_added'.tr);
      type = ProposalTemplateFormType.edit;
    }
    // delete unsaved resource
    await deleteUnsavedResource();
    // updating template ids
    updatePagesList(proposal);
    isSavedOnTheGo = true;
    // will not show confirmation dialog when all changes are saved
    changesMade = false;
    setInitialHtml();
    // updating proposal Id
    proposalId = int.tryParse(proposal.id.toString());
  }

  /// [updatePagesList] - updates pages list with proposal pages
  void updatePagesList(FilesListingModel proposal) {
    files.clear();
    pages.clear();
    files.add(proposal);
    setPagesFromProposalFile();
  }

  /// [onPagesEdited] - set new order of the pages and also remove them
  void onPagesEdited(List<FormProposalTemplateModel> tempTemplates) {

    Get.back(); // closing manage pages sheet

    final selectedTemplate = pages[selectedPageIndex];
    // updating pages
    pages.clear();
    pages.addAll(tempTemplates);
    // In case selected page is still in new list, simply updating the page index
    // Other selecting very first page of the new list and loading it
    int index = pages.indexWhere((page) => page.id == selectedTemplate.id);
    if (index >= 0) {
      selectedPageIndex = index;
    } else {
      selectedPageIndex = 0;
      // When page is removed no need to save it temporarily
      switchPage(0, tempSave: false);
    }
    changesMade = true;
    update();
  }

  /// [addPages] - select pages and updates pages list
  Future<void> addPages() async {
    dynamic response = await Get.to(() => FilesListingView(refTag: "${FLModule.mergeTemplate}${job?.id}-add-pages"), arguments: {
      'type': FLModule.mergeTemplate,
      'job': job,
      'proposalPageType': selectedPageType,
    }, preventDuplicates: false);

    if (response != null && response is List<FilesListingModel>) {
      try {
        showJPLoader();
        // adding new data to selected files
        files.clear();
        files.addAll(response);
        // loading pages from groups
        await getTemplatesByGroups();
        // setting up pages from files
        setPagesFromProposalFile();
      } catch (e) {
        rethrow;
      } finally {
        changesMade = true;
        update();
        Get.back();
      }
    }
  }

  /// [appendImage] - appends image in IMAGE template
  Future<void> appendImage(AttachmentResourceModel attachment) async {

    String height = selectedPageType == TemplateConstants.a4page ? "353px" : "456px";

    String crossIcon = TemplateFormHtmlConstants.crossIcon;
    String container = TemplateFormHtmlConstants
        .imageContainer(height, service?.getImageTitle(attachment.moduleType, job) ?? '', attachment.url!);
    String textArea = TemplateFormHtmlConstants.imageNote;

    await executeJs(TemplateFunctionConstants.appendImage, args: {
      "crossIcon": crossIcon,
      "container": container,
      "textArea": textArea,
    });
  }

  /// [bindDeleteListener] - binds delete listener on the appended image in HTML
  Future<void> bindDeleteListener() async {
    webViewController?.addJavaScriptHandler(
      handlerName: 'deleteImage',
      callback: (dynamic arguments) async {
        String url = arguments[0];
        return await deleteImage(url);
      },
    );

    await executeJs(TemplateFunctionConstants.bindImageRemoveListener);
  }

  /// Dialogs & Sheets --------------------------------------------------------

  /// [showSwitchTemplateSingleSelect] - opens up pages single-select to switch page
  void showSwitchTemplateSingleSelect() {
    unFocus();
    // converting pages to single-select list
    List<JPSingleSelectModel> list = pages.map((template) => template.toSingleSelect()).toList();
    String selectedItemId = pages[selectedPageIndex].uniqueId.toString();

    FormValueSelectorService.openSingleSelect(
        list: list,
        title: 'select_page'.tr,
        selectedItemId: selectedItemId,
        onValueSelected: (val) async {
          // additional delay for single select sheet to close before showing loader
          await Future<void>.delayed(const Duration(milliseconds: 200));
          int index = list.indexWhere((page) => page.id == val);
          // switching page
          if (index >= 0) switchPage(index);
        },
    );
  }

  /// [showSaveMergeTemplateDialog] - displays name pop-up and asks for proposal name
  /// to be saved with
  Future<void> showSaveMergeTemplateDialog({String? initialValue}) async {
    service?.showSaveDialog(
      isEditForm: isEditForm,
      initialValue: initialValue,
      onTapSuffix: (name, _) => saveMergeTemplate(name: name),
    );
  }

  /// [checkAndShowUnVisitDialog] - verifies if there is any unvisited page and
  /// displays dialog accordingly
  bool checkAndShowUnVisitDialog() {
    // filtering unvisited pages
    List<FormProposalTemplateModel> unVisitedTemplates = pages
        .where((template) => template.isVisitRequired ?? false).toList();

    if (unVisitedTemplates.isEmpty) return false;

    showJPDialog(
        child: (_) => MergeTemplateUnVisitDialog(
          unVisitedTemplates: unVisitedTemplates,
          onTap: (String id) {
            Get.back();
            int index = pages.indexWhere((page) => page.uniqueId == id);
            if (index >= 0) switchPage(index);
          },
        )
    );
    return true;
  }

  /// [showManagePagesSheet] - displays merge template bottom sheet
  void showManagePagesSheet() {
    showJPBottomSheet(
        child: (_) => MergeTemplateManagePagesView(
          pages: pages,
          hideDelete: isWorksheetTemplate,
          onDone: onPagesEdited,
        ),
        isScrollControlled: true,
    );
  }

  /// [onBackPressed] - handles back button click
  Future<bool> onBackPressed() async {
    unFocus();
    await service?.stream?.cancel();
    return super.onWillPop(hasUnsavedChanges: changesMade);
  }

  /// [showAddImagesSheet] - displays image attachment sheet
  void showAddImagesSheet() {

    List<AttachmentResourceModel> attachments = [];

    FormValueSelectorService.selectAttachments(
        type: AttachmentOptionType.imageTemplate,
        maxSize: Helper.flagBasedUploadSize(fileSize: CommonConstants.maxAllowedFileSize),
        dirWithImageOnly: true,
        uploadType: FileUploadType.template,
        attachments: attachments,
        jobId: jobId,
        companyCamProjectId: job?.meta?.companyCamId,
        onSelectionDone: () async {
          for (var image in attachments) {
            await appendImage(image);
          }
          await bindDeleteListener();
        });
  }

  @override
  Future<void> fillHtmlElements() async {
    await super.fillHtmlElements();
    bindDeleteListener();
    executeJs(TemplateFunctionConstants.reAssignContentEditable);
  }

  /// Local DB Calls -----------------------------------------------------------

  /// [setupUnsavedResources] - will load pages from local DB and sets up initial HTML
  Future<void> setupUnsavedResources() async {
    if(dbUnsavedResourceId != null) {
      await fetchJob();
      await fetchUnsavedMergeResourcesData();
    }
  }

  /// [fetchUnsavedMergeResourcesData] - read unsaved resources
  Future<void> fetchUnsavedMergeResourcesData() async {
    try {
      final response = await FormsDBHelper.getUnsavedResources(dbUnsavedResourceId);

      setUnsavedMergeFromProposal(response);
    } catch (e) {
      rethrow;
    } finally {
      update();
    }
  }

  void setUnsavedMergeFromProposal(Map<String, dynamic>? response) {
    if(response?["created_through"] == "v1") {
      unsavedResourceJson = FormsDBHelper.getOldAppUnsavedResourcesJsonData(response);
    } else {
      unsavedResourceJson = FormsDBHelper.getUnsavedResourcesJsonData(response);
    }
    templateId = unsavedResourceJson?["template_id"];
    selectedPageType = unsavedResourceJson?["page_type"];
    proposalId = unsavedResourceJson?["proposal_id"];
    type = unsavedResourceJson?["isEditForm"] ?? false ? ProposalTemplateFormType.edit : ProposalTemplateFormType.add;
    pages = [];
    for (var element in (unsavedResourceJson?["pages"] as List<dynamic>)) {
      pages.add(FormProposalTemplateModel(
          id: int.tryParse(element["id"]?.toString() ?? ""),
          type: element["type"]?.toString(),
          tempSaveId: int.tryParse(element["temp_id"]?.toString() ?? ""),
          autoFillRequired: element["auto_fill_required"].toString(),
          content: element["content"]?.toString() ?? "",
          pageType: element["page_type"]?.toString() ?? "",
          title: element["title"]?.toString() ?? "",
          tables: element["tables"] is Map ? element["tables"] : {},
          isVisitRequired: Helper.isTrue(element["is_visit_required"]),
      ));
    }
  }

  /// [saveDataMergeTemplateInLocalDB] - save unsaved resources
  Future<void> saveDataMergeTemplateInLocalDB() async {
    if(Get.routing.current != Routes.formProposalMergeTemplate || isWorksheetTemplate) return;
    try {
      if(pages[selectedPageIndex].id != null && pages[selectedPageIndex].id != -2 && service?.dbUnsavedResourceId != null) {
        pages[selectedPageIndex].content = await getHtml();
      }

      Map<String, dynamic> params = requestParams.getMergeTemplateSaveParams(
        selectedPageType!, pages,
        proposalId: proposalId,
        forEdit: isEditForm,
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
    } catch (e) {
      return;
    }
  }

  @override
  Future<void> dispose() async {
    await service?.stream?.cancel();
    super.dispose();
  }
}
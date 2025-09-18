
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/supplier_form_type.dart';
import 'package:jobprogress/common/enums/worksheet.dart';
import 'package:jobprogress/common/models/company_trades/company_trades_model.dart';
import 'package:jobprogress/common/models/financial_product/financial_product_model.dart';
import 'package:jobprogress/common/models/financial_product/financial_product_price.dart';
import 'package:jobprogress/common/models/forms/worksheet/add_item_params.dart';
import 'package:jobprogress/common/models/forms/worksheet/index.dart';
import 'package:jobprogress/common/models/forms/worksheet/supplier_form_params.dart';
import 'package:jobprogress/common/models/job/job_division.dart';
import 'package:jobprogress/common/models/job_financial/tax_model.dart';
import 'package:jobprogress/common/models/macros/index.dart';
import 'package:jobprogress/common/models/pagination_model.dart';
import 'package:jobprogress/common/models/popover_action.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/common/models/workflow/header_action_params.dart';
import 'package:jobprogress/common/models/workflow/tier_service_params.dart';
import 'package:jobprogress/common/models/worksheet/amounts.dart';
import 'package:jobprogress/common/models/worksheet/srs_product_availability_notice_status_model.dart';
import 'package:jobprogress/common/repositories/financial_product.dart';
import 'package:jobprogress/common/repositories/job.dart';
import 'package:jobprogress/common/repositories/suppliers.dart';
import 'package:jobprogress/common/repositories/worksheet.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/common/services/forms/value_selector.dart';
import 'package:jobprogress/common/services/run_mode/index.dart';
import 'package:jobprogress/common/services/worksheet/calculations.dart';
import 'package:jobprogress/common/services/worksheet/helpers.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/financial_constants.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/constants/worksheet.dart';
import 'package:jobprogress/core/utils/form/db_helper.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/controller.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/select_supplier_branch/index.dart';
import 'package:jobprogress/modules/worksheet/widgets/add_item_sheet/index.dart';
import 'package:jobprogress/modules/worksheet/widgets/settings/widgets/percent_amount_dialog/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../../../core/constants/launchdarkly/flag_keys.dart';
import '../../../../../modules/worksheet/widgets/pricing_availability_notice/index.dart';
import '../../../../../modules/worksheet/widgets/product_availability_notice/index.dart';
import '../../../../../routes/pages.dart';
import '../../../../../core/constants/sql/auto_save_duration.dart';
import '../../../../../core/utils/form/unsaved_resources_helper/unsaved_resources_helper.dart';
import '../../../../models/suppliers/beacon/default_branch_model.dart';
import '../../../../models/files_listing/files_listing_model.dart';
import '../../../../models/financial_product/variants_model.dart';
import '../../../../models/sql/user/user.dart';
import '../../../../repositories/company_settings.dart';
import '../../../launch_darkly/index.dart';
import 'more_actions.dart';
import 'tier_quick_actions.dart';

/// [WorksheetFormService] helps in adding, updating and manipulating the
/// worksheets data along with loading sheet details from server
class WorksheetFormService extends WorksheetFormData {

  WorksheetFormService({
    super.jobId,
    super.worksheetId,
    super.flModule,
    super.hidePriceDialog,
    super.dbUnsavedResourceId,
    required this.update,
    required super.worksheetType,
    required super.formType,
    super.removeIntegratedSupplierItems,
    super.materialSupplierFormParams,
    this.resetDbUnsavedResourceId,
    super.showVariationConfirmationValidation
  });

  VoidCallback update; // helps in updating Ui from service

  VoidCallback? resetDbUnsavedResourceId; // helps in resetting dbUnsavedResourceId

  // initForm(): initializes form data
  Future<void> initForm() async {
    try {
      // loading type of resource form
      setUnsavedResourceType();

      await checkIfUnsavedRecordExists();

      isDBResourceIdFromController = dbUnsavedResourceId != null;

      await Future.wait([
        // loading job details from server
        fetchJobDetail(),
        // loading tiers to select tier name
        fetchTiers(),
        // loading categories to select item types
        fetchCategories(),
        // loading list of suppliers to available for selection
        fetchCompanySuppliers(),
        // loading data from local DB
        getLocalDBData(),
        // fetching company worksheet templates
        fetchWorksheetPages(),
        // loading tax rates that will be applied by default
        fetchTaxDetailList(),
        // fetching worksheet details in case of edit
        if(isUnsavedForm && worksheetId == null) ...{
          fetchUnsavedResourcesData()
        } else ...{
          if (isEditForm) fetchWorksheet()
        },
      ]);

      if(isUnsavedForm && worksheetId == null) {
        setWorksheetFormData();// filling form data
      } else {
        // loading worksheet settings from company settings
        getWorksheetSettings();
      }
      // initialising form with data
      setFormData();
      // adding settings to line items in case of edit
      bindSettingsWithItems();
      // loading default tax & overhead details
      setAmountRates();

      if (isEditForm || isUnsavedForm) {
        // calculating amounts
        calculateSummary();
        // setting tier prices
        updateAllTiersPrice();
        // checking for any tier with warning
        checkAnyTierWithWarning();
      } else {
        // setting up worksheet settings
        updateSettings([]);
      }
      // auto saving form data
      autoSaveFormData();
    } catch (e) {
      rethrow;
    } finally {
      // setting initial json form comparison
      setInitialJson();
      isLoading = false;
      update();
      // update all SRS product details & prices
      if (isEditForm || isUnsavedForm) updateSupplierProductDetails(showLoader: true, isSetInitialData: true, showUnavailable: true);
    }

  }

  /// Network calls -----------------------------------------------------------

  Map<String, dynamic> typeToIncludes() {
    switch (worksheetType) {
      case WorksheetConstants.estimate:
        return {
          "includes[13]": "job_estimate.created_by",
          "includes[14]": "job_estimate.my_favourite_entity",
          "includes[15]": "job_estimate.linked_measurement",
        };

      case WorksheetConstants.materialList:
        return {
          "includes[13]": "material_list.created_by",
          "includes[14]": "material_list.my_favourite_entity",
          "includes[15]": "material_list.linked_measurement",
        };

      case WorksheetConstants.proposal:
        return {
          "includes[13]": "job_proposal.created_by",
          "includes[14]": "job_proposal.my_favourite_entity",
          "includes[15]": "job_proposal.linked_measurement",
        };

      case WorksheetConstants.workOrder:
        return {
          "includes[13]": "work_order.created_by",
          "includes[14]": "work_order.my_favourite_entity",
          "includes[15]": "work_order.linked_measurement",
        };

      default:
        return {};
    }
  }

  Future<void> fetchWorksheetPages() async {
    // fetching templates only in case of proposal worksheet
    if (worksheetType != WorksheetConstants.proposal) return;
    try {
      companyTemplates = await WorksheetRepository.getCompanyWorksheetTemplates();
    } catch(e) {
      rethrow;
    }
  }

  /// [fetchWorksheet] loads worksheet in case of edit from server
  ///
  /// Params:
  /// [id] - The ID of the worksheet to fetch. If not provided, `worksheetId` is used.
  /// [division] - The division model to set for the worksheet.
  Future<void> fetchWorksheet({String? id, DivisionModel? division}) async {

    if (worksheetId == null && id == null) return;

    try {
      Map<String, dynamic> params = {
        "id": id ?? worksheetId,
        "includes[0]": "suppliers",
        "includes[1]": "custom_tax",
        "includes[2]": "material_custom_tax",
        "includes[3]": "labor_custom_tax",
        "includes[4]": "attachments",
        "includes[5]": "srs_ship_to_address",
        "includes[6]": "branch",
        "includes[7]": "division",
        "includes[8]": "qbd_queue_status",
        "includes[9]": "beacon_account",
        "includes[10]": "beacon_job",
        "includes[11]": "variants",
        "includes[12]": "material_list.delivery_date",
        ...typeToIncludes(),
        if(LDService.hasFeatureEnabled(LDFlagKeyConstants.abcMaterialIntegration))
          "includes[16]": "supplier_account",
      };

      final result = await WorksheetRepository.getWorksheet(params);
      workSheet = result.worksheet;
      deliveryDate = workSheet?.file?.deliveryDateModel?.deliveryDate;
      // Overriding the worksheet division if it is available
      // Use Case: While selecting the favourite division it might be the case that favourite
      // file belong to other division than the Job, In such a scenario user selects
      // the division of his choice to be applied. So, overriding this worksheet division
      if (division != null) workSheet?.division = division;
      settingsJson = result.settingsJson;
      selectedFromFavourite = id != null;
    } catch (e) {
      rethrow;
    }
  }

  /// [fetchJobDetail] loads job details in both add and edit cases
  Future<void> fetchJobDetail() async {
    try {
      final params = <String, dynamic> {
        "id": jobId,
        "includes[0]": "pricing_history",
        "includes[1]": "payments",
        "includes[2]": "change_order",
        "includes[3]": "change_order_history",
        "includes[4]": "address.state_tax",
        "includes[5]": "address",
        "includes[6]": "parent.address.state_tax",
        "includes[7]": "payment_receive",
        "includes[8]": "financial_details",
        "includes[9]": "projects",
        "includes[10]": "custom_tax",
        "includes[11]": "division",
        "includes[12]": "job_invoice_count",
        "includes[13]": "flags.color",
        "includes[14]": "division.address",
      };

      final response = await JobRepository.fetchJob(jobId!, params: params);
      job = response['job'];
    } catch (e) {
      rethrow;
    }
  }

  /// [fetchCategories] loads list of categories to select from while adding item
  Future<void> fetchCategories() async {
    try {
      final params = {
        'active': 1,
        'includes[]': 'system_category',
      };

      final response = await WorksheetRepository.fetchCategories(params);
      final singleSelectCategories = response.map((category) => category.toSingleSelect());
      allCategories.addAll(singleSelectCategories);
      // removing material category in case of work order worksheet
      if (worksheetType == WorksheetConstants.workOrder) {
        allCategories.removeWhere((category) => category.additionalData.slug == FinancialConstant.material);
      }

    } catch (e) {
      rethrow;
    }
  }

  /// [fetchCompanySuppliers] loads list of of suppliers to select from
  Future<void> fetchCompanySuppliers() async {
    try {
      final response = await SuppliersRepository.fetchCompanySuppliers({});
      final singleSelectSuppliers = response.map((supplier) => supplier.toSingleSelect());
      final srsV1Id = Helper.getSupplierId(forceV1: true).toString();
      final srsV2Id = Helper.getSupplierId().toString();
      final abcSupplierId = Helper.getSupplierId(key: CommonConstants.abcSupplierId).toString();
      final beaconId = Helper.getSupplierId(key: CommonConstants.beaconId).toString();
      for (JPSingleSelectModel supplier in singleSelectSuppliers) {
        // Excluding SRS v1, SRS V2, ABC and Beacon from list of selectable suppliers
        if (supplier.id == srsV1Id || supplier.id == srsV2Id || supplier.id == abcSupplierId || supplier.id == beaconId) continue;
        allSuppliers.add(supplier);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// [fetchTaxDetailList] loads custom tax to select from
  Future<void> fetchTaxDetailList() async {
    try {
      List<TaxModel> taxList = await JobRepository.fetchCustomTax({"limit":0, ...CommonConstants.ignoreToastQueryParam});
      for (TaxModel items in taxList) {
        allTax.add(JPSingleSelectModel(
          id: items.id.toString(),
          label: "${items.title} - (${items.taxRate} %)",
          additionalData: items.taxRate,
        ));
      }
    } catch (e) {
      Helper.recordError(e);
    }
  }

  /// [fetchTiers] loads list of tiers name to select tier from add tier option 
  Future<void> fetchTiers() async {
    try {
      final params = {
        'limit': 0,
      };

      final response = await WorksheetRepository.getTiers(params);
      allTiers = response;
    } catch (e) {
      rethrow;
    }
  }

  /// [getLocalDBData] loads data from local db
  Future<void> getLocalDBData() async {
    try {
      final tempTrades = await FormsDBHelper.getAllTrades(includeNone: true);
      allTrades.addAll(tempTrades);

      final tempDivision = await FormsDBHelper.getAllDivisions();
      allDivisions.addAll(tempDivision);
      setDivision(job?.division?.id.toString() ?? "");
    } catch (e) {
      rethrow;
    }
  }

  /// Selectors ---------------------------------------------------------------

  void selectDivision() {
    FormValueSelectorService.openSingleSelect(
      list: allDivisions,
      title: 'select_division'.tr,
      selectedItemId: selectedDivisionId,
      onValueSelected: setDivision,
    );
  }

  /// [selectTaxRateAll] opens up single select to select custom tax rate
  void selectTaxRateAll() {
    FormValueSelectorService.openSingleSelect(
        list: allTax,
        selectedItemId: settings?.selectedTaxRateId ?? "",
        title: 'select_tax'.tr,
        onValueSelected: onCustomTaxRateSelected
    );
  }

  /// [selectMaterialTaxRate] opens up single select to select material custom tax rate
  void selectMaterialTaxRate() {
    FormValueSelectorService.openSingleSelect(
        list: allTax,
        selectedItemId: settings?.selectedMaterialTaxRateId ?? "",
        title: 'select_tax'.tr,
        onValueSelected: onCustomMaterialTaxRateSelected
    );
  }

  /// [selectLaborTaxRate] opens up single select to select labor custom tax rate
  void selectLaborTaxRate() {
    FormValueSelectorService.openSingleSelect(
        list: allTax,
        selectedItemId: settings?.selectedLaborTaxRateId ?? "",
        title: 'select_tax'.tr,
        onValueSelected: onCustomLaborTaxRateSelected
    );
  }

  /// [onCustomTaxRateSelected] is responsible for updating custom tax rate
  void onCustomTaxRateSelected(String id) {
    final selectedTax = FormValueSelectorService.getSelectedSingleSelect(allTax, id);
    settings?.selectedTaxRateId = selectedTax.id;
    settings?.isRevisedTaxApplied = false;
    settings?.overriddenTaxRate = num.tryParse(selectedTax.additionalData.toString());
    calculateSummary();
  }

  /// [onCustomMaterialTaxRateSelected] is responsible for updating custom material tax rate
  void onCustomMaterialTaxRateSelected(String id) {
    final selectedTax = FormValueSelectorService.getSelectedSingleSelect(allTax, id);
    settings?.selectedMaterialTaxRateId = selectedTax.id;
    settings?.isRevisedMaterialTaxApplied = false;
    settings?.overriddenMaterialTaxRate = num.tryParse(selectedTax.additionalData.toString());
    calculateSummary();
  }

  /// [onCustomLaborTaxRateSelected] is responsible for updating custom labor tax rate
  void onCustomLaborTaxRateSelected(String id) {
    final selectedTax = FormValueSelectorService.getSelectedSingleSelect(allTax, id);
    settings?.selectedLaborTaxRateId = selectedTax.id;
    settings?.isRevisedLaborTaxApplied = false;
    settings?.overriddenLaborTaxRate = num.tryParse(selectedTax.additionalData.toString());
    calculateSummary();
  }

  /// [getActions] helps in getting worksheet more action after performing several calculation
  List<PopoverActionModel> getActions() {
    return WorksheetMoreActionService.getActions(
        params: WorksheetHeaderActionParams(data: this, hasTiers: hasTiers)
    );
  }

  /// [getTierSubTotalsActions] helps in getting tier subtotal actions
  List<PopoverActionModel> getTierSubTotalsActions() {
    return WorksheetMoreActionService.getTierSubTotalsActions();
  }

  /// [onNoteChange] helps in updating worksheet note
  void onNoteChange(String? newNote) {
    note = newNote ?? "";
    update();
  }

  /// [setAmountRates] is responsible for setting default tax rates
  void setAmountRates() {
    settings?.laborTaxRate = WorksheetHelpers.getLaborTaxRate(jobModel: job, worksheet: workSheet);
    settings?.materialTaxRate = WorksheetHelpers.getMaterialTaxRate(jobModel: job, worksheet: workSheet);
    settings?.taxRate = WorksheetHelpers.getTaxAllRate(jobModel: job, worksheet: workSheet);
    settings?.overHeadRate = WorksheetHelpers.getOverHeadRate();
    if (isEditForm) settings?.checkForRevisedTax();
  }

  Future<bool> showRevisedTaxConfirmation({
    required num revisedTaxRate,
    required String title,
  }) async {
    bool applyRevised = true;
    await WorksheetHelpers.showConfirmation(
      subTitle: "${'do_you_want_to_apply_the_revised_tax'.tr} $title ${'rate'.tr}"
          " (${JobFinancialHelper.getRoundOff(revisedTaxRate)}%)? ${'press_confirm_to_proceed'.tr.capitalizeFirst}",
      onConfirmed: () {
        applyRevised = false;
      }
    );
    return applyRevised;
  }

  /// [toggleRevisedTax] handles enable/disable revised tax
  Future<void> toggleRevisedTax(bool val) async {
    final rate = settings!.revisedTaxAll ?? 0;
    if (!val) val = await showRevisedTaxConfirmation(revisedTaxRate: rate, title: 'tax_all'.tr);
    settings?.isRevisedTaxApplied = !val;
    calculateSummary();
  }

  /// [toggleRevisedMaterialTax] handles enable/disable revised tax
  Future<void> toggleRevisedMaterialTax(bool val) async {
    final rate = settings!.revisedMaterialTax ?? 0;
    if (!val) val = await showRevisedTaxConfirmation(revisedTaxRate: rate, title: 'tax_material'.tr);
    settings?.isRevisedMaterialTaxApplied = !val;
    calculateSummary();
  }

  /// [toggleRevisedLaborTax] handles enable/disable revised tax
  Future<void> toggleRevisedLaborTax(bool val) async {
    final rate = settings!.revisedLaborTax ?? 0;
    if (!val) val = await showRevisedTaxConfirmation(revisedTaxRate: rate, title: 'tax_labor'.tr);
    settings?.isRevisedLaborTaxApplied = !val;
    calculateSummary();
  }

  /// Helpers -----------------------------------------------------------------

  /// [bindSettingsWithItems] helps in binding settings reference with line items so
  /// Ui elements can be controller accordingly
  void bindSettingsWithItems() {
    List<SheetLineItemModel> items = WorksheetHelpers.getParsedItems(lineItems: lineItems);
    for (SheetLineItemModel item in items) {
      item.workSheetSettings = settings;
    }
  }

  /// [updateSettings] is responsible for updating the settings variables so data
  /// and actions can be displayed accordingly
  void updateSettings(List<SheetLineItemModel> items) {
    settings?.isQbWorksheet = workSheet?.isQbdWorksheet ?? false;
    settings?.isMaterialWorkSheet = worksheetType == WorksheetConstants.materialList;
    settings?.isWorkOrderSheet = worksheetType == WorksheetConstants.workOrder;
    settings?.hasMaterialItem = items.any((item) => item.productSlug == FinancialConstant.material);
    settings?.hasLaborItem = items.any((item) => item.productSlug == FinancialConstant.labor);
    settings?.hasNoChargeItem = items.any((item) => item.productSlug == FinancialConstant.noCharge);
    settings?.hasTier = hasTiers;
    settings?.isEstimateOrProposalWorksheet = worksheetType == WorksheetConstants.estimate || worksheetType == WorksheetConstants.proposal;
  }

  /// [calculateSummary] iterates through all line items and make calculations on the
  /// basis of settings and data available in item
  void calculateSummary() {
    // making hierarchical items to linear
    List<SheetLineItemModel> items = WorksheetHelpers.getParsedItems(lineItems: lineItems);

    // updating selling price unavailability
    if (Helper.isTrue(settings?.enableSellingPrice)) {
      updateSellingPriceUnavailability(items);
    }

    // updating setting for new set of items
    updateSettings(items);
    // calculating amounts and setting up calculatedAmounts model
    calculatedAmounts = WorksheetCalculations.calculateAmounts(
      lineItems: items,
      settings: settings!
    );
    // updating sub-total of settings as several calculations rely on it
    settings?.subTotalAmount = calculatedAmounts.subTotal;
    settings?.listTotalAmount = calculatedAmounts.listTotal;
    // updating tier prices if exists
    updateAllTiersPrice();
    update();
  }

  /// [onItemSaved] add or updated line item and updates calculations accordingly
  void onItemSaved(SheetLineItemModel? tier, SheetLineItemModel? editLineItem, SheetLineItemModel item, int? index) {
    if (tier != null) {
      if(editLineItem != null) tier.subItems![editLineItem.currentIndex!] = item;
      if(editLineItem == null) tier.subItems?.add(item);
      updateTierPrice(tier.subItems, collectionIndex: index);
    } else {
      if (editLineItem != null) lineItems[editLineItem.currentIndex!] = item;
      if (editLineItem == null) lineItems.add(item);
    }

    checkColorIsSelected(item);
    checkAnyTierWithWarning();
    update();
    // Updating amounts
    calculateSummary();
    Helper.hideKeyboard();
    Get.back();

    /// Below line is responsible for displaying 'Product Availability Dialog' conditionally
    /// on adding SRS item. This code has been blocked for the time being as this feature is
    /// not implemented in old app
    // openDoNotAskAgainAvailabilityNoticeSheet(item);
  }

  /// [reorderItem] handles reordering of items for both with or without tier case
  void reorderItem(int oldIndex, int newIndex, List<SheetLineItemModel> lineItems) {
    final SheetLineItemModel temp = lineItems.removeAt(oldIndex);
    lineItems.insert(newIndex, temp);
  }

  /// [removeItem] helps in removing item for both with or without tier case
  void removeItem(int index, {List<SheetLineItemModel>? items, int? collectionIndex}) {
    (items ?? lineItems).removeAt(index);
    updateTierPrice(items, collectionIndex: collectionIndex);
    checkAnyTierWithWarning();
    calculateSummary();
    update();
  }

  /// [onListItemReorder] verifies the re-ordered indices and updates them accordingly
  void onListItemReorder(int oldIndex, int newIndex, {
    List<SheetLineItemModel>? items
  }) {
    if (oldIndex <= newIndex) {
      newIndex -= 1;
    }
    if(oldIndex == newIndex) return;

    reorderItem(oldIndex, newIndex, items ?? lineItems);
    update();
  }

  /// [onTierExpansionChanged] helps in managing tier's expansion state
  Future<void> onTierExpansionChanged(bool val, SheetLineItemModel tier) async {
    if (tier.isTierExpanded != val) {
      tier.isTierExpanded = val;
      WorksheetHelpers.tierIterator(tier, action: (item) {
        Helper.hideKeyboard();
        item.isTierExpanded = val;
      });
      update();
    }
  }

  /// [toggleIsSavingForm] helps in toggling forms saving state which further
  /// helps in disabling up and user interation
  void toggleIsSavingForm(bool val) {
    isSavingForm = val;
    update();
  }

  /// [updateTierPrice] helps in updating tier price on updating sub list
  void updateTierPrice(List<SheetLineItemModel>? items, {int? collectionIndex}) {
    // Calculating all the Tier amounts and setting at tier level
    WorksheetAmounts tierTotals = WorksheetCalculations.getTierAmounts(items ?? []);
    if (collectionIndex != null) {
      WorksheetHelpers.tierIterator(lineItems[collectionIndex], action: (item) => item.setTierSubTotals(tierTotals));
    }
  }

  /// [updateAllTiersPrice] iterates through all tiers and updates price
  void updateAllTiersPrice() {
    if (!hasTiers) return;
    WorksheetHelpers.tierListIterator(lineItems, action: (item) {
      // Calculating all the amounts of sub items with in a tier and setting at tier level
      WorksheetAmounts itemsTotal = WorksheetCalculations.getTierAmounts(item.subItems ?? []);
      // Calculating all the amounts of tiers with in a tier and setting at parent tier level
      WorksheetAmounts tiersTotal = WorksheetCalculations.getTierAmounts(item.subTiers ?? []);
      if (item.subItems?.isNotEmpty ?? false) {
        item.setTierSubTotals(itemsTotal);
      } else {
        item.setTierSubTotals(tiersTotal);
      }
    });

    update();
  }

  /// [removeCollection] helps in extracting all the items from tiers so that
  /// tiers can be removed and item can rendered without tiers
  void removeCollection(int index) {
    if (hasTiers) {
      if (lineItems.length == 1) {
        List<SheetLineItemModel> items = [];
        WorksheetHelpers.tierIterator(lineItems[index], action: (item) {
          items.addAll(item.subItems ?? []);
        });
        lineItems.clear();
        lineItems.addAll(items);
      } else {
        lineItems.removeAt(index);
      }
    } else if (lineItems.isNotEmpty) {
      lineItems.removeAt(index);
    }
    calculateSummary();
    update();
  }

  /// [removeAttachedItem] removes the attached item from list of attachments
  void removeAttachedItem(int index) {
    attachments.removeAt(index);
    if (attachments.isEmpty) Get.back();
    update();
  }

  /// [parseMacroToLineItems] parse marco list items to worksheet line items
  /// by adding in addition details eg. settings and trade
  void parseMacroToLineItems(List<MacroListingModel> macros) {
    List<SheetLineItemModel> items = WorksheetHelpers.parseMacroToLineItems(
        macros,
        settings: settings,
        allTrades: allTrades
    );
    setSellingPrice(items);
    lineItems.addAll(items);
    update();
  }

  /// [toggleSupplier] activates/deactivates the supplier based on the given value.
  ///
  /// If [val] is true, it activates the [supplier], otherwise it deactivates it.
  /// If [isAction] is [False], it navigates back.
  void toggleSupplier(bool val, MaterialSupplierType supplier, {
    bool isAction = false,
  }) {
    // closing the more actions pop-up if it's open
    if (!isAction) Get.back();
    if (val) {
      // activating supplier if it's not been activated before
      activateSupplier(supplier);
    } else {
      // deactivating supplier if it's been activated before
      deactivateSupplier(supplier);
    }
  }

  /// [activateSupplier] Activates a supplier by conditionally showing a confirmation
  /// message and then opens the supplier selector bottom sheet.
  ///
  /// [supplier] The material supplier type to activate.
  void activateSupplier(MaterialSupplierType supplier) {
    // Check if a confirmation message needs to be displayed
    String? message = getRemoveSupplierConfirmation(makeProductCheck: true);

    // If a confirmation message is available, show confirmation dialog and
    // then remove supplier and open bottom sheet
    if (message != null) {
      WorksheetHelpers.showConfirmation(
          subTitle: message,
          onConfirmed: () async {
            // Removing previously activated supplier
            // As only one material supplier can be active at a time
            removeSupplier();
            // Open the bottom sheet to select the supplier details
            openSupplierSelector(supplier);
          }
      );
    }
    else {
      // If no confirmation message is available, directly open
      // the supplier selector bottom sheet
      openSupplierSelector(supplier);
    }
  }

  /// [deactivateSupplier] Deactivates the supplier of the specified type.
  ///
  /// If a confirmation message is available, it is shown to the user.
  /// If the user confirms, the supplier is removed.
  void deactivateSupplier(MaterialSupplierType supplier) {
    String? message = getRemoveSupplierConfirmation();
    if (message == null) return;
    WorksheetHelpers.showConfirmation(
        subTitle: message,
        onConfirmed: removeSupplier
    );
  }

  /// [getRemoveSupplierConfirmation] gives a confirmation message for removing a supplier.
  ///
  /// If [makeProductCheck] is true, checks for the presence of products from the specified supplier.
  /// If [isSRSEnable] is true, checks for SRS products;
  /// if [isBeaconEnable] is true, checks for Beacon products.
  /// Returns the appropriate deactivation message based on the presence of products.
  /// Returns null if neither SRS nor Beacon are enabled.
  String? getRemoveSupplierConfirmation({bool makeProductCheck = false}) {
    if (isSRSEnable) {
      bool hasSRSProducts = makeProductCheck && WorksheetHelpers.hasSuppliersProduct(CommonConstants.srsId, lineItems);
      return hasSRSProducts
          ? 'deactivate_srs_dialog_with_products_message'.tr
          : 'deactivate_srs_dialog_message'.tr;
    } else if (isBeaconEnable) {
      bool hasBeaconProducts = makeProductCheck && WorksheetHelpers.hasSuppliersProduct(CommonConstants.beaconId, lineItems);
      return hasBeaconProducts
          ? 'deactivate_beacon_dialog_with_products_message'.tr
          : 'deactivate_beacon_dialog_message'.tr;
    }

    else if (isAbcEnable) {
      bool hasAbcProducts = makeProductCheck && WorksheetHelpers.hasSuppliersProduct(CommonConstants.abcSupplierId, lineItems);
      return hasAbcProducts
          ? 'deactivate_abc_dialog_with_products_message'.tr
          : 'deactivate_abc_dialog_message'.tr;
    }
    return null;
  }

  /// [removeSupplier] Removes the supplier and resets related variables and line items.
  void removeSupplier() {
    final selectedSupplierId = getActiveSupplierId();
    if (selectedSupplierId != null) removeSupplierProducts(isDeactivating: true);

    selectedSrsShipToAddress = null;
    selectedSrsBranch = null;
    isSRSEnable = false;
    selectedBeaconAccount = null;
    selectedBeaconBranch = null;
    selectedBeaconJob = null;
    isBeaconEnable = false;
    isAbcEnable = false;
    selectedAbcAccount = null;
    selectedAbcBranch = null;

    for (SheetLineItemModel lineItem in lineItems) {
      lineItem.product?.notAvailable = false;
      lineItem.product?.notAvailableInPriceList = false;
    }
    update();
  }

  /// [setFavourite] will be responsible for setting favourite items and replacing
  /// existing items
  /// Params:
  /// [file] - selected favourite file, from which data is to be extracted
  Future<void> setFavourite(FilesListingModel file) async {
    try {
      // additional delay to avoid lags
      await Future<void>.delayed(const Duration(milliseconds: 200));
      final currentWorksheetId = worksheetId ?? workSheet?.id;
      showJPLoader();
      lineItems.clear();
      removeSupplier();
      // fetching worksheet details from favourite worksheet id & applying division
      await fetchWorksheet(id: file.favouriteFile?.worksheetId, division: file.division);
      // loading worksheet settings from company settings
      getWorksheetSettings(forFavourite: true);
      // initialising form with data
      setFormData();
      // adding settings to line items in case of edit
      bindSettingsWithItems();
      // loading default tax & overhead details
      setAmountRates();
      // calculating amounts
      calculateSummary();
      // setting tier prices
      updateAllTiersPrice();
      // Check for tiers missing Macros
      checkAnyTierWithWarning();
      // update all SRS product details & prices
      await updateSupplierProductDetails();
      // checking fro revised tax rate
      settings?.checkForRevisedTax();
      // using the actual worksheet id instead of fav.'s worksheet id
      workSheet?.id = currentWorksheetId;
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  /// [handleTierQuickAction] is responsible for handling tier quick action
  /// it basically deals with another service and updates this service's data accordingly
  void handleTierQuickAction(SheetLineItemModel lineItem, int index) {
    WorksheetTierQuickActionService.openQuickActions(
        params: WorksheetTierParams(
            lineItem: lineItem,
            jobId: jobId,
            data: this,
            rootItem: lineItems[index],
            totalCollections: lineItems.length,
            worksheetJson: worksheetJson,
            onActionComplete: (String actionId, {dynamic data}) {
              switch (actionId) {
                case WorksheetConstants.addDescription:
                case WorksheetConstants.rename:
                  update();
                  break;

                case WorksheetConstants.addSubTier:
                  checkAnyTierWithWarning();
                  update();
                  break;

                case WorksheetConstants.removeCollection:
                  removeCollection(index);
                  checkAnyTierWithWarning();
                  break;

                case WorksheetConstants.macros:
                  updateSupplierProductDetails(showLoader: true);
                  break;

                case WorksheetConstants.removeSubTier:
                case WorksheetConstants.applyMeasurement:
                case WorksheetConstants.reapplyMeasurement:
                case WorksheetConstants.discardMeasurement:
                case WorksheetConstants.deleteTier:
                case WorksheetConstants.deleteTierWithItems:
                  checkAnyTierWithWarning();
                  calculateSummary();
                  update();
                  break;

                case WorksheetConstants.addItem:
                  showAddEditSheet(tier: lineItem, index: index);
                  break;
                case WorksheetConstants.srsSmartTemplate:
                  navigateToSrsSmartTemplateScreen(true, index: index);
                  break;
              }
            }
        )
    );
  }

  /// [onTapMoreActionOption] is responsible for handling worksheet more actions
  /// it basically deals with another service and updates this service's data accordingly
  void onTapMoreActionOption(PopoverActionModel val) {
    if (val.isDisabled) return;

   Helper.hideKeyboard();
    WorksheetMoreActionService().handleMoreAction(
        params: WorksheetHeaderActionParams(
            data: this,
            action: val.value,
            hasTiers: hasTiers,
            worksheetJson: worksheetJson,
            onActionComplete: (String actionId, {dynamic data}) {
              switch (actionId) {
                case WorksheetConstants.expandTier:
                case WorksheetConstants.collapseTier:
                case WorksheetConstants.attachPhotos:
                case WorksheetConstants.addTemplatePages:
                  update();
                  break;

                case WorksheetConstants.removeZeroQuantityItems:
                case WorksheetConstants.removeTiers:
                  checkAnyTierWithWarning();
                  update();
                  break;

                case WorksheetConstants.favourites:
                  setFavourite(data);
                  break;

                case WorksheetConstants.markAsFavourite:
                case WorksheetConstants.unMarkAsFavourite:
                  isSavedOnTheGo = true;
                  update();
                  break;

                case WorksheetConstants.macros:
                  parseMacroToLineItems(data);
                  updateSupplierProductDetails(showLoader: true);
                  break;

                case WorksheetConstants.addTier:
                case WorksheetConstants.applyMeasurement:
                case WorksheetConstants.reapplyMeasurement:
                case WorksheetConstants.discardMeasurement:
                case WorksheetConstants.worksheetPricing:
                case WorksheetConstants.worksheetSettings:
                  calculateSummary();
                  update();
                  break;

                case WorksheetConstants.srs:
                  toggleSupplier(!isSRSEnable, MaterialSupplierType.srs, isAction: true);
                  break;

                case WorksheetConstants.beacon:
                  toggleBeaconSupplier(!isBeaconEnable, isPopupOpen: false);
                  break;

                case WorksheetConstants.srsSmartTemplate:
                  navigateToSrsSmartTemplateScreen(false);
                  break;
                case WorksheetConstants.placeSRSOrder:
                case WorksheetConstants.placeBeaconOrder:
                  saveAndNavigateToPlaceOrderForm();
                  break;
                case WorksheetConstants.saveAs:
                    isSavedOnTheGo = true;
                    deleteUnsavedResource();
                    update();
                  break;
                case WorksheetConstants.abc:
                  toggleSupplier(!isAbcEnable, MaterialSupplierType.abc, isAction: true);
                  break;
              }
            }
        )
    );
  }

  /// [onTapTierSubTotal] is responsible for handling tier subtotal actions
  void onTapTierSubTotal(PopoverActionModel val) {
    selectedTierSubTotal = val.value;
    update();
  }

  /// Dialogs & bottom sheets -------------------------------------------------
  
  /// [openSupplierSelector] helps in selecting supplier account and branch
  Future<void> openSupplierSelector([MaterialSupplierType? type, bool isDefaultBranch = true]) async {
    type ??= getSelectedSupplier();
    if (type == null) return;
    bool isDefaultBranchSaved = this.isDefaultBranchSaved(type);
    DefaultBranchModel? defaultBranchModel = WorksheetHelpers.getDefaultBranch(type);
    final result = await showJPBottomSheet(
      ignoreSafeArea: false,
      isScrollControlled: true,
      child: (_) => MaterialSupplierForm(
        params: MaterialSupplierFormParams(
          abcAccount: isDefaultBranchSaved ? defaultBranchModel?.abcAccount : selectedAbcAccount,
          abcBranch: isDefaultBranchSaved ? defaultBranchModel?.branch : selectedAbcBranch,
          srsShipToAddress: isDefaultBranchSaved ? defaultBranchModel?.srsShipToAddress : selectedSrsShipToAddress,
          srsBranch: isDefaultBranchSaved ? defaultBranchModel?.branch : selectedSrsBranch,
          beaconAccount: isDefaultBranchSaved ? defaultBranchModel?.beaconAccount : selectedBeaconAccount,
          beaconJob: isDefaultBranchSaved ? defaultBranchModel?.jobAccount : selectedBeaconJob,
          beaconBranch: isDefaultBranchSaved ? defaultBranchModel?.branch : selectedBeaconBranch,
          type: type,
          isDefaultBranchSaved: isDefaultBranch && isDefaultBranchSaved,
          onChooseDifferentBranch: () {
            openSupplierSelector(type, false);
          },
          srsSupplierId: srsSupplierId,
          worksheetType: WorksheetHelpers.getDefaultSaveName(worksheetType).toLowerCase()
        ),
      ),
    );

    // In case supplier has been selected or updated in the supplier form
    if (result != null && result is Map<String, dynamic>) {
      // resetting the supplier details to avoid any conflicts
      resetSupplier();
      // Parsing and updating the supplier details
      final supplierDetails = result[NavigationParams.supplierDetails];
      setUpSupplier(type, supplierDetails);
    }
    update();
  }

  /// [setUpSupplier] Sets up the supplier based on the given [type] and [details].
  ///
  /// If [type] [is MaterialSupplierType.srs], sets the selected
  /// SRS ship to address and branch and checks if SRS is enabled.
  /// If [type] is [MaterialSupplierType.beacon], sets the selected
  /// Beacon account and branch, and checks if Beacon is enabled.
  void setUpSupplier(MaterialSupplierType type, MaterialSupplierFormParams details) {
    switch (type) {
      case MaterialSupplierType.srs:
        selectedSrsShipToAddress = details.srsShipToAddress;
        selectedSrsBranch = details.srsBranch;
        isSRSEnable = selectedSrsShipToAddress != null && selectedSrsBranch != null;
        // removing the beacon & ABC supplier products
        removeSupplierProducts();
        updateSupplierProductDetails(showLoader: true);
        break;
      case MaterialSupplierType.beacon:
        selectedBeaconAccount = details.beaconAccount;
        selectedBeaconBranch = details.beaconBranch;
        selectedBeaconJob = details.beaconJob;
        isBeaconEnable = selectedBeaconAccount != null && selectedBeaconBranch != null;
        // removing the SRS & ABC supplier products
        removeSupplierProducts();
        updateSupplierProductDetails(showLoader: true);
        break;
      case MaterialSupplierType.abc:
        selectedAbcAccount = details.abcAccount;
        selectedAbcBranch = details.abcBranch;
        isAbcEnable = selectedAbcAccount != null && selectedAbcBranch != null;
        // removing the beacon and SRS supplier products
        removeSupplierProducts();
        updateSupplierProductDetails(showLoader: true);
        break;
    }

    if(details.isBranchMakeDefault) {
      WorksheetHelpers.saveDefaultBranchSettings(
          DefaultBranchModel(
              srsShipToAddress: type == MaterialSupplierType.srs ? selectedSrsShipToAddress : null,
              beaconAccount: type == MaterialSupplierType.beacon ? selectedBeaconAccount : null,
              abcAccount: type == MaterialSupplierType.abc ? selectedAbcAccount : null,
              branch: WorksheetHelpers.getSupplierBranch(
                type,
                selectedSrsBranch: selectedSrsBranch,
                selectedBeaconBranch: selectedBeaconBranch,
                selectedAbcBranch: selectedAbcBranch,
              ),
              jobAccount: selectedBeaconJob
          ),
          type
      );
    }
  }

  /// [removeSupplierProducts] Removes products associated with a supplier.
  ///
  /// [id] The id of the supplier.
  void removeSupplierProducts({bool isDeactivating = false}) {
    int? supplierId1;
    int? supplierId2;
    int? supplierId3;
    if(getActiveSupplierId() == CommonConstants.srsId) {
      supplierId1 = Helper.getSupplierId(key: CommonConstants.beaconId);
      supplierId2 = Helper.getSupplierId(key: CommonConstants.abcSupplierId);
    } else if(getActiveSupplierId() == CommonConstants.beaconId) {
      supplierId1 = Helper.getSRSV1Supplier();
      supplierId2 = Helper.getSRSV2Supplier();
      supplierId3 = Helper.getSupplierId(key: CommonConstants.abcSupplierId);
    } else if(getActiveSupplierId() == CommonConstants.abcSupplierId) {
      supplierId1 = Helper.getSRSV1Supplier();
      supplierId2 = Helper.getSRSV2Supplier();
      supplierId3 = Helper.getSupplierId(key: CommonConstants.beaconId);
    }

    if (hasTiers) {
      // Remove supplier products from tiered items
      WorksheetHelpers.tierListIterator(lineItems, action: (item) {
        if(isDeactivating) {
          if(isSRSEnable) {
            int? srsV1Id = Helper.getSRSV1Supplier();
            int? srsV12d = Helper.getSRSV2Supplier();
            item.subItems?.removeWhere((item) =>
            (item.supplier?.id == srsV1Id
                || item.supplierId == srsV1Id.toString())
                || (item.supplier?.id == srsV12d
                || item.supplierId == srsV12d.toString())
            );
          } else {
            int? activatedSupplierId = Helper.getSupplierId(key: getActiveSupplierId());
            item.subItems?.removeWhere((item) =>
            item.supplier?.id == activatedSupplierId || item.supplierId == activatedSupplierId.toString());
          }
        } else {
          if(isSRSEnable) {
            item.subItems?.removeWhere((item) =>
            (item.supplier?.id == supplierId1 || item.supplierId == supplierId1.toString())
                || (item.supplier?.id == supplierId2 || item.supplierId == supplierId2.toString())
            );
          } else {
            item.subItems?.removeWhere((item) =>
            (item.supplier?.id == supplierId1 || item.supplierId == supplierId1.toString())
                || (item.supplier?.id == supplierId2 || item.supplierId == supplierId2.toString())
                || (item.supplier?.id == supplierId3 || item.supplierId == supplierId3.toString())
            );
          }
        }
      });
    } else {
      // Remove supplier products from line items
      if(isDeactivating) {
        if(isSRSEnable) {
          int? srsV1Id = Helper.getSRSV1Supplier();
          int? srsV12d = Helper.getSRSV2Supplier();
          lineItems.removeWhere((item) =>
          (item.supplier?.id == srsV1Id
              || item.supplierId == srsV1Id.toString())
              || (item.supplier?.id == srsV12d
              || item.supplierId == srsV12d.toString())
          );
        } else {
          int? activatedSupplierId = Helper.getSupplierId(key: getActiveSupplierId());
          lineItems.removeWhere((item) =>
          item.supplier?.id == activatedSupplierId || item.supplierId == activatedSupplierId.toString());
        }
      } else {
        if (isSRSEnable) {
          lineItems.removeWhere((item) =>
          (item.supplier?.id == supplierId1 ||
              item.supplierId == supplierId1.toString())
              || (item.supplier?.id == supplierId2 ||
              item.supplierId == supplierId2.toString())
          );
        } else {
          lineItems.removeWhere((item) =>
          (item.supplier?.id == supplierId1 ||
              item.supplierId == supplierId1.toString())
              || (item.supplier?.id == supplierId2 ||
              item.supplierId == supplierId2.toString())
              || (item.supplier?.id == supplierId3 ||
              item.supplierId == supplierId3.toString())
          );
        }
      }
    }
  }

  /// [updateSupplierProductDetails] helps to check product item is available on selected branch & update their product details
  Future<void> updateSupplierProductDetails({bool showLoader = false, bool isSetInitialData = false, bool showUnavailable = false, bool placeOrder = false, void Function()? goToOrderForm}) async {
    if (RunModeService.isUnitTestMode) return;

    if(isPlaceSupplierOrder() && !hidePriceDialog) {
      showUnavailableDialog = showUnavailable;
    }

    // In case supplier no supplier is selected simply calculating the price
    if (!isAnySupplierEnabled) {
      calculateSummary();
      updateAllTiersPrice();
      return;
    }

    // Otherwise loading the price and product details, updating them and
    // then calculating the price
    try {
      if (showLoader) showJPLoader();

      if (isSRSEnable) {
        await updateSRSSupplierProducts();
      } else if (isBeaconEnable) {
        await updateBeaconSupplierProducts();
      } else if(isAbcEnable) {
        await updateABCSupplierProducts();
      }
    } catch (e) {
      rethrow;
    } finally {
      if (showLoader) Get.back(); // close loader dialog
      calculateSummary();
      updateAllTiersPrice();
      if(isSetInitialData) {
        setInitialJson();
      }

      if(showUnavailableDialog && lineItems.isNotEmpty) {
        WorksheetHelpers.showProductAvailabilityConfirmationModal(placeOrder: placeOrder, onProceed: goToOrderForm);
      } else {
        goToOrderForm?.call();
      }
      showUnavailableDialog = false;
    }
  }

  Future<void> updateSRSSupplierProducts() async {
    List<SheetLineItemModel> items = WorksheetHelpers.getParsedItems(lineItems: lineItems);
    bool hasSRSItem = items.any((item) => Helper.isSRSv1Id(item.supplier?.id) || Helper.isSRSv2Id(item.supplier?.id));
    if (items.isEmpty || !hasSRSItem) return;

    Set<int> categoriesIds = {};
    Set<String> productCodes = {};
    List<Map<String, dynamic>> itemDetails = [];
    final Map<String, FinancialProductModel> productsJson = {};

    setParamsForSupplierProductApi(
        items, categoriesIds, productCodes, itemDetails);

    await fetchSRSProductDetails(
    page: 1,
    categoriesIds: categoriesIds.toList(),
    productCodes: productCodes.toList(),
    productsJson: productsJson,
    );

    await fetchSRSProductPrice(items, itemDetails, productsJson);
  }

  Future<void> updateBeaconSupplierProducts() async {
    List<SheetLineItemModel> items = WorksheetHelpers.getParsedItems(lineItems: lineItems);
    // Check if any item has beacon supplier and update price for only that items
    bool hasBeaconItem = items.any((item) => item.supplier?.id == Helper.getSupplierId(key: CommonConstants.beaconId));
    // If no item has beacon supplier or there are no items simply return
    if (items.isEmpty || !hasBeaconItem) return;

    List<FinancialProductModel> products = items
        .map((item) => (item.product?..code ??= item.productCode) ?? FinancialProductModel()).toList();

    await fetchBeaconProductPriceList(products);
  }

  /// [setParamsForSupplierProductApi] helps to set parameters for srs product detail & price api
  void setParamsForSupplierProductApi(List<SheetLineItemModel> items, Set<int> categoriesIds, Set<String> productCodes, List<Map<String, dynamic>> itemDetails) {

    for (SheetLineItemModel lineItem in items) {
      if(!isAbcEnable && !Helper.isSRSv1Id(lineItem.supplier?.id) && !Helper.isSRSv2Id(lineItem.supplier?.id)) continue;
      if(isAbcEnable && !Helper.isABCSupplierId(lineItem.supplier?.id)) continue;

      int? categoryId = lineItem.categoryId ?? lineItem.category?.id;
      int? systemCategoryId = lineItem.systemCategoryId ?? lineItem.category?.systemCategory?.id;
      if(isAbcEnable) {
        if(!Helper.isValueNullOrEmpty(lineItem.variants)) {
          lineItem.productCode = lineItem.variants?.first.code;
        }
      }
      String? productCode = lineItem.productCode ?? lineItem.product?.code;

      if (categoryId != null) {
        categoriesIds.add(categoryId);
      }
      if (systemCategoryId != null) {
        categoriesIds.add(systemCategoryId);
      }
      if (productCode != null) {
        productCodes.add(productCode);

        if (lineItem.unit != null) {
          if(!Helper.isValueNullOrEmpty(lineItem.product?.variants)) {
            if(isAbcEnable) {
              itemDetails.add({
                'item_code': productCode,
                'unit': lineItem.unit!,
              });
            } else {
              itemDetails.add({
                'product_code': productCode,
                'unit': lineItem.unit!,
                'product_name': lineItem.product?.name ?? lineItem.name,
                'variant_code': lineItem.variants?.firstOrNull?.code ?? lineItem.product?.code,
              });
            }
          } else {
            itemDetails.add({
              'item_code': productCode,
              if(isSRSEnable || isAbcEnable)
                'unit': lineItem.unit!,
            });
          }
        }
      }
    }
  }

  /// [fetchSRSProductDetails] helps to fetch all srs product until last pae
  Future<void> fetchSRSProductDetails({
    required int page,
    required Map<String, FinancialProductModel> productsJson,
    required List<int> categoriesIds,
    required List<String> productCodes,
  }) async {
    try {
      final selectedBranch = getSelectedBranch();
      final params = {
        'page': page,
        'categories_ids': categoriesIds,
        'src': 'supplier',
        'supplier_id': isSRSEnable ? srsSupplierId : Helper.getSupplierId(key: getActiveSupplierId()),
        'code': productCodes,
        'include_srs_products': Helper.isTrueReverse(isSRSEnable),
        'branch_code': selectedBranch?.branchCode ?? '',
        'include[0]': 'variants'
      };
      Map<String, dynamic> result = await FinancialProductRepository().getSrsProductResult(params);

      if (result['products_json'] is Map<String, FinancialProductModel>) {
        productsJson.addAll(result['products_json']);
      }
      if (result['pagination'] is PaginationModel) {
        int totalPages = (result['pagination'] as PaginationModel).totalPages ?? 1;
        if (page < totalPages) {
          await fetchSRSProductDetails(page: page + 1, productsJson: productsJson, categoriesIds: categoriesIds, productCodes: productCodes);
        }
      }
    } catch (e) {
      rethrow;
    }
  }


  /// [fetchSRSProductPrice] helps to fetch all srs product prices
  Future<void> fetchSRSProductPrice(List<SheetLineItemModel> items, List<Map<String, dynamic>> itemDetails, Map<String, FinancialProductModel> productsJson) async {
    final Map<String, FinancialProductPrice> productsPriceJson = {};
    final List<String> deletedProductIds = [];
    final selectedSupplier = getSelectedSupplier();

    if (itemDetails.isNotEmpty && selectedSupplier != null) {
      final params = {
        if (isSRSEnable) ...{
          'ship_to_sequence_number': selectedSrsShipToAddress!
              .shipToSequenceId!,
          'branch_code': selectedSrsBranch!.branchCode!,
          'supplier_id': srsSupplierId
        },
        if(Helper.isSRSv2Id(srsSupplierId)) ...{
          'product_detail': itemDetails,
        } else ...{
          'item_detail': itemDetails,
        }
      };
      Map<String, dynamic> priceListResult = await FinancialProductRepository()
          .getPriceList(params, type: selectedSupplier, srsSupplierId: srsSupplierId);

      if (priceListResult['data'] != null) {
        productsPriceJson.addAll(priceListResult['data']);
      }
      if(priceListResult['deleted_items'] != null) {
        deletedProductIds.addAll(priceListResult['deleted_items']);
      }
      if(Helper.isValueNullOrEmpty(priceListResult['deleted_items'])) {
        showUnavailableDialog = false;
      }
    }

    for (SheetLineItemModel lineItem in items) {
      setAllSrsProductDetails(lineItem, productsJson, productsPriceJson, deletedProductIds);
    }
  }

  /// [setAllSrsProductDetails] helps to set all product detail & price in lineItem
  void setAllSrsProductDetails(SheetLineItemModel lineItem, Map<String, FinancialProductModel> productsJson, Map<String, FinancialProductPrice> productsPriceJson, List<String> deletedProductsPriceJson) {
    String? productCode = lineItem.productCode ?? lineItem.product?.code;
    final tempProduct = lineItem.product;

    if (productCode != null) {
      if (productsJson.containsKey(productCode)) {
        List<VariantModel>? variants = lineItem.product?.variants;
        lineItem.product = productsJson[productCode];
        lineItem.product?.variants = variants;
        lineItem.product?.notAvailableInPriceList = false;
        lineItem.product?.notAvailable = false;
      }

      if (productsPriceJson.containsKey(productCode)) {
        final productPrice = productsPriceJson[productCode];
        lineItem.price = lineItem.product?.sellingPrice = productPrice?.selllingPrice ?? tempProduct?.sellingPrice ?? '';
        lineItem.unitCost = lineItem.product?.unitCost = productPrice?.price ?? tempProduct?.unitCost ?? '';
        lineItem.product?.notAvailableInPriceList = false;
        lineItem.product?.notAvailable = false;
      } else if(deletedProductsPriceJson.contains(productCode)) {
        lineItem.product?.notAvailable = true;
        lineItem.product?.notAvailableInPriceList = true;
      }

    }
    update();
  }

  /// [showAddEditSheet] displays add item sheet to add or edit line item
  void showAddEditSheet({SheetLineItemModel? tier, SheetLineItemModel? editLineItem, int? index}) {
    Helper.hideKeyboard();
    CompanyTradesModel? tradeTypeDefault = getStickySelectedTrade(index: index);
    showJPBottomSheet(
      child: (_) => WorksheetAddItemView(
          params: WorksheetAddItemParams(
            allTrade: allTrades,
            allCategories: allCategories,
            allSuppliers: allSuppliers,
            worksheetType: worksheetType,
            settings: settings!,
            lineItem: editLineItem,
            srsBranchCode: selectedSrsBranch?.branchCode,
            shipToSequenceId: selectedSrsShipToAddress?.shipToSequenceId,
            isSRSEnabled: isSRSEnable,
            isBeaconEnabled: isBeaconEnable,
            beaconBranchCode: selectedBeaconBranch?.branchCode,
            beaconJobNumber: selectedBeaconJob?.jobNumber,
            forSupplierId: workSheet?.materialList?.forSupplierId,
            beaconAccount: selectedBeaconAccount,
            supplierBranch: getSelectedBranch(),
            flModule: flModule,
            srsSupplierId: srsSupplierId,
            abcBranchCode: selectedAbcBranch?.branchCode,
            isAbcEnabled: isAbcEnable,
            supplierAccountId: selectedAbcAccount?.shipToId,
            tradeTypeDefault: tradeTypeDefault,
            jobDivision: job?.division
          ),
          onSave: (item) {
            onItemSaved(tier, editLineItem, item, index);
          },
      ),
      ignoreSafeArea: false,
      isScrollControlled: true,
      enableInsets: true
    );
  }

  /// Validations & data saving -----------------------------------------------

  /// [onTapSave] validates whether any item exists to be saved and decides
  /// accordingly whether to save data directly or show save name dialog
  Future<void> onTapSave() async {
    if (checkIfAnyItemToSave()) {
      Helper.showToastMessage('please_add_at_least_one_item'.tr);
      return;
    } else if (isAnySupplierEnabled && !WorksheetHelpers.isAllItemColorSelected(lineItems)) {
      Helper.showToastMessage('please_select_color_as_highlighted'.tr);
      return;
    }

    // showing confirmation dialog in case of save worksheet and total is negative
    final saveWithNegativeTotal = await WorksheetHelpers.doSaveWithNegativeTotal(getContractTotal(), isEditForm);
    if (!saveWithNegativeTotal) return;

    // saving data directly in case of edit
    if (isEditForm) {
      saveWorksheet();
    } else {
      final filledVal = WorksheetHelpers.getDefaultSaveName(worksheetType, worksheet: workSheet);
      // asking for worksheet name to be saved with
      WorksheetHelpers.showNameDialog(
        title: WorksheetHelpers.worksheetTypeToTitle(worksheetType),
        label: 'name'.tr,
        filledValue: filledVal,
        onDone: (name) => saveWorksheet(name: name),
      );
    }
  }

  /// [saveWorksheet] makes network call to save or update worksheet
  Future<void> saveWorksheet({String? name}) async {
    // closes the name dialog
    if (name != null) Get.back();
    toggleIsSavingForm(true);
    // creating json from available items
    final items = WorksheetHelpers.getParsedItems(lineItems: lineItems, addEmptyTier: true);
    final params = worksheetJson(items, name: name);
    try {
      final response = await WorksheetRepository.saveWorksheet(params);
      // updating worksheet id it can updated once saved
      workSheet = response;
      // helps in deciding whether to refresh files listing or not
      isSavedOnTheGo = true;
      // updating initial json again so to avoid showing changes made dialog
      setFormData();
      setInitialJson();
      Helper.showToastMessage(isEditForm ? 'worksheet_updated'.tr : 'worksheet_saved'.tr);

      if(isDBResourceIdFromController) deleteUnsavedResource();

      if (!isEditForm || selectedFromFavourite) {
        worksheetId = response.id;
        selectedFromFavourite = false;
      }
    } catch (e) {
      rethrow;
    } finally {
      // updating the form type
      if (workSheet?.id != null) formType = WorksheetFormType.edit;
      toggleIsSavingForm(false);
      checkAnyTierWithWarning();
      update();
    }
  }

  /// [showAmountPercentDialog] displays Amount-Percent dialog to update
  /// percentage or amount from worksheet directly
  void showAmountPercentDialog(WorksheetPercentAmountDialogType type) {
    showJPGeneralDialog(
      child: (_) => WorksheetPercentAmountDialog(
        settingModel: settings!,
        type: type,
        onUpdate: () => calculateSummary(),
      ),
    );
  }

  Future<void> fetchBeaconProductPriceList(List<FinancialProductModel> list) async {
    try {
      if (!isBeaconEnable) return;

      final params = getPriceListParams(list);
      Map<String, dynamic> priceListResult = await FinancialProductRepository()
              .getPriceList(params, type: MaterialSupplierType.beacon, srsSupplierId: srsSupplierId);

      if(Helper.isValueNullOrEmpty(priceListResult['deleted_items'])) {
        showUnavailableDialog = false;
      }

      if (Helper.isValueNullOrEmpty(params['item_detail'])) return;

      if (priceListResult['data'] != null) {
        final Map<String, FinancialProductPrice> productsPriceJson = priceListResult['data'];

        if (productsPriceJson.isNotEmpty) {
          if (hasTiers) {
            WorksheetHelpers.tierListIterator(lineItems, action: (item) {
              for (SheetLineItemModel subItem in item.subItems ?? []) {
                final updatedProductPrice = productsPriceJson[subItem.product?.code];
                if (updatedProductPrice != null) {
                  subItem.unitCost = subItem.product?.unitCost = updatedProductPrice.price;
                  subItem.price = subItem.product?.sellingPrice = updatedProductPrice.selllingPrice;
                } else if(Helper.isTrue(settings?.enableSellingPrice)
                    && !Helper.isValueNullOrEmpty(subItem.product?.sellingPrice)) {
                  subItem.price = subItem.product?.sellingPrice;
                }
              }
            });
          } else {
            for (SheetLineItemModel subItem in lineItems) {
              final productCode = isBeaconEnable ? subItem.variantModel?.code : subItem.product?.code;
              final updatedProductPrice = productsPriceJson[productCode];
              if (updatedProductPrice != null) {
                subItem.unitCost = subItem.product?.unitCost = updatedProductPrice.price;
                subItem.price = subItem.product?.sellingPrice = updatedProductPrice.selllingPrice;
              } else if(Helper.isTrue(settings?.enableSellingPrice)
                  && !Helper.isValueNullOrEmpty(subItem.product?.sellingPrice)) {
                subItem.price = subItem.product?.sellingPrice;
              }
            }
          }
        } else if(Helper.isTrue(settings?.enableSellingPrice)) {
          if (hasTiers) {
            WorksheetHelpers.tierListIterator(lineItems, action: (item) {
              for (SheetLineItemModel subItem in item.subItems ?? []) {
                if (!Helper.isValueNullOrEmpty(subItem.product?.sellingPrice)) {
                  subItem.price = subItem.product?.sellingPrice;
                }
              }
            });
          } else {
            for (SheetLineItemModel subItem in lineItems) {
              if(!Helper.isValueNullOrEmpty(subItem.product?.sellingPrice)) {
                subItem.price = subItem.product?.sellingPrice;
              }
            }
          }
        }
      }
      if(priceListResult['deleted_items'] != null) {
        final List<String> deletedItemsPriceJson = priceListResult['deleted_items'];
        if(deletedItemsPriceJson.isNotEmpty) {
          if (hasTiers) {
            WorksheetHelpers.tierListIterator(lineItems, action: (item) {
              for (SheetLineItemModel subItem in item.subItems ?? []) {
                final String? productCode = subItem.product?.code ?? subItem.productCode;
                if(priceListResult['deleted_items'].contains(productCode)) {
                  subItem.product?.notAvailable = true;
                  subItem.product?.notAvailableInPriceList = true;
                } else {
                  subItem.product?.notAvailable = false;
                  subItem.product?.notAvailableInPriceList = false;
                }
              }
            });
          } else {
            for (SheetLineItemModel subItem in lineItems) {
              final String? productCode = subItem.product?.code ?? subItem.productCode;
              if(priceListResult['deleted_items'].contains(productCode)) {
                subItem.product?.notAvailable = true;
                subItem.product?.notAvailableInPriceList = true;
              } else {
                subItem.product?.notAvailable = false;
                subItem.product?.notAvailableInPriceList = false;
              }
            }
          }
        }
      }
      calculateSummary();
      updateAllTiersPrice();

      update();
    } on DioException catch (e) {
      WorksheetHelpers.handleBeaconError(e);
    }
  }

  Future<void> fetchSRSProductPriceList(bool hasTiers, int? index, List<FinancialProductModel> list) async {
      final supplierType = getSelectedSupplier();
      if (supplierType == null) return;

      final params = getPriceListParams(list);
      Map<String, dynamic> priceListResult = await FinancialProductRepository()
          .getPriceList(params, type: supplierType, srsSupplierId: srsSupplierId);

      if (priceListResult['data'] != null) {
        final Map<String, FinancialProductPrice> productsPriceJson = priceListResult['data'];
        final List<String> deletedProductsCode = priceListResult['deleted_items'];

        final SheetLineItemModel? lineItem = hasTiers ? lineItems[index!] : null;

        if(lineItem != null) {
          lineItem.subItems = [];
        }
        for (var i = 0; i < list.length; i++) {
          String? productCode = list[i].code;
          if (productsPriceJson.isNotEmpty) {
            final productPrice = productsPriceJson[productCode];
            list[i].sellingPrice = productPrice?.selllingPrice ?? '';
            list[i].unitCost = productPrice?.price ?? '';
          }

          if (deletedProductsCode.contains(productCode)) {
            list[i].notAvailableInPriceList = true;
          }
          SheetLineItemModel tempLineItem = getParsedSheetLineItem(list[i]);

          tempLineItem.product?.notAvailableInPriceList = false;
          tempLineItem.product?.notAvailable = false;

          if(lineItem != null) {
            lineItem.subItems?.add(tempLineItem);
          } else {
            lineItems.add(tempLineItem);
          }
        }

        calculateSummary();
        updateAllTiersPrice();
    }
  }

  /// [getPriceListParams] gives the parameters for the price list based on the
  /// selected supplier type and list of financial product models.
  ///
  /// [list] - the list of financial product models
  Map<String, dynamic> getPriceListParams(List<FinancialProductModel> list) {
    final supplierType = getSelectedSupplier();
    switch (supplierType) {
      case MaterialSupplierType.srs:
        final List<Map<String, dynamic>> itemsCodesList = [];
        for(var item in list) {
          if (!Helper.isValueNullOrEmpty(item.variants)) {
            itemsCodesList.add({
              if(!Helper.isValueNullOrEmpty(item.variants?.firstOrNull?.code))
                'product_code': item.code,
              'unit': Helper.isValueNullOrEmpty(
                  item.variants?.firstOrNull?.uom) ?
              '' : item.variants?.firstOrNull?.uom?.firstOrNull?.toString(),
              'product_name': item.name,
              'variant_code': item.variants?.firstOrNull?.code,
            });
          } else {
            itemsCodesList.add({
              if(!Helper.isValueNullOrEmpty(item.code))
                'item_code': item.code,
              'unit': item.unit
            });
          }
        }
        return {
          'ship_to_sequence_number': selectedSrsShipToAddress?.id, // ship to sequence number
          'branch_code': selectedSrsBranch?.branchCode, // branch code
          if(Helper.isSRSv2Id(srsSupplierId))
            'product_detail': itemsCodesList.toList()
          else
            'item_detail': itemsCodesList.toList()
        };
      case MaterialSupplierType.beacon:
        /// Get list of variant code
        final List<String> itemCodes = [];
        for (var item in list) {
          if(item.variantModel != null || !Helper.isValueNullOrEmpty(item.variants)) {
            final String? itemCode = item.variantModel?.code ?? item.variants?.firstOrNull?.code;
            if(itemCode != null) {
              itemCodes.add(itemCode);
            }
          } else if (!itemCodes.contains(item.code) && !Helper.isValueNullOrEmpty(item.code)) {
            itemCodes.add(item.code!);
          }
        }
        return {
          'branch_code': selectedBeaconBranch?.branchCode,
          'account_id': selectedBeaconAccount?.accountId,
          'job_number': selectedBeaconJob?.jobNumber,
          'item_detail': itemCodes.map((item) => {'item_code': item}).toList(),
          'ignoreToast': true
        };
      case MaterialSupplierType.abc:
      /// Get list of variant code
        final List<String> itemCodes = [];
        for (var item in list) {
          if (item.variants != null) {
            for (var variant in item.variants!) {
              if (!itemCodes.contains(variant.code) && !Helper.isValueNullOrEmpty(variant.code)) {
                itemCodes.add(variant.code!);
              }
            }
          } else if (!itemCodes.contains(item.code) && !Helper.isValueNullOrEmpty(item.code)) {
            itemCodes.add(item.code!);
          }
        }
        return {
          'branch_code': selectedAbcBranch?.branchCode,
          'supplier_account_id': selectedAbcAccount?.shipToId?.toString(),
          'item_detail': itemCodes.map((item) => {'item_code': item}).toList()
        };
      default:
        return {};
    }
  }

  void checkColorIsSelected(SheetLineItemModel item) {
    if (!Helper.isValueNullOrEmpty(item.product?.colors) &&
        !Helper.isValueNullOrEmpty(item.color)) {
      isColorAdded = true;
    }
  }

  Future<void> fetchUnsavedResourcesData() async {
    try {
      setUnsavedResourceType();
      unsavedResourceJson = await FormsDBHelper.getUnsavedResources(dbUnsavedResourceId);
      await FormsDBHelper.getAllUnsavedResources(type: unsavedResourcesType, jobId: jobId!);
    } catch (e) {
      rethrow;
    } finally {
      update();
    }
  }

  Future<void> navigateToSrsSmartTemplateScreen(bool hasTiers, {int? index}) async {
    final result = await Get.toNamed(Routes.srsSmartTemplate, arguments: {
      NavigationParams.srsBranch: selectedSrsBranch?.branchCode
    });

    if (result != null) {
      final List<FinancialProductModel> templateProducts = result;

      try {
        showJPLoader();
        await fetchSRSProductPriceList(hasTiers, index, templateProducts);
      } catch (e) {
        rethrow;
      } finally {
        await Future<void>.delayed(const Duration(milliseconds: 300));

        Get.back();
      }
    }
  }

  void autoSaveFormData() => stream = Stream.periodic(AutoSaveDuration.delay, (val) async {
    if(checkIfNewDataAdded()) {
      await setUnsavedResourceDB();
    }
  }).listen((count) {});

  Future<void> checkIfUnsavedRecordExists() async {
    if(formType == WorksheetFormType.edit && dbUnsavedResourceId == null) {
      List<FilesListingModel> unsavedResourceList = [];
      //  read unsaved resources from DB
      unsavedResourceList.addAll((await UnsavedResourcesHelper.getAllUnsavedResources(
          type: unsavedResourcesType,
          jobId: jobId ?? 0)) as List<FilesListingModel>);

      int? tempId;
      for (var unsavedResource in unsavedResourceList) {
        //    Read details of unsaved resources
        Map<String,dynamic>? tempJson = await FormsDBHelper.getUnsavedResources(unsavedResource.unsavedResourceId);
        tempJson = jsonDecode(jsonEncode(tempJson));
        tempId = jsonDecode(tempJson?["data"])?["workSheet"]?["id"];
        //    Compare worksheet id with already saved worksheet id
        if(tempId == worksheetId) {
          dbUnsavedResourceId = tempJson?["id"];
          break;
        }
      }
    }
  }

  Future<void> saveAndNavigateToPlaceOrderForm() async {
    if(!WorksheetHelpers.isAllItemColorSelected(lineItems)) {
      Helper.showToastMessage('please_select_color_as_highlighted'.tr);
    } else if((isPlaceBeaconOrder() || isPlaceABCOrder()) && WorksheetHelpers.isBeaconOrABCQuantityZero(lineItems)) {
      WorksheetHelpers.showQuantityWarningDialog(isAbcOrder: isAbcEnable);
    } else if(WorksheetHelpers.isVariationConfirmationRequired(lineItems)) {
      showVariationConfirmationValidation = true;
      update();
      WorksheetHelpers.showConfirmationVariationDialog();
    } else {
      try {
        await updateSupplierProductDetails(showLoader: true, isSetInitialData: false, showUnavailable: true, placeOrder: true, goToOrderForm: () async {
          await saveWorksheet();
          checkBeaconLoginOrNavigateToSupplierOrderForm();
        });
      } catch(e) {
        rethrow;
      }
    }
  }

  /// [setUnsavedResourceDB] is responsible for auto save worksheet data
  Future<void> setUnsavedResourceDB() async {
    if(Get.routing.current != Routes.worksheetForm) return;

    final params = {
      "workSheet": worksheetJson(lineItems, isForUnsavedDB: true,),
      "workSheetSetting": settings?.toAutoSavedResourceJson(),
      "settingsJson": settingsJson,
      "isEditForm": isEditForm,
    };

    Map<String, dynamic> resource = {
      "type": UnsavedResourcesHelper.getUnsavedResourcesString(unsavedResourcesType),
      "job_id": jobId,
      "data": json.encode(params),
    };
    dbUnsavedResourceId = await UnsavedResourcesHelper().insertOrUpdate(dbUnsavedResourceId, resource);
  }

  /// [deleteUnsavedResource]  will delete unsaved form from local DB
  void deleteUnsavedResource() {
    if(dbUnsavedResourceId != null) {
      UnsavedResourcesHelper.deleteUnsavedResource(id: dbUnsavedResourceId!);
      dbUnsavedResourceId = null;
      isDBResourceIdFromController = false;
      resetDbUnsavedResourceId?.call();
    }
  }

  Future<void> openAvailabilityProductNoticeSheet({bool isWhenWorksheetItemAdd = false}) async {
    final bool isDoNotAskAgainChecked = Helper.isTrue(CompanySettingsService.getCompanySettingByKey(
        CompanySettingConstants.srsProductAvailabilityNoticeStatus));

    if(!(isWhenWorksheetItemAdd && isDoNotAskAgainChecked)) {
      showJPBottomSheet(
          child: (JPBottomSheetController controller) => ProductAvailabilityNotice(
            isSRSEnable: isSRSEnable,
            isBeaconEnable: isBeaconEnable,
            isAbcEnable: isAbcEnable,
            isDoNotAskAgainVisible: isWhenWorksheetItemAdd && !isDoNotAskAgainChecked,
            controller: controller,
            onTapOk: () => onTapAvailabilityNoticeOK(isWhenWorksheetItemAdd, controller)
          ));
    }
  }

  Future<void> saveSRSProductAvailabilitySetting(bool checked) async {
    try {
      UserModel? userModel = AuthService.userDetails;
      Map<String, dynamic> params =
      SRSProductAvailabilityNoticeStatusModel(
          userId: userModel?.id,
          companyId: userModel?.companyId ?? 0,
          checked: checked).toJson();
      await CompanySettingRepository.saveSettings(params);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> onTapAvailabilityNoticeOK(bool isWhenWorksheetItemAdd,
      JPBottomSheetController controller) async {
    // TODO: Below code can be used for srs product availability notice pop-up setting preservation, commented for the time being as this feature is not in use
    // if (isWhenWorksheetItemAdd) {
    //   try {
    //     controller.toggleIsLoading();
    //     await saveSRSProductAvailabilitySetting(controller.switchValue);
    //   } catch (e) {
    //     rethrow;
    //   } finally {
    //     controller.toggleIsLoading();
    //     Get.back();
    //   }
    // } else {
      Get.back();
    // }
  }

  void openDoNotAskAgainAvailabilityNoticeSheet(SheetLineItemModel item) {
    if(isSRSEnable && ((item.product?.notAvailable ?? false) ||
        (item.product?.notAvailableInPriceList ?? false))
    ) {
      openAvailabilityProductNoticeSheet(isWhenWorksheetItemAdd: true);
    }
  }

  void toggleBeaconSupplier(bool isOn, {bool isPopupOpen = true}) {
    if(isOn && !AuthService.isUserBeaconConnected()) {
        WorksheetHelpers.showBeaconLoginConfirmationDialog((isBeaconConnecting) {
          if(isBeaconConnecting) {
            toggleSupplier(isOn, MaterialSupplierType.beacon, isAction: !isPopupOpen);
          } else if(isPopupOpen) {
            Get.back();
          }
        });
    } else {
      toggleSupplier(isOn, MaterialSupplierType.beacon, isAction: !isPopupOpen);
    }
  }

  Future<void> navigateToPlaceSupplierOrderForm() async {
    final result = await Get.toNamed(
      Routes.placeSupplierOrderForm, arguments: {
        NavigationParams.id: worksheetId,
        NavigationParams.jobId: jobId,
        NavigationParams.jobModel: job,
        NavigationParams.supplierType: getSelectedSupplier(),
        NavigationParams.deliveryDate: deliveryDate,
        NavigationParams.forSupplierId: workSheet?.file?.forSupplierId
      }
    );
    if (result != null) {
      Get.back(result: result);
    }
  }

  void checkBeaconLoginOrNavigateToSupplierOrderForm() {
    if (isBeaconEnable) {
      if (AuthService.isUserBeaconConnected()) {
        navigateToPlaceSupplierOrderForm();
      } else {
        WorksheetHelpers.showBeaconLoginConfirmationDialog((isBeaconConnecting) {
          if(isBeaconConnecting) {
            navigateToPlaceSupplierOrderForm();
          }
        });
      }
    } else {
      navigateToPlaceSupplierOrderForm();
    }
  }

  /// [isDefaultBranchSaved] - In case of Default supplier branch is saved in company settings - Dialog will be shown
  bool isDefaultBranchSaved(MaterialSupplierType type) {
    final DefaultBranchModel selectedDefaultAccount = DefaultBranchModel(
        srsShipToAddress: type == MaterialSupplierType.srs ? selectedSrsShipToAddress : null,
        beaconAccount: type == MaterialSupplierType.beacon ? selectedBeaconAccount : null,
        abcAccount: type == MaterialSupplierType.abc ? selectedAbcAccount : null,
        branch: WorksheetHelpers.getSupplierBranch(
          type,
          selectedSrsBranch: selectedSrsBranch,
          selectedBeaconBranch: selectedBeaconBranch,
          selectedAbcBranch: selectedAbcBranch,
        ),
        jobAccount: type == MaterialSupplierType.beacon ? selectedBeaconJob : null
    );
    return WorksheetHelpers.isDefaultBranchSaved(selectedDefaultAccount, type);
  }

  void updateSellingPriceUnavailability(List<SheetLineItemModel> items) {
      for (var item in items) {
        if(!Helper.isTrue(item.product?.isSellingPriceNotAvailable)) {
          item.product?.isSellingPriceNotAvailable = Helper.isValueNullOrEmpty(item.price);
        } else {
          if(Helper.isValueNullOrEmpty(item.price)) {
            item.product?.isSellingPriceNotAvailable = true;
          } else {
            item.product?.isSellingPriceNotAvailable = num.tryParse(item.price ?? '0') == 0;
          }
        }
      }
  }

  /// [checkAnyTierWithWarning] - iterates over all the available tiers to identify if
  /// any tier is missing missing macro so, to display the warning at global level.
  void checkAnyTierWithWarning() {
    // Manually setting the flag as there are no tiers with warning
    isAnyTierWithWarning = false;

    // If there are no tiers, exit early
    if (!hasTiers) return;

    // Iterate through the tier list
    WorksheetHelpers.tierListIterator(lineItems, action: (item) {
      // If a tier with a warning has already been found, stop iterating
      if (isAnyTierWithWarning) return;

      // Check if the current tier should be highlighted (indicating a warning)
      // Update the flag if a warning is found
      isAnyTierWithWarning = item.doHighlightTier();
    });
  }

  Future<void> updateABCSupplierProducts() async {
    List<SheetLineItemModel> items = WorksheetHelpers.getParsedItems(lineItems: lineItems);
    bool hasABCItem = items.any((item) => item.supplierId == Helper.getSupplierId(key: CommonConstants.abcSupplierId)?.toString());
    if (items.isEmpty || !hasABCItem) return;

    Set<int> categoriesIds = {};
    Set<String> productCodes = {};
    List<Map<String, dynamic>> itemDetails = [];
    final Map<String, FinancialProductModel> productsJson = {};

    setParamsForSupplierProductApi(
        items, categoriesIds, productCodes, itemDetails);

    await fetchABCProductDetails(
      page: 1,
      categoriesIds: categoriesIds.toList(),
      productCodes: productCodes.toList(),
      productsJson: productsJson,
    );

    await fetchABCProductPrice(items, itemDetails, productsJson);
  }

  /// [fetchABCProductDetails] helps to fetch all ABC product until last pae
  Future<void> fetchABCProductDetails({
    required int page,
    required Map<String, FinancialProductModel> productsJson,
    required List<int> categoriesIds,
    required List<String> productCodes,
  }) async {
    try {
      final selectedBranch = getSelectedBranch();
      final params = {
        'page': page,
        'categories_ids': categoriesIds,
        'src': 'supplier',
        'supplier_id': Helper.getSupplierId(key: getActiveSupplierId()),
        'code': productCodes,
        'include_abc_products': Helper.isTrueReverse(isAbcEnable),
        'branch_code': selectedBranch?.branchCode ?? '',
        'include[0]': 'variants'
      };
      Map<String, dynamic> result = await FinancialProductRepository().getSrsProductResult(params);

      if (result['products_json'] is Map<String, FinancialProductModel>) {
        productsJson.addAll(result['products_json']);
      }
      if (result['pagination'] is PaginationModel) {
        int totalPages = (result['pagination'] as PaginationModel).totalPages ?? 1;
        if (page < totalPages) {
          await fetchABCProductDetails(page: page + 1, productsJson: productsJson, categoriesIds: categoriesIds, productCodes: productCodes);
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  /// [fetchABCProductPrice] helps to fetch all ABC product prices
  Future<void> fetchABCProductPrice(List<SheetLineItemModel> items, List<Map<String, dynamic>> itemDetails, Map<String, FinancialProductModel> productsJson) async {
    final Map<String, FinancialProductPrice> productsPriceJson = {};
    final List<String> deletedProductIds = [];
    final selectedSupplier = getSelectedSupplier();

    if (itemDetails.isNotEmpty && selectedSupplier != null) {
      final params = {
          'supplier_account_id': selectedAbcAccount!.shipToId,
          'branch_code': selectedAbcBranch!.branchCode!,
          'supplier_id': Helper.getSupplierId(key: CommonConstants.abcSupplierId),
          'item_detail': itemDetails,
      };
      Map<String, dynamic> priceListResult = await FinancialProductRepository()
          .getPriceList(params, type: selectedSupplier, srsSupplierId: null);

      if (priceListResult['data'] != null) {
        productsPriceJson.addAll(priceListResult['data']);
      }

      if (priceListResult['deleted_items'] != null) {
        deletedProductIds.addAll(priceListResult['deleted_items']);
      }

      if(Helper.isValueNullOrEmpty(priceListResult['deleted_items'])) {
        showUnavailableDialog = false;
      }
    }

    for (SheetLineItemModel lineItem in items) {
      setAllSrsProductDetails(lineItem, productsJson, productsPriceJson, deletedProductIds);
    }
  }

  void setSellingPrice(List<SheetLineItemModel> items) {
    for(SheetLineItemModel item in items) {
      if(Helper.isTrue(settings?.enableSellingPrice)
          && !Helper.isValueNullOrEmpty(item.product?.sellingPrice)) {
        item.price = item.product?.sellingPrice;
      }
    }
  }

  void openPricingAvailabilityNoticeSheet() => showJPBottomSheet(child: (_) => const PricingAvailabilityNotice());

}
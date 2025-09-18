import 'dart:async';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/enums/supplier_form_type.dart';
import 'package:jobprogress/common/enums/worksheet.dart';
import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/common/models/company_trades/company_trades_model.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/forms/measurement/measurement.dart';
import 'package:jobprogress/common/models/forms/worksheet/supplier_form_params.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/common/models/suppliers/beacon/job.dart';
import 'package:jobprogress/common/models/suppliers/branch.dart';
import 'package:jobprogress/common/models/suppliers/srs/srs_ship_to_address.dart';
import 'package:jobprogress/common/models/suppliers/beacon/account.dart';
import 'package:jobprogress/common/models/templates/form_proposal/template.dart';
import 'package:jobprogress/common/models/worksheet/amounts.dart';
import 'package:jobprogress/common/models/worksheet/settings/index.dart';
import 'package:jobprogress/common/models/worksheet/worksheet_model.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/common/services/forms/value_selector.dart';
import 'package:jobprogress/common/services/launch_darkly/index.dart';
import 'package:jobprogress/common/services/worksheet/helpers.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/core/constants/worksheet.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../../global_widgets/select_supplier_branch/controller.dart';
import '../../../services/connected_third_party.dart';
import '../../financial_product/financial_product_model.dart';
import '../../../../core/utils/form/db_helper.dart';
import '../../../enums/unsaved_resource_type.dart';
import '../../job/job_division.dart';

/// [WorksheetFormData] handles the worksheet form data along with provides
/// necessary methods of converting data to server json and checking unsaved changes
class WorksheetFormData {

  int? jobId;
  int? worksheetId;
  int? measurementId;
  int? dbUnsavedResourceId;

  String note = "";
  String selectedDivisionId = "";
  String selectedTierSubTotal = WorksheetConstants.tierSubTotal;

  bool isSavedOnTheGo = false;
  bool isSavingForm = false;
  bool isLoading = true;
  bool selectedFromFavourite = false;
  bool isSRSEnable = false;
  bool isBeaconEnable = false; // helps in deciding whether beacon supplier is enabled or not
  bool isColorAdded = false;
  bool isDBResourceIdFromController = false;
  bool isAbcEnable = false;
  /// [isAnyTierWithWarning] helps in deciding whether any tier has warning or not
  bool isAnyTierWithWarning = false;
  bool showUnavailableDialog = false;
  bool hidePriceDialog = false;

  SrsShipToAddressModel? selectedSrsShipToAddress;
  SupplierBranchModel? selectedSrsBranch;
  /// [selectedBeaconAccount] holds the selected/active beacon account for worksheet
  /// and [selectedBeaconBranch] holds the branch associated with the account
  /// and [selectedBeaconJob] holds the job associated with the branch
  BeaconAccountModel? selectedBeaconAccount;
  SupplierBranchModel? selectedBeaconBranch;
  BeaconJobModel? selectedBeaconJob;
  StreamSubscription<void>? stream;
  late UnsavedResourceType unsavedResourcesType;

  List<JPSingleSelectModel> allCategories = [];
  List<JPSingleSelectModel> allSuppliers = [];
  List<JPSingleSelectModel> allDivisions = [];
  List<JPSingleSelectModel> allTrades = [];
  List<JPSingleSelectModel> allTax = [];

  List<SheetLineItemModel> lineItems = [];
  List<String> allTiers = []; // get all tiers name from server
  List<AttachmentResourceModel> attachments = []; // contains attachments being displayed to user
  List<AttachmentResourceModel> uploadedAttachments = []; // contains attachments coming from server
  List<FormProposalTemplateModel> companyTemplates = []; // contains the template pages

  JPInputBoxController titleController = JPInputBoxController();
  JPInputBoxController divisionController = JPInputBoxController();

  WorksheetAmounts calculatedAmounts = WorksheetAmounts();

  Map<String, dynamic>? settingsJson;
  Map<String, dynamic> initialJson = {};
  Map<String, dynamic>? unsavedResourceJson; // helps in storing unsaved resource data

  MeasurementModel? worksheetMeasurement;
  WorksheetSettingModel? settings;
  WorksheetModel? workSheet;
  JobModel? job;
  FLModule? flModule;

  String worksheetType;
  WorksheetFormType formType;
  int? srsSupplierId;

  SrsShipToAddressModel? selectedAbcAccount;
  SupplierBranchModel? selectedAbcBranch;

  String? deliveryDate;

  bool removeIntegratedSupplierItems;

  MaterialSupplierFormParams? materialSupplierFormParams;

  bool showVariationConfirmationValidation;

  WorksheetFormData({
    this.jobId,
    this.worksheetId,
    this.flModule,
    this.dbUnsavedResourceId,
    required this.worksheetType,
    required this.formType,
    this.hidePriceDialog = false,
    this.removeIntegratedSupplierItems = false,
    this.materialSupplierFormParams,
    this.showVariationConfirmationValidation = false
  });

  /// [isAnySupplierEnabled] helps in deciding whether any supplier is enabled or not
  bool get isAnySupplierEnabled {
    return isSRSEnable || isBeaconEnable || isAbcEnable;
  }

  /// [getSupplierDetails] gives supplier details based on active supplier
  String get getSupplierDetails {
    if (isSRSEnable) {
      // SRS branch details
      String label = '${'srs'.tr.toUpperCase()} ${'branch'.tr}';
      String branchName = selectedSrsBranch?.name ?? '';
      String branchCode = selectedSrsBranch?.branchCode ?? '';
      return '$label: $branchName ($branchCode)';
    } else if (isBeaconEnable) {
      // Beacon branch details
      String label = '${'qxo'.tr} ${'branch'.tr}';
      String branchName = selectedBeaconBranch?.name ?? '';
      String branchCode = selectedBeaconBranch?.branchCode ?? '';
      return '$label: $branchName ${branchCode.isNotEmpty ? '($branchCode)' : ''}';
    } else if (isAbcEnable) {
      // ABC branch details
      String label = '${'abc'.tr} ${'branch'.tr}';
      String branchName = selectedAbcBranch?.name ?? '';
      String branchCode = selectedAbcBranch?.branchCode ?? '';
      return '$label: $branchName ${branchCode.isNotEmpty ? '($branchCode)' : ''}';
    } else {
      // Default case
      return '';
    }
  }

  bool get hasTiers => lineItems.isNotEmpty && lineItems[0].type == WorksheetConstants.collection;
  bool get isEditForm => formType == WorksheetFormType.edit || worksheetId != null;
  bool get isUnsavedForm => dbUnsavedResourceId != null;

  /// [setFormData] initializes form with data
  void setFormData() {
    // in case of edit filling in worksheet details
    if (workSheet != null) {
      titleController.text = workSheet?.title ?? "";
      divisionController.text = workSheet?.division?.name ?? "";
      selectedDivisionId = (workSheet?.division?.id ?? "").toString();
      measurementId = int.tryParse(workSheet!.measurementId.toString());

      uploadedAttachments.clear();
      attachments.clear();
      // setting up attachment section
      uploadedAttachments.addAll(workSheet?.attachments ?? []);
      attachments.addAll(uploadedAttachments);
      note = workSheet?.note ?? "";
      setSupplierDetails();
      selectedTierSubTotal = workSheet?.selectedTierTotal ?? WorksheetConstants.tierSubTotal;
      final worksheetLineItems = workSheet?.lineItems ?? [];
      if (worksheetLineItems.isNotEmpty) {
        setLineItemsFromWorkSheet(worksheetLineItems);
      }
    }

    setSRSSupplierId();
    srsBranchList = [];
    shipToAddressList = [];
  }

  /// [worksheetJson] converts form data to json that can be stored on server
  /// [name] - helps in saving the name of the worksheet in case of save or creating
  /// new worksheet from tier
  /// [lineItems] - list of items for which have has to be prepared, It is kept dynamic as
  /// data can also be prepared for limited items
  Map<String, dynamic> worksheetJson(List<SheetLineItemModel> lineItems, {
    String? name,
    bool isPreview = false,
    bool isForUnsavedDB = false,
  }) {
    Map<String, dynamic> data = {};

    if (settings == null) return {};

    /// Basic data
    if (workSheet?.id != null && name == null) data['id'] = workSheet?.id;
    data['job_id'] = jobId;
    data['type'] = worksheetType;
    if (titleController.text.isNotEmpty) data['title'] = titleController.text;
    if (note.isNotEmpty) data['note'] = note;
    data['division_id'] = selectedDivisionId;

    data['re_calculate'] = "0";
    data['name'] = name ?? workSheet?.name;
    data['attachments[]'] = null;
    data['delete_attachments[]'] = null;
    data['is_qbd_worksheet'] = Helper.isTrueReverse(workSheet?.isQbdWorksheet);
    data['is_mobile'] = 1;

    /// Apply measurement
    data['measurement_id'] = worksheetMeasurement?.id;

    /// Tax Settings
    data['material_tax_rate'] = settings!.applyTaxMaterial! ? settings?.getMaterialTaxRate : "";
    if (settings!.applyTaxMaterial!) data['material_tax_amount'] = calculatedAmounts.materialTax;
    if (settings!.applyTaxMaterial!) data['material_custom_tax_id'] = settings?.selectedMaterialTaxRateId;
    data['labor_tax_rate'] = settings!.applyTaxLabor! ? settings?.getLaborTaxRate : "";
    if (settings!.applyTaxLabor!) data['labor_tax_amount'] = calculatedAmounts.laborTax;
    if (settings!.applyTaxLabor!) data['labor_custom_tax_id'] = settings?.selectedLaborTaxRateId;
    data['tax_rate'] = settings!.applyTaxAll! ? settings?.getTaxAllRate.toString() : "";
    if (settings!.applyTaxAll!) data['tax_amount'] = calculatedAmounts.taxAll;
    if (settings!.applyTaxAll!) data['custom_tax_id'] = settings?.selectedTaxRateId;
    data['taxable'] = Helper.isTrueReverse(settings?.applyTaxAll);
    data['line_tax'] = Helper.isTrueReverse(settings?.addLineItemTax);

    /// Other Settings
    data['overhead'] = settings!.applyOverhead! ? settings?.getOverHeadRate : "";
    data['profit'] = settings!.applyProfit! ? settings?.getOverAllProfitRate : "";
    if (settings!.applyProfit!) data['profit_amount'] = calculatedAmounts.profitMargin + calculatedAmounts.profitMarkup;
    if (settings!.applyProfit!) data['margin'] = Helper.isTrueReverse(!settings!.getIsOverAllProfitMarkup).toString();
    data['line_margin_markup'] = Helper.isTrueReverse(settings?.applyLineItemProfit);
    if (settings!.applyLineItemProfit!) data['margin'] = Helper.isTrueReverse(!settings!.getIsLineItemProfitMarkup).toString();
    data['enable_line_worksheet_profit'] = Helper.isTrueReverse(settings?.applyLineAndWorksheetProfit);
    if(Helper.isTrue(settings?.applyLineAndWorksheetProfit)) data['projected_profit_margin'] = Helper.isTrueReverse(!settings!.getIsOverAllProfitMarkup).toString();
    data['commission'] = settings!.applyCommission! ? settings?.getCommissionRate : "";
    if (settings!.applyCommission!) data['commission_amount'] = calculatedAmounts.commission;
    
    data['discount'] = settings?.applyDiscount?? false ? settings?.getDiscount : ''; 
    data['show_discount'] = Helper.isTrueReverse(settings?.showDiscount);
    
    // Saving/Updating Credit card fee in worksheet
    data['processing_fee_percentage'] = settings!.applyProcessingFee! ? settings?.getCardFeeRate : "";
    if (settings!.applyProcessingFee!) {
      // Amount and Contact total will be included only when card fee is applied
      // over the grand total
      data['processing_fee_amount'] = calculatedAmounts.creaditCardFee;
      data['contract_total'] = getContractTotal();
    }

    /// Line Item & Tier Settings
    data['only_description'] = settings?.descriptionOnly;
    data['description_only'] = Helper.isTrueReverse(settings?.descriptionOnly);

    if (settings?.descriptionOnly ?? false) {
      data['show_unit'] = Helper.isTrueReverse(settings?.showUnit);
      data['show_quantity'] = Helper.isTrueReverse(settings?.showQuantity);
      data['show_style'] = Helper.isTrueReverse(settings?.showStyle);
      data['show_size'] = Helper.isTrueReverse(settings?.showSize);
      data['show_color'] = Helper.isTrueReverse(settings?.showColor);
      data['show_variation'] = Helper.isTrueReverse(settings?.showVariation);
      data['show_supplier'] = Helper.isTrueReverse(settings?.showSupplier);
      data['show_trade_type'] = Helper.isTrueReverse(settings?.showTradeType);
      data['show_work_type'] = Helper.isTrueReverse(settings?.showWorkType);
    }

    bool showPricing = !settings!.hidePricing!;
    data['show_pricing'] = Helper.isTrueReverse(showPricing);
    data['hide_pricing'] = Helper.isTrueReverse(settings?.hidePricing);
    data['hide_customer_info'] = Helper.isTrueReverse(settings?.hideCustomerInfo);
    data['show_total'] = Helper.isTrueReverse(!(settings?.hideTotal ?? false));
    data['show_taxes'] = Helper.isTrueReverse(settings?.showTaxes);
    data['hide_total'] = Helper.isTrueReverse(!(settings?.showCalculationSummary ?? false) && settings!.hideTotal!);
    data['only_tier_total'] = settings?.showTierTotal;
    data['show_tier_total'] = Helper.isTrueReverse(settings?.showTierTotal);
    // Saving the setting in worksheet to whether display tier subtotals or not
    data['show_tier_sub_totals'] = Helper.isTrue(settings?.canShowTierSubTotals) ? Helper.isTrueReverse(settings?.showTierSubTotals) : 0;
    data['selected_tier_total'] = selectedTierSubTotal;
    if (!showPricing) data['show_line_total'] = Helper.isTrueReverse(settings?.showLineTotal);
    data['show_calculation_summary'] = Helper.isTrueReverse(settings?.showCalculationSummary);
    data['show_tier_color'] = Helper.isTrueReverse(settings?.showTierColor);

    /// Worksheet Pricing
    data['enable_selling_price'] = Helper.isTrueReverse(settings?.enableSellingPrice);
    if (settings?.isFixedPrice ?? false) data['fixed_price'] = calculatedAmounts.fixedPrice;

    data['show_no_charge'] = settings?.hasNoChargeItem;
    data['update_tax_order'] = 1;
    data['multi_tier'] = Helper.isTrueReverse(hasTiers);

    data.putIfAbsent('margin', () => 0);
    data['details'] = lineItems.map((item) => item.toWorksheetJson(
        isForUnsavedDB: isForUnsavedDB,
        isPreview: isPreview,
        branchDetails: getSelectedBranch()
    )).toList();
    data['includes[0]'] = "attachments";
    data['includes[1]'] = "job_estimate.my_favourite_entity";
    data['includes[2]'] = "suppliers";
    data['includes[3]'] = "custom_tax";
    data['includes[4]'] = "material_custom_tax";
    data['includes[5]'] = "labor_custom_tax";
    data['includes[6]'] = "branch";
    data['includes[7]'] = "division";
    data['includes[8]'] = "qbd_queue_status";
    data['includes[9]'] = "beacon_account";
    data['includes[10]'] = "beacon_job";
    data['includes[11]'] = "variants";
    if(selectedSrsShipToAddress != null) {
      data['includes[12]'] = "srs_ship_to_address";
    } else if(isAbcEnable) {
      data['includes[12]'] = "supplier_account";
    }

    if(isBeaconEnable || isSRSEnable || isAbcEnable) {
      final selectedBranch = getSelectedBranch();
      data["branch_code"] = selectedBranch?.branchCode;
      data["branch_id"] = selectedBranch?.branchId ?? "";

      if (isAbcEnable) {
        data["supplier_account_id"] = selectedAbcAccount?.shipToId;
        data["ship_to_sequence_number"] = "";
      } else {
        data["ship_to_sequence_number"] = selectedSrsShipToAddress?.shipToSequenceId ?? '0';
      }
      if(isBeaconEnable) {
        data["beacon_account_id"] = selectedBeaconAccount?.accountId ?? "";
        data["beacon_job_number"] = selectedBeaconJob?.jobNumber ?? "";
      }
    } else {
      data["branch_code"] = "";
      data["branch_id"] = "";
      data["ship_to_sequence_number"] = "";
      data["supplier_account_id"] = "";
      data["beacon_account_id"] = "";
      data["beacon_job_number"] = "";
    }

    if(isForUnsavedDB) {
      data['fixed_price'] = workSheet?.fixedPrice ?? "0";
      data['file'] = workSheet?.file?.toJson();
      data['is_srs_enable'] = isSRSEnable;
      data['is_beacon_enable'] = isBeaconEnable;
      data['srs_branch_model'] = selectedSrsBranch?.toJson();
      data['beacon_branch_model'] = selectedBeaconBranch?.toJson();
      data['beacon_job'] = selectedBeaconJob?.toJson();
      data['beacon_account'] = selectedBeaconAccount?.toJson();
      if (isAbcEnable) {
        data['supplier_account'] = selectedAbcAccount?.toJson();
        data['is_abc_enable'] = isAbcEnable;
        data['abc_branch_model'] = selectedAbcBranch?.toJson();
      }
    }

    if (selectedSrsShipToAddress != null) {
      data['srs_ship_to_address'] = selectedSrsShipToAddress?.toJson();
    }

    // Attachments section
    if(attachments.isNotEmpty || uploadedAttachments.isNotEmpty) {

      List<AttachmentResourceModel> attachmentsToUpload = [];
      List<AttachmentResourceModel> attachmentsToDelete = [];

      attachmentsToUpload = attachments.where((attachment) {
        return !uploadedAttachments.contains(attachment) || isPreview || selectedFromFavourite;
      }).toList();
      attachmentsToDelete = uploadedAttachments.where((attachment) => attachments.isEmpty || !attachments.contains(attachment)).toList();

      if(isForUnsavedDB) {
        data['attachments'] = attachmentsToUpload.map((attachment) => attachment.toJson()).toList();
        data['delete_attachments'] = attachmentsToDelete.map((attachment) => attachment.toJson()).toList();
      } else {
        data['attachments'] = attachmentsToUpload.map((attachment) => {
          'type': attachment.type ?? "resource",
          'value': attachment.id,
        }).toList();

        data['delete_attachments[]'] = attachmentsToDelete.map((attachment) => attachment.id).toList();
      }
  }
    if (!Helper.isValueNullOrEmpty(workSheet?.materialList)) {
      data['for_supplier_id'] = isSRSEnable ? srsSupplierId : workSheet?.forSupplierId;
    }
    return data;
  }

  

  /// [setInitialJson] helps in setting up initial json that can be further used
  /// for making comparison whether any changes in form are made or not
  void setInitialJson() {
    initialJson = worksheetJson(lineItems);
  }

  /// [checkIfNewDataAdded] compares initial json with current json and decides
  /// whether any new changes are made in the form or not
  bool checkIfNewDataAdded() {
    final currentJson = worksheetJson(lineItems);
    return initialJson.toString() != currentJson.toString();
  }

  /// [checkIfAnyItemToSave] checks whether is there any item added or not
  bool checkIfAnyItemToSave() {
    bool hasNoItem = false;
    if (hasTiers) {
      // checking added item in tiers
      hasNoItem = WorksheetHelpers.getParsedItems(lineItems: lineItems).isEmpty;
    } else {
      // checking added item in list without tiers
      hasNoItem = lineItems.isEmpty;
    }
    return hasNoItem;
  }

  /// [getWorksheetSettings] helps in loading worksheet settings from company settings
  /// that can be further used to show/hide content or performing calculations
  void getWorksheetSettings({bool forFavourite = false}) {
    try {
      final settingsKey = typeToSettingsKey();
      dynamic result = CompanySettingsService.getCompanySettingByKey(settingsKey);
      if (result == null || result is bool) {
        result = <String, dynamic>{};
      }
      // setting up settings loaded from company settings
      settings = WorksheetSettingModel.fromJson(result);
      if ((formType == WorksheetFormType.edit || forFavourite) && settingsJson != null) {
        // updating settings coming along in worksheet
        settings?.fromWorksheetJson(settingsJson!, workSheet);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// [setDivision] is responsible for updating selected division
  void setDivision(String id) {
    selectedDivisionId = id;
    final selectedDivision = FormValueSelectorService.getSelectedSingleSelect(allDivisions, selectedDivisionId);
    divisionController.text = selectedDivision.label;
  }

  String typeToSettingsKey() {
    switch (worksheetType) {
      case WorksheetConstants.estimate:
        return CompanySettingConstants.estimateWorksheet;

      case WorksheetConstants.materialList:
        return CompanySettingConstants.materialWorksheet;

      case WorksheetConstants.workOrder:
        return CompanySettingConstants.workOrderWorksheet;

      case WorksheetConstants.proposal:
        return CompanySettingConstants.proposalWorksheet;

      default:
        return "";
    }
  }

  bool isPlaceSRSOrder() {
    bool isSrsConnected = worksheetType != WorksheetConstants.workOrder && ConnectedThirdPartyService.isSrsConnected();
    bool isSupplierIdSame = Helper.isSRSv1Id(workSheet?.materialList?.forSupplierId) || Helper.isSRSv2Id(workSheet?.materialList?.forSupplierId);
    return isSrsConnected && isSupplierIdSame && isEditForm && isSRSEnable;
  }

  /// [isPlaceBeaconOrder] Checks if the order is a place beacon order.
  /// Returns [True] if the order is a place beacon order, false otherwise.
  bool isPlaceBeaconOrder() {
    // Check if the worksheet type is not a work order and the beacon is connected
    bool isBeaconConnected = worksheetType != WorksheetConstants.workOrder && ConnectedThirdPartyService.isBeaconConnected();
    // Check if the supplier ID is the same as the beacon ID
    bool isSupplierIdSame = workSheet?.materialList?.forSupplierId == Helper.getSupplierId(key: CommonConstants.beaconId);
    // Return true if the order meets all the conditions
    return isBeaconConnected && isSupplierIdSame && isEditForm && isBeaconEnable;
  }

  /// [isPlaceABCOrder] Checks if the order is a place ABC order.
  /// Returns [True] if the order is a place ABC order, false otherwise.
  bool isPlaceABCOrder() {
    // Check if the worksheet type is not a work order and the ABC is connected
    bool isABCConnected = worksheetType != WorksheetConstants.workOrder
        && ConnectedThirdPartyService.isAbcConnected();
    // Check if the supplier ID is the same as the ABC ID
    bool isSupplierIdSame = Helper.isABCSupplierId(workSheet?.materialList?.forSupplierId);
    // Return true if the order meets all the conditions
    return isABCConnected && isSupplierIdSame && isEditForm && isAbcEnable;
  }

  SheetLineItemModel getParsedSheetLineItem(FinancialProductModel financialProductModel) {
    return SheetLineItemModel(
        productId: financialProductModel.id.toString(),
        title: financialProductModel.name,
        price: financialProductModel.sellingPrice,
        qty: '0',
        totalPrice: '0',
        category: financialProductModel.productCategory,
        supplier: financialProductModel.supplier,
        supplierId: financialProductModel.supplierId.toString(),
        productName: financialProductModel.name,
        product: financialProductModel,
        unit: financialProductModel.unit,
        unitCost: financialProductModel.unitCost,
        description: financialProductModel.description,
        workSheetSettings: settings,
    );
  }

  /// [setUnsavedResourceType] is responsible for updating auto save worksheet type
  void setUnsavedResourceType() {
    switch (worksheetType) {
      case WorksheetConstants.estimate:
        unsavedResourcesType = UnsavedResourceType.estimateWorksheet;
        break;
      case WorksheetConstants.materialList:
        unsavedResourcesType = UnsavedResourceType.materialWorksheet;
        break;
      case WorksheetConstants.workOrder:
        unsavedResourcesType = UnsavedResourceType.workOrderWorksheet;
        break;
      case WorksheetConstants.proposal:
        unsavedResourcesType = UnsavedResourceType.proposalWorksheet;
        break;
    }
  }

  /// [setWorksheetFormData] is responsible for setting auto save worksheet data in form
  void setWorksheetFormData() {
    Map<String, dynamic> data;
    if(unsavedResourceJson?["created_through"] == "v1") {
      data = FormsDBHelper.getOldAppUnsavedResourcesJsonData(unsavedResourceJson);
      workSheet = WorksheetModel.fromWorksheetJson(data);
      settingsJson = workSheet?.toJson(fromWorkSheetJson: true);
      isSRSEnable = data['is_srs_enable'];
      formType = data['isEditForm'] ? WorksheetFormType.edit : WorksheetFormType.add;
      getWorksheetSettings(forFavourite: true);
    } else {
      data = FormsDBHelper.getUnsavedResourcesJsonData(unsavedResourceJson);
      formType = data['isEditForm'] ? WorksheetFormType.edit : WorksheetFormType.add;
      //  get worksheet and worksheet settings data
      Map<String, dynamic> tempWorkSheet = data['workSheet'];
      Map<String, dynamic> tempSettings = data['workSheetSetting'];
      settingsJson = data['settingsJson'];
      settings = WorksheetSettingModel.fromJson(tempSettings);
      worksheetType = tempWorkSheet['type'];
      jobId = tempWorkSheet['job_id'];
      selectedDivisionId = tempWorkSheet['division_id'];
      //    binding worksheet data
      workSheet = WorksheetModel(
        id: tempWorkSheet['id'],
        name: tempWorkSheet['name'],
        title: tempWorkSheet['title'],
        note: tempWorkSheet['note'],
        division: DivisionModel(id: int.tryParse(tempWorkSheet['division_id'])),
        isQbdWorksheet: Helper.isTrue(tempWorkSheet['is_qbd_worksheet']),
        measurementId: tempWorkSheet['measurement_id'].toString(),
        materialTaxRate: tempWorkSheet['material_tax_rate'].toString(),
        laborTaxRate: tempWorkSheet['labor_tax_rate'].toString(),
        taxRate: tempWorkSheet['tax_rate'],
        taxable: tempWorkSheet['taxable'],
        lineTax: tempWorkSheet['line_tax'],
        overhead: tempWorkSheet['overhead'].toString(),
        profit: tempWorkSheet['profit'].toString(),
        lineMarginMarkup: tempWorkSheet['line_margin_markup'],
        commission: tempWorkSheet['commission'].toString(),
        discount: tempWorkSheet['discount'].toString(),
        processingFee: tempWorkSheet['processing_fee_percentage'].toString(),
        descriptionOnly: tempWorkSheet['description_only'],
        hidePricing: tempWorkSheet['hide_pricing'],
        hideCustomerInfo: tempWorkSheet['hide_customer_info'],
        hideTotal: tempWorkSheet['hide_total'],
        showTierTotal: tempWorkSheet['show_tier_total'],
        isShowLineTotal: Helper.isTrue(tempWorkSheet['show_line_total']),
        showCalculationSummary: tempWorkSheet['show_calculation_summary'],
        isShowTierColor: Helper.isTrue(tempWorkSheet['show_tier_color']),
        isEnableSellingPrice: Helper.isTrue(tempWorkSheet['enable_selling_price']),
        updateTaxOrder: tempWorkSheet['update_tax_order'],
        isMultiTier: Helper.isTrue(tempWorkSheet['multi_tier']),
        margin: int.tryParse(tempWorkSheet['margin'].toString()),
        projectedProfitMargin: int.tryParse(tempWorkSheet['projected_profit_margin'].toString()),
        branchCode: tempWorkSheet['branch_code'],
        shipToSequenceNumber: tempWorkSheet['ship_to_sequence_number'],
        showQuantity: tempSettings['show_quantity'] ?? false ? 1 : 0,
        showUnit: tempSettings['show_unit'] ?? false ? 1 : 0,
        isShowStyle: tempSettings['show_style'],
        isShowSize: tempSettings['show_size'],
        isShowColor: tempSettings['show_color'],
        isShowSupplier: tempSettings['show_supplier'],
        isShowTradeType: tempSettings['show_trade_type'],
        isShowWorkType: tempSettings['show_work_type'],
        showDiscount: tempSettings['show_discount'],
        fixedPrice: tempWorkSheet["fixed_price"],
        file: tempWorkSheet['file'] is Map ? FilesListingModel.fromEstimatesJson(tempWorkSheet['file']) : null,
        selectedTierTotal: tempWorkSheet['selected_tier_total'],
        isEnableLineAndWorksheetProfit: Helper.isTrue(tempWorkSheet['enable_line_worksheet_profit']),
      );
      isSRSEnable = tempWorkSheet['is_srs_enable'] ?? false;
      if(isSRSEnable) {
        workSheet?.supplierType = MaterialSupplierType.srs;
        selectedSrsBranch = tempWorkSheet['srs_branch_model'] is Map ? SupplierBranchModel.fromJson(tempWorkSheet['srs_branch_model']) : null;
        selectedSrsShipToAddress = tempWorkSheet['srs_ship_to_address'] is Map ? SrsShipToAddressModel.fromJson(tempWorkSheet['srs_ship_to_address']) : null;
      }

      isBeaconEnable = tempWorkSheet['is_beacon_enable'] ?? false;
      if (isBeaconEnable) {
        workSheet?.supplierType = MaterialSupplierType.beacon;
        selectedBeaconBranch = tempWorkSheet['beacon_branch_model'] is Map ? SupplierBranchModel.fromJson(tempWorkSheet['beacon_branch_model']) : null;
        selectedBeaconAccount = tempWorkSheet['beacon_account'] is Map ? BeaconAccountModel.fromJson(tempWorkSheet['beacon_account']) : null;
        selectedBeaconJob = tempWorkSheet['beacon_job'] is Map ? BeaconJobModel.fromJson(tempWorkSheet['beacon_job']) : null;
      }

      isAbcEnable = tempWorkSheet['is_abc_enable'] ?? false;
      if(isAbcEnable) {
        workSheet?.supplierType = MaterialSupplierType.abc;
        selectedAbcBranch = tempWorkSheet['abc_branch_model'] is Map ? SupplierBranchModel.fromJson(tempWorkSheet['abc_branch_model']) : null;
        selectedAbcAccount = tempWorkSheet['supplier_account'] is Map ? SrsShipToAddressModel.fromJson(tempWorkSheet['supplier_account']) : null;
      }

      //     binding sheet line items data
      if (tempWorkSheet['details'] is List) {
        lineItems = <SheetLineItemModel>[];
        tempWorkSheet['details'].forEach((dynamic item) {
          if (item['type'] == WorksheetConstants.item) {
            final tempItem = SheetLineItemModel.fromWorkSheetJson(item['data'] ?? item);
            tempItem.type = item['type'];
            lineItems.add(tempItem);
          } else {
            lineItems.add(SheetLineItemModel.fromWorkSheetJson(item));
          }
        });
      }
      //    binding worksheet settings with line items
      settings?.fromWorksheetJson(tempWorkSheet, workSheet);
      //    binding attachments data
      workSheet?.attachments = [];
      uploadedAttachments = [];
      (tempWorkSheet["attachments"] as List?)?.forEach((element) => workSheet?.attachments?.add(AttachmentResourceModel.fromJson(element)));
      (tempWorkSheet["delete_attachments"] as List?)?.forEach((element) => uploadedAttachments.add(AttachmentResourceModel.fromJson(element)));
      //    binding division data
      if(workSheet?.division?.id != null) {
        final selectedDivision = FormValueSelectorService.getSelectedSingleSelect(allDivisions, workSheet?.division?.id?.toString() ?? "");
        workSheet?.division = DivisionModel(id: int.tryParse(selectedDivision.id), name: selectedDivision.label);
      }
    }
  }

  /// [getSelectedBranch] gives the selected branch based on the enabled supplier (SRS or Beacon).
  /// If SRS is enabled, it returns the selected SRS branch.
  /// If Beacon is enabled, it returns the selected Beacon branch.
  /// If neither SRS nor Beacon is enabled, it returns null.
  SupplierBranchModel? getSelectedBranch() {
    if (isSRSEnable) {
      return selectedSrsBranch;
    } else if (isBeaconEnable) {
      return selectedBeaconBranch;
    } else if(isAbcEnable) {
      return selectedAbcBranch;
    }
    return null;
  }

  /// [getSelectedSupplier] gives the selected material supplier type based on the enabled supplier.
  ///
  /// If [isSRSEnable] is true, returns [MaterialSupplierType.srs].
  /// If [isBeaconEnable] is true, returns [MaterialSupplierType.beacon].
  /// Otherwise, returns null.
  MaterialSupplierType? getSelectedSupplier() {
    if (isSRSEnable) {
      return MaterialSupplierType.srs;
    } else if (isBeaconEnable) {
      return MaterialSupplierType.beacon;
    } else if(isAbcEnable) {
      return MaterialSupplierType.abc;
    }
    return null;
  }

  /// [getActiveSupplierId] gives the active supplier ID based on the enabled supplier.
  String? getActiveSupplierId() {
    if (isSRSEnable) {
      // Return the SRS supplier ID if SRS is enabled
      return CommonConstants.srsId;
    } else if (isBeaconEnable) {
      // Return the beacon supplier ID if beacon is enabled
      return CommonConstants.beaconId;
    } else if (isAbcEnable) {
      // Return the ABC supplier ID if ABC is enabled
      return CommonConstants.abcSupplierId;
    }
    // Return null if no supplier is enabled
    return null;
  }

  /// [setSupplierDetails] Sets the supplier details based on the type of supplier.
  void setSupplierDetails() {
    if(materialSupplierFormParams != null) {
      setIntegratedSupplierDetails();
    }
    switch (workSheet?.supplierType) {
      case MaterialSupplierType.srs:
      // Set SRS details
        isSRSEnable = true;
        selectedSrsShipToAddress = workSheet?.srsShipToAddressModel ?? selectedSrsShipToAddress;
        selectedSrsBranch = workSheet?.supplierBranch ?? selectedSrsBranch;
        break;
      case MaterialSupplierType.beacon:
      // Set Beacon details
        selectedBeaconAccount = workSheet?.beaconAccountModel ?? selectedBeaconAccount;
        selectedBeaconBranch = workSheet?.supplierBranch ?? selectedBeaconBranch;
        selectedBeaconJob = workSheet?.beaconJob ?? selectedBeaconJob;
        isBeaconEnable = true;
        break;
      case MaterialSupplierType.abc:
      // Set Beacon details
        selectedAbcAccount = workSheet?.abcAccountModel ?? selectedAbcAccount;
        selectedAbcBranch = workSheet?.supplierBranch ?? selectedAbcBranch;
        isAbcEnable = true;
        break;
      default:
        resetSupplier();
        break;
    }
  }

  /// [resetSupplier] resets the supplier details
  void resetSupplier() {
    selectedSrsShipToAddress = null;
    selectedSrsBranch = null;
    selectedBeaconAccount = null;
    selectedBeaconBranch = null;
    selectedBeaconJob = null;
    selectedAbcAccount = null;
    selectedAbcBranch = null;
    isSRSEnable = false;
    isBeaconEnable = false;
    isAbcEnable = false;
  }

  /// [getGrandTotal] give the grand total to be displayed accordingly when
  /// fixed price is to be displayed or the list total
  num getGrandTotal() {
    if (settings?.isFixedPrice ?? false) {
      return calculatedAmounts.fixedPrice;
    }
    return calculatedAmounts.listTotal;
  }

  /// [getContractTotal] give the contract total to be displayed accordingly when
  /// card fee is applied over the grand total
  num getContractTotal() {
    final grandTotal = getGrandTotal();
    final contractTotal = grandTotal + calculatedAmounts.creaditCardFee;
    return Helper.isTrue(settings?.applyProcessingFee) ? contractTotal : grandTotal;
  }

  /// [showTierSubtotals] help is displaying subtotals selector on tier level
  /// It will be in effect only when MetroBath feature is enabled and
  /// Tier Subtotals setting is enabled
  bool doShowTierSubTotals() {
    return LDService.hasFeatureEnabled(LDFlagKeyConstants.metroBathFeature)
        && Helper.isTrue(settings?.showTierSubTotals)
        && Helper.isTrue(settings?.canShowTierSubTotals)
        && !Helper.isTrue(settings?.hidePricing);
  }

  /// [getTierSubtotalTitle] helps in getting the title as per type of the
  /// subtotal to be displayed in option as well as selector
  String getTierSubtotalTitle(String value) {
    switch (value) {
      case WorksheetConstants.tierProfit:
        return "${value.tr} (${Helper.isTrue(settings?.isLineItemProfitMarkup) ? 'markup'.tr : 'margin'.tr}) :";
      default:
        return "${value.tr}:";
    }
  }

  /// [getTierSubTotalAmount] helps in getting the amount as per type of the
  /// subtotal to be displayed in option as well as selector
  String getTierSubTotalAmount(String value, SheetLineItemModel? tierItem) {
    switch (value) {
      case WorksheetConstants.tierSubTotal:
        return tierItem?.totalPrice.toString() ?? "0";

      case WorksheetConstants.tierLineTotal:
        return tierItem?.tiersLineTotal.toString() ?? "0";

      case WorksheetConstants.tierProfit:
        return tierItem?.lineProfitAmt.toString() ?? "0";

      case WorksheetConstants.tierTax:
        return tierItem?.lineTaxAmt.toString() ?? "0";

      default:
        return "0";
    }
  }

  void setSRSSupplierId() {
    if(!Helper.isValueNullOrEmpty(workSheet?.suppliers)) {
      int? supplierId = workSheet?.suppliers?.first.id;
      if(Helper.isSRSv1Id(supplierId) || Helper.isSRSv2Id(supplierId)) {
        srsSupplierId = supplierId;
      }
    }
    srsSupplierId ??= Helper.getSupplierId();
  }

  /// [getStickySelectedTrade] gives the default trade type for a worksheet new worksheet line item to be added.
  ///
  /// This function determines the default trade type based on the following criteria:
  /// 1. If the line item above the current one has a trade type, it uses that.
  /// 2. If the settings specify that no trade type should be used, it trade type will not be populated.
  /// 3. If the settings specify to inherit the trade type from the job, it uses the job's trade type.
  ///    - NOTE: If Job has ROOFING trade type it will be prioritised over others
  /// 4. If the settings specify a default trade type, it uses that.
  ///
  /// Params: [index] The index of the selected tier.
  /// Returns: The default trade type, or null if none is applicable.
  CompanyTradesModel? getStickySelectedTrade({int? index}) {
    // Get the line item above the current one to be added
    final item =  WorksheetHelpers.getLineItemAbove(lineItems: lineItems, tierIndex: index);

    // If the line item above has a trade type, use it
    bool doPickTradeFromLastLineItem = item?.tradeType != null;
    if (doPickTradeFromLastLineItem) {
      return CompanyTradesModel(
        id: int.tryParse(item!.tradeType!.id.toString()),
        name: item.tradeType!.label
      );
    }

    // If the settings specify no trade type, no need to populate it
    if (Helper.isTrue(settings?.tradeTypeDefaultDetails?.isNone)) return null;

    if (!Helper.isValueNullOrEmpty(settings?.tradeTypeDefaultDetails?.trade)) {
      // If the settings specify a default trade type, use it
      return settings?.tradeTypeDefaultDetails?.trade;
    } else if (Helper.isTrue(settings?.tradeTypeDefaultDetails?.inheritFromJob)) {
      // If the settings specify to inherit the trade type from the job
      bool hasMultipleTrades = (job?.trades?.length ?? 0) > 1;
      if (hasMultipleTrades) {
        // If the job has multiple trades, use the ROOFING trade if available, otherwise use the first trade
        CompanyTradesModel? roofingTrade = job?.trades?.firstWhereOrNull((trade) => trade.name?.toUpperCase().trim() == WorksheetConstants.roofingTradeType);
        return roofingTrade ?? job?.trades?.first;
      }
      // If the job has only one trade, use it
      return !Helper.isValueNullOrEmpty(job?.trades) ? job?.trades?.first : null;
    }

    // If none of the above conditions are met, populate nothing
    return null;
  }

  /// [setLineItemsFromWorkSheet] - Sets the line items from the worksheet line items.
  /// If [removeIntegratedSupplierItems] is true, it removes integrated supplier items.
  void setLineItemsFromWorkSheet(List<SheetLineItemModel> worksheetLineItems) {
    // Initialize lineItems as an empty list
    lineItems = [];
    // Check if integrated supplier items should be removed
    if (removeIntegratedSupplierItems) {
      // Iterate through each line item in the worksheet line items
      for (SheetLineItemModel lineItem in worksheetLineItems) {
        int? supplierId = int.tryParse(lineItem.supplierId ?? '');
        // Check if the supplier is non-integrated
        if (Helper.isNonIntegratedSupplier(supplierId)) {
          // Initialize subTierLineItems as an empty list
          final List<SheetLineItemModel> subTierLineItems = [];
          // Check if the line item has sub-tiers
          if (!Helper.isValueNullOrEmpty(lineItem.subTiers)) {
            // Iterate through each sub-tier in the line item's sub-tiers
            WorksheetHelpers.tierListIterator(lineItem.subTiers!, action: (subTier) {
              // Initialize subItemLineItems as an empty list
              final List<SheetLineItemModel> subItemLineItems = [];
              // Check if the sub-tier has sub-items
              if (!Helper.isValueNullOrEmpty(subTier.subItems)) {
                // Iterate through each sub-item in the sub-tier's sub-items
                for (SheetLineItemModel subItem in subTier.subItems!) {
                  int? subItemSupplierId = int.tryParse(subItem.supplierId ?? '');
                  // Check if the sub-item supplier is non-integrated
                  if (Helper.isNonIntegratedSupplier(subItemSupplierId)) {
                    // Add the sub-item to the subItemLineItems list
                    subItemLineItems.add(subItem);
                  }
                }
              }
              // Set the sub-tier's sub-items to the filtered subItemLineItems
              subTier.subItems = subItemLineItems;
              // Add the sub-tier to the subTierLineItems list
              subTierLineItems.add(subTier);
            });
          }
          // Set the line item's sub-tiers to the filtered subTierLineItems
          lineItem.subTiers = subTierLineItems;
          // Add the line item to the lineItems list
          lineItems.add(lineItem);
        }
      }
    } else {
      // Set line items normally without removing integrated supplier items
      if(isPlaceSupplierOrder()) {
        lineItems = WorksheetHelpers.getParsedItems(lineItems: worksheetLineItems);
      } else {
        lineItems = worksheetLineItems;
      }
    }
  }

  /// [setIntegratedSupplierDetails] sets the integrated supplier details
  void setIntegratedSupplierDetails() {
    workSheet?.supplierType = materialSupplierFormParams?.type;
    workSheet?.srsShipToAddressModel = materialSupplierFormParams?.srsShipToAddress;
    workSheet?.beaconAccountModel = materialSupplierFormParams?.beaconAccount;
    workSheet?.abcAccountModel = materialSupplierFormParams?.abcAccount;
    if(materialSupplierFormParams?.srsBranch != null) {
      workSheet?.supplierBranch = materialSupplierFormParams?.srsBranch;
    } else if(materialSupplierFormParams?.beaconBranch != null) {
      workSheet?.supplierBranch = materialSupplierFormParams?.beaconBranch;
    } else if(materialSupplierFormParams?.abcBranch != null) {
      workSheet?.supplierBranch = materialSupplierFormParams?.abcBranch;
    }
    workSheet?.beaconJob = materialSupplierFormParams!.beaconJob;
    materialSupplierFormParams = null;
  }

  /// [isPlaceSupplierOrder] checks if the current worksheet is for placing a supplier order.
  bool isPlaceSupplierOrder() => isPlaceSRSOrder() || isPlaceBeaconOrder() || isPlaceABCOrder();
}
import 'package:jobprogress/common/enums/supplier_form_type.dart';
import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/job/job_division.dart';
import 'package:jobprogress/common/models/job_financial/tax_model.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/common/models/suppliers/beacon/account.dart';
import 'package:jobprogress/common/models/suppliers/beacon/job.dart';
import 'package:jobprogress/common/models/suppliers/branch.dart';
import 'package:jobprogress/common/models/suppliers/srs/srs_ship_to_address.dart';
import 'package:jobprogress/common/models/suppliers/suppliers.dart';
import 'package:jobprogress/common/models/worksheet/settings/settings.dart';
import 'package:jobprogress/common/services/worksheet/helpers.dart';
import 'package:jobprogress/core/constants/worksheet.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import '../files_listing/linked_material.dart';
import 'worksheet_detail_model.dart';
import 'worksheet_meta.dart';

class WorksheetModel {

  int? id;
  int? jobId;
  String? name;
  String? title;
  int? order;
  String? overhead;
  String? discount;
  String? discountAmount;
  String? processingFee;
  String? processingFeeAmount;
  String? measurementId;
  String? profit;
  String? type;
  int? taxable;
  String? taxRate;
  String? total;
  int? enableActualCost;
  String? sellingPriceTotal;
  String? filePath;
  String? fileSize;
  String? note;
  String? thumb;
  String? customTaxId;
  int? hidePricing;
  int? showTierTotal;
  bool? isEnableSellingPrice;
  bool? isEnableLineAndWorksheetProfit;
  String? materialTaxRate;
  String? laborTaxRate;
  String? commission;
  bool? isReCalculate;
  bool? isMultiTier;
  int? margin;
  int? projectedProfitMargin;
  String? createdAt;
  String? updatedAt;
  String? materialCustomTaxId;
  String? laborCustomTaxId;
  int? descriptionOnly;
  int? hideCustomerInfo;
  int? showQuantity;
  String? insuranceMeta;
  int? showUnit;
  int? lineTax;
  int? lineMarginMarkup;
  String? branchCode;
  String? shipToSequenceNumber;
  int? updateTaxOrder;
  bool? isSrsOldWorksheet;
  int? showCalculationSummary;
  bool? isSyncOnQbd;
  bool? isQbdWorksheet;
  int? pagesExist;
  int? pagesRequired;
  bool? isCollapseAllLineItems;
  bool? isShowLineTotal;
  String? fixedPrice;
  bool? enableJobCommission;
  bool? isShowStyle;
  bool? isShowSize;
  bool? isShowColor;
  bool? isShowVariation;
  bool? isShowSupplier;
  bool? isShowTradeType;
  bool? isShowWorkType;
  bool? isShowTierColor;
  int? hideTotal;
  int? showTaxes;
  int? showDiscount;
  List<SheetLineItemModel>? lineItems;
  List<WorksheetDetailModel?>? details;
  List<String>? detailsType;
  String? jobPrice;
  WorksheetModel? worksheet;
  List<SuppliersModel>? suppliers;
  DivisionModel? division;
  int? proposalId;
  String? materialListId;
  List<AttachmentResourceModel>? attachments;
  FilesListingModel? file;
  TaxModel? customTax;
  TaxModel? customMaterialTax;
  TaxModel? customLaborTax;
  SrsShipToAddressModel? srsShipToAddressModel;
  SrsShipToAddressModel? abcAccountModel;
  BeaconAccountModel? beaconAccountModel;
  SupplierBranchModel? supplierBranch;
  int? linkId;
  String? linkType;
  int? forSupplierId;
  LinkedMaterialModel? materialList;
  WorksheetMeta? meta;
  MaterialSupplierType? supplierType;
  String? beaconJobNumber;
  String? beaconAccountId;
  BeaconJobModel? beaconJob;
  /// [selectedTierTotal] helps in displaying subtotal at tier level
  String? selectedTierTotal;
  String? supplierAccountId;
  String? origin;


  WorksheetModel({
    this.id,
    this.jobId,
    this.name,
    this.title,
    this.order,
    this.overhead,
    this.processingFee,
    this.processingFeeAmount,
    this.profit,
    this.type,
    this.taxable,
    this.taxRate,
    this.total,
    this.measurementId,
    this.enableActualCost,
    this.sellingPriceTotal,
    this.file,
    this.filePath,
    this.fileSize,
    this.note,
    this.thumb,
    this.customTaxId,
    this.hidePricing,
    this.showTierTotal,
    this.isEnableSellingPrice,
    this.isEnableLineAndWorksheetProfit,
    this.materialTaxRate,
    this.laborTaxRate,
    this.commission,
    this.isReCalculate,
    this.isMultiTier,
    this.margin,
    this.projectedProfitMargin,
    this.createdAt,
    this.updatedAt,
    this.materialCustomTaxId,
    this.laborCustomTaxId,
    this.descriptionOnly,
    this.hideCustomerInfo,
    this.showQuantity,
    this.insuranceMeta,
    this.showUnit,
    this.lineTax,
    this.lineMarginMarkup,
    this.branchCode,
    this.shipToSequenceNumber,
    this.updateTaxOrder,
    this.isSrsOldWorksheet,
    this.showCalculationSummary,
    this.isSyncOnQbd,
    this.isQbdWorksheet,
    this.pagesExist,
    this.pagesRequired,
    this.isCollapseAllLineItems,
    this.isShowLineTotal,
    this.fixedPrice,
    this.enableJobCommission,
    this.isShowStyle,
    this.isShowSize,
    this.isShowColor,
    this.isShowVariation,
    this.isShowSupplier,
    this.isShowTradeType,
    this.isShowWorkType,
    this.isShowTierColor,
    this.hideTotal,
    this.showTaxes,
    this.showDiscount,
    this.discountAmount,
    this.discount,
    this.lineItems,
    this.detailsType,
    this.jobPrice,
    this.division,
    this.proposalId,
    this.materialListId,
    this.suppliers,
    this.srsShipToAddressModel,
    this.supplierBranch,
    this.meta,
    this.beaconAccountId,
    this.selectedTierTotal,
    this.supplierAccountId,
    this.origin
  });

  WorksheetModel.fromProfitLossSummaryJson(Map<String, dynamic> json) {
    jobId = int.tryParse(json['job_id']?.toString() ?? '');
    jobPrice = json['job_price']?.toString();
    taxRate = json['tax_rate']?.toString();
    worksheet = (json['worksheet'] != null && (json['worksheet'] is Map)) ? WorksheetModel.fromJson(json['worksheet']) : null;
  }

  WorksheetModel.fromJson(Map<String, dynamic> json,{bool isInsurance = false}) {
    id = int.tryParse(json['id']?.toString() ?? '');
    jobId = int.tryParse(json['job_id']?.toString() ?? '');
    name = json['name']?.toString();
    title = json['title']?.toString();
    order = int.tryParse(json['order']?.toString() ?? '');
    overhead = json['overhead']?.toString();
    discount = json['discount']?.toString();
    processingFee = num.tryParse(json['processing_fee_percentage'].toString()).toString();
    processingFeeAmount = num.tryParse(json['processing_fee_amount'].toString()).toString();
    profit = json['profit']?.toString();
    type = json['type']?.toString();
    taxable = int.tryParse(json['taxable']?.toString() ?? '');
    taxRate = json['tax_rate']?.toString();
    total = json['total']?.toString();
    enableActualCost = int.tryParse(json['enable_actual_cost']?.toString() ?? '');
    sellingPriceTotal = json['selling_price_total']?.toString();
    filePath = json['file_path']?.toString();
    fileSize = json['file_size']?.toString();
    note = json['note']?.toString();
    thumb = json['thumb']?.toString();
    customTaxId = json['custom_tax_id']?.toString();
    hidePricing = int.tryParse(json['hide_pricing']?.toString() ?? '');
    showTierTotal = int.tryParse(json['show_tier_total']?.toString() ?? '');
    isEnableSellingPrice = Helper.isTrue(json['enable_selling_price']);
    materialTaxRate = json['material_tax_rate']?.toString();
    laborTaxRate = json['labor_tax_rate']?.toString();
    commission = json['commission']?.toString();
    isReCalculate = Helper.isTrue(json['re_calculate']);
    isMultiTier = Helper.isTrue(json['multi_tier']);
    margin = int.tryParse(json['margin']?.toString() ?? '');
    projectedProfitMargin = int.tryParse(json['projected_profit_margin']?.toString() ?? '');
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    materialCustomTaxId = json['material_custom_tax_id']?.toString();
    laborCustomTaxId = json['labor_custom_tax_id']?.toString();
    descriptionOnly = int.tryParse(json['description_only']?.toString() ?? '');
    hideCustomerInfo = int.tryParse(json['hide_customer_info']?.toString() ?? '');
    showQuantity = int.tryParse(json['show_quantity']?.toString() ?? '');
    insuranceMeta = json['insurance_meta']?.toString();
    showUnit = int.tryParse(json['show_unit']?.toString() ?? '');
    lineTax = int.tryParse(json['line_tax']?.toString() ?? '');
    lineMarginMarkup = int.tryParse(json['line_margin_markup']?.toString() ?? '');
    branchCode = json['branch_code']?.toString();
    shipToSequenceNumber = json['ship_to_sequence_number']?.toString();
    updateTaxOrder = int.tryParse(json['update_tax_order']?.toString() ?? '');
    isSrsOldWorksheet = Helper.isTrue(json['srs_old_worksheet']);
    showCalculationSummary = int.tryParse(json['show_calculation_summary']?.toString() ?? '');
    isSyncOnQbd = Helper.isTrue(json['sync_on_qbd']);
    isQbdWorksheet = Helper.isTrue(json['is_qbd_worksheet']);
    pagesExist = int.tryParse(json['pages_exist']?.toString() ?? '');
    pagesRequired = int.tryParse(json['pages_required']?.toString() ?? '');
    isCollapseAllLineItems = Helper.isTrue(json['collapse_all_line_items']);
    isShowLineTotal = Helper.isTrue(json['show_line_total']);
    fixedPrice = json['fixed_price']?.toString();
    enableJobCommission = Helper.isTrue(json['enable_job_commission']);
    isShowStyle = Helper.isTrue(json['show_style']);
    isShowSize = Helper.isTrue(json['show_size']);
    measurementId = json['job_estimate']?['measurement_id']?.toString()?? '';
    isShowColor = Helper.isTrue(json['show_color']);
    isShowVariation = Helper.isTrue(json['show_variation']);
    isShowSupplier = Helper.isTrue(json['show_supplier']);
    isShowTradeType = Helper.isTrue(json['show_trade_type']);
    isShowWorkType = Helper.isTrue(json['show_work_type']);
    isShowTierColor = Helper.isTrue(json['show_tier_color']);
    hideTotal = int.tryParse(json['hide_total']?.toString() ?? '');
    showTaxes = int.tryParse(json['show_taxes']?.toString() ?? '');
    isEnableLineAndWorksheetProfit = Helper.isTrue(json['enable_line_worksheet_profit']);
    if (json['details'] != null && (json['details'] is List)) {
      detailsType = <String>[];
      lineItems = <SheetLineItemModel>[];
      json['details'].forEach((dynamic v) {
        detailsType!.add(v["type"]);

        if(v['data'] is Map) {
          isInsurance ? lineItems!.add(SheetLineItemModel.fromEstimateJson(v['data'])):
          lineItems!.add(SheetLineItemModel.fromFileListingJson(v['data']));
        } else {
          lineItems = v['data'].map<SheetLineItemModel>((dynamic data) {
            if(data['data'] is Map) {
              return isInsurance ?
              SheetLineItemModel.fromEstimateJson(data['data']) :
              SheetLineItemModel.fromFileListingJson(data['data']);
            } else {
              return isInsurance ?
              SheetLineItemModel.fromEstimateJson({}):
              SheetLineItemModel.fromFileListingJson(data);
            } 
          }
          ).toList();
        }
      });
    }
    if (json['suppliers']?['data'] != null && (json['suppliers']?['data'] is List)) {
      suppliers = <SuppliersModel>[];
      json['suppliers']['data'].forEach((dynamic v) {
        suppliers!.add(SuppliersModel.fromJson(v)) ;
      });
    }
    division = (json['division'] != null && (json['division'] is Map))
        ? DivisionModel.fromJson(json["division"]) : null;
    if (json['details'] != null && (json['details'] is List)) {
      detailsType = <String>[];
      details = <WorksheetDetailModel>[];
      json['details'].forEach((dynamic v) {
        detailsType!.add(v["type"]) ;
        if(v['data'] is Map) {
          details!.add(WorksheetDetailModel.fromJson(v["data"]));
        } else {
          details = v["data"].map<WorksheetDetailModel>((dynamic data) => WorksheetDetailModel.fromJson(data)).toList();
        }
      });
    }
    proposalId = int.tryParse(json["job_proposal"]?["id"]?.toString() ?? '');
    materialListId = json['material_list']?['id']?.toString();
    supplierBranch = json["branch"] is Map ? SupplierBranchModel.fromJson(json["branch"]) : null;
    meta = json['meta'] is Map ? WorksheetMeta.fromJson(json['meta']) : null;
    beaconJobNumber = json['beacon_job_number']?.toString();
    beaconAccountId = json['beacon_account_id']?.toString();
    beaconJob = json['beacon_job'] is Map ? BeaconJobModel.fromJson(json['beacon_job']) : null;
    setWorksheetSupplier(json);
    selectedTierTotal = json['selected_tier_total'];
    if(json['material_list'] != null) {
      materialList = LinkedMaterialModel.fromJson(json['material_list']);
    }
    supplierAccountId = json['supplier_account_id']?.toString();
    origin = json['origin']?.toString();
  }

  WorksheetModel.fromWorksheetJson(Map<String, dynamic> data) {
    id = int.tryParse(data['id'].toString());
    jobId = int.tryParse(data['job_id'].toString());
    name = data['name']?.toString();
    title = data['title']?.toString();
    order = int.tryParse(data['order'].toString());
    overhead = data['overhead']?.toString();
    processingFee = num.tryParse(data['processing_fee_percentage'].toString())?.toString();
    processingFeeAmount = num.tryParse(data['processing_fee_amount'].toString())?.toString();
    profit = data['profit']?.toString();
    type = data['type'];
    taxable = int.tryParse(data['taxable'].toString());
    taxRate = data['tax_rate']?.toString();
    total = data['total'].toString();
    enableActualCost = int.tryParse(data['enable_actual_cost'].toString());
    sellingPriceTotal = data['selling_price_total']?.toString();
    filePath = data['file_path']?.toString();
    fileSize = data['file_size']?.toString();
    note = data['note']?.toString();
    thumb = data['thumb']?.toString();
    customTaxId = data['custom_tax_id']?.toString();
    hidePricing = int.tryParse(data['hide_pricing'].toString());
    showTierTotal = int.tryParse(data['show_tier_total'].toString());
    isEnableSellingPrice = Helper.isTrue(data['enable_selling_price']);
    materialTaxRate = data['material_tax_rate']?.toString();
    laborTaxRate = data['labor_tax_rate']?.toString();
    commission = data['commission']?.toString();
    margin = int.tryParse(data['margin'].toString());
    projectedProfitMargin = int.tryParse(data['projected_profit_margin'].toString());
    createdAt = data['created_at']?.toString();
    updatedAt = data['updated_at']?.toString();
    materialCustomTaxId = data['material_custom_tax_id']?.toString();
    laborCustomTaxId = data['labor_custom_tax_id']?.toString();
    descriptionOnly = int.tryParse(data['description_only'].toString());
    hideCustomerInfo = int.tryParse(data['hide_customer_info'].toString());
    showQuantity = int.tryParse(data['show_quantity'].toString());
    insuranceMeta = data['insurance_meta']?.toString();
    showUnit = int.tryParse(data['show_unit'].toString());
    lineTax = int.tryParse(data['line_tax'].toString());
    lineMarginMarkup = int.tryParse(data['line_margin_markup'].toString());
    branchCode = data['branch_code']?.toString();
    shipToSequenceNumber = data['ship_to_sequence_number']?.toString();
    updateTaxOrder = int.tryParse(data['update_tax_order'].toString());
    showCalculationSummary = int.tryParse(data['show_calculation_summary'].toString());
    isShowTierColor = Helper.isTrue(data['show_tier_color']);
    isQbdWorksheet = Helper.isTrue(data['is_qbd_worksheet']);
    pagesExist = int.tryParse(data['pages_exist'].toString());
    pagesRequired = int.tryParse(data['pages_required'].toString());
    fixedPrice = data['fixed_price']?.toString();
    enableJobCommission = Helper.isTrue(data['enable_job_commission']);
    hideTotal = int.tryParse(data['hide_total'].toString());
    showTaxes = int.tryParse(data['show_taxes'].toString());
    showDiscount = int.tryParse(data['show_discount'].toString());
    discountAmount = data['discount_amount']?.toString();
    discount = data['discount']?.toString();
    isShowTierColor = data['show_tier_color'];
    if (data['suppliers']?['data'] is List) {
      suppliers = <SuppliersModel>[];
      data['suppliers']['data'].forEach((dynamic v) {
        suppliers!.add(SuppliersModel.fromJson(v));
      });
    }
    if (data['attachments'] != null) {
      attachments = <AttachmentResourceModel>[];
      data['attachments']?['data']?.forEach((dynamic attachment) {
        attachment['type'] = 'attachment';
        attachments!.add(AttachmentResourceModel.fromJson(attachment));
      });
    }
    division = data['division'] is Map ? DivisionModel.fromJson(data['division']) : null;
    customTax = data['custom_tax'] is Map ? TaxModel.fromJson(data['custom_tax']) : null;
    customMaterialTax = data['material_custom_tax'] is Map ? TaxModel.fromJson(data['material_custom_tax']) : null;
    customLaborTax = data['labor_custom_tax'] is Map ? TaxModel.fromJson(data['labor_custom_tax']) : null;
    if (data['details'] is List) {
      lineItems = <SheetLineItemModel>[];
      data['details'].forEach((dynamic item) {
        if (item['type'] == WorksheetConstants.item) {
          final tempItem = SheetLineItemModel.fromWorkSheetJson(item['data']);
          tempItem.type = item['type'];
          lineItems?.add(tempItem);
        } else {
          lineItems?.add(SheetLineItemModel.fromWorkSheetJson(item));
        }
      });
    }
    supplierBranch = data["branch"] is Map ? SupplierBranchModel.fromJson(data["branch"]) : null;
     if(data['material_list'] != null) {
      materialList = LinkedMaterialModel.fromJson(data['material_list']);
    }
    meta = data['meta'] is Map ? WorksheetMeta.fromJson(data['meta']) : null;
    beaconJobNumber = data['beacon_job_number']?.toString();
    beaconAccountId = data['beacon_account_id']?.toString();
    beaconJob = data['beacon_job'] is Map ? BeaconJobModel.fromJson(data['beacon_job']) : null;
    setWorksheetSupplier(data);
    selectedTierTotal = data['selected_tier_total'];
    isEnableLineAndWorksheetProfit = Helper.isTrue(data['enable_line_worksheet_profit']);
    isShowLineTotal = Helper.isTrue(data['show_line_total']);

    // Apply item detail display settings
    isShowStyle = Helper.isTrue(data['show_style']);
    isShowSize = Helper.isTrue(data['show_size']);
    isShowColor = Helper.isTrue(data['show_color']);
    isShowVariation = Helper.isTrue(data['show_variation']);
    isShowSupplier = Helper.isTrue(data['show_supplier']);
    isShowTradeType = Helper.isTrue(data['show_trade_type']);
    isShowWorkType = Helper.isTrue(data['show_work_type']);
    isShowTierColor = Helper.isTrue(data['show_tier_color']);

    // Apply customer info settings
    hideCustomerInfo = int.tryParse(data['hide_customer_info'].toString());
    supplierAccountId = data['supplier_account_id']?.toString();
  }

  Map<String, dynamic> toJson({
    bool fromWorkSheetJson = false,
    String? generateWorksheetType,
    bool includeIntegratedSuppliers = true
  }) {
    bool isMaterialSheet = generateWorksheetType == WorksheetConstants.materialList;
    bool isWorkOrderSheet = generateWorksheetType == WorksheetConstants.workOrder;
    bool isWorkOrderOrMaterialSheet = isWorkOrderSheet || isMaterialSheet;
    bool excludeTaxAndProfit = isMaterialSheet || isWorkOrderSheet;

    final data = <String, dynamic>{};

    data['job_id'] = jobId;
    data['name'] = name;
    data['type'] = type;
    if (!excludeTaxAndProfit) {
      data['id'] = id;
      data['title'] = title;
      data['order'] = order;
      data['total'] = total;
      data['enable_actual_cost'] = enableActualCost;
      data['selling_price_total'] = sellingPriceTotal;
      data['file_path'] = filePath;
      data['file_size'] = fileSize;
      data['taxable'] = taxable ?? 0;
      data['tax_rate'] = num.tryParse(taxRate.toString());
      data['custom_tax_id'] = customTaxId;
      data['commission'] = commission;
      data['line_tax'] = lineTax;
      data['line_margin_markup'] = lineMarginMarkup;
      data['overhead'] = overhead;
      data['processing_fee_percentage'] = processingFee;
      data['profit'] = profit;
      data['material_tax_rate'] = materialTaxRate;
      data['material_custom_tax_id'] = materialCustomTaxId;
      data['labor_tax_rate'] = laborTaxRate;
      data['labor_custom_tax_id'] = laborCustomTaxId;
      data['enable_line_worksheet_profit'] = Helper.isTrueReverse(isEnableLineAndWorksheetProfit);
      data['projected_profit_margin'] = projectedProfitMargin ?? 0;
    }
    if (isMaterialSheet) {
      data['material_tax_rate'] = num.tryParse(materialTaxRate.toString()) ?? "";
      data['material_custom_tax_id'] = materialCustomTaxId;
    }
    if (isWorkOrderSheet) {
      data['labor_tax_rate'] = num.tryParse(laborTaxRate.toString());
      data['labor_custom_tax_id'] = laborCustomTaxId;
    }
    data['note'] = note;
    data['thumb'] = thumb;
    data['hide_pricing'] = hidePricing ?? 0;
    data['show_tier_total'] = showTierTotal ?? 0;
    data['enable_selling_price'] = Helper.isTrueReverse(isEnableSellingPrice);
    data['re_calculate'] = Helper.isTrueReverse(isReCalculate);
    data['multi_tier'] = Helper.isTrueReverse(isMultiTier);
    data['margin'] = margin ?? 0;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['description_only'] = descriptionOnly;
    data['hide_customer_info'] = hideCustomerInfo;
    data['show_quantity'] = showQuantity ?? 0;
    data['insurance_meta'] = insuranceMeta;
    data['show_unit'] = showUnit ?? 0;
    data['update_tax_order'] = updateTaxOrder;
    data['srs_old_worksheet'] = isSrsOldWorksheet;
    data['show_calculation_summary'] = showCalculationSummary ?? 0;
    data['sync_on_qbd'] = Helper.isTrueReverse(isSyncOnQbd);
    data['is_qbd_worksheet'] = Helper.isTrueReverse(isQbdWorksheet);
    data['pages_exist'] = pagesExist;
    data['pages_required'] = pagesRequired;
    data['collapse_all_line_items'] = isCollapseAllLineItems;
    data['show_line_total'] = Helper.isTrueReverse(isShowLineTotal);
    data['fixed_price'] = fixedPrice;
    data['enable_job_commission'] = enableJobCommission;
    data['show_style'] = Helper.isTrueReverse(isShowStyle ?? false);
    data['show_size'] = Helper.isTrueReverse(isShowSize ?? false);
    data['show_color'] = Helper.isTrueReverse(isShowColor ?? false);
    data['show_variation'] = Helper.isTrueReverse(isShowVariation ?? false);
    data['show_supplier'] = Helper.isTrueReverse(isShowSupplier ?? false);
    data['show_trade_type'] = Helper.isTrueReverse(isShowTradeType ?? false);
    data['show_work_type'] = Helper.isTrueReverse(isShowWorkType ?? false);
    data['show_tier_color'] = Helper.isTrueReverse(isShowTierColor);
    if (lineItems != null) {
      data['details'] = <dynamic>[];
      for (var lineItem in lineItems!) {
        if (fromWorkSheetJson) {
          int? supplierId = int.tryParse(lineItem.supplierId ?? '');
          if (includeIntegratedSuppliers || !Helper.isIntegratedSupplier(supplierId)) {
            data['details'].add(lineItem.toWorksheetJson(generateWorksheetType: generateWorksheetType));
          }
        } else {
          data['details'].add(lineItem.toJson());
        }
      }
    }
    if(includeIntegratedSuppliers) {
      data["branch"] = supplierBranch?.toJson();
      data["srs_ship_to_address"] = srsShipToAddressModel?.toJson();

      if (beaconAccountId != null) {
        data["beacon_account_id"] = beaconAccountModel?.accountId ?? beaconAccountId;
      }

      if (beaconAccountModel != null) data["beacon_account"] = beaconAccountModel?.toJson();
      if (beaconJobNumber != null) data["beacon_job_number"] = beaconJobNumber;
      if (supplierAccountId != null) {
        data["supplier_account_id"] = supplierAccountId;
      }

    if (beaconAccountModel != null) data["beacon_account"] = beaconAccountModel?.toJson();
    if (beaconJobNumber != null) data["beacon_job_number"] = beaconJobNumber;

      if(abcAccountModel != null) data["supplier_account"] = abcAccountModel?.toJson();

      if (supplierBranch != null) {
        if(abcAccountModel != null) {
          data['supplier_account_id'] = abcAccountModel?.shipToId;
        } else {
          data['ship_to_sequence_number'] = shipToSequenceNumber;
        }
        data['branch_id'] = supplierBranch?.branchId;
        data['branch_code'] = supplierBranch?.branchCode;
      }
    }
    if (linkId != null && linkType != WorksheetConstants.materialList) {
      data["link_id"] = linkId;
      data["link_type"] = linkType;
    }
    data['division_id'] = division?.id ?? "";
    data['measurement_id'] = measurementId;
    data['for_supplier_id'] = forSupplierId;
    data['is_mobile'] = 1;
    data['attachments'] = attachments?.map((attachment) => {
      'type': attachment.type,
      'value': attachment.id,
    }).toList();
    if (!isWorkOrderOrMaterialSheet) {
      data['hide_total'] = hideTotal;
      data['show_total'] = Helper.isTrue(hideTotal);
      data['show_discount'] = showDiscount;
      data['discount'] = discount;
      data['discount_amount'] = discountAmount;
    }
    data['show_taxes'] = showTaxes;
    data['show_pricing'] = Helper.isTrue(hidePricing);
    data['selected_tier_total'] = selectedTierTotal;
    return data;
  }

  void setWorksheetFile(Map<String, dynamic> data) {
    if (data['job_estimate'] is Map) {
      file = FilesListingModel.fromEstimatesJson(data['job_estimate']);
    } else if (data['material_list'] is Map) {
      file = FilesListingModel.fromMaterialListsJson(data['material_list']);
    } else if (data['job_proposal'] is Map) {
      file = FilesListingModel.fromJobProposalJson(data['job_proposal']);
    } else if (data['work_order'] is Map) {
      file = FilesListingModel.fromWorkOrderJson(data['work_order']);
    }
    measurementId = file?.linkedMeasurement?.id?.toString();
  }

  /// [setWorksheetSupplier] Sets the worksheet supplier based on the provided JSON data.
  void setWorksheetSupplier(Map<String, dynamic> json) {
    if (json["srs_ship_to_address"] is Map) {
      supplierType = MaterialSupplierType.srs;
      srsShipToAddressModel = SrsShipToAddressModel.fromJson(json["srs_ship_to_address"]);
    } else if (json["beacon_account"] is Map) {
      supplierType = MaterialSupplierType.beacon;
      beaconAccountModel = BeaconAccountModel.fromJson(json["beacon_account"]);
    } else if (json["supplier_account"] is Map) {
      supplierType = MaterialSupplierType.abc;
      abcAccountModel = SrsShipToAddressModel.fromJson(json["supplier_account"]);
    } else if(Helper.isSupplierHaveABCItem(suppliers) && json["supplier_account_id"] != null) {
      supplierType = MaterialSupplierType.abc;
      abcAccountModel =SrsShipToAddressModel(shipToId: json["supplier_account_id"]?.toString());
    } else {
      supplierType = null;
      srsShipToAddressModel = null;
      beaconAccountModel = null;
      abcAccountModel = null;
    }
  }

  /// Overrides the current worksheet settings with default settings based on the worksheet type.
  ///
  /// This method applies predefined settings from [WorksheetHelpers.getWorksheetDefaultSettings]
  /// based on the provided [generateWorksheetType]. The settings control various display options
  /// like pricing, taxes, totals, and item details.
  void overrideWithDefaultSettings({required String generateWorksheetType}) {
    // Determine worksheet type flags
    bool isMaterialSheet = generateWorksheetType == WorksheetConstants.materialList;
    bool isWorkOrderSheet = generateWorksheetType == WorksheetConstants.workOrder;
    bool isWorkOrderOrMaterialSheet = isWorkOrderSheet || isMaterialSheet;

    final defaultSetting = WorksheetHelpers.getWorksheetDefaultSettings(worksheetType: generateWorksheetType);
    if (defaultSetting is WorksheetSheetSetting) {
      // Apply pricing and cost settings
      hidePricing = Helper.isTrueReverse(isWorkOrderOrMaterialSheet ? !(defaultSetting.includeCost ?? false) : defaultSetting.hidePricing);
      showDiscount = Helper.isTrueReverse(defaultSetting.showDiscount);
      showTaxes = Helper.isTrueReverse(defaultSetting.showTaxes);
      hideTotal = Helper.isTrueReverse(defaultSetting.hideTotal);
      isShowLineTotal = defaultSetting.showLineTotal;
      showCalculationSummary = Helper.isTrueReverse(defaultSetting.showCalculationSummary);
      isEnableSellingPrice = defaultSetting.enableSellingPrice;
      showTierTotal = Helper.isTrueReverse(defaultSetting.showTierTotal);

      // Apply item detail display settings
      descriptionOnly = Helper.isTrueReverse(defaultSetting.descriptionOnly);
      showQuantity = Helper.isTrueReverse(defaultSetting.showQuantity);
      showUnit = Helper.isTrueReverse(defaultSetting.showUnit);
      isShowStyle = defaultSetting.showStyle;
      isShowSize = defaultSetting.showSize;
      isShowColor = defaultSetting.showColor;
      isShowVariation = defaultSetting.showVariation;

      // Apply supplier and type settings
      isShowSupplier = defaultSetting.showSupplier;
      isShowTradeType = defaultSetting.showTradeType;
      isShowWorkType = defaultSetting.showWorkType;

      // Apply customer info settings
      hideCustomerInfo = Helper.isTrueReverse(defaultSetting.hideCustomerInfo);
    }
  }
}
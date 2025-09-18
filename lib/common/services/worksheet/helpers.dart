import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/beacon_access_denied_type.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/enums/macro.dart';
import 'package:jobprogress/common/enums/sheet_line_item_type.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/macros/index.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/common/models/worksheet/amounts.dart';
import 'package:jobprogress/common/models/worksheet/settings/index.dart';
import 'package:jobprogress/common/models/worksheet/settings/settings.dart';
import 'package:jobprogress/common/models/worksheet/worksheet_meta.dart';
import 'package:jobprogress/common/models/worksheet/worksheet_model.dart';
import 'package:jobprogress/common/repositories/financial_product.dart';
import 'package:jobprogress/common/repositories/macros.dart';
import 'package:jobprogress/common/repositories/worksheet.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/common/services/download.dart';
import 'package:jobprogress/common/services/forms/value_selector.dart';
import 'package:jobprogress/common/services/launch_darkly/index.dart';
import 'package:jobprogress/common/services/quick_book.dart';
import 'package:jobprogress/common/services/worksheet/calculations.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/constants/regex_expression.dart';
import 'package:jobprogress/core/constants/worksheet.dart';
import 'package:jobprogress/core/utils/file_helper.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/core/utils/measurement_helper.dart';
import 'package:jobprogress/core/utils/upgrade_plan_helper.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/controller.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/confirmation_dialog_type.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/QuickEditDialog/type.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../global_widgets/beacon_auth_error_dialog/index.dart';
import '../../../global_widgets/beacon_server_down_error_dialog/index.dart';
import '../../enums/supplier_form_type.dart';
import '../../models/job/job_division.dart';
import '../../models/suppliers/beacon/default_branch_model.dart';
import '../../models/suppliers/beacon/account.dart';
import '../../models/suppliers/branch.dart';
import '../../repositories/company_settings.dart';
import '../../repositories/material_supplier.dart';
import '../connected_third_party.dart';

class WorksheetHelpers {

  /// [tierIterator] helps iterating over a single tier
  static void tierIterator(SheetLineItemModel item, {
    required Function(SheetLineItemModel) action,
  }) {
    item.subTiers?.forEach((subTier) {
      tierIterator(subTier, action: action);
    });
    action.call(item);
  }

  /// [formatPercentage] formats percentage values according to the following rules:
  /// 1. If percentage is zero it returns "0"
  /// 2. If percentage is less than 0.01 (e.g., 0.0002) it returns "<1"
  /// 3. If percentage and rounded off percentage are equal (e.g., 1.25 and 1.25) it returns "1.25"
  /// 4. If percentage and rounded off percentage are not equal (e.g., 1.2524 and 1.25) it returns "~1.25"
  /// 5. Zeros in decimals are not considered (e.g., 1.2500 and 1.25 are considered equal)
  static String formatPercentage(num percentage, {int fractionDigits = 2}) {
    // Rule 1: Handle zero case
    if (percentage == 0) {
      return "0";
    }

    final roundedValue = JobFinancialHelper.getRoundOff(percentage, fractionDigits: fractionDigits, avoidZero: true);
    final percentageWithoutZeros = percentage.toString().replaceAll(RegExp(RegexExpression.removeDecimalZeros), '');

    final parsedRoundedPercentage = num.tryParse(roundedValue) ?? 0;

    // Rule 2: Handle values less than 1
    if (percentage > 0 && parsedRoundedPercentage < 0.01) {
      return "<1";
    }

    bool isEqual = percentageWithoutZeros == roundedValue.toString();

    // Return the formatted result
    return isEqual ? roundedValue : "~$roundedValue";
  }

  /// [tierListIterator] helps in iterating over list of tiers to deep down their hierarchy
  static void tierListIterator(List<SheetLineItemModel> lineItems, {
    required Function(SheetLineItemModel) action,
  }) {
    for (SheetLineItemModel item in lineItems) {
      WorksheetHelpers.tierIterator(item, action: (item) {
        action.call(item);
      });
    }
  }

  /// [getParsedItems] can be used to convert hierarchy structure of line
  /// items to one dimensional
  static List<SheetLineItemModel> getParsedItems({
    required List<SheetLineItemModel> lineItems,
    bool attachTierDetails = true,
    int tierIndex = 1,
    bool addEmptyTier = false
  }) {

    if (lineItems.isEmpty) return [];

    bool hasTiers = lineItems[0].type == WorksheetConstants.collection;

    List<SheetLineItemModel> items = [];
    if (hasTiers) {
      for (SheetLineItemModel item in lineItems) {

        List<SheetLineItemModel> subItems = [];

        // iterating all the tiers and sub tiers to extract line items
        // so to make data linear from hierarchy
        WorksheetHelpers.tierIterator(item, action: (item) {
          if (addEmptyTier && item.doHighlightTier()) {
            final emptyItem = item.emptyTierItem;
            emptyItem.setParent(item);
            subItems.add(emptyItem);
          }

          for (SheetLineItemModel subItem in item.subItems ?? []) {
            // adding parent to item this will help in setting the tier details
            // while preparing data for server
            subItem.setParent(item);
            subItems.add(subItem);
          }
        });

        if (Helper.isValueNullOrEmpty(item.subItems) && Helper.isValueNullOrEmpty(item.title)) {
          subItems.add(item);
        }

        for (SheetLineItemModel subItem in subItems) {
          // an empty line item which will be used for storing parent tier details
          SheetLineItemModel tierDetail = SheetLineItemModel.empty();
          // adding prepared tier details to item
          tierDetail.itemToTierDetails(subItem, tierIndex);
          // attaching tier details only if required
          if (attachTierDetails){
            subItem.attachTierDetails(tierDetail);
          } else {
            subItem.deAttachTierDetail();
          }
          items.add(subItem);
        }

      }
    } else {
      items.addAll(lineItems);
    }

    return items;
  }

  static List<SheetLineItemModel> deAttachTierDetails(List<SheetLineItemModel> items) {
    for (SheetLineItemModel item in items) {
      item.deAttachTierDetail();
    }
    return items;
  }

  /// [reCalculateLineTotal] helps in re-calculating line total
  static void reCalculateLineTotal(List<SheetLineItemModel> items, {
    bool resetQuantity = false,
  }) {
    for (SheetLineItemModel item in items) {
      if (resetQuantity) {
        item.qty = JobFinancialHelper.removeDecimalZeroFormat(item.actualQty ?? 0);
      }
    }
  }

  /// [openFile] can be used to download file from and open it up in native viewer
  static Future<void> openFile(String? path) async {
    if (path == null) return;
    String fileName = '${FileHelper.getFileName(path)}.pdf';
    await DownloadService.downloadFile(path, fileName, action: 'open');
  }

  /// [getMaterialTaxRate] returns material tax to be applied
  static num getMaterialTaxRate({JobModel? jobModel, WorksheetModel? worksheet}) {

    if ((QuickBookService.isQuickBookConnected() || QuickBookService.isQBDConnected())) {
      if (!Helper.isValueNullOrEmpty(worksheet?.materialTaxRate)) {
        return num.tryParse(worksheet?.materialTaxRate?.toString() ?? "") ?? 0;
      } else {
        return 0;
      }
    } else {
      if (!Helper.isValueNullOrEmpty(worksheet?.customMaterialTax?.taxRate)) {
        return worksheet?.customMaterialTax?.taxRate ?? 0;
      } else if (jobModel?.parent?.address?.state?.tax?.materialTaxRate != null && Helper.isTrue(jobModel?.isProject)) {
        return jobModel!.parent!.address!.state!.tax!.materialTaxRate!;
      } else if (jobModel?.address?.state?.tax?.materialTaxRate != null) {
        return jobModel!.address!.state!.tax!.materialTaxRate!;
      } else {
        var companyTaxRate = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.materialTaxRate);
        bool isTaxable = companyTaxRate is bool ? false : companyTaxRate.toString().isNotEmpty;
        if(isTaxable) {
          return num.tryParse(companyTaxRate.toString()) ?? 0;
        } else {
          return 0;
        }
      }
    }
  }

  /// [getLaborTaxRate] returns labor tax to be applied
  static num getLaborTaxRate({JobModel? jobModel, WorksheetModel? worksheet}) {

    if ((QuickBookService.isQuickBookConnected() || QuickBookService.isQBDConnected())) {
      if (!Helper.isValueNullOrEmpty(worksheet?.laborTaxRate)) {
        return num.tryParse(worksheet?.laborTaxRate ?? "") ?? 0;
      } else {
        return 0;
      }
    } else {
      if (!Helper.isValueNullOrEmpty(worksheet?.customLaborTax?.taxRate)) {
        return worksheet?.customLaborTax?.taxRate ?? 0;
      } else if (jobModel?.parent?.address?.state?.tax?.laborTaxRate != null && Helper.isTrue(jobModel?.isProject)) {
        return jobModel!.parent!.address!.state!.tax!.laborTaxRate!;
      } else if (jobModel?.address?.state?.tax?.laborTaxRate != null) {
        return jobModel!.address!.state!.tax!.laborTaxRate!;
      } else {
        var companyTaxRate = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.laborTaxRate);
        bool isTaxable = companyTaxRate is bool ? false : companyTaxRate.toString().isNotEmpty;
        if(isTaxable) {
          return num.tryParse(companyTaxRate.toString()) ?? 0;
        } else {
          return 0;
        }
      }
    }
  }

  /// [getTaxAllRate] returns tax all to be applied
  static num getTaxAllRate({JobModel? jobModel, WorksheetModel? worksheet}) {

    if ((QuickBookService.isQuickBookConnected() || QuickBookService.isQBDConnected())) {
      if (!Helper.isValueNullOrEmpty(worksheet?.taxRate)) {
        return num.tryParse(worksheet?.taxRate ?? "") ?? 0;
      } else {
        return 0;
      }
    } else {
      if (!Helper.isValueNullOrEmpty(worksheet?.customTax?.taxRate)) {
        return worksheet?.customTax?.taxRate ?? 0;
      } else if (jobModel?.parent?.address?.stateTax != null && Helper.isTrue(jobModel?.isProject)) {
        return jobModel!.parent!.address!.stateTax!;
      } else if (jobModel?.address?.stateTax != null) {
        return jobModel!.address!.stateTax!;
      } else {
        var companyTaxRate = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.taxRate);
        bool isTaxable = companyTaxRate is bool ? false : companyTaxRate.toString().isNotEmpty;
        if(isTaxable) {
          return num.tryParse(companyTaxRate.toString()) ?? 0;
        } else {
          return 0;
        }
      }
    }
  }

  /// [getOverHeadRate] returns overhead rate to be applied
  static num getOverHeadRate() {
    var overHead = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.jobCostOverhead);
    if (overHead is bool) {
      return 0;
    }
    return (num.tryParse(overHead['overhead'].toString()) ?? 0);
  }

  static SheetLineItemModel? getParentMeasurementItem(SheetLineItemModel item) {
    final tierLevel1 = item;
    final tierLevel2 = item.parent;
    final tierLevel3 = item.parent?.parent;

    if (tierLevel1.tierMeasurement != null) return tierLevel1;
    if (tierLevel2?.tierMeasurement != null) return tierLevel2;
    if (tierLevel3?.tierMeasurement != null) return tierLevel3;
    return null;
  }

  static Map<String, dynamic> getFavouriteParamsFromType(String worksheetType) {
    switch (worksheetType) {
      case WorksheetConstants.estimate:
        return {
          'includes[0]': 'estimate',
          'includes[1]': 'division.address',
          'type[]': 'estimate',
        };

      case WorksheetConstants.materialList:
        return {
          'includes[0]': 'material_list',
          'includes[1]': 'division.address',
          'type[]': 'material_list',
        };

      case WorksheetConstants.proposal:
        return {
          'includes[0]': 'proposal',
          'includes[1]': 'division.address',
          'type[]': 'proposal',
        };

      case WorksheetConstants.workOrder:
        return {
          'includes[0]': 'work_order',
          'includes[1]': 'division.address',
          'type[]': 'work_order',
        };

      default:
        return {};
    }
  }

  static MacrosListType getMarcoListType(String worksheetType, {
    int? forSupplierId
  }) {
    if (forSupplierId != null) {
      if (Helper.isSRSv1Id(forSupplierId) || Helper.isSRSv2Id(forSupplierId)) {
        return MacrosListType.srs;
      } else if (Helper.getSupplierId(key: CommonConstants.beaconId) == forSupplierId) {
        return MacrosListType.beacon;
      } else {
        return MacrosListType.estimateProposal;
      }
    }

    switch (worksheetType) {
      case WorksheetConstants.materialList:
        return MacrosListType.materialList;
      case WorksheetConstants.workOrder:
        return MacrosListType.workOrder;
      default:
        return MacrosListType.estimateProposal;
    }
  }

  static Future<void> navigateToMacros({
    bool? isEnableSellingPrice,
    int? forSupplierId,
    int? srsSupplierId,
    required String worksheetType,
    required String? srsBranchCode,
    required String? beaconBranchCode,
    required String? abcBranchCode,
    required String? shipToSequenceId,
    required int? jobDivisionId,
    Function(List<MacroListingModel>)? onDone
  }) async {
    final macrosIds = await Get.toNamed(Routes.macroListing, arguments: {
      NavigationParams.isEnableSellingPrice : isEnableSellingPrice,
      NavigationParams.macroType: getMarcoListType(worksheetType, forSupplierId: forSupplierId),
      NavigationParams.srsBranchCode: srsBranchCode,
      NavigationParams.beaconBranchCode: beaconBranchCode,
      NavigationParams.abcBranchCode: abcBranchCode,
      NavigationParams.srsSupplierId: srsSupplierId,
      NavigationParams.shipToSequenceId: shipToSequenceId,
      NavigationParams.jobDivisionId: jobDivisionId
    });
    String? branchCode = getBranchCode(srsBranchCode, beaconBranchCode, abcBranchCode);
    int? supplierId = getSupplierId(srsBranchCode, abcBranchCode, srsSupplierId);
    if (macrosIds is List<String>) await fetchMacroDetails(macrosIds, onDone: onDone, branchCode: branchCode, supplierId: supplierId);
  }

  static Future<void> fetchMacroDetails(List<String> macrosIds, {
    Function(List<MacroListingModel>)? onDone,
    String? branchCode,
    int? supplierId,
  }) async {
    try {
      final requestParams = MacroListingModel.getViewSelectedMacroParams(macrosIds, branchCode: branchCode, supplierId: supplierId);
      final macros = await MacrosRepository().fetchSelectedMacrosData(requestParams, type: AddLineItemFormType.worksheet);
      onDone?.call(macros);
    } catch (e) {
      rethrow;
    }
  }

  static List<SheetLineItemModel> parseMacroToLineItems(List<MacroListingModel> macros, {
    required WorksheetSettingModel? settings,
    required List<JPSingleSelectModel> allTrades,
  }) {
    List<SheetLineItemModel> items = [];
    num tempFixedPrice = 0;
    for (MacroListingModel macro in macros) {
      final trade = FormValueSelectorService.getSelectedSingleSelect(allTrades, macro.tradeId.toString());
      tempFixedPrice += num.tryParse(macro.fixedPrice.toString()) ?? 0;
      for (SheetLineItemModel item in (macro.details ?? [])) {
        int? supplierId = int.tryParse(item.supplierId ?? '');
        bool isSupplierMatched = Helper.isABCSupplierId(supplierId) || Helper.isBeaconSupplierId(supplierId) || Helper.isSRSv2Id(supplierId);
        if ((isSupplierMatched && !Helper.isValueNullOrEmpty(item.variants?.firstOrNull?.code)) || !isSupplierMatched) {
          item.workSheetSettings = settings;
          item.tradeId = macro.tradeId;
          item.tradeType = trade;
          // Find a formula that matches the trade ID from the measurement formulas
          // This ensures the correct formula is applied to the line item based on its trade
          String? foundFormula = MeasurementHelper.findFormulaByTradeId(item.measurementFormulas, macro.tradeId.toString());
          if (foundFormula != null) {
            // If a matching formula is found, set it to the item's formula property
            item.formula = foundFormula;
          }
          item.branchCode = macro.branchCode;
          items.add(item);
        }
      }
    }
    settings?.setFixedPrice(tempFixedPrice);
    return items;
  }

  static bool verifyTierName(List<SheetLineItemModel>? items, String name, {
    String? avoidName
  }) {
    bool anyTierWithSameName = items?.any((item) => item.title != avoidName && item.title == name) ?? false;
    if (anyTierWithSameName) {
      Helper.showToastMessage('this_tier_name_is_already_in_use'.tr);
    }
    return anyTierWithSameName;
  }

  static Future<void> showConfirmation({
    required String subTitle,
    String? title,
    String? suffixTitle,
    VoidCallback? onConfirmed
  }) async {
    await showJPBottomSheet(
        child: (_) => JPConfirmationDialog(
          title: title ?? 'confirmation'.tr,
          icon: Icons.warning_amber_rounded,
          subTitle: subTitle,
          prefixBtnText: 'cancel'.tr,
          onTapPrefix: Get.back<void>,
          suffixBtnText: suffixTitle ?? 'confirm'.tr,
          onTapSuffix: () {
           Get.back();
           onConfirmed?.call();
          },
        ),
    );
  }

  static Future<void> showNameDialog({
    required String title,
    required String label,
    required Future<dynamic> Function(String) onDone,
    String? filledValue,
    String? secondaryToggleText,
    bool isSecondaryToggle = false,
    Widget? Function(JPBottomSheetController)? preFooter,
    bool secondaryToggleValue = false,
    ValueChanged<bool>? onSecondaryToggle
  }) async {
    bool showUpgradeDialog = await UpgradePlanHelper.showUpgradePlanOnDocumentLimit();
    if(showUpgradeDialog) {
      return;
    }
    FocusNode renameDialogFocusNode = FocusNode();

    showJPGeneralDialog(
        child: (controller){
          return AbsorbPointer(
            absorbing: controller.isLoading,
            child: JPQuickEditDialog(
              type: JPQuickEditDialogType.inputBox,
              label: label,
              title: title.toUpperCase(),
              fillValue: filledValue,
              disableButton: controller.isLoading,
              onSuffixTap: (val) async {
                controller.toggleIsLoading();
                renameDialogFocusNode.unfocus();
                await onDone.call(val).then((value) {
                  controller.toggleIsLoading();
                }).catchError((e) {
                  renameDialogFocusNode.requestFocus();
                  controller.toggleIsLoading();
                });
              },
              errorText: "$label ${'is_required'.tr}",
              onCancel: controller.isLoading ? null : Get.back<void>,
              focusNode: renameDialogFocusNode,
              suffixTitle: controller.isLoading ? '' : 'save'.tr.toUpperCase(),
              suffixIcon: showJPConfirmationLoader(
                show: controller.isLoading,
              ),
              maxLength: 50,
              preFooter: preFooter?.call(controller),
              secondaryToggleText: secondaryToggleText,
              isSecondaryToggle: isSecondaryToggle,
              secondaryToggleValue: secondaryToggleValue,
              onSecondaryToggle: onSecondaryToggle,
            ),
          );
        });

    await Future<void>.delayed(const Duration(milliseconds: 400));

    renameDialogFocusNode.requestFocus();
  }

  static String worksheetTypeToTitle(String type, {bool saveAs = false}) {
    switch (type) {
      case WorksheetConstants.estimate:
        return saveAs ? 'save_as_estimate'.tr : 'save_estimate'.tr;

      case WorksheetConstants.proposal:
        return saveAs ? 'save_as_proposal'.tr : 'save_proposal'.tr;

      case WorksheetConstants.materialList:
        return saveAs ? 'save_as_material_list'.tr : 'save_material_list'.tr;

      case WorksheetConstants.workOrder:
        return saveAs ? 'save_as_work_order'.tr : 'save_work_order'.tr;

      case WorksheetConstants.srsMaterialList:
        return saveAs ? 'save_as_srs_order_form'.tr : 'save_srs_order_form'.tr;

      case WorksheetConstants.beaconMaterialList:
        return saveAs ? 'save_as_beacon_order_form'.tr : 'save_beacon_order_form'.tr;

      case WorksheetConstants.abcMaterialList:
        return saveAs ? 'save_as_abc_order_form'.tr : 'save_abc_order_form'.tr;

      default:
        return "";
    }
  }

  static String getDefaultSaveName(String type, {WorksheetModel? worksheet}) {
    switch (type) {
      case WorksheetConstants.workOrder:
        return worksheet?.name ?? 'work_order'.tr;

      case WorksheetConstants.materialList:
        return worksheet?.name ?? 'material_list'.tr.capitalize!;

      case WorksheetConstants.proposal:
        return worksheet?.name ?? 'document'.tr.capitalize!;

      case WorksheetConstants.estimate:
        return worksheet?.name ?? 'estimate'.tr.capitalize!;

      default:
        return worksheet?.name ?? '';
    }
  }

  /// [isColorMissing] checks whether color is missing in worksheet to be generated
  static bool isColorMissing(WorksheetModel worksheet) {

    if (Helper.isValueNullOrEmpty(worksheet.suppliers)) return false;

    final srsV1Id = Helper.getSupplierId(key: CommonConstants.srsId, forceV1: true);
    final srsV2Id = Helper.getSupplierId(key: CommonConstants.srsId);
    final beaconId = Helper.getSupplierId(key: CommonConstants.beaconId);

    final lineItems = getParsedItems(lineItems: worksheet.lineItems ?? []);
    return lineItems.any((item) {
      if (Helper.isValueNullOrEmpty(item.product?.colors)) return false;
      if (item.supplierId != srsV1Id.toString() && item.supplierId != srsV2Id.toString() && item.supplierId != beaconId.toString()) return false;
      return Helper.isValueNullOrEmpty(item.color);
    });
  }

  /// [extractLineItems] returns line items that can be saved in generated worksheet
  static List<SheetLineItemModel> extractLineItems(WorksheetModel worksheet, {
    List<String>? slugs,
    bool isSrs = false,
    bool isBeacon = false,
    bool isABC = false,
    bool allowAll = false,
  }) {
    final lineItems = getParsedItems(lineItems: worksheet.lineItems ?? []);
    if (allowAll) {
      return lineItems;
    } else if (isSrs) {
      String? srsV1Id = Helper.getSupplierId(forceV1: true)?.toString();
      String? srsV2Id = Helper.getSupplierId()?.toString();
      return lineItems.where((item) => item.supplierId == srsV1Id || item.supplierId == srsV2Id).toList();
    } else if (isBeacon) {
      return lineItems.where((item) => item.supplierId == Helper.getSupplierId(key: CommonConstants.beaconId).toString()).toList();
    } else if (isABC) {
      return lineItems.where((item) => item.supplierId == Helper.getSupplierId(key: CommonConstants.abcSupplierId).toString()).toList();
    } else if (!Helper.isValueNullOrEmpty(slugs)) {
      return lineItems.where((item) => slugs!.contains(item.categoryName)).toList();
    } else {
      return [];
    }
  }

  /// [filterLineItemsByCategory] filters the line items as per the worksheet type to be generated
  static Future<List<SheetLineItemModel>> filterLineItemsByCategory(WorksheetModel worksheet, String type) async {

    List<SheetLineItemModel> lineItems = [];

    switch (type) {
      case WorksheetConstants.materialList:
        lineItems = extractLineItems(worksheet, slugs: [WorksheetConstants.categoryMaterials]);
        if (lineItems.isEmpty) emptyItemsToToastMessage(type);
        break;

      case WorksheetConstants.workOrder:
        final selectedSlugs = await showWorkOrderCategorySelector(worksheet.id!);
        lineItems = extractLineItems(worksheet, slugs: selectedSlugs);
        break;

      case WorksheetConstants.proposal:
        lineItems = extractLineItems(worksheet, allowAll: true);
        break;

      case WorksheetConstants.srsMaterialList:
        worksheet.forSupplierId = getSrsSupplierId(worksheet) ?? Helper.getSupplierId();
        lineItems = extractLineItems(worksheet, isSrs: true);
        break;
      case WorksheetConstants.beaconMaterialList:
        worksheet.forSupplierId = Helper.getSupplierId(key: CommonConstants.beaconId);
        lineItems = extractLineItems(worksheet, isBeacon: true);
        break;
      case WorksheetConstants.abcMaterialList:
        worksheet.forSupplierId = Helper.getSupplierId(key: CommonConstants.abcSupplierId);
        lineItems = extractLineItems(worksheet, isABC: true);
        break;
    }

    return lineItems;
  }

  /// [showWorkOrderCategorySelector] opens up single select to select work order category
  static Future<List<String>> showWorkOrderCategorySelector(int id) async {

    List<String> selectedSlugs = [];

    try {
      final categories = await WorksheetRepository.getWorksheetCategories(id.toString());

      if (categories.isEmpty) {
        emptyItemsToToastMessage(WorksheetConstants.workOrder);
        return selectedSlugs;
      }

      await showJPBottomSheet(
        child: (_) => JPMultiSelect(
          mainList: categories,
          title: 'work_order'.tr,
          onDone: (items) {
            final selectedItems = FormValueSelectorService.getSelectedMultiSelectValues(items);
            if (selectedItems.isEmpty) {
              Helper.showToastMessage('please_select_category'.tr);
            } else {
              for (JPMultiSelectModel item in selectedItems) {
                selectedSlugs.add(item.label);
              }
              Get.back();
            }
          },
        ),
      );
    } catch (e) {
      rethrow;
    }

    return selectedSlugs;
  }

  static FLModule? typeToFLModule(String type) {
    switch (type) {
      case WorksheetConstants.materialList:
      case WorksheetConstants.srsMaterialList:
      case WorksheetConstants.beaconMaterialList:
      case WorksheetConstants.abcMaterialList:
        return FLModule.materialLists;

      case WorksheetConstants.workOrder:
        return FLModule.workOrder;

      case WorksheetConstants.proposal:
        return FLModule.jobProposal;

      default:
        return null;
    }
  }

  /// [emptyItemsToToastMessage] shows the validation message as per the worksheet type
  static void emptyItemsToToastMessage(String type) {
    switch (type) {
      case WorksheetConstants.materialList:
        Helper.showToastMessage('no_material_item_for_item_list_desc'.tr);
        break;

      case WorksheetConstants.workOrder:
        Helper.showToastMessage('no_labor_item_for_item_list_desc'.tr);
        break;
    }
  }

  /// [getFileWorksheetParams] helps in conditionally generating params for files
  /// while updating job price
  static Map<String, dynamic>? getFileWorksheetParams(FilesListingModel? file) {

    WorksheetModel? worksheet = file?.worksheet;
    WorksheetMeta? meta = worksheet?.meta ?? WorksheetMeta();
    bool isTaxable = Helper.isTrue(worksheet?.taxable);
    bool isSellingPriceEnabled = worksheet?.isEnableSellingPrice ?? false;
    bool isDerivedTax = false;
    num amount = 0;
    num taxAmount = 0;
    num amountToCalculateTaxAll = 0;
    num taxRate = 0;
    String customTaxId = "";

    if (worksheet == null) return null;

    WorksheetAmounts amounts = WorksheetCalculations.calculateAmountForResource(file!.worksheet!);

    amount = amounts.listTotal;

    if (Helper.isTrue(worksheet.taxable)) {

      String subTotal = (isSellingPriceEnabled ? worksheet.sellingPriceTotal : worksheet.total).toString();
      amountToCalculateTaxAll = num.tryParse(subTotal) ?? 0;

      if (Helper.isTrue(worksheet.updateTaxOrder)) {
        amountToCalculateTaxAll += amounts.overhead;
        amountToCalculateTaxAll += amounts.profitMargin + amounts.profitMarkup + amounts.lineItemProfit;
        amountToCalculateTaxAll += amounts.commission;
        amountToCalculateTaxAll -= amounts.discount;
      }

      if (Helper.isTrue(worksheet.lineTax) && meta.totalLineTax > 0) {
        taxAmount = meta.totalLineTax;
        isTaxable = true;
        isDerivedTax = true;
      } else if (!Helper.isValueNullOrEmpty(worksheet.taxRate)) {
        num? taxPercent = num.tryParse(worksheet.taxRate.toString());
        taxAmount = WorksheetCalculations.percentToAmount(taxPercent, amountToCalculateTaxAll);
      }

      if (amounts.laborTax > 0 && Helper.isValueNullOrEmpty(worksheet.taxRate) && Helper.isValueNullOrEmpty(worksheet.materialTaxRate)) {
        num laborLineItemTotal = isSellingPriceEnabled ? meta.laborSellingPriceTotal : meta.laborCostTotal;
        amount = amount - amounts.laborTax;

        taxAmount = amounts.laborTax;
        if(laborLineItemTotal != amount) isDerivedTax = true;
        isTaxable = true;
      }

      if(amounts.materialTax > 0 && Helper.isValueNullOrEmpty(worksheet.taxRate) && Helper.isValueNullOrEmpty(worksheet.laborTaxRate)) {
        num materialLineItemTotal = isSellingPriceEnabled ? meta.materialsSellingPriceTotal : meta.materialsCostTotal;
        amount = amount - amounts.materialTax;

        taxAmount = amounts.materialTax;

        if(materialLineItemTotal != amount) isDerivedTax = true;
        isTaxable = true;
      }

      if (!Helper.isValueNullOrEmpty(worksheet.fixedPrice)) {
        amount = num.parse(worksheet.fixedPrice!) - taxAmount;
      }
      double temp = taxAmount / amount;
      if(temp.isNaN || temp.isInfinite) {
        temp = 0;
      }
      taxRate = (temp * 100).toPrecision(8);

      if (!Helper.isValueNullOrEmpty(worksheet.customTaxId) && Helper.isValueNullOrEmpty(worksheet.materialTaxRate) && Helper.isValueNullOrEmpty(worksheet.laborTaxRate)) {
        customTaxId = worksheet.customTaxId!;
      }
      isDerivedTax = !Helper.isValueNullOrEmpty(worksheet.taxRate) && (amounts.laborTax > 0 || amounts.materialTax > 0);
    }

    // In case worksheet has processing fee rate available, calculating
    // processing fee amount using it
    if (!Helper.isValueNullOrEmpty(worksheet.processingFeeAmount)) {
      amounts.processingFee += num.tryParse(worksheet.processingFeeAmount.toString()) ?? 0;
    }

    Map<String, dynamic> updateJobAmountParams = {
      'id': file.jobId,
      'taxable': Helper.isTrueReverse(isTaxable),
      'is_derived_tax': Helper.isTrueReverse(isDerivedTax),
      'amount': amount + amounts.processingFee,
      'total': amount + taxAmount + amounts.processingFee,
      if (isTaxable) 'tax_rate': taxRate,
      if (customTaxId.isNotEmpty) 'custom_tax_id': customTaxId,
    };

    return updateJobAmountParams;
  }

  /// [isAllItemColorSelected] checks whether all color is selected in worksheet
  static bool isAllItemColorSelected(List<SheetLineItemModel> lineItems) {
    final List<SheetLineItemModel> linearLineItems = getParsedItems(lineItems: lineItems);

    final srsV1Id = Helper.getSupplierId(key: CommonConstants.srsId, forceV1: true);
    final srsV2Id = Helper.getSupplierId(key: CommonConstants.srsId);
    final beaconId = Helper.getSupplierId(key: CommonConstants.beaconId);
    bool isAllItemColorSelected = true;

    for (var item in linearLineItems) {
      if (item.supplierId != srsV1Id.toString()
          && item.supplierId != srsV2Id.toString()
          && item.supplierId != beaconId.toString()) {
        continue;
      }
      if(!Helper.isValueNullOrEmpty(item.product?.colors) && Helper.isValueNullOrEmpty(item.color)) {
        isAllItemColorSelected = false;
        break;
      }
    }
    return isAllItemColorSelected;
  }

  /// [hasSuppliersProduct] Checks if the given [supplier] has any product in the list of [lineItems].
  ///
  /// Returns true if the supplier has any product, otherwise returns false.
  static bool hasSuppliersProduct(String supplier, List<SheetLineItemModel> lineItems) {
    // Get the ID of the supplier
    int? supplierId = Helper.getSupplierId(key: supplier);
    // If the supplier ID is null, no need to check further
    if (supplierId == null) return false;

    // Parse the line items
    final parsedLineItems = WorksheetHelpers.getParsedItems(lineItems: lineItems );
    // Check if any of the line items belong to the supplier
    final isAnySupplierProduct = parsedLineItems.any((item) {
      return item.supplier?.id == supplierId || item.supplierId == supplierId.toString();
    });

    // Return the result
    return isAnySupplierProduct;
  }

  static void showBeaconLoginConfirmationDialog(Function(bool) callbacks) {
    showJPBottomSheet(child: (controller) =>
     JPConfirmationDialog(
       title: 'confirmation'.tr,
       subTitle: 'beacon_login_confirmation_msg'.tr,
       suffixBtnText: 'continue'.tr,
       prefixBtnText: 'cancel'.tr,
       icon: Icons.warning_amber_outlined,
       onTapSuffix: () async {
         Get.back();
         callbacks.call(await navigateToBeaconLoginWebView());
       },
       onTapPrefix: Get.back<void>,
     ));
  }

  static void showBeaconAccessDeniedDialog(BeaconAccessDeniedType type) {
    showJPDialog(child: (_) {
      return Material(
        color: JPColor.transparent,
        child: Center(
          child: JPConfirmationDialog(
            icon: Icons.not_interested_outlined,
            title: 'access_denied'.tr,
            subTitle: getBeaconAccessDeniedMsg(type),
            type: JPConfirmationDialogType.alert,
            prefixBtnColorType: JPButtonColorType.tertiary,
            prefixBtnText: 'ok'.tr.toUpperCase(),
            onTapPrefix: Get.back<void>,
          ),
        ),
      );
    });
  }

  static Future<bool> navigateToBeaconLoginWebView() async {
    final result = await Get.toNamed(Routes.beaconLoginWebView);
    if(!Helper.isTrue(result)) {
      Helper.showToastMessage('beacon_is_not_connected'.tr);
    }
    return Helper.isTrue(result);
  }

  static Future<void> updateUserBeaconClient() async {
    try {
      final response = await WorksheetRepository.getBeaconClient();
      if(response == null) {
        resetDefaultBranchSettings(getDefaultBranchKey(MaterialSupplierType.beacon));
      }
      await AuthService.updateUserData({'beacon_client': response});
    } catch (e) {
      rethrow;
    }
  }

  static Future<WorksheetModel?> fetchWorksheet(int? worksheetId) async {
    try {
      showJPLoader();
      Map<String, dynamic> param = {
        "id": worksheetId,
        "includes[0]": "suppliers",
        "includes[1]": "custom_tax",
        "includes[2]": "attachments",
        "includes[3]": "material_custom_tax",
        "includes[4]": "labor_custom_tax",
        "includes[5]": "srs_ship_to_address",
        "includes[6]": "branch",
        "includes[7]": "division",
        "includes[8]": "beacon_account",
        "includes[9]": "beacon_job",
        if(LDService.hasFeatureEnabled(LDFlagKeyConstants.abcMaterialIntegration))
         "includes[10]": "supplier_account",
      };

      final response = await WorksheetRepository.getWorksheet(param);
      return response.worksheet;
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  /// [isBeaconAccountBranchExist] Checks [beaconAccountId] exist or not
  static Future<bool> isBeaconAccountBranchExist(String? beaconAccountId, BeaconAccessDeniedType type) async {
    try {
      showJPLoader(msg: 'fetching_beacon_accounts'.tr);
      final List<BeaconAccountModel> beaconAccounts = await MaterialSupplierRepository().getBeaconAccounts();
      Get.back();
      final bool isBeaconBranchExist = beaconAccounts.any((element) =>
      element.accountId.toString() == beaconAccountId);
      if(!isBeaconBranchExist) {
        showBeaconAccessDeniedDialog(type);
      }
      return isBeaconBranchExist;
    } catch (e) {
      Get.back();
      rethrow;
    }
  }

  /// [checkIsNotBeaconOrBeaconAccountExist] Checks [beaconAccountId] has valid id or Checks beacon branch exist or not
  static void checkIsNotBeaconOrBeaconAccountExist(String? beaconAccountId, Function(bool) callback, {BeaconAccessDeniedType type = BeaconAccessDeniedType.worksheet}) async {
    if (ConnectedThirdPartyService.isBeaconConnected()) {
      final isBeacon = (int.tryParse(beaconAccountId ?? '0') ?? 0) > 0 && beaconAccountId != 'null';
      if(isBeacon && AuthService.isUserBeaconConnected()) {
        callback.call(await isBeaconAccountBranchExist(beaconAccountId, type));
      } else if(!isBeacon) {
        callback.call(true);
      } else {
        showBeaconLoginConfirmationDialog((isBeaconConnecting) async {
          if(isBeaconConnecting) {
            callback.call(await isBeaconAccountBranchExist(beaconAccountId, type));
          } else {
            callback.call(false);
          }
        });
      }
    } else {
      callback.call(true);
    }
  }

  /// [showBeaconAuthErrorDialog] shows Beacon auth error dialog
  static void showBeaconAuthErrorDialog(String errorMessage) => showJPDialog(child: (_) =>
      BeaconAuthErrorDialog(errorMessage: errorMessage));

  /// [handleBeaconError] If error type is beacon [showBeaconAuthErrorDialog] will be shown
  /// or if error status code is 503 [showBeaconServerDownErrorDialog] will be shown
  static void handleBeaconError(DioException error, {bool isCreatingBeaconOrder = false}) async {
    if(error.response?.data?['error']?['type'] == 'beacon') {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      if (!Helper.isTrue(Get.isDialogOpen)) {
        showBeaconAuthErrorDialog(error.response?.data?['error']?['message']);
      }
    }
    if(!isCreatingBeaconOrder && !Helper.isTrue(Get.isDialogOpen) && error.response?.statusCode == 503) {
      showBeaconServerDownErrorDialog();
    }
    Helper.recordError(error);
  }

  /// [checkAndAddProcessingFeeItem] is responsible for adding processing fee
  /// item to worksheet after performing some checks
  static void checkAndAddProcessingFeeItem(WorksheetModel worksheet) {
    // If MetroBath LD flag is not enabled, simply return
    if (!LDService.hasFeatureEnabled(LDFlagKeyConstants.metroBathFeature)) return;
    // if processing fee amount is not coming from server then no need to do anything
    if (!Helper.isValueNullOrEmpty(worksheet.processingFeeAmount)) {
      // Processing Fee Line Item
      final SheetLineItemModel processingFeeItem = SheetLineItemModel(
        productId: "",
        title: "processing_fee".tr,
        qty: "1", // quantity is always 1
        price: worksheet.processingFeeAmount.toString(),
        unitCost: worksheet.processingFeeAmount.toString(),
        sellingPrice: worksheet.processingFeeAmount.toString(),
        totalPrice: worksheet.processingFeeAmount.toString(),
      );
      // adding processing fee item
      worksheet.lineItems?.add(processingFeeItem);
    }
  }

  static String getBeaconAccessDeniedMsg(BeaconAccessDeniedType type) {
    switch(type) {
      case BeaconAccessDeniedType.worksheet:
        return 'beacon_access_denied_msg'.tr;
      case BeaconAccessDeniedType.changeOrder:
        return 'beacon_access_denied_change_order_msg'.tr;
      case BeaconAccessDeniedType.invoice:
        return 'beacon_access_denied_invoice_msg'.tr;
    }
  }

  /// [getDefaultBranch] - get saved default branch from company settings
  static DefaultBranchModel? getDefaultBranch(MaterialSupplierType type) {
    dynamic defaultBranch = CompanySettingsService.getCompanySettingByKey(getDefaultBranchKey(type));
    if(defaultBranch is String && defaultBranch.isNotEmpty) {
      return DefaultBranchModel.fromJson(jsonDecode(defaultBranch));
    } else {
      return defaultBranch is Map ?
      DefaultBranchModel.fromJson(defaultBranch) : null;
    }
  }

  /// [getDefaultBranchKey] - get saved default branch key as per material supplier type
  static String getDefaultBranchKey(MaterialSupplierType type) {
    switch (type) {
      case MaterialSupplierType.srs:
        return CompanySettingConstants.srsDefaultBranch;
      case MaterialSupplierType.beacon:
        return CompanySettingConstants.beaconDefaultBranch;

      case MaterialSupplierType.abc:
        return CompanySettingConstants.abcDefaultBranch;
    }
  }

  /// [saveDefaultBranchSettings] - Saving default branch in company settings
  static Future<void> saveDefaultBranchSettings(DefaultBranchModel defaultBranchModel, MaterialSupplierType type) async {
    try {
      String defaultBranchKey = getDefaultBranchKey(type);
      dynamic preservedDefaultBranch = CompanySettingsService.getCompanySettingByKey(
          defaultBranchKey,
          onlyValue: false
      );
      // Creating settings for the first time
      if (preservedDefaultBranch is bool || preservedDefaultBranch == null) {
        preservedDefaultBranch = {
          "name": defaultBranchKey,
          "key": defaultBranchKey,
          "user_id": AuthService.userDetails?.id,
          "company_id": AuthService.userDetails?.companyDetails?.id
        };
      }
      preservedDefaultBranch['value'] = jsonEncode(defaultBranchModel.toJson());
      CompanySettingsService.addOrReplaceCompanySetting(defaultBranchKey, preservedDefaultBranch);
      await CompanySettingRepository.saveSettings(preservedDefaultBranch);
    } catch (e) {
      rethrow;
    }
  }


  /// [isDefaultBranchSaved] - Check whether Supplier Default branch is saved
  /// [isInvoiceFormType] - If this true beacon job account is not visible
  static bool isDefaultBranchSaved(DefaultBranchModel selectedDefaultBranchModel, MaterialSupplierType type, {bool isInvoiceFormType = false}) {
    DefaultBranchModel? defaultBranchModel = getDefaultBranch(type);

    if(defaultBranchModel != null) {
      bool isSelectedAccountNull = selectedDefaultBranchModel.srsShipToAddress == null
          && selectedDefaultBranchModel.beaconAccount == null
          && selectedDefaultBranchModel.abcAccount == null;
      bool isSelectedBranchNull = selectedDefaultBranchModel.branch == null;
      bool isSelectedJobNullOrInvoice = isInvoiceFormType || selectedDefaultBranchModel.jobAccount == null;

      bool isAnySelectedAccountEqualToDefaultAccount = defaultBranchModel.srsShipToAddress?.shipToSequenceId == selectedDefaultBranchModel.srsShipToAddress?.shipToSequenceId
          || defaultBranchModel.beaconAccount?.accountId == selectedDefaultBranchModel.beaconAccount?.accountId
          || defaultBranchModel.abcAccount?.shipToId == selectedDefaultBranchModel.abcAccount?.shipToId;
      bool isSelectedBranchEqualToDefaultBranch = selectedDefaultBranchModel.branch?.branchId == defaultBranchModel.branch?.branchId;
      bool isSelectedJobEqualToDefaultJob = isInvoiceFormType || selectedDefaultBranchModel.jobAccount?.jobNumber == defaultBranchModel.jobAccount?.jobNumber;

      return (isSelectedAccountNull && isSelectedBranchNull && isSelectedJobNullOrInvoice) ||
          (isAnySelectedAccountEqualToDefaultAccount && isSelectedBranchEqualToDefaultBranch && isSelectedJobEqualToDefaultJob);
    }

    return false;
  }

  /// [resetDefaultBranchSettings] - Reset the default branch settings
  static void resetDefaultBranchSettings(String defaultBranchKey) {
    final defaultBranchMap = {
      "name": defaultBranchKey,
      "key": defaultBranchKey,
      "user_id": AuthService.userDetails?.id,
      "company_id": AuthService.userDetails?.companyDetails?.id,
      'value': ""
    };
    CompanySettingsService.addOrReplaceCompanySetting(defaultBranchKey, defaultBranchMap);
  }

  static Map<String, dynamic> getFavouriteParams(String worksheetType, int? supplierId) {
    return {
      if(Helper.isSRSv2Id(Helper.getSupplierId())) ...{
        'exclude_suppliers[]': Helper.isSRSv1Id(supplierId)
            ? Helper.getSRSV2Supplier() : Helper.getSRSV1Supplier()
      },
      ...getFavouriteParamsFromType(worksheetType),
      ...{
        'includes[2]' : 'job',
        'includes[3]' : 'job.rep_ids',
        'includes[4]' : 'job.estimator_ids',
        'includes[5]' : 'job.sub_ids'
      }
    };
  }

  static int? getSrsSupplierId(WorksheetModel? worksheet) {
    int? srsSupplierId;
    if(!Helper.isValueNullOrEmpty(worksheet?.suppliers)) {
      for(var supplier in worksheet!.suppliers!) {
        if(Helper.isSRSv1Id(supplier.id)) {
          srsSupplierId = supplier.id;
          break;
        }
      }
    }
    return srsSupplierId;
  }

  /// [showABCSupplierInfoDialog] shows ABC branch info updated msg
  static showABCSupplierInfoDialog() {
    showJPBottomSheet(child: (_) => JPConfirmationDialog(
      title: 'abc_supplier_info'.tr,
      subTitle: 'abc_supplier_info_msg'.tr,
      type: JPConfirmationDialogType.alert,
      prefixBtnText: 'confirm'.tr.toUpperCase(),
      prefixBtnColorType: JPButtonColorType.tertiary,
      onTapSuffix: Get.back<void>,
    ));
  }

  /// [showQuantityWarningDialog] shows Zero Quantity warning dialog
  static showQuantityWarningDialog({required bool isAbcOrder, bool isFromQuickAction= false, VoidCallback? onTapUpdate}) {
    showJPDialog(child: (_) =>
        Material(
          color: JPColor.transparent,
          child: Center(
            child: JPConfirmationDialog(
              title: isAbcOrder ? 'abc_order_requires_quantities'.tr : 'beacon_order_requires_quantities'.tr,
              subTitle: isAbcOrder ? 'abc_zero_quantity_msg'.tr : 'beacon_zero_quantity_msg'.tr,
              type: isFromQuickAction ? JPConfirmationDialogType.message : JPConfirmationDialogType.alert,
              prefixBtnText: isFromQuickAction ? 'cancel'.tr.toUpperCase() : 'ok'.tr.toUpperCase(),
              prefixBtnColorType: isFromQuickAction ? null : JPButtonColorType.tertiary,
              suffixBtnText: 'update'.tr.toUpperCase(),
              onTapSuffix: () {
                Get.back();
                onTapUpdate?.call();
              },
            ),
          ),
        ));
  }

  /// [isQuantityZero] Check whether any Beacon & ABC Line item exist
  /// [lineItems] List of Worksheet Line Items
  static bool isBeaconOrABCQuantityZero(List<SheetLineItemModel> lineItems) {
    if(lineItems.isEmpty) return true;
    bool isQuantityZero = false;
    for(final item in lineItems) {
      final qty = Helper.isValueNullOrEmpty(item.qty) ? '0' : item.qty!;
      final int? supplierId = int.tryParse(item.supplierId ?? '');
      if((Helper.isBeaconSupplierId(supplierId) || Helper.isABCSupplierId(supplierId)) && num.tryParse(qty)! <= 0) {
        isQuantityZero = true;
        break;
      }
    }
    return isQuantityZero;
  }

  /// [doSaveWithNegativeTotal] - In case of total is negative - Dialog will be shown
  /// for conformation, whether to save the worksheet with negative total
  static Future<bool> doSaveWithNegativeTotal(num total, bool isEdit) async {
    if (total < 0) {
      bool saveWithNegativeTotal = await showNegativeTotalConfirmation(total, isEdit);
      return saveWithNegativeTotal;
    }
    return true;
  }

  /// [showNegativeTotalConfirmation] - Displays the confirmation dialog for negative total
  static Future<bool> showNegativeTotalConfirmation(num total, bool isEdit) async {
    bool saveWithNegativeTotal = false;
    await showJPBottomSheet(
      child: (_) {
        return JPConfirmationDialog(
          title: 'confirmation'.tr,
          icon: Icons.warning_amber_outlined,
          content: Text.rich(
            JPTextSpan.getSpan(
                'total_for_this_worksheet_is_negative'.tr,
                height: 1.5,
                textColor: JPAppTheme.themeColors.tertiary,
                children: [
                  JPTextSpan.getSpan(
                      ' (', textColor: JPAppTheme.themeColors.tertiary
                  ),
                  // Negative Total
                  JPTextSpan.getSpan(
                    JobFinancialHelper.getCurrencyFormattedValue(
                      value: total,
                    ),
                    textColor: JPAppTheme.themeColors.red,
                  ),
                  JPTextSpan.getSpan(
                      '). ', textColor: JPAppTheme.themeColors.tertiary
                  ),
                  JPTextSpan.getSpan(
                      isEdit
                          ? 'do_you_want_to_update_it_or_continue_editing'.tr
                          : 'do_you_want_to_save_it_or_continue_editing'.tr,
                      textColor: JPAppTheme.themeColors.tertiary
                  ),

                ]
            ),
            textAlign: TextAlign.center,
          ),
          suffixBtnText: isEdit ? 'update'.tr : 'save'.tr,
          prefixBtnText: 'continue'.tr,
          onTapSuffix: () {
            saveWithNegativeTotal = true;
            Get.back();
          },
        );
      },
    );

    return saveWithNegativeTotal;
  }

  /// [getBranchCode] - Gets tha available branch code
  static String? getBranchCode(String? srsBranchCode, String? beaconBranchCode, String? abcBranchCode) {
    String? branchCode;
    if(srsBranchCode != null) {
      branchCode = srsBranchCode;
    }
    if(beaconBranchCode != null) {
      branchCode = beaconBranchCode;
    }
    if(abcBranchCode != null) {
      branchCode = abcBranchCode;
    }
    return branchCode;
  }

  /// [getBranchCode] - Gets the supplier id for which branch code is available
  static int? getSupplierId(String? srsBranchCode, String? abcBranchCode, int? srsSupplierId) {
    int? supplierId;
    if(srsBranchCode != null) {
      supplierId = srsSupplierId;
    }
    if(abcBranchCode != null) {
      supplierId = Helper.getSupplierId(key: CommonConstants.abcSupplierId);
    }
    return supplierId;
  }

  static String? getItemCodeInDescription({
    required int? supplierId,
    required String? productCode,
    required String? variantCode,
    required String? productDescription,
    required String? lineItemDescription}) {
    final String itemCode = Helper.isSRSv2Id(supplierId)
        ? productCode ?? ''
        : variantCode?.isNotEmpty == true
        ? variantCode! : productCode ?? '';
    if (itemCode.isEmpty) return null;

    String itemCodeDesc = '${'item_code'.tr}: $itemCode';
    final bool isSRSv2Supplier = Helper.isSRSv2Id(supplierId);
    String? description;
    if (isSRSv2Supplier) {
      description = itemCodeDesc;
    } else if (!Helper.isValueNullOrEmpty(productDescription)) {
      description = '$productDescription \n $itemCodeDesc';
    } else if(lineItemDescription?.contains('item_code'.tr) ?? false) {
      description = itemCodeDesc;
    } else if (!Helper.isValueNullOrEmpty(lineItemDescription)) {
      description = '$lineItemDescription \n $itemCodeDesc';
    } else {
      description = itemCodeDesc;
    }

    return description;
  }

  /// [getLineItemAbove] gives the line item within or above the given tier index in the list of tiers or.
  /// If the tiers do not exist, it gives the last line item in the list.
  /// Params:
  /// [lineItems] The list of line items.
  /// [tierIndex] The index of the tier to find the item within or above.
  static SheetLineItemModel? getLineItemAbove({
    required List<SheetLineItemModel> lineItems,
    int? tierIndex
  }) {
    // If there are no tiers simply refer to the last item of the
    // line items list, In case it exists
    if (tierIndex == null) {
      return lineItems.isNotEmpty ? lineItems.last : null;
    } else {
      // List to hold line items above the given index
      List<SheetLineItemModel> aboveLineItems = [];
      // Preparing a list of all the items that fall within or above the selected tier
      WorksheetHelpers.tierListIterator(lineItems.sublist(0, tierIndex + 1), action: (item) {
        aboveLineItems.addAll(item.subItems ?? []);
      });
      // Returning the last item of the above line items list, In case it exists
      return aboveLineItems.isNotEmpty ? aboveLineItems.last : null;
    }
  }

  static bool isDivisionMatches(List<DivisionModel>? divisions, int? selectedDivisionId) {
    return divisions?.any((element) => element.id == selectedDivisionId) ?? false;
  }

  /// [getSupplierBranch] gets the selected supplier branch.
  /// Params:
  /// [type] The material supplier type.
  /// [selectedSrsBranch] The selected SRS branch.
  /// [selectedBeaconBranch] The selected Beacon branch.
  /// [selectedAbcBranch] The selected ABC branch.
  static SupplierBranchModel? getSupplierBranch(
      MaterialSupplierType type,{
        SupplierBranchModel? selectedSrsBranch,
        SupplierBranchModel? selectedBeaconBranch,
        SupplierBranchModel? selectedAbcBranch,
      }) {
    switch(type) {
      case MaterialSupplierType.srs:
        return selectedSrsBranch;
      case MaterialSupplierType.beacon:
        return selectedBeaconBranch;
      case MaterialSupplierType.abc:
        return selectedAbcBranch;
    }
  }

  /// [fetchSRSProductPrice] helps to fetch all srs product prices
  static Future<bool?> isProductPriceListEmpty(WorksheetModel? worksheet, MaterialSupplierType type, int? supplierID, String? fileId) async {
    Map<String, dynamic> params = getProductPriceListParams(worksheet, type, supplierID, fileId);
    showJPLoader();
    try {
      final response = await FinancialProductRepository().getPriceList(params, type: type, srsSupplierId: supplierID);
      Get.back();
      return Helper.isValueNullOrEmpty(response['deleted_items']);
    } on DioException catch (e) {
      Get.back();
      WorksheetHelpers.handleBeaconError(e);
    } catch (e) {
      Get.back();
      rethrow;
    }
    return null;
  }

  static Map<String, dynamic> getProductPriceListParams(WorksheetModel? worksheet, MaterialSupplierType type, int? supplierId, String? fileId) {
    switch (type) {
      case MaterialSupplierType.srs:
        return {
          'branch_code': worksheet?.branchCode,
          'material_list_id': fileId,
          'ship_to_sequence_number': worksheet?.shipToSequenceNumber,
          'supplier_id': supplierId
        };
      case MaterialSupplierType.beacon:
        return {
          'account_id': worksheet?.beaconAccountId,
          'material_list_id': fileId,
          'job_number': worksheet?.beaconJobNumber,
          ...CommonConstants.ignoreToastQueryParam
        };
      case MaterialSupplierType.abc:
        return {
          'branch_code': worksheet?.branchCode,
          'material_list_id': fileId,
          'supplier_account_id': worksheet?.supplierAccountId
        };
    }
  }


  /// Converts a worksheet type to its corresponding company settings key.
  ///
  /// Takes a worksheet type string and returns the appropriate company settings key
  /// that stores the default settings for that worksheet type.
  ///
  /// Params:
  /// [worksheetType] The type of worksheet (estimate, material list, work order, or proposal)
  ///
  /// Returns:
  /// The company settings key string for the given worksheet type.
  /// Returns empty string if worksheet type is not recognized.
  static String typeToSettingsKey(String worksheetType) {
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

  /// Gets the default worksheet settings for a given worksheet type from company settings.
  ///
  /// Retrieves and parses the default settings stored in company settings for the specified
  /// worksheet type. If no settings exist or if they are invalid, returns empty settings.
  ///
  /// Parameters:
  /// - [worksheetType] The type of worksheet to get default settings for (e.g. estimate, material list)
  ///
  /// Returns:
  /// A [WorksheetSheetSetting] object containing the default settings, or empty settings if none found.
  ///
  /// Throws:
  /// Rethrows any exceptions that occur during settings retrieval or parsing.
  static WorksheetSheetSetting? getWorksheetDefaultSettings({
    required String worksheetType,
  }) {
    try {
      // Get the company settings key for this worksheet type
      final settingsKey = typeToSettingsKey(worksheetType);

      // Retrieve settings from company settings service
      dynamic result = CompanySettingsService.getCompanySettingByKey(settingsKey);

      // If settings are null/invalid, use empty map
      if (result is bool || result?['settings'] == null) {
        result = <String, dynamic>{};
      }

      // Create and populate settings object from JSON
      final settings = WorksheetSheetSetting();
      settings.fromJson(result['settings']);
      return settings;
    } catch (e) {
      rethrow;
    }
  }

  /// Determines whether to show the default settings selector for a given worksheet type.
  ///
  /// This method checks if the default settings selector should be displayed based on
  /// the worksheet type. Currently returns true for work orders, material lists, and
  /// proposals, and false for all other types.
  ///
  /// Parameters:
  /// - [worksheetType] The type of worksheet to check (e.g. work order, material list, proposal)
  ///
  /// Returns:
  /// A boolean indicating whether to show the default settings selector for this worksheet type.
  static bool doShowDefaultSettingsSelector(String worksheetType) {
    switch (worksheetType) {
      case WorksheetConstants.workOrder:
      case WorksheetConstants.materialList:
      case WorksheetConstants.proposal:
        return true;
      default:
        return false;
    }
  }

  // Show product availability confirmation modal
  static Future<void> showProductAvailabilityConfirmationModal(
      {bool placeOrder = false, void Function()? onProceed}) async {
    await showJPBottomSheet(
      child: (controller) {
        return JPConfirmationDialog(
          icon: Icons.warning_amber_outlined,
          title: 'confirmation'.tr,
          suffixBtnText: 'proceed'.tr,
          prefixBtnText: 'cancel'.tr,
          subTitle: 'product_unavailability_notice'.tr,
          disableButtons: controller.isLoading,
          suffixBtnIcon: showJPConfirmationLoader(show: controller.isLoading),
          onTapSuffix: () {
            Get.back();
            if (placeOrder) {
              onProceed?.call();
            }
          },
          onTapPrefix: () {
            Get.back();
            if (placeOrder) return;
            Get.back();
          },
        );
      },
    );
  }

  ///Checks if an integrated supplier exists in the worksheet
  /// Params:
  /// [worksheet] - The worksheet object to check
  static bool hasIntegratedSupplier(WorksheetModel? worksheet) {
    if(Helper.isValueNullOrEmpty(worksheet?.suppliers)) return false;
    return worksheet?.suppliers?.any((element) => Helper.isIntegratedSupplier(element.id)) ?? false;
  }

  /// [showEditWorksheetRestrictionDialog] shows a dialog to restrict editing of worksheet
  static showEditWorksheetRestrictionDialog() {
    showJPBottomSheet(child: (_) => JPConfirmationDialog(
      title: 'editing_of_favourite_worksheet_is_restricted'.tr,
      subTitle: 'don_t_have_access_to_the_job'.tr,
      type: JPConfirmationDialogType.alert,
      prefixBtnText: 'ok'.tr.toUpperCase(),
      prefixBtnColorType: JPButtonColorType.tertiary,
      onTapSuffix: Get.back<void>,
    ));
  }

  /// [showBeaconServerDownErrorDialog] shows Beacon server down error dialog
  static void showBeaconServerDownErrorDialog() => showJPDialog(child: (_) => const BeaconServerDownErrorDialog());

  /// [showConfirmationVariationDialog] shows a confirmation dialog for variations
  static Future<void> showConfirmationVariationDialog({VoidCallback? onUpdate}) async {
    bool isUpdateMode = onUpdate != null;
    await showJPBottomSheet(
      child: (controller) {
        return JPConfirmationDialog(
          icon: Icons.warning_amber_outlined,
          title: 'variation_confirmation_required'.tr,
          suffixBtnText: isUpdateMode ? 'update'.tr : null,
          prefixBtnText: isUpdateMode ? 'cancel'.tr : 'ok'.tr,
          prefixBtnColorType: isUpdateMode ? null : JPButtonColorType.tertiary,
          subTitle: 'variation_confirmation_desc'.tr,
          disableButtons: controller.isLoading,
          suffixBtnIcon: showJPConfirmationLoader(show: controller.isLoading),
          type: isUpdateMode ? JPConfirmationDialogType.message : JPConfirmationDialogType.alert,
          onTapSuffix: () {
            Get.back();
            onUpdate?.call();
          },
          onTapPrefix: Get.back<void>,
        );
      },
    );
  }

  /// [isVariationConfirmationRequired] checks if any line item requires variation confirmation
  static bool isVariationConfirmationRequired(List<SheetLineItemModel> lineItems) {
    for(final item in lineItems) {
      if(Helper.isTrue(item.isConfirmedVariationRequired) && !Helper.isTrue(item.isConfirmedVariation)) {
        return true;
      }
    }
    return false;
  }
}
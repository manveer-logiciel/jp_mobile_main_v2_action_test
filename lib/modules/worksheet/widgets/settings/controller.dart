import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/worksheet.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/common/models/worksheet/settings/index.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';
import 'widgets/percent_amount_dialog/index.dart';

class WorksheetSettingsController extends GetxController {

  WorksheetSettingModel settings = Get.arguments[NavigationParams.settings];

  int? forSupplierId = Get.arguments?[NavigationParams.forSupplierId];
  int? get supplierId => Helper.getSupplierId();

  bool hasEditPermission = PermissionService.hasUserPermissions([PermissionConstants.workSheetSettingsWithInJob]);

  bool get showTaxAndOtherSection => !settings.isQbWorksheet;
  bool get showTaxSection => !(settings.isMaterialWorkSheet && forSupplierId == supplierId);
  bool get isNotWorkOrderAndMaterial => !settings.isMaterialWorkSheet && !settings.isWorkOrderSheet;
  bool get showColor => (!settings.isBeaconEnable && !settings.isSRSEnable) || ((settings.isBeaconEnable || settings.isSRSEnable) && showColorControls);
  bool get showSize => (!settings.isBeaconEnable && !settings.isSRSEnable) || ((settings.isBeaconEnable || settings.isSRSEnable) && showSizeControls);

  List<SheetLineItemModel>? lineItems = Get.arguments[NavigationParams.lineItems];

  /// [showVariationControls] check Variation is available in any line item
  bool get showVariationControls => lineItems?.any((element) => !Helper.isValueNullOrEmpty(element.product?.variants)) ?? false;

  /// [showColorControls] check Color is available in any line item
  bool get showColorControls => lineItems?.any((element) => !Helper.isValueNullOrEmpty(element.product?.colors)) ?? false;

  /// [showSizeControls] check Size is available in any line item
  bool get showSizeControls => lineItems?.any((element) => !Helper.isValueNullOrEmpty(element.product?.sizes)) ?? false;

  /// Tax toggles -------------------------------------------------------------

  Future<void> toggleApplyTaxMaterial(bool val) async {
    bool result = await validateToggle(
      message: 'material_tax_apply_desc'.tr,
      condition: val && settings.addLineItemTax!
    );
    if (!result) return;
    settings.applyTaxMaterial = val;
    settings.addLineItemTax = false;
    settings.overriddenMaterialTaxRate = settings.selectedMaterialTaxRateId = null;
    settings.revisedMaterialTax = null;
    update();
  }

  Future<void> toggleApplyTaxLabor(bool val) async {
    bool result = await validateToggle(
        message: 'labor_tax_apply_desc'.tr,
        condition: val && settings.addLineItemTax!
    );
    if (!result) return;
    settings.applyTaxLabor = val;
    settings.addLineItemTax = false;
    settings.overriddenLaborTaxRate = settings.selectedLaborTaxRateId = null;
    settings.revisedLaborTax = null;
    update();
  }

  Future<void> toggleApplyTaxAll(bool val) async {
    bool result = await validateToggle(
        message: 'all_tax_apply_desc'.tr,
        condition: val && settings.addLineItemTax!
    );
    if (!result) return;
    settings.applyTaxAll = val;
    settings.addLineItemTax = false;
    settings.overriddenTaxRate = settings.selectedTaxRateId = null;
    settings.revisedTaxAll = null;
    update();
  }

  Future<void> toggleAddLineItemTax(bool val) async {
    bool result = await validateToggle(
        message: 'line_item_tax_apply_desc'.tr,
        condition: val && settings.isOverAllTaxSelected
    );
    if (!result) return;
    settings.addLineItemTax = val;
    if (!val) settings.lineItemTaxPercent = null;
    settings.applyTaxMaterial = false;
    settings.applyTaxLabor = false;
    settings.applyTaxAll = false;
    settings.overriddenMaterialTaxRate = settings.selectedMaterialTaxRateId = null;
    settings.overriddenTaxRate = settings.selectedTaxRateId = null;
    settings.overriddenLaborTaxRate = settings.selectedLaborTaxRateId = null;
    update();
  }

  void editLineItemTax() {
    showPercentAmountDialog(
        type: WorksheetPercentAmountDialogType.lineItemTax,
        condition: settings.addLineItemTax!,
    );
  }

  /// Other Option Toggles ----------------------------------------------------

  void toggleOverhead(bool val) {
    settings.applyOverhead = val;
    settings.overriddenOverHeadRate = null;
    update();
  }

  Future<void> toggleProfit(bool val) async {
    final result = await showPercentAmountDialog(
      subTitle: settings.applyLineItemProfit! ? 'overall_profit_apply_desc'.tr : "",
      type: WorksheetPercentAmountDialogType.overAllProfit,
      condition: val || settings.applyLineAndWorksheetProfit!,
    );

    onProfitToggled(val, result);
  }

  void onProfitToggled(bool val, bool result) {
    if (val) {
      settings.lineItemProfitPercent = null;
      settings.lineItemTempProfitPercent = null;
      settings.isLineItemProfitMarkup = null;
    } else {
      settings.overAllProfitAmount = settings.overAllProfitPercent = null;
      settings.isOverAllProfitMarkup = null;
    }

    if (!result) return;
    settings.applyProfit = val;
    settings.applyLineItemProfit = false;
    settings.applyLineAndWorksheetProfit = false;
    update();
  }

  Future<void> toggleApplyLineItemProfit(bool val) async {
    final result = await validateToggle(
      message: 'line_profit_apply_desc'.tr,
      condition: settings.applyProfit! || settings.applyLineAndWorksheetProfit!
    );
    onLineItemProfitToggled(val, result);
  }

  void onLineItemProfitToggled(bool val, bool result) {
    if (val) {
      settings.overAllProfitAmount = settings.overAllProfitPercent = null;
      settings.isOverAllProfitMarkup = null;
    } else {
      settings.lineItemProfitPercent = null;
      settings.lineItemTempProfitPercent = null;
      settings.isLineItemProfitMarkup = null;
    }

    if (!result) return;
    settings.applyLineItemProfit = val;
    settings.applyProfit = false;
    settings.applyLineAndWorksheetProfit = false;
    update();
  }

  Future<void> toggleApplyLineAndWorksheetProfit(bool val) async {
    final result = await validateToggle(
        message: 'apply_line_and_worksheet_profit_desc'.tr,
        condition: val && (settings.applyProfit! || settings.applyLineItemProfit!)
    );
    onLineAndWorksheetProfitToggled(val, result);
  }

  void onLineAndWorksheetProfitToggled(bool val, bool result) {
    if(!val) {
      ///   clear worksheet profit
      settings.overAllProfitAmount = settings.overAllProfitPercent = null;
      settings.isOverAllProfitMarkup = null;
      ///   clear line item profit
      settings.lineItemProfitPercent = settings.lineItemTempProfitPercent = null;
      settings.isLineItemProfitMarkup = null;
    }

    if (!result) return;
    settings.applyLineAndWorksheetProfit = val;
    settings.applyProfit = val;
    settings.applyLineItemProfit = val;
    update();
  }

  Future<bool> editLineItemProfit() async {
    return await showPercentAmountDialog(
      type: WorksheetPercentAmountDialogType.lineItemProfit,
      condition: settings.applyLineItemProfit!,
    );
  }

  Future<void> toggleCommission(bool val) async {
    final result = await showPercentAmountDialog(
      type: WorksheetPercentAmountDialogType.commission,
      condition: val,
    );
    if (!result) return;
    onCommissionToggled(val);
  }

  void onCommissionToggled(bool val) {
    settings.applyCommission = val;
    if (!val) settings.commissionPercent = null;
    update();
  }

  Future<void> toggleCardFee(bool val) async {
    final result = await showPercentAmountDialog(
      type: WorksheetPercentAmountDialogType.cardFee,
      condition: val,
    );
    if (!result) return;
    onToggleCardFee(val);
  }

  void onToggleCardFee(bool val) {
    settings.applyProcessingFee = val;
    if (!val) settings.creditCardFeePercent = null;
    update();
  }

  /// Item Details ------------------------------------------------------------

  void toggleDescriptionOnly(bool val) {
    settings.descriptionOnly = val;
    settings.showUnit = !val;
    settings.showQuantity = !val;
    settings.showStyle = !settings.isWorkOrderSheet;
    settings.showSize =  !settings.isWorkOrderSheet && showSize;
    settings.showColor = !settings.isWorkOrderSheet && showColor;
    settings.showVariation = !settings.isWorkOrderSheet && showVariationControls;
    settings.showSupplier = true;
    settings.showTradeType = true;
    settings.showWorkType = true;
    update();
  }

  void toggleShowUnit(bool val) {
    settings.showUnit = val;
    update();
  }

   Future<void> toggleDiscount(bool val) async {
    final result = await showPercentAmountDialog(
      type: WorksheetPercentAmountDialogType.discount,
      condition: val,
    );
    if (!result) return;
    onToggleDiscount(val);
  }

  void onToggleDiscount(bool val) {
    settings.applyDiscount = val;
    if (!val) settings.discountPercent = null;
    update();
  }

  void toggleShowQuantity(bool val) {
    settings.showQuantity = val;
    update();
  }

  void toggleShowStyle(bool val) {
    settings.showStyle = val;
    update();
  }

  void toggleShowSize(bool val) {
    settings.showSize = val;
    update();
  }

  void toggleShowColor(bool val) {
    settings.showColor = val;
    update();
  }

  void toggleShowVariation(bool val) {
    settings.showVariation = val;
    update();
  }

  void toggleShowSupplier(bool val) {
    settings.showSupplier = val;
    update();
  }

  void toggleShowTradeType(bool val) {
    settings.showTradeType = val;
    update();
  }

  void toggleShowWorkType(bool val) {
    settings.showWorkType = val;
    update();
  }

  /// Amount ------------------------------------------------------------------

  void toggleHidePricing(bool val) {
    settings.hidePricing = !val;
    if (isNotWorkOrderAndMaterial) settings.hideTotal = val;
    settings.showTaxes = val;
    settings.showLineTotal = val;
    settings.showCalculationSummary = val;
    settings.showDiscount = val;
    update();
  }

  void toggleHideTotal(bool val) {
    settings.hideTotal = !val;
    update();
  }

  void toggleShowTaxes(bool val) {
    settings.showTaxes = val;
    update();
  }

  void toggleShowDiscount(bool val) {
    settings.showDiscount = val;
    update();
  }

  void toggleShowLineTotal(bool val) {
    settings.showLineTotal = val;
    update();
  }

  void toggleShowCalculationSummary(bool val) {
    if (isNotWorkOrderAndMaterial) settings.hideTotal = val;
    settings.showTaxes = val;
    settings.showCalculationSummary = val;
    settings.showDiscount = val;
    update();
  }

  /// [toggleShowTierTotal] is used to enable/disable tier Sub Totals
  void toggleShowTierTotal(bool val) {
    settings.showTierTotal = val;
    update();
  }

  /// [toggleShowTierSubTotals] is used to enable/disable tier Sub Totals
  void toggleShowTierSubTotals(bool val) {
    settings.showTierSubTotals = val;
    update();
  }

  void toggleShowTierColor(bool val) {
    settings.showTierColor = val;
    update();
  }

  void toggleHideCustomerInfo(bool val) {
    settings.hideCustomerInfo = val;
    update();
  }

  /// Dialogs & Helpers -------------------------------------------------------

  Future<bool> showPercentAmountDialog({
    String subTitle = "",
    required WorksheetPercentAmountDialogType type,
    bool condition = false,
  }) async {

    if (!condition) return true;

    bool result = false;
    try {
      await showJPGeneralDialog(
        child: (_) =>
            WorksheetPercentAmountDialog(
              subTitle: subTitle,
              settingModel: settings,
              type: type,
              onUpdate: () {
                result = true;
              },
            ),
      );
    } catch (e) {
      return result;
    }
    return result;
  }

  Future<bool> validateToggle({
    required String message,
    bool condition = false,
  }) async {
    if (!condition) return true;
    bool result = false;
    try {
      await showJPBottomSheet(child: (_) =>
          JPConfirmationDialog(
            title: 'confirmation'.tr,
            icon: Icons.warning,
            subTitle: message,
            onTapPrefix: Get.back<void>,
            onTapSuffix: () {
              result = true;
              Get.back();
            },
          ),
      );
    } catch(e) {
      result = false;
    }
    return result;
  }

}
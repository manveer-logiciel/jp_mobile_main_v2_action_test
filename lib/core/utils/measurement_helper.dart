import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/measurement_type.dart';
import 'package:jobprogress/common/extensions/String/index.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/forms/measurement/measurement.dart';
import 'package:jobprogress/common/models/forms/measurement/measurement_attribute.dart';
import 'package:jobprogress/common/models/forms/measurement/measurement_data.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/common/models/subscriber/hover_client.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/connected_third_party.dart';
import 'package:jobprogress/common/services/subscriber_details.dart';
import 'package:jobprogress/common/services/worksheet/calculations.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/regex_expression.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/Button/color_type.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/confirmation_dialog_type.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';
import 'package:jp_mobile_flutter_ui/Text/index.dart';
import '../../common/repositories/measurements.dart';
import '../../common/services/company_settings.dart';
import '../../global_widgets/bottom_sheet/index.dart';
import '../../global_widgets/eagle_view_auth_error_dialog/index.dart';
import '../../global_widgets/loader/index.dart';
import '../constants/measurement_constant.dart';
import 'package:jobprogress/common/models/sheet_line_item/measurement_formula_model.dart';

class MeasurementHelper {

  static bool isSubContractorPrime = AuthService.isPrimeSubUser();

  static HoverClient hoverClient = SubscriberDetailsService.subscriberDetails?.hoverClient??HoverClient();
  
  static bool isEagleviewUncompletedMeasurement(FilesListingModel file) {
    return (
      file.evReportId != null &&
      file.evOrder?.status != null &&
      file.path == null
    );
  }

  static bool isSkymeasureMeasurementHasNotFile(FilesListingModel file) {
    return (file.smOrderId != null && !file.isFile!);
  }

  static bool isHoverMeasurementHasNotFile(FilesListingModel file) {
    return (file.hoverJob != null && (!file.isFile!) && (file.path?.isEmpty ?? true));
  }

  static bool doShowMeasurementQuickAction(FilesListingModel selectedMeasurement) {
    if (
      isEagleviewUncompletedMeasurement(selectedMeasurement) ||
      isSkymeasureMeasurementHasNotFile(selectedMeasurement) &&
      selectedMeasurement.smOrder != null &&
      !( selectedMeasurement.smOrder!.status!.toLowerCase() == "cancelled" ||
        selectedMeasurement.smOrder!.status!.toLowerCase() == "hold"
      )
    ) { 
      return false;
    }

    // no action if quickmeasure reports are not created yet
    if (selectedMeasurement.type == 'quickmeasure' && selectedMeasurement.path == null ) {
      return false;
    }
    
    /**
     * Return if hover measurement have no file
     * and no hover images
     * and if hover type Complete
     */ 
    if(selectedMeasurement.hoverJob != null) {
      if (isHoverMeasurementHasNotFile(selectedMeasurement) &&
      (
        selectedMeasurement.hoverJob!.deliverableId == 3 ||
        !ConnectedThirdPartyService.isHoverConnected() ||
        hoverClient.ownerId != selectedMeasurement.hoverJob!.ownerId
      ) && (selectedMeasurement.hoverJob!.hoverImages?.isEmpty ?? true)){
        return false;
      }
    }

    if ( isSubContractorPrime && selectedMeasurement.smOrder != null &&
      ( selectedMeasurement.smOrder!.status!.toLowerCase() == "cancelled" ||
        selectedMeasurement.smOrder!.status!.toLowerCase() == "hold")
      ) {
        return false;
      }

      return true;
  }
  
  /// Sets the appropriate formula to a line item based on its trade type
  /// 
  /// This method checks if the item has a trade type and measurement formulas,
  /// then finds and sets the matching formula for that trade
  /// [item] The sheet line item to set the formula for
  static void setFormulaToItem (SheetLineItemModel item) {
    // Only proceed if the item has a trade type and measurement formulas
    if (item.tradeType != null && !Helper.isValueNullOrEmpty(item.measurementFormulas)) {  
      // Find the formula that matches the item's trade ID
      String? foundFormula = MeasurementHelper.findFormulaByTradeId(item.measurementFormulas, item.tradeType!.id);
      // If a matching formula is found, set it to the item
      if (foundFormula != null) {
        item.formula = foundFormula;
      }
    }
  }

  /// Finds the matching formula for a given trade ID from a list of measurement formulas
  /// 
  /// [formulas] The list of measurement formulas to search through
  /// [tradeId] The trade ID to match against
  /// Returns the matching formula string or null if no match is found
  static String? findFormulaByTradeId(List<MeasurementFormulaModel>? formulas, String? tradeId) {
    // Return null if either formulas or tradeId is empty
    if (Helper.isValueNullOrEmpty(formulas) || Helper.isValueNullOrEmpty(tradeId)) {
      return null;
    }

    // Iterate through each formula to find a matching trade ID
    for (var formula in formulas!) {
      // Compare trade IDs as strings to ensure proper matching
      if (formula.tradeId.toString() == tradeId.toString()) {
        return formula.formula;
      }
    }

    // Return null if no matching formula is found
    return null;
  }

  static String formulaUnnormalization(String ? formula, bool forRegex) {
  if (Helper.isValueNullOrEmpty(formula)) {
    return '';
  }

  final RegExp re = RegExp(r'[\\/\\(\\)+*-]');
  final String prefix = forRegex ? ' \\' : ' ';
  
  return ' ${formula!.replaceAllMapped(re, (Match match) {
    return '$prefix${match.group(0)} ';
  })} ';
}

  static List<SheetLineItemModel> getAppliedMeasurementItems(MeasurementModel measurement, List<SheetLineItemModel> items, {String? wasteFactor}) {
    if(wasteFactor != null) {
      setHoverWasteFactor(wasteFactor, measurement);
    }
    for (SheetLineItemModel item in items) {
      if(Helper.isValueNullOrEmpty(item.actualQty)){
        item.actualQty = item.qty;
      }
      item.qty = getProductQuantity(measurement, item);
    }
    return items;
  }
  
  static String getProductQuantity(MeasurementModel measurement, SheetLineItemModel item) {
    if (!Helper.isValueNullOrEmpty(measurement.measurements)) {

      setFormulaToItem(item);

      String? formula = item.formula ?? "";

      if (formula.isEmpty) {
        return item.qty ?? "";
      }

      for (var i = 0; i < measurement.measurements!.length; i++) {
        if (measurement.measurements![i].id.toString() == item.tradeType?.id &&
          !Helper.isValueNullOrEmpty(measurement.measurements![i].attributes)
        ) {
          for (MeasurementAttributeModel attribute in measurement.measurements![i].attributes!) {
            if(!Helper.isValueNullOrEmpty(attribute.subAttributes)) {
              for (MeasurementAttributeModel subAttribute in attribute.subAttributes!) {
                formula = formula?.replaceAll(subAttribute.slug ?? "", (subAttribute.value ?? 0).toString());
              }
            } else {
              formula = formula?.replaceAll(attribute.slug ?? "", Helper.isValueNullOrEmpty(attribute.value) ? "0" : attribute.value.toString());
            }
          }
          //handle errors
          try {
            if(!Helper.isTrue(formula?.isValidMathExpression())) {
              return '0';
            }
            formula = formulaUnnormalization(formula, false);
            var regex = RegExp(RegexExpression.alphabet);
            formula = formula.replaceAll(regex, '0');
            formula = formula.evaluate().toString();
          } catch (err) {
            return '0';
          }
          final result = WorksheetCalculations.convertToFixedNum(num.parse(formula)).toString();

          if(isQuantityGlobalRoundOffEnabled()) {
            return (double.parse(result).ceil()).toString();
          } else {
            return result;
          }
        }
      }
    }
    return item.qty ?? "";
  }

  /// This method is used to determine whether a given [slug] represents the name field for a particular measurement or trade.
  static bool isNameField({int? measurementId, String? slug}) {
    return slug == 'name' || slug == 'trade_id_${measurementId}_slug_name' ;
  }

  static String getAttributeHintText({required MeasurementDataModel measurement, required int index}) {
    final slug = measurement.attributes![index].slug;
    final isName = isNameField(measurementId: measurement.id, slug: slug);
    return isName ? 'name'.tr : '0.0'; 
  }

  static TextInputType getAttributeKeyBoardType({required MeasurementDataModel measurement, required int index}) {
    if(!isNameField(measurementId: measurement.id, slug: measurement.attributes![index].slug)){
      return const TextInputType.numberWithOptions(decimal: true);
    }
    return TextInputType.text;
  }

  static List<TextInputFormatter>? getAttributeInputFormatters({required MeasurementDataModel measurement, required int index}) {
  
    final attribute = measurement.attributes![index];

    if (!isNameField(measurementId: measurement.id, slug: attribute.slug)) {
      final regex = RegExp(RegexExpression.amount);
      return [FilteringTextInputFormatter.allow(regex)];
    }

    return null;
  }

  static bool isQuantityGlobalRoundOffEnabled() {
    final value = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.globalFormulaRoundUp);
    return Helper.isTrue(value);
  }

  static Future<void> handleEagleViewError(DioException error, {VoidCallback? eagleViewAuthenticated}) async {
    if(error.response?.statusCode == 412) {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      showEVAuthErrorDialog(eagleViewAuthenticated: eagleViewAuthenticated);
    }
    Helper.recordError(error);
  }

  /// [showEVAuthErrorDialog] shows EagleView Auth error dialog
  static void showEVAuthErrorDialog({VoidCallback? eagleViewAuthenticated}) => showJPDialog(
    child: (_) => EagleViewAuthErrorDialog(onTapLogin: () => navigateToEagleViewConnectWebView(eagleViewAuthenticated: eagleViewAuthenticated)));

  static Future<void> navigateToEagleViewConnectWebView({VoidCallback? eagleViewAuthenticated}) async {
    final result = await Get.toNamed(Routes.eagleViewConnectWebView);
    if(result == true) {
      eagleViewAuthenticated?.call();
    } else {
      Get.back();
    }
  }

  /// [showApplyingSuggestedWasteFactorDialog] shows Applying suggested waste factor dialog
  static void showApplyingSuggestedWasteFactorDialog(
      int hoverJobId,
      int wasteFactorAttributeId,
      {Function(String)? wasteFactorApplied, VoidCallback? onTapNo}) =>
      showJPBottomSheet(
         child: (_) => JPConfirmationDialog(
             icon: Icons.error_outline_outlined,
             title: 'apply_suggested_waste_factor'.tr,
             type: JPConfirmationDialogType.message,
             prefixBtnColorType: JPButtonColorType.tertiary,
             suffixBtnText: 'yes'.tr.toUpperCase(),
             prefixBtnText: 'no'.tr.toUpperCase(),
             onTapSuffix: () {
               Get.back();
               applySuggestedWasteFactor(hoverJobId, wasteFactorAttributeId, wasteFactorApplied);
             },
             onTapPrefix: () {
               Get.back();
               onTapNo?.call();
             },
             content: JPText(
               text: 'apply_suggested_waste_factor_msg'.tr,
             )
         ));

  /// [showApplyingSuggestedWasteFactorRetryDialog] shows Applied waste factor retry dialog
  static void showApplyingSuggestedWasteFactorRetryDialog({
    required VoidCallback onTapRetry,
  }) => showJPBottomSheet(
      child: (_) => JPConfirmationDialog(
          icon: Icons.error_outline_outlined,
          title: 'applied_waste_factor_fail'.tr,
          type: JPConfirmationDialogType.message,
          prefixBtnColorType: JPButtonColorType.tertiary,
          suffixBtnText: 'retry'.tr.toUpperCase(),
          prefixBtnText: 'close'.tr.toUpperCase(),
          onTapSuffix: () {
            Get.back();
            onTapRetry.call();
          },
          onTapPrefix: Get.back<void>,
          content: JPText(
            text: 'applied_waste_factor_fail_msg'.tr,
          )
      ));

  /// [getWasteFactorAttributeId] get waste factor attribute Id from measurement values
  static int? getWasteFactorAttributeId(MeasurementModel? measurementModel) {
    int? wasteFactorAttributeId;
    if(measurementModel?.type == MeasurementType.hover.name) {
      for(var measurement in measurementModel?.measurements ?? []) {
        if(measurement.name?.toLowerCase() == MeasurementConstant.roofing) {
          for(var valueData in measurement.values ?? []) {
            for(var value in valueData) {
              if(Helper.isTrue(value.thirdPartyAttributeEditable)) {
                wasteFactorAttributeId = value.id;
                break;
              }
            }
          }
        }
      }
    }

    return wasteFactorAttributeId;
  }

  /// [applySuggestedWasteFactor] apply suggest waste factor
  static Future<void> applySuggestedWasteFactor(int hoverJobId, int wasteFactorAttributeId, Function(String)? wasteFactorApplied) async {
    try {
      showJPLoader();
      final String? wasteFactor = await MeasurementsRepository.updateWasteFactor(hoverJobId, wasteFactorAttributeId);
      Get.back();
      if(wasteFactor != null) {
        Helper.showToastMessage('waste_factor_applied'.tr);
        wasteFactorApplied?.call(wasteFactor);
      }
    } on DioException catch(e) {
      Helper.recordError(e);
      Get.back();
      MeasurementHelper.showApplyingSuggestedWasteFactorRetryDialog(onTapRetry: () {
        applySuggestedWasteFactor(hoverJobId, wasteFactorAttributeId, wasteFactorApplied);
      });
    }
  }

  /// [setHoverWasteFactor] set waste factor value in measurement values
  static void setHoverWasteFactor(String wasteFactor, MeasurementModel? measurementModel) {
    if(measurementModel?.type == MeasurementType.hover.name) {
      for(var measurement in measurementModel?.measurements ?? []) {
        if(measurement.name?.toLowerCase() == MeasurementConstant.roofing) {
          for(var attribute in measurement.attributes ?? []) {
              if(Helper.isTrue(attribute.thirdPartyAttributeEditable)) {
                attribute.value = wasteFactor;
                break;
            }
          }
        }
      }
    }
  }

}

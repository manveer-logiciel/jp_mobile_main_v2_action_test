import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/financial_product/financial_product_model.dart';
import 'package:jobprogress/common/models/financial_product/variants_model.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/common/models/worksheet/settings/applied_percentage.dart';
import 'package:jobprogress/common/models/worksheet/settings/index.dart';
import 'package:jobprogress/common/models/worksheet/worksheet_model.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/core/config/app_env.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/modules/worksheet/widgets/settings/controller.dart';

import 'mocked_data.dart';

void main() {

  WorksheetMockedSettings mockedData = WorksheetMockedSettings();

  late WorksheetSettingModel settings;
  late WorksheetSettingsController controller;

  final lineItem = SheetLineItemModel(
      productId: '1',
      title: 'Demo',
      price: '1.0',
      qty: '1',
      totalPrice: '1'
  );

  void setController() {
    controller = WorksheetSettingsController();
  }

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    settings = WorksheetSettingModel.fromJson(mockedData.plainSettings);
    PermissionService.permissionList.addAll([PermissionConstants.workSheetSettingsWithInJob]);
    Get.routing.args = {
      NavigationParams.settings: settings
    };
    setController();
  });

  test("WorksheetSettingsController should be initialized with correct data", () {
    expect(controller.settings, settings);
    expect(controller.forSupplierId, isNull);
    expect(controller.hasEditPermission, isTrue);
  });

  group("WorksheetSettingsController@toggleApplyTaxMaterial should toggle material tax rate", () {
    group("When line item tax is applied", () {
      setUp(() {
        controller.settings.addLineItemTax = true;
      });

      test("Material tax can't be applied", () async {
        await controller.toggleApplyTaxMaterial(true);
        expect(controller.settings.applyTaxMaterial, isFalse);
        expect(controller.settings.addLineItemTax, isTrue);
        expect(controller.settings.overriddenMaterialTaxRate, settings.overriddenMaterialTaxRate);
        expect(controller.settings.selectedMaterialTaxRateId, settings.selectedMaterialTaxRateId);
        expect(controller.settings.revisedMaterialTax, settings.revisedMaterialTax);
      });

      test("Material tax can be removed", () async {
        await controller.toggleApplyTaxMaterial(false);
        expect(controller.settings.applyTaxMaterial, isFalse);
        expect(controller.settings.addLineItemTax, isFalse);
        expect(controller.settings.overriddenMaterialTaxRate, settings.overriddenMaterialTaxRate);
        expect(controller.settings.selectedMaterialTaxRateId, settings.selectedMaterialTaxRateId);
        expect(controller.settings.revisedMaterialTax, settings.revisedMaterialTax);
      });
    });

    group("When line item tax is not applied", () {
      setUp(() {
        controller.settings.addLineItemTax = false;
      });

      test("Material tax can be applied", () async {
        await controller.toggleApplyTaxMaterial(true);
        expect(controller.settings.applyTaxMaterial, isTrue);
        expect(controller.settings.addLineItemTax, isFalse);
        expect(controller.settings.overriddenMaterialTaxRate, isNull);
        expect(controller.settings.selectedMaterialTaxRateId, isNull);
        expect(controller.settings.revisedMaterialTax, isNull);
      });

      test("Material tax can be removed", () async {
        await controller.toggleApplyTaxMaterial(false);
        expect(controller.settings.applyTaxMaterial, isFalse);
        expect(controller.settings.addLineItemTax, isFalse);
        expect(controller.settings.overriddenMaterialTaxRate, settings.overriddenMaterialTaxRate);
        expect(controller.settings.selectedMaterialTaxRateId, settings.selectedMaterialTaxRateId);
        expect(controller.settings.revisedMaterialTax, settings.revisedMaterialTax);
      });
    });
  });

  group("WorksheetSettingsController@toggleApplyTaxLabor should toggle labour tax rate", () {
    group("When line item tax is applied", () {
      setUp(() {
        controller.settings.addLineItemTax = true;
      });

      test("Labour tax can't be applied", () async {
        await controller.toggleApplyTaxLabor(true);
        expect(controller.settings.applyTaxLabor, isFalse);
        expect(controller.settings.addLineItemTax, isTrue);
        expect(controller.settings.overriddenLaborTaxRate, settings.overriddenLaborTaxRate);
        expect(controller.settings.selectedLaborTaxRateId, settings.selectedLaborTaxRateId);
        expect(controller.settings.revisedLaborTax, settings.revisedLaborTax);
      });

      test("Labour tax can be removed", () async {
        await controller.toggleApplyTaxLabor(false);
        expect(controller.settings.applyTaxLabor, isFalse);
        expect(controller.settings.addLineItemTax, isFalse);
        expect(controller.settings.overriddenLaborTaxRate, settings.overriddenLaborTaxRate);
        expect(controller.settings.selectedLaborTaxRateId, settings.selectedLaborTaxRateId);
        expect(controller.settings.revisedLaborTax, settings.revisedLaborTax);
      });
    });

    group("When line item tax is not applied", () {
      setUp(() {
        controller.settings.addLineItemTax = false;
      });

      test("Labour tax can be applied", () async {
        await controller.toggleApplyTaxLabor(true);
        expect(controller.settings.applyTaxLabor, isTrue);
        expect(controller.settings.addLineItemTax, isFalse);
        expect(controller.settings.overriddenLaborTaxRate, isNull);
        expect(controller.settings.selectedLaborTaxRateId, isNull);
        expect(controller.settings.revisedLaborTax, isNull);
      });

      test("Labour tax can be removed", () async {
        await controller.toggleApplyTaxLabor(false);
        expect(controller.settings.applyTaxLabor, isFalse);
        expect(controller.settings.addLineItemTax, isFalse);
        expect(controller.settings.overriddenLaborTaxRate, settings.overriddenLaborTaxRate);
        expect(controller.settings.selectedLaborTaxRateId, settings.selectedLaborTaxRateId);
        expect(controller.settings.revisedLaborTax, settings.revisedLaborTax);
      });
    });
  });

  group("WorksheetSettingsController@toggleApplyTaxAll should toggle tax all rate", () {
    group("When line item tax is applied", () {
      setUp(() {
        controller.settings.addLineItemTax = true;
      });

      test("Tax All tax can't be applied", () async {
        await controller.toggleApplyTaxAll(true);
        expect(controller.settings.applyTaxAll, isFalse);
        expect(controller.settings.addLineItemTax, isTrue);
        expect(controller.settings.overriddenTaxRate, settings.overriddenTaxRate);
        expect(controller.settings.selectedTaxRateId, settings.selectedTaxRateId);
        expect(controller.settings.revisedTaxAll, settings.revisedTaxAll);
      });

      test("Tax All tax can be removed", () async {
        await controller.toggleApplyTaxAll(false);
        expect(controller.settings.applyTaxAll, isFalse);
        expect(controller.settings.addLineItemTax, isFalse);
        expect(controller.settings.overriddenTaxRate, settings.overriddenTaxRate);
        expect(controller.settings.selectedTaxRateId, settings.selectedTaxRateId);
        expect(controller.settings.revisedTaxAll, settings.revisedTaxAll);
      });
    });

    group("When line item tax is not applied", () {
      setUp(() {
        controller.settings.addLineItemTax = false;
      });

      test("Tax All tax can be applied", () async {
        await controller.toggleApplyTaxAll(true);
        expect(controller.settings.applyTaxAll, isTrue);
        expect(controller.settings.addLineItemTax, isFalse);
        expect(controller.settings.overriddenTaxRate, isNull);
        expect(controller.settings.selectedTaxRateId, isNull);
        expect(controller.settings.revisedTaxAll, isNull);
      });

      test("Tax All tax can be removed", () async {
        await controller.toggleApplyTaxAll(false);
        expect(controller.settings.applyTaxAll, isFalse);
        expect(controller.settings.addLineItemTax, isFalse);
        expect(controller.settings.overriddenTaxRate, settings.overriddenTaxRate);
        expect(controller.settings.selectedTaxRateId, settings.selectedTaxRateId);
        expect(controller.settings.revisedTaxAll, settings.revisedTaxAll);
      });
    });
  });

  group("WorksheetSettingsController@toggleAddLineItemTax should toggle line item tax", () {
    group("Line item tax can't be applied", () {
      test("When material tax is applied", () async {
        controller.settings.applyTaxMaterial = true;
        controller.settings.hasMaterialItem = true;
        await controller.toggleAddLineItemTax(true);
        expect(controller.settings.addLineItemTax, isFalse);
        expect(controller.settings.lineItemTaxPercent, isNull);
        expect(controller.settings.applyTaxMaterial, isTrue);
        expect(controller.settings.applyTaxLabor, settings.applyTaxLabor);
        expect(controller.settings.applyTaxAll, settings.applyTaxAll);
        expect(settings.overriddenMaterialTaxRate, settings.overriddenMaterialTaxRate);
        expect(settings.selectedMaterialTaxRateId, settings.selectedMaterialTaxRateId);
        expect(settings.selectedTaxRateId, settings.selectedTaxRateId);
        expect(settings.overriddenLaborTaxRate, settings.overriddenLaborTaxRate);
        expect(settings.selectedLaborTaxRateId, settings.selectedLaborTaxRateId);
      });

      test("When labor tax is applied", () async {
        controller.settings.applyTaxLabor = true;
        controller.settings.hasLaborItem = true;
        await controller.toggleAddLineItemTax(true);
        expect(controller.settings.addLineItemTax, isFalse);
        expect(controller.settings.lineItemTaxPercent, isNull);
        expect(controller.settings.applyTaxMaterial, settings.applyTaxMaterial);
        expect(controller.settings.applyTaxLabor, isTrue);
        expect(controller.settings.applyTaxAll, settings.applyTaxAll);
        expect(settings.overriddenMaterialTaxRate, settings.overriddenMaterialTaxRate);
        expect(settings.selectedMaterialTaxRateId, settings.selectedMaterialTaxRateId);
        expect(settings.selectedTaxRateId, settings.selectedTaxRateId);
        expect(settings.overriddenLaborTaxRate, settings.overriddenLaborTaxRate);
        expect(settings.selectedLaborTaxRateId, settings.selectedLaborTaxRateId);
      });

      test("When tax all is applied", () async {
        controller.settings.applyTaxAll = true;
        await controller.toggleAddLineItemTax(true);
        expect(controller.settings.addLineItemTax, isFalse);
        expect(controller.settings.lineItemTaxPercent, isNull);
        expect(controller.settings.applyTaxMaterial, settings.applyTaxMaterial);
        expect(controller.settings.applyTaxLabor, settings.applyTaxLabor);
        expect(controller.settings.applyTaxAll, isTrue);
        expect(settings.overriddenMaterialTaxRate, settings.overriddenMaterialTaxRate);
        expect(settings.selectedMaterialTaxRateId, settings.selectedMaterialTaxRateId);
        expect(settings.selectedTaxRateId, settings.selectedTaxRateId);
        expect(settings.overriddenLaborTaxRate, settings.overriddenLaborTaxRate);
        expect(settings.selectedLaborTaxRateId, settings.selectedLaborTaxRateId);
      });
    });

    test("Line item tax can be applied only when other taxes are not applied", () async {
      controller.settings.applyTaxMaterial = false;
      controller.settings.applyTaxLabor = false;
      controller.settings.applyTaxAll = false;
      controller.settings.hasMaterialItem = true;
      await controller.toggleAddLineItemTax(true);
      expect(controller.settings.addLineItemTax, isTrue);
      expect(controller.settings.lineItemTaxPercent, settings.lineItemTaxPercent);
      expect(controller.settings.applyTaxMaterial, isFalse);
      expect(controller.settings.applyTaxLabor, isFalse);
      expect(controller.settings.applyTaxAll, isFalse);
      expect(settings.overriddenMaterialTaxRate, isNull);
      expect(settings.selectedMaterialTaxRateId, isNull);
      expect(settings.selectedTaxRateId, isNull);
      expect(settings.overriddenLaborTaxRate, isNull);
      expect(settings.selectedLaborTaxRateId, isNull);
    });
  });

  group("WorksheetSettingsController@toggleOverhead should toggle overhead", () {
    test("Overhead should be applied", () {
      controller.toggleOverhead(true);
      expect(controller.settings.applyOverhead, isTrue);
      expect(controller.settings.overriddenOverHeadRate, isNull);
    });

    test("Overhead should be removed", () {
      controller.toggleOverhead(false);
      expect(controller.settings.applyOverhead, isFalse);
      expect(controller.settings.overriddenOverHeadRate, isNull);
    });

    test("Overhead previously added rate should be removed", () {
      controller.settings.overriddenOverHeadRate = 20;
      controller.toggleOverhead(false);
      expect(controller.settings.overriddenOverHeadRate, isNull);
    });
  });

  group("WorksheetSettingsController@onProfitToggled should toggle overall profit", () {
    test("Overall profit should be applied", () {
      controller.onProfitToggled(true, true);
      expect(controller.settings.lineItemProfitPercent, settings.lineItemProfitPercent);
      expect(controller.settings.lineItemTempProfitPercent, settings.lineItemTempProfitPercent);
      expect(controller.settings.applyProfit, isTrue);
      expect(controller.settings.applyLineItemProfit, isFalse);
    });

    test("Overall profit should be removed", () {
      controller.onProfitToggled(false, true);
      expect(controller.settings.overAllProfitAmount, isNull);
      expect(controller.settings.overAllProfitPercent, isNull);
      expect(controller.settings.isOverAllProfitMarkup, isNull);
      expect(controller.settings.applyProfit, isFalse);
      expect(controller.settings.applyLineItemProfit, isFalse);
    });

    test("Line profit should be removed on applying overall profit", () {
      controller.onProfitToggled(true, true);
      expect(controller.settings.applyLineItemProfit, isFalse);
    });
  });

  group("WorksheetSettingsController@onLineItemProfitToggled should toggle line item profit", () {
    test("Line item profit should be applied", () {
      controller.onLineItemProfitToggled(true, true);
      expect(controller.settings.overAllProfitAmount, isNull);
      expect(controller.settings.overAllProfitPercent, isNull);
      expect(controller.settings.isOverAllProfitMarkup, isNull);
      expect(controller.settings.applyProfit, isFalse);
      expect(controller.settings.applyLineItemProfit, isTrue);
    });

    test("Line item profit should be removed", () {
      controller.onLineItemProfitToggled(false, true);
      expect(controller.settings.lineItemTempProfitPercent, settings.lineItemTempProfitPercent);
      expect(controller.settings.lineItemProfitPercent, settings.lineItemProfitPercent);
      expect(controller.settings.isLineItemProfitMarkup, settings.isLineItemProfitMarkup);
      expect(controller.settings.applyProfit, isFalse);
    });

    test("Overall should be removed on applying line item profit", () {
      controller.onLineItemProfitToggled(true, true);
      expect(controller.settings.applyProfit, isFalse);
    });
  });

  group("WorksheetSettingsController@onLineAndWorksheetProfitToggled should toggle line and worksheet profit", () {
    test("Line item and worksheet profit should be applied", () {
      controller.onLineAndWorksheetProfitToggled(true, true);
      expect(controller.settings.overAllProfitAmount, isNull);
      expect(controller.settings.overAllProfitPercent, isNull);
      expect(controller.settings.isOverAllProfitMarkup, isNull);
      expect(controller.settings.applyProfit, isTrue);
      expect(controller.settings.applyLineItemProfit, isTrue);
      expect(controller.settings.applyLineAndWorksheetProfit, isTrue);
    });

    test("Line item and worksheet profit should be removed", () {
      controller.onLineAndWorksheetProfitToggled(false, true);
      expect(controller.settings.lineItemTempProfitPercent, settings.lineItemTempProfitPercent);
      expect(controller.settings.lineItemProfitPercent, settings.lineItemProfitPercent);
      expect(controller.settings.isLineItemProfitMarkup, settings.isLineItemProfitMarkup);
      expect(controller.settings.applyProfit, isFalse);
      expect(controller.settings.applyLineItemProfit, isFalse);
      expect(controller.settings.applyLineAndWorksheetProfit, isFalse);
    });

    test("worksheet profit and line item profit should be applying", () {
      controller.onLineAndWorksheetProfitToggled(true, true);
      expect(controller.settings.applyProfit, isTrue);
      expect(controller.settings.applyLineItemProfit, isTrue);
      expect(controller.settings.applyLineAndWorksheetProfit, isTrue);
    });
  });

  group("WorksheetSettingsController@onCommissionToggled should apply remove commission rate", () {
    test("Commission should be applied", () {
      controller.onCommissionToggled(true);
      expect(controller.settings.applyCommission, isTrue);
      expect(controller.settings.commissionPercent, settings.commissionPercent);
    });

    test("Commission should be removed", () {
      controller.onCommissionToggled(false);
      expect(controller.settings.applyCommission, isFalse);
      expect(controller.settings.commissionPercent, isNull);
    });
  });

  group("WorksheetSettingsController@onCommissionToggled should apply remove commission rate", () {
    test("Card Fee should be applied", () {
      controller.onToggleCardFee(true);
      expect(controller.settings.applyProcessingFee, isTrue);
      expect(controller.settings.creditCardFeePercent, settings.creditCardFeePercent);
    });

    test("Card Fee should be removed", () {
      controller.onToggleCardFee(false);
      expect(controller.settings.applyProcessingFee, isFalse);
      expect(controller.settings.creditCardFeePercent, isNull);
    });
  });

  group("WorksheetSettingsController@toggleDescriptionOnly should toggle display description on line item", () {
    group("When description only is enabled", () {
      test("Description should be displayed on line item", () {
        controller.toggleDescriptionOnly(true);
        expect(controller.settings.descriptionOnly, isTrue);
      });

      test("Unit and quantity should not be disabled on line item", () {
        expect(controller.settings.showUnit, isFalse);
        expect(controller.settings.showQuantity, isFalse);
      });

      test("Other line item details should be displayed", () {
        expect(controller.settings.showSupplier, isTrue);
        expect(controller.settings.showTradeType, isTrue);
        expect(controller.settings.showWorkType, isTrue);
      });

      test('When worksheet type is work order', () {
        controller.settings.isWorkOrderSheet = true;
        controller.toggleDescriptionOnly(true);
        expect(controller.settings.showStyle, isFalse);
        expect(controller.settings.showSize, isFalse);
        expect(controller.settings.showColor, isFalse);
        expect(controller.settings.showVariation, isFalse);
      });

      group('When worksheet type is not work order', () {
        setUpAll(() {
          controller.lineItems = [
            lineItem..product = FinancialProductModel()
          ];
          controller.settings.isWorkOrderSheet = false;
        });
        test('In case product has variations', () {
          controller.lineItems?.firstOrNull?.product?.variants = [VariantModel()];
          controller.toggleDescriptionOnly(true);
          expect(controller.settings.showStyle, isTrue);
          expect(controller.settings.showSize, isTrue);
          expect(controller.settings.showColor, isTrue);
          expect(controller.showVariationControls, isTrue);
        });

        test('In case product has no variations', () {
          controller.lineItems?.firstOrNull?.product?.variants = [];
          controller.toggleDescriptionOnly(true);
          expect(controller.settings.showStyle, isTrue);
          expect(controller.settings.showSize, isTrue);
          expect(controller.settings.showColor, isTrue);
          expect(controller.showVariationControls, isFalse);
        });
      });

    });

    group("When description only is disabled", () {
      test("Description only should be displayed on line item", () {
        controller.toggleDescriptionOnly(false);
        expect(controller.settings.descriptionOnly, isFalse);
      });

      test("Unit and quantity should be displayed on line item", () {
        expect(controller.settings.showUnit, isTrue);
        expect(controller.settings.showQuantity, isTrue);
      });

      test("Other line item details should be displayed", () {
        expect(controller.settings.showSupplier, isTrue);
        expect(controller.settings.showTradeType, isTrue);
        expect(controller.settings.showWorkType, isTrue);
      });

      test('When worksheet type is work order', () {
        controller.settings.isWorkOrderSheet = true;
        controller.toggleDescriptionOnly(false);
        expect(controller.settings.showStyle, isFalse);
        expect(controller.settings.showSize, isFalse);
        expect(controller.settings.showColor, isFalse);
        expect(controller.settings.showVariation, isFalse);
      });

      group('When worksheet type is not work order', () {
        setUpAll(() {
          controller.lineItems = [
            lineItem..product = FinancialProductModel()
          ];
          controller.settings.isWorkOrderSheet = false;
        });
        test('In case product has variations', () {
          controller.lineItems?.firstOrNull?.product?.variants = [VariantModel()];
          controller.toggleDescriptionOnly(false);
          expect(controller.settings.showStyle, isTrue);
          expect(controller.settings.showSize, isTrue);
          expect(controller.settings.showColor, isTrue);
          expect(controller.showVariationControls, isTrue);
        });

        test('In case product has no variations', () {
          controller.lineItems?.firstOrNull?.product?.variants = [];
          controller.toggleDescriptionOnly(false);
          expect(controller.settings.showStyle, isTrue);
          expect(controller.settings.showSize, isTrue);
          expect(controller.settings.showColor, isTrue);
          expect(controller.showVariationControls, isFalse);
        });
      });
    });
  });

  group("WorksheetSettingsController@toggleShowUnit should toggle display unit on line item", () {
    test("Unit should be displayed on line item", () {
      controller.toggleShowUnit(true);
      expect(controller.settings.showUnit, isTrue);
    });

    test("Unit should not be displayed on line item", () {
      controller.toggleShowUnit(false);
      expect(controller.settings.showUnit, isFalse);
    });
  });

  group("WorksheetSettingsController@toggleShowQuantity should toggle display quantity on line item", () {
    test("Quantity should be displayed on line item", () {
      controller.toggleShowQuantity(true);
      expect(controller.settings.showQuantity, isTrue);
    });

    test("Quantity should not be displayed on line item", () {
      controller.toggleShowQuantity(false);
      expect(controller.settings.showQuantity, isFalse);
    });
  });

  group("WorksheetSettingsController@toggleShowStyle should toggle display style on line item", () {
    test("Style should be displayed on line item", () {
      controller.toggleShowStyle(true);
      expect(controller.settings.showStyle, isTrue);
    });

    test("Style should not be displayed on line item", () {
      controller.toggleShowStyle(false);
      expect(controller.settings.showStyle, isFalse);
    });
  });

  group("WorksheetSettingsController@toggleShowSize should toggle display size on line item", () {
    test("Size should be displayed on line item", () {
      controller.toggleShowSize(true);
      expect(controller.settings.showSize, isTrue);
    });

    test("Size should not be displayed on line item", () {
      controller.toggleShowSize(false);
      expect(controller.settings.showSize, isFalse);
    });
  });

  group("WorksheetSettingsController@toggleShowColor should toggle display color on line item", () {
    test("Color should be displayed on line item", () {
      controller.toggleShowColor(true);
      expect(controller.settings.showColor, isTrue);
    });

    test("Color should not be displayed on line item", () {
      controller.toggleShowColor(false);
      expect(controller.settings.showSize, isFalse);
    });
  });

  group("WorksheetSettingsController@toggleShowVariation should toggle display variation on line item", () {
    test("Variation should be displayed on line item", () {
      controller.toggleShowVariation(true);
      expect(controller.settings.showVariation, isTrue);
    });

    test("Variation should not be displayed on line item", () {
      controller.toggleShowVariation(false);
      expect(controller.settings.showVariation, isFalse);
    });
  });

  group("WorksheetSettingsController@toggleShowSupplier should toggle display supplier on line item", () {
    test("Supplier should be displayed on line item", () {
      controller.toggleShowSupplier(true);
      expect(controller.settings.showSupplier, isTrue);
    });

    test("Supplier should not be displayed on line item", () {
      controller.toggleShowSupplier(false);
      expect(controller.settings.showSupplier, isFalse);
    });
  });

  group("WorksheetSettingsController@toggleShowTradeType should toggle display trade type on line item", () {
    test("Trade type should be displayed on line item", () {
      controller.toggleShowTradeType(true);
      expect(controller.settings.showTradeType, isTrue);
    });

    test("Trade type should not be displayed on line item", () {
      controller.toggleShowTradeType(false);
      expect(controller.settings.showTradeType, isFalse);
    });
  });

  group("WorksheetSettingsController@toggleShowWorkType should toggle display work type on line item", () {
    test("Work type should be displayed on line item", () {
      controller.toggleShowWorkType(true);
      expect(controller.settings.showWorkType, isTrue);
    });

    test("work type should not be displayed on line item", () {
      controller.toggleShowWorkType(false);
      expect(controller.settings.showWorkType, isFalse);
    });
  });

  group("WorksheetSettingsController@toggleShowTaxes should toggle display taxes in calculation sheet", () {
    test("Taxes should be displayed in calculation sheet", () {
      controller.toggleShowTaxes(true);
      expect(controller.settings.showTaxes, isTrue);
    });

    test("Taxes should not be displayed in calculation sheet", () {
      controller.toggleShowTaxes(false);
      expect(controller.settings.showTaxes, isFalse);
    });
  });

  group("WorksheetSettingsController@toggleHidePricing should toggle display price on calculations sheet", () {
    group("When show pricing is enabled", () {
      test("All amounts should be displayed on worksheet", () {
        controller.toggleHidePricing(true);
        expect(controller.settings.hidePricing, isFalse);
        expect(controller.settings.hideTotal, isTrue);
        expect(controller.settings.showLineTotal, isTrue);
        expect(controller.settings.showTaxOnly, isTrue);
        expect(controller.settings.showCalculationSummary, isTrue);
      });

      group("Hide Total setting should be updated on enabling show price conditionally", () {
        test("In case of material worksheet, Hide Total setting should not be updated", () {
          controller.settings.isMaterialWorkSheet = true;
          controller.settings.isWorkOrderSheet = false;
          settings.hideTotal = false;
          controller.toggleHidePricing(true);
          expect(controller.settings.hideTotal, isFalse);
        });

        test("In case of work order worksheet, Hide Total setting should not be updated", () {
          controller.settings.isMaterialWorkSheet = false;
          controller.settings.isWorkOrderSheet = true;
          settings.hideTotal = false;
          controller.toggleHidePricing(true);
          expect(controller.settings.hideTotal, isFalse);
        });

        test("In case of estimate worksheet, Hide Total setting should be updated", () {
          controller.settings.isMaterialWorkSheet = false;
          controller.settings.isWorkOrderSheet = false;
          settings.hideTotal = false;
          controller.toggleHidePricing(true);
          expect(controller.settings.hideTotal, isTrue);
        });

        test("In case of proposal worksheet, Hide Total setting should be updated", () {
          controller.settings.isMaterialWorkSheet = false;
          controller.settings.isWorkOrderSheet = false;
          settings.hideTotal = false;
          controller.toggleHidePricing(true);
          expect(controller.settings.hideTotal, isTrue);
        });
      });
    });

    group("When show pricing is disabled", () {
      test("Amounts should not be displayed on line items", () {
        controller.toggleHidePricing(false);
        expect(controller.settings.hidePricing, isTrue);
      });

      test("Total amount in calculation sheet should be displayed", () {
        expect(controller.settings.hideTotal, isFalse);
      });

      test("Show taxes in calculation sheet should not be displayed", () {
        expect(controller.settings.showTaxOnly, isFalse);
      });

      test("Line item total should not be displayed", () {
        expect(controller.settings.showLineTotal, isFalse);
      });

      test("Calculation summary should not be displayed", () {
        expect(controller.settings.showCalculationSummary, isFalse);
      });
    });
  });

  group("WorksheetSettingsController@toggleHideTotal should toggle display total for calculation summary", () {
    test("Total should be displayed", () {
      controller.toggleHideTotal(true);
      expect(controller.settings.hideTotal, isFalse);
    });

    test("Total should not be displayed", () {
      controller.toggleHideTotal(false);
      expect(controller.settings.hideTotal, isTrue);
    });
  });

  group("WorksheetSettingsController@toggleShowLineTotal should toggle display total for line item", () {
    test("Line item total should be displayed", () {
      controller.toggleShowLineTotal(true);
      expect(controller.settings.showLineTotal, isTrue);
    });

    test("Line item total should not be displayed", () {
      controller.toggleShowLineTotal(false);
      expect(controller.settings.showLineTotal, isFalse);
    });
  });

  group("WorksheetSettingsController@toggleShowCalculationSummary should toggle display calculation summary", () {
    group("When calculation summary is enabled", () {
      test("Calculation summary should be displayed", () {
        controller.toggleShowCalculationSummary(true);
        expect(controller.settings.showCalculationSummary, isTrue);
      });

      test("Only total display in calculation summary should be disabled", () {
        expect(controller.settings.hideTotal, isTrue);
      });

      test("Taxes should be displayed in calculation summary", () {
        expect(controller.settings.showTaxes, isTrue);
      });
    });

    group("When calculation summary is disabled", () {
      test("Calculation summary should not be displayed", () {
        controller.toggleShowCalculationSummary(false);
        expect(controller.settings.showCalculationSummary, isFalse);
      });

      test("Only total display in calculation summary should disabled", () {
        expect(controller.settings.hideTotal, isFalse);
      });

      test("Taxes should not be displayed in calculation summary", () {
        expect(controller.settings.showTaxes, isFalse);
      });
    });
  });

  group("WorksheetSettingsController@toggleShowTierTotal should toggle display total on tier", () {
    test("Tier total should be displayed", () {
      controller.toggleShowTierTotal(true);
      expect(controller.settings.showTierTotal, isTrue);
    });

    test("Tier total should not be displayed", () {
      controller.toggleShowTierTotal(false);
      expect(controller.settings.showTierTotal, isFalse);
    });
  });

  group("WorksheetSettingsController@toggleShowTierSubTotals should toggle display sub totals on tier", () {
    test("Tier sub totals should be displayed", () {
      controller.toggleShowTierSubTotals(true);
      expect(controller.settings.showTierSubTotals, isTrue);
    });

    test("Tier sub totals should not be displayed", () {
      controller.toggleShowTierSubTotals(false);
      expect(controller.settings.showTierSubTotals, isFalse);
    });
  });

  group("WorksheetSettingsController@toggleShowTierColor should toggle tier display color", () {
    test("Tier should be filled with color", () {
      controller.toggleShowTierColor(true);
      expect(controller.settings.showTierColor, isTrue);
    });

    test("Tier should not be filled with color", () {
      controller.toggleShowTierColor(false);
      expect(controller.settings.showTierColor, isFalse);
    });
  });

  group("WorksheetSettingsController@toggleHideCustomerInfo should toggle display customer info in prepared worksheet", () {
    test("Customer info should be displayed", () {
      controller.toggleHideCustomerInfo(true);
      expect(controller.settings.hideCustomerInfo, isTrue);
    });

    test("Customer info should not be displayed", () {
      controller.toggleHideCustomerInfo(false);
      expect(controller.settings.hideCustomerInfo, isFalse);
    });
  });

  group("WorksheetSettingsController@getRevisedRate should give revised tax rate", () {
    test('When revised tax rate is applied', () {
      final val = controller.settings.getRevisedRate(10, isApplied: true);
      expect(val, 10);
    });

    test('When revised tax rate is not applied', () {
      final val = controller.settings.getRevisedRate(10, isApplied: false);
      expect(val, isNull);
    });
  });

  group("WorksheetSettingsController@doApplyRevisedTax should check whether to apply revise tax can be applied", () {
    test('Revise tax can be applied if new tax does not matches with old tax', () {
      final val = controller.settings.doApplyRevisedTax(10, 15, isApplied: true);
      expect(val, isTrue);
    });

    test('Revise tax should not be applied if new tax does not matches with old tax and tax is not applied', () {
      final val = controller.settings.doApplyRevisedTax(10, 15, isApplied: false);
      expect(val, isFalse);
    });
  });

  group("WorksheetSettingsController@checkForRevisedTax should check and show the revised tax that can be applied", () {
    group("In case of material tax", () {
      setUp(() {
        controller.settings.overriddenMaterialTaxRate = 10;
        controller.settings.materialTaxRate = 15;
      });

      test("When revised tax is not available, it should not be indicated in calculation summary", () {
        controller.settings.applyTaxMaterial = false;
        controller.settings.checkForRevisedTax();
        expect(controller.settings.revisedMaterialTax, isNull);
      });

      test("When revised tax is available, it should be indicated in calculation summary", () {
        controller.settings.applyTaxMaterial = true;
        controller.settings.checkForRevisedTax();
        expect(controller.settings.revisedMaterialTax, 15);
      });
    });

    group("In case of labour tax", () {
      setUp(() {
        controller.settings.overriddenLaborTaxRate = 10;
        controller.settings.laborTaxRate = 15;
      });

      test("When revised tax is not available, it should not be indicated in calculation summary", () {
        controller.settings.applyTaxLabor = false;
        controller.settings.checkForRevisedTax();
        expect(controller.settings.revisedLaborTax, isNull);
      });

      test("When revised tax is available, it should be indicated in calculation summary", () {
        controller.settings.applyTaxLabor = true;
        controller.settings.checkForRevisedTax();
        expect(controller.settings.revisedLaborTax, 15);
      });
    });

    group("In case of tax all", () {
      setUp(() {
        controller.settings.overriddenTaxRate = 10;
        controller.settings.taxRate = 15;
      });

      test("When revised tax is not available, it should not be indicated in calculation summary", () {
        controller.settings.applyTaxAll = false;
        controller.settings.checkForRevisedTax();
        expect(controller.settings.revisedTaxAll, isNull);
      });

      test("When revised tax is available, it should be indicated in calculation summary", () {
        controller.settings.applyTaxAll = true;
        controller.settings.checkForRevisedTax();
        expect(controller.settings.revisedTaxAll, 15);
      });
    });
  });

  group("WorksheetSettingsController@setFixedPrice should check and set worksheet fixed price", () {
    test("When fixed price amount is zero, it should not be applied", () {
      controller.settings.setFixedPrice(0);
      expect(controller.settings.isFixedPrice, isFalse);
    });

    group("When fixed price amount greater than zero", () {
      test("Fixed price should be applied", () {
        controller.settings.setFixedPrice(10);
        expect(controller.settings.isFixedPrice, isTrue);
      });

      test("Exiting or applied profit should be removed", () {
        controller.settings.setFixedPrice(10);
        expect(controller.settings.lineItemProfitPercent, isNull);
        expect(controller.settings.lineItemTempProfitPercent, isNull);
        expect(controller.settings.isLineItemProfitMarkup, isNull);
        expect(controller.settings.overAllProfitAmount, isNull);
        expect(controller.settings.applyProfit, isFalse);
        expect(controller.settings.applyLineItemProfit, isFalse);
      });

      test("Overall and Line Item Profit settings should be disabled", () {
        expect(controller.settings.isFixedPrice, isTrue);
      });
    });
  });

  group("Settings should be displayed conditionally", () {
    group("In case of estimate worksheet", () {
      group("Material tax should be displayed conditionally", () {
        test("When material item does not exists, tax can not be applied", () {
          settings.hasMaterialItem = false;
          settings.isWorkOrderSheet = false;
          setController();
          expect(controller.settings.hasMaterialItem, false);
        });

        test("When material item exists, tax can be applied conditionally", () {
          settings.hasMaterialItem = true;
          setController();
          expect(controller.settings.hasMaterialItem, true);
        });
      });

      group("Labour tax should be displayed conditionally", () {
        test("When labour item does not exists, tax can not be applied", () {
          settings.hasLaborItem = false;
          setController();
          expect(controller.settings.hasLaborItem, false);
        });

        test("When labour item exists, tax can be applied ", () {
          settings.hasLaborItem = true;
          setController();
          expect(controller.settings.hasLaborItem, true);
        });
      });

      group("Tax and Other section will be displayed conditionally", () {
        test("When worksheet is qbd worksheet, sections should not be displayed", () {
          controller.settings.isQbWorksheet = true;
          expect(controller.showTaxAndOtherSection, isFalse);
        });

        test("When worksheet is not qbd worksheet, sections should be displayed", () {
          controller.settings.isQbWorksheet = false;
          expect(controller.showTaxAndOtherSection, isTrue);
        });
      });

      group("Tier settings will be displayed conditionally", () {
        test("When worksheet has tiers, tier settings should be displayed", () {
          settings.hasTier = true;
          setController();
          expect(controller.settings.hasTier, isTrue);
        });

        test("When worksheet has no tiers, tier settings should not be displayed", () {
          settings.hasTier = false;
          setController();
          expect(controller.settings.hasTier, isFalse);
        });
      });

      test("Hide customer info should not be displayed", () {
        expect(controller.settings.isWorkOrderSheet, isFalse);
      });
    });

    group("In case of proposal worksheet", () {
      group("Material tax should be displayed conditionally", () {
        test("When material item does not exists, tax can not be applied", () {
          settings.hasMaterialItem = false;
          setController();
          expect(controller.settings.hasMaterialItem, false);
        });

        test("When material item exists, tax can be applied ", () {
          settings.hasMaterialItem = true;
          setController();
          expect(controller.settings.hasMaterialItem, true);
        });
      });

      group("Labour tax should be displayed conditionally", () {
        test("When labour item does not exists, tax can not be applied", () {
          settings.hasLaborItem = false;
          setController();
          expect(controller.settings.hasLaborItem, false);
        });

        test("When labour item exists, tax can be applied ", () {
          settings.hasLaborItem = true;
          setController();
          expect(controller.settings.hasLaborItem, true);
        });
      });

      group("Tax and Other section will be displayed conditionally", () {
        test("When worksheet is qbd worksheet, sections should not be displayed", () {
          controller.settings.isQbWorksheet = true;
          expect(controller.showTaxAndOtherSection, isFalse);
        });

        test("When worksheet is not qbd worksheet, sections should be displayed", () {
          controller.settings.isQbWorksheet = false;
          expect(controller.showTaxAndOtherSection, isTrue);
        });
      });

      group("Tier settings will be displayed conditionally", () {
        test("When worksheet has tiers, tier settings should be displayed", () {
          settings.hasTier = true;
          setController();
          expect(controller.settings.hasTier, isTrue);
        });

        test("When worksheet has no tiers, tier settings should not be displayed", () {
          settings.hasTier = false;
          setController();
          expect(controller.settings.hasTier, isFalse);
        });
      });

      test("Hide customer info should not be displayed", () {
        expect(controller.settings.isWorkOrderSheet, isFalse);
      });
    });

    group("In case of material worksheet", () {
      setUp(() {
        settings.isMaterialWorkSheet = true;
      });

      group("Only material tax can be applied", () {
        test("When material item does not exists, tax can not be applied", () {
          settings.hasMaterialItem = false;
          setController();
          expect(controller.settings.hasMaterialItem, isFalse);
        });

        test("When material item exists, tax can be applied ", () {
          settings.hasMaterialItem = true;
          setController();
          expect(controller.settings.hasMaterialItem, isTrue);
        });
      });

      group("Tax section will be displayed on the basis of SRS supplier", () {
        test("When supplier is the SRS supplier, tax section should not be displayed", () {
          AppEnv.envConfig[CommonConstants.suppliersIds] = {
            CommonConstants.srsId: 3,
          };
          controller.forSupplierId = 3;
          expect(controller.showTaxSection, isFalse);
        });

        test("When supplier is not the SRS supplier, tax section should be displayed", () {
          AppEnv.envConfig[CommonConstants.suppliersIds] = {
            CommonConstants.srsId: 8,
          };
          controller.forSupplierId = 3;
          expect(controller.showTaxSection, isTrue);
        });
      });

      test("Other section will not be displayed", () {
        setController();
        expect(controller.isNotWorkOrderAndMaterial, isFalse);
      });

      test("Show total setting will not be displayed", () {
        setController();
        expect(controller.isNotWorkOrderAndMaterial, isFalse);
      });

      group("Tier settings will be displayed conditionally", () {
        test("When worksheet has tiers, tier settings should be displayed", () {
          settings.hasTier = true;
          setController();
          expect(controller.settings.hasTier, isTrue);
        });

        test("When worksheet has no tiers, tier settings should not be displayed", () {
          settings.hasTier = false;
          setController();
          expect(controller.settings.hasTier, isFalse);
        });
      });

      test("Hide customer info should not be displayed", () {
        expect(controller.settings.isWorkOrderSheet, isFalse);
      });
    });

    group("In case of work order worksheet", () {
      setUp(() {
        settings.isWorkOrderSheet = true;
      });

      group("Only labor tax can be applied", () {
        test("When labor item does not exists, tax can not be applied", () {
          settings.hasLaborItem = false;
          setController();
          expect(controller.settings.hasLaborItem, isFalse);
        });

        test("When labor item exists, tax can be applied ", () {
          settings.hasLaborItem = true;
          setController();
          expect(controller.settings.hasLaborItem, isTrue);
        });
      });

      test("Other section will not be displayed", () {
        setController();
        expect(controller.isNotWorkOrderAndMaterial, isFalse);
      });

      test("Show total & Show line total setting will not be displayed", () {
        setController();
        expect(controller.isNotWorkOrderAndMaterial, isFalse);
      });

      group("Tier settings will be displayed conditionally", () {
        test("When worksheet has tiers, tier settings should be displayed", () {
          settings.hasTier = true;
          setController();
          expect(controller.settings.hasTier, isTrue);
        });

        test("When worksheet has no tiers, tier settings should not be displayed", () {
          settings.hasTier = false;
          setController();
          expect(controller.settings.hasTier, isFalse);
        });
      });

      test("Hide customer info should be displayed", () {
        expect(controller.settings.isWorkOrderSheet, isTrue);
      });
    });
  });

  group("Tax rates & profits should be prioritized properly", () {
    group("In case of material tax", () {
      test("When tax not exists, rate should be 0", () {
        controller.settings.revisedMaterialTax = null;
        controller.settings.isRevisedMaterialTaxApplied = false;
        controller.settings.overriddenMaterialTaxRate = null;
        controller.settings.materialTaxRate = null;
        expect(controller.settings.getMaterialTaxRate, 0);
      });

      test("Tax coming along in settings should have priority level 4", () {
        controller.settings.revisedMaterialTax = null;
        controller.settings.isRevisedMaterialTaxApplied = false;
        controller.settings.overriddenMaterialTaxRate = null;
        controller.settings.materialTaxRate = 2;
        expect(controller.settings.getMaterialTaxRate, 2);
      });

      test("Tax coming along in worksheet should have priority level 3", () {
        controller.settings.revisedMaterialTax = null;
        controller.settings.isRevisedMaterialTaxApplied = false;
        controller.settings.overriddenMaterialTaxRate = 5;
        controller.settings.materialTaxRate = 2;
        expect(controller.settings.getMaterialTaxRate, 5);
      });

      test("Revised tax should have priority level 2", () {
        controller.settings.revisedMaterialTax = 15;
        controller.settings.isRevisedMaterialTaxApplied = true;
        controller.settings.overriddenMaterialTaxRate = 5;
        controller.settings.materialTaxRate = 2;
        expect(controller.settings.getMaterialTaxRate, 15);
      });

      test("Tax added manually should have priority level 1", () {
        controller.settings.revisedMaterialTax = null;
        controller.settings.isRevisedMaterialTaxApplied = true;
        controller.settings.overriddenMaterialTaxRate = 7;
        controller.settings.materialTaxRate = 2;
        expect(controller.settings.getMaterialTaxRate, 7);
      });
    });

    group("In case of labor tax", () {
      test("When tax not exists, rate should be 0", () {
        controller.settings.revisedLaborTax = null;
        controller.settings.isRevisedLaborTaxApplied = false;
        controller.settings.overriddenLaborTaxRate = null;
        controller.settings.laborTaxRate = null;
        expect(controller.settings.getLaborTaxRate, 0);
      });

      test("Tax coming along in settings should have priority level 4", () {
        controller.settings.revisedLaborTax = null;
        controller.settings.isRevisedLaborTaxApplied = false;
        controller.settings.overriddenLaborTaxRate = null;
        controller.settings.laborTaxRate = 2;
        expect(controller.settings.getLaborTaxRate, 2);
      });

      test("Tax coming along in worksheet should have priority level 3", () {
        controller.settings.revisedLaborTax = null;
        controller.settings.isRevisedLaborTaxApplied = false;
        controller.settings.overriddenLaborTaxRate = 5;
        controller.settings.laborTaxRate = 2;
        expect(controller.settings.getLaborTaxRate, 5);
      });

      test("Revised tax should have priority level 2", () {
        controller.settings.revisedLaborTax = 15;
        controller.settings.isRevisedLaborTaxApplied = true;
        controller.settings.overriddenLaborTaxRate = 5;
        controller.settings.laborTaxRate = 2;
        expect(controller.settings.getLaborTaxRate, 15);
      });

      test("Tax added manually should have priority level 1", () {
        controller.settings.revisedLaborTax = null;
        controller.settings.isRevisedLaborTaxApplied = true;
        controller.settings.overriddenLaborTaxRate = 7;
        controller.settings.laborTaxRate = 2;
        expect(controller.settings.getLaborTaxRate, 7);
      });
    });

    group("In case of tax all", () {
      test("When tax not exists, rate should be 0", () {
        controller.settings.revisedTaxAll = null;
        controller.settings.isRevisedTaxApplied = false;
        controller.settings.overriddenTaxRate = null;
        controller.settings.taxRate = null;
        expect(controller.settings.getTaxAllRate, 0);
      });

      test("Tax coming along in settings should have priority level 4", () {
        controller.settings.revisedTaxAll = null;
        controller.settings.isRevisedTaxApplied = false;
        controller.settings.overriddenTaxRate = null;
        controller.settings.taxRate = 2;
        expect(controller.settings.getTaxAllRate, 2);
      });

      test("Tax coming along in worksheet should have priority level 3", () {
        controller.settings.revisedTaxAll = null;
        controller.settings.isRevisedTaxApplied = false;
        controller.settings.overriddenTaxRate = 5;
        controller.settings.taxRate = 2;
        expect(controller.settings.getTaxAllRate, 5);
      });

      test("Revised tax should have priority level 2", () {
        controller.settings.revisedTaxAll = 15;
        controller.settings.isRevisedTaxApplied = true;
        controller.settings.overriddenTaxRate = 5;
        controller.settings.taxRate = 2;
        expect(controller.settings.getTaxAllRate, 15);
      });

      test("Tax added manually should have priority level 1", () {
        controller.settings.revisedTaxAll = null;
        controller.settings.isRevisedTaxApplied = true;
        controller.settings.overriddenTaxRate = 7;
        controller.settings.taxRate = 2;
        expect(controller.settings.getTaxAllRate, 7);
      });
    });

    group("In case of overhead", () {
      test("When overhead not exists, value should be 0", () {
        controller.settings.overHeadRate = null;
        controller.settings.overriddenOverHeadRate = null;
        expect(controller.settings.getOverHeadRate, 0);
      });

      test("Overhead rate coming in settings should have priority level 2", () {
        controller.settings.overHeadRate = 5;
        controller.settings.overriddenOverHeadRate = null;
        expect(controller.settings.getOverHeadRate, 5);
      });

      test("Overhead rate added manually by user should have priority level 1", () {
        controller.settings.overHeadRate = 5;
        controller.settings.overriddenOverHeadRate = 10;
        expect(controller.settings.getOverHeadRate, 10);
      });
    });

    group("In case of over all profit", () {
      group("Profit rate coming from settings or worksheet should be given priority level 2", () {
        group("When margin profit is enabled", () {
          setUp(() {
            controller.settings.isMarkup = false;
          });

          test("Margin profit should be applied", () {
            controller.settings.margin = '10';
            controller.settings.markup = null;
            controller.settings.overAllProfitPercent = null;
            expect(controller.settings.getOverAllProfitRate, 10);
          });

          test("Markup profit should not be applied even when margin profit doesn't exists", () {
            controller.settings.margin = null;
            controller.settings.markup = '10';
            controller.settings.overAllProfitPercent = null;
            expect(controller.settings.getOverAllProfitRate, 0);
          });
        });

        group("When markup profit is enabled", () {
          setUp(() {
            controller.settings.isMarkup = true;
          });

          test("Markup profit should be applied", () {
            controller.settings.margin = null;
            controller.settings.markup = '10';
            controller.settings.overAllProfitPercent = null;
            expect(controller.settings.getOverAllProfitRate, 10);
          });

          test("Margin profit should not be applied even when markup profit doesn't exists", () {
            controller.settings.margin = '10';
            controller.settings.markup = null;
            controller.settings.overAllProfitPercent = null;
            expect(controller.settings.getOverAllProfitRate, 0);
          });
        });
      });

      test('Profit entered manually should be given priority level 1', () {
        controller.settings.overAllProfitPercent = 20;
        expect(controller.settings.getOverAllProfitRate, 20);
      });

      test("When profit doesn't exists, value should be 0", () {
        controller.settings
          ..overAllProfitPercent = null
          ..markup = null
          ..margin = null;
        expect(controller.settings.getOverAllProfitRate, 0);
      });
    });

    group("In case of line item profit", () {
      group("Line Item Profit rate coming from settings or worksheet should be given priority level 2", () {
        group("When margin profit is enabled", () {
          setUp(() {
            controller.settings.isMarkup = false;
          });

          test("Margin profit should be applied", () {
            controller.settings.margin = '10';
            controller.settings.markup = null;
            controller.settings.lineItemProfitPercent = null;
            expect(controller.settings.getLineItemProfitRate, 10);
          });

          test("Markup profit should not be applied even when margin profit doesn't exists", () {
            controller.settings.margin = null;
            controller.settings.markup = '10';
            controller.settings.lineItemProfitPercent = null;
            expect(controller.settings.getLineItemProfitRate, 0);
          });
        });

        group("When markup profit is enabled", () {
          setUp(() {
            controller.settings.isMarkup = true;
          });

          test("Markup profit should be applied", () {
            controller.settings.margin = null;
            controller.settings.markup = '10';
            controller.settings.lineItemProfitPercent = null;
            expect(controller.settings.getLineItemProfitRate, 10);
          });

          test("Margin profit should not be applied even when markup profit doesn't exists", () {
            controller.settings.margin = '10';
            controller.settings.markup = null;
            controller.settings.lineItemProfitPercent = null;
            expect(controller.settings.getLineItemProfitRate, 0);
          });
        });
      });

      test('Line Item Profit entered manually should be given priority level 1', () {
        controller.settings.overAllProfitPercent = 20;
        expect(controller.settings.getOverAllProfitRate, 20);
      });

      test('In case Line Item Profit is not available, It should default to 0', () {
        controller.settings
          ..lineItemProfitPercent = null
          ..lineItemTempProfitPercent = null
          ..markup = null
          ..margin = null;
        expect(controller.settings.getLineItemProfitRate, 0);
      });
    });

    group("In case of commission", () {
      test("When commission not exists, value should be 0", () {
        controller.settings.commissionPercent = null;
        controller.settings.defaultCommission?.rate = null;
        expect(controller.settings.getCommissionRate, 0);
      });

      test("Commission rate coming in settings should have priority level 2", () {
        controller.settings.commissionPercent = null;
        controller.settings.defaultCommission = WorksheetAppliedPercentage(
          rate: 10,
        );
        expect(controller.settings.getCommissionRate, 10);
      });

      test("Commission rate added manually by user should have priority level 1", () {
        controller.settings.commissionPercent = 10;
        controller.settings.defaultCommission?.rate = 5;
        expect(controller.settings.getCommissionRate, 10);
      });
    });

    group("In case of Card Fee", () {
      test("When card fee not exists, value should be 0", () {
        controller.settings.creditCardFeePercent = null;
        controller.settings.defaultFeeRate?.rate = null;
        expect(controller.settings.getCardFeeRate, 0);
      });

      test("Card Fee rate coming in settings should have priority level 2", () {
        controller.settings.creditCardFeePercent = null;
        controller.settings.defaultFeeRate = WorksheetAppliedPercentage(
          rate: 10
        );
        expect(controller.settings.getCardFeeRate, 10);
      });

      test("Card Fee rate added manually by user should have priority level 1", () {
        controller.settings.creditCardFeePercent = 10;
        controller.settings.defaultFeeRate?.rate = 5;
        expect(controller.settings.getCardFeeRate, 10);
      });
    });
  });

  group("In case of discount", () {
    test("When discount not exists, value should be 0", () {
      controller.settings.discountPercent = null;
      controller.settings.defaultDiscount?.discount = null;
      expect(controller.settings.getDiscount, 0);
    });

    test("Discount coming in settings should have priority level 2", () {
      controller.settings.discountPercent = null;
      controller.settings.defaultDiscount = WorksheetAppliedPercentage(
        discount: 10
      );
      expect(controller.settings.getDiscount, 10);
    });

      test("Discount added manually by user should have priority level 1", () {
        controller.settings.discountPercent = 10;
        controller.settings.defaultDiscount?.discount = 5;
        expect(controller.settings.getDiscount, 10);
      });
    });

  group("Settings should be modified on permission basis", () {
    test("When user has 'workSheetSettingsWithInJob' permission, settings can be modified", () {
      expect(controller.hasEditPermission, isTrue);
    });

    test("When user does not have 'workSheetSettingsWithInJob' permission, settings can not be modified", () {
      PermissionService.permissionList.clear();
      setController();
      expect(controller.hasEditPermission, isFalse);
    });
  });

  group("WorksheetSettingModel@isAnyTaxApplied should decide whether to display tax in calculation or not", () {
    setUp(() {
      controller.settings.applyTaxMaterial = false;
      controller.settings.applyTaxLabor = false;
      controller.settings.applyTaxAll = false;
      controller.settings.addLineItemTax = false;
    });

    test('When material tax is applied, tax should be displayed', () {
      controller.settings.applyTaxMaterial = true;
      expect(controller.settings.isAnyTaxApplied, isTrue);
      controller.settings.applyTaxMaterial = false;
    });

    test('When labor tax is applied, tax should be displayed', () {
      controller.settings.applyTaxLabor = true;
      expect(controller.settings.isAnyTaxApplied, isTrue);
      controller.settings.applyTaxLabor = false;
    });

    test('When tax all is applied, tax should be displayed', () {
      controller.settings.applyTaxAll = true;
      expect(controller.settings.isAnyTaxApplied, isTrue);
      controller.settings.applyTaxAll = false;
    });

    test('When line item tax is applied, tax should be displayed', () {
      controller.settings.addLineItemTax = true;
      expect(controller.settings.isAnyTaxApplied, isTrue);
      controller.settings.addLineItemTax = false;
    });

    test('Tax should be displayed, when multiple taxes are applied', () {
      controller.settings.applyTaxMaterial = true;
      controller.settings.applyTaxLabor = true;
      expect(controller.settings.isAnyTaxApplied, isTrue);
    });

    test("Tax should not be displayed, when no tax is applied", () {
      controller.settings.applyTaxMaterial = false;
      controller.settings.applyTaxLabor = false;
      controller.settings.applyTaxAll = false;
      controller.settings.addLineItemTax = false;
      expect(controller.settings.isAnyTaxApplied, isFalse);
    });
  });

  group("WorksheetSettingModel@showTaxOnly should individually show/hide tax section", () {
    setUp(() {
      controller.settings.addLineItemTax = true;
    });

    test("Tax section should be displayed, when Show Taxes setting is enabled and at least one tax is applied", () {
      controller.toggleApplyTaxMaterial(true);
      controller.toggleShowTaxes(true);
      expect(controller.settings.showTaxOnly, isTrue);
    });

    group("Tax section should not be displayed", () {
      test("When Show Taxes setting is disabled", () {
        controller.toggleShowTaxes(false);
        expect(controller.settings.showTaxOnly, isFalse);
      });

      test("When no tax is applied", () {
        controller.toggleApplyTaxMaterial(false);
        expect(controller.settings.showTaxOnly, isFalse);
      });
    });
  });

  group("WorksheetSettingModel@showTotalOnly should individually show/hide total section", () {
    test("Total section should be displayed, when Show Total setting is enabled", () {
      controller.toggleHideTotal(true);
      expect(controller.settings.showTotalOnly, isTrue);
    });

    test("Total section should not be displayed, when Show Total setting is disabled", () {
      controller.toggleHideTotal(false);
      expect(controller.settings.showTotalOnly, isFalse);
    });
  });

  group("WorksheetSettingModel@showTaxOrTotalOrDiscount should conditionally show/hide combined tax ,total section and discount", () {
    group("When Show Taxes setting is enabled", () {
      setUp(() {
        controller.settings.applyTaxAll = true;
        controller.toggleShowTaxes(true);
      });

      test('Combined tax ,total section and discount should be displayed', () {
        expect(controller.settings.showTaxOrTotalOrDiscount, isTrue);
      });

      test("Individually only tax section should be displayed", () {
        expect(controller.settings.showTaxOnly, isTrue);
      });
    });

    group("When Show Total setting is enabled", () {
      setUp(() {
        controller.toggleHideTotal(true);
      });

      test('Combined tax and total section should be displayed', () {
        expect(controller.settings.showTaxOrTotalOrDiscount, isTrue);
      });

      test("Individually only total section should be displayed", () {
        expect(controller.settings.showTotalOnly, isTrue);
      });
    });

    test("Combined tax and total section should be displayed", () {
      controller.toggleShowTaxes(true);
      controller.toggleHideTotal(true);
      expect(controller.settings.showTaxOrTotalOrDiscount, isTrue);
      expect(controller.settings.showTaxOnly, isTrue);
    });

    test("Combined tax and total section should not be displayed", () {
      controller.toggleShowTaxes(false);
      controller.toggleHideTotal(false);
      expect(controller.settings.showTaxOrTotalOrDiscount, isFalse);
      expect(controller.settings.showTaxOnly, isFalse);
    });
  });

  group("WorksheetSettingModel@showEntireSummary should entire calculation summary", () {
    test("When only Show Pricing setting is enabled, calculation summary should be displayed", () {
      controller.toggleHidePricing(true);
      expect(controller.settings.showEntireSummary, isTrue);
    });

    test("When only Calculation Summary setting is enabled, calculation summary should be displayed", () {
      controller.toggleShowCalculationSummary(true);
      expect(controller.settings.showEntireSummary, isTrue);
    });

    group("WorksheetSettingModel@applyDiscount should conditionally apply discount", () {
      test("Should not apply discount When apply Discount setting is disabled", () {
        controller.onToggleDiscount(false);
        expect(controller.settings.applyDiscount, isFalse);
        expect(controller.settings.discountPercent, isNull);
      });

      test("Should apply discount When apply Discount setting is enabled", () {
        controller.onToggleDiscount(true);
        expect(controller.settings.applyDiscount, isTrue);
      }); 
    });

    group("WorksheetSettingModel@showDiscount should conditionally show/hide discount", () {
    group("Discount should not be displayed", () {
      test("When show Discount setting is disabled", () {
        controller.toggleShowDiscount(false);
        expect(controller.settings.showDiscount, isFalse);
      });

      test("When pricing is not displayed", () {
        controller.toggleShowDiscount(true);
        controller.toggleHidePricing(false);
        expect(controller.settings.showDiscount, isFalse);
      });

      test("When pricing is not displayed and show Discount setting is not displayed", () {
        controller.toggleShowDiscount(false);
        controller.toggleHidePricing(false);
        expect(controller.settings.showDiscount, isFalse);
      });
    });

    test("Discount should be displayed when show Discount setting is enabled and pricing is displayed", () {
      controller.toggleShowDiscount(true);
      controller.toggleHidePricing(true);
      expect(controller.settings.showDiscount, isTrue);
    });
  });

    test("When Calculation Summary & Show Pricing setting is disabled, calculation summary should not be displayed", () {
      controller.toggleHidePricing(false);
      controller.toggleShowCalculationSummary(false);
      expect(controller.settings.showEntireSummary, isFalse);
    });
  });
  
  group("WorksheetSettingModel@showProcessingFee should conditionally show/hide processing fee", () {
    setUp(() {
      // Reset settings before each test
      controller.settings.applyProcessingFee = false;
      controller.toggleHidePricing(false);
      controller.toggleShowCalculationSummary(false);
    });

    test("Should show processing fee when both showEntireSummary and applyProcessingFee are true", () {
      // Set showEntireSummary to true by enabling hidePricing
      controller.toggleHidePricing(true);
      controller.settings.applyProcessingFee = true;

      expect(controller.settings.showProcessingFee, isTrue);
    });

    test("Should hide processing fee when showEntireSummary is false but applyProcessingFee is true", () {
      // Keep showEntireSummary false by keeping hidePricing and showCalculationSummary false
      controller.settings.applyProcessingFee = true;
      
      expect(controller.settings.showProcessingFee, isFalse);
    });

    test("Should hide processing fee when showEntireSummary is true but applyProcessingFee is false", () {
      // Set showEntireSummary to true by enabling showCalculationSummary
      controller.toggleShowCalculationSummary(true);
      controller.settings.applyProcessingFee = false;

      expect(controller.settings.showProcessingFee, isFalse);
    });

    test("Should hide processing fee when both showEntireSummary and applyProcessingFee are false", () {
      controller.settings.applyProcessingFee = false;
      // Keep showEntireSummary false

      expect(controller.settings.showProcessingFee, isFalse);
    });

    test("Should show processing fee when showEntireSummary is true via showCalculationSummary", () {
      controller.toggleShowCalculationSummary(true);
      controller.settings.applyProcessingFee = true;
      
      expect(controller.settings.showProcessingFee, isTrue);
    });
  });

  group("WorksheetSettingModel@canShowTierSubTotals should conditionally show/hide tier sub totals setting option", () {
    group("Tier sub totals Setting Option should be displayed", () {
      test("When Line Item Tax is enabled", () {
        controller.settings.addLineItemTax = true;
        expect(controller.settings.canShowTierSubTotals, isTrue);
      });

      test("When Line Item Profit is enabled", () {
        controller.settings.applyLineItemProfit = true;
        expect(controller.settings.canShowTierSubTotals, isTrue);
      });
    });

    test("Tier sub totals Setting Option should not be displayed line item tax and profit is not applied", () {
      controller.settings.addLineItemTax = false;
      controller.settings.applyLineItemProfit = false;
      expect(controller.settings.canShowTierSubTotals, isFalse);
    });
  });

  group("WorksheetSettingModel@fromWorksheetJson should set data from worksheet", () {
    group("Tier sub totals settings should be overridden conditionally", () {
      test("Tier subtotals settings should not be overridden when line item tax is enabled", () {
        controller.settings.addLineItemTax = true;
        controller.settings.fromWorksheetJson({'show_tier_sub_totals': 1}, WorksheetModel(lineTax: 1));
        expect(controller.settings.showTierSubTotals, isTrue);
      });

      test("Tier subtotals settings should not be overridden when line item profit is enabled", () {
        controller.settings.applyLineItemProfit = true;
        controller.settings.showTierSubTotals = true;
        controller.settings.fromWorksheetJson({'show_tier_sub_totals': 1}, WorksheetModel(lineMarginMarkup: 1));
        expect(controller.settings.showTierSubTotals, isTrue);
      });

      test("Tier subtotals settings should not be overridden when line item tax and profit is enabled", () {
        controller.settings.addLineItemTax = true;
        controller.settings.applyLineItemProfit = true;
        controller.settings.fromWorksheetJson({'show_tier_sub_totals': 1}, WorksheetModel(lineTax: 1, lineMarginMarkup: 1));
        expect(controller.settings.showTierSubTotals, isTrue);
      });

      test("Tier subtotals settings should be overridden when line item tax and profit is disabled", () {
        controller.settings.addLineItemTax = false;
        controller.settings.applyLineItemProfit = false;
        controller.settings.fromWorksheetJson({'show_tier_sub_totals': 1}, WorksheetModel(lineTax: 0, lineMarginMarkup: 0));
        expect(controller.settings.showTierSubTotals, isFalse);
      });
    });

    group("Apply line and worksheet profit settings should be overridden conditionally", () {
      test("Line and worksheet profit settings should be enabled", () {
        controller.settings.fromWorksheetJson({'enable_line_worksheet_profit': 1}, WorksheetModel(isEnableLineAndWorksheetProfit: true));
        expect(controller.settings.applyLineAndWorksheetProfit, isTrue);
      });
      test("Line and worksheet profit settings should be disable", () {
        controller.settings.fromWorksheetJson({'enable_line_worksheet_profit': 0}, WorksheetModel(isEnableLineAndWorksheetProfit: false));
        expect(controller.settings.applyLineAndWorksheetProfit, isFalse);
      });
    });
  });

  group('WorksheetSettingsController@showVariationControls test cases', () {
    test('When line items is empty', () {
      controller.lineItems?.clear();
      expect(controller.showVariationControls, false);
    });

    test('When product has no variations', () {
      controller.lineItems = [
        lineItem..product = FinancialProductModel()
      ];
      expect(controller.showVariationControls, false);
    });

    test('When product has variations', () {
      controller.lineItems?.firstOrNull?.product?.variants = [VariantModel(name: 'variant1')];
      expect(controller.showVariationControls, true);
    });
  });

  group('WorksheetSettingsController@showSizeControls test cases', () {
    test('When line items is empty', () {
      controller.lineItems?.clear();
      expect(controller.showSizeControls, false);
    });

    test('When product has no sizes', () {
      controller.lineItems = [
        lineItem..product = FinancialProductModel()
      ];
      expect(controller.showSizeControls, false);
    });

    test('When product has sizes', () {
      controller.lineItems?.firstOrNull?.product?.sizes = ['1'];
      expect(controller.showSizeControls, true);
    });
  });

  group('WorksheetSettingsController@showColorControls test cases', () {
    test('When line items is empty', () {
      controller.lineItems?.clear();
      expect(controller.showColorControls, false);
    });

    test('When product has no colors', () {
      controller.lineItems = [
        lineItem..product = FinancialProductModel()
      ];
      expect(controller.showColorControls, false);
    });

    test('When product has colors', () {
      controller.lineItems?.firstOrNull?.product?.colors = ['Black'];
      expect(controller.showColorControls, true);
    });
  });
  
  group("WorksheetSettingModel@includeCost property", () {
    test("Should be null by default when not initialized", () {
      WorksheetSettingModel settings = WorksheetSettingModel();
      expect(settings.includeCost, isNull);
    });

    test("Should retain assigned true value", () {
      controller.settings.includeCost = true;
      expect(controller.settings.includeCost, isTrue);
    });

    test("Should retain assigned false value", () {
      controller.settings.includeCost = false;
      expect(controller.settings.includeCost, isFalse);
    });

    test("Should be able to be reset to null", () {
      controller.settings.includeCost = true;
      controller.settings.includeCost = null;
      expect(controller.settings.includeCost, isNull);
    });
  });
}
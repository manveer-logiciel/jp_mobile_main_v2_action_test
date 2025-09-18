import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/financial_product/financial_product_model.dart';
import 'package:jobprogress/common/models/financial_product/variants_model.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/core/constants/worksheet.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:jobprogress/common/models/worksheet/amounts.dart';

void main() {
  SheetLineItemModel item = SheetLineItemModel(
    productId: "1",
    title: 'TEST LINE ITEM',
    price: '20',
    qty: '5',
    totalPrice: '100'
  );

  VariantModel variant = VariantModel(
    id: 1,
    name: "TEST VARIANT",
    code: 'ABC',
    uom: ['AC', 'BC']
  );

  group("SheetLineItemModel.setVariant should set variant details properly", () {
    group('When variant data is directly available in "variants" key', () {
      test("In case there are no variants, it should not set", () {
        item.setVariant({});
        expect(item.variantModel, isNull);
        expect(item.variants, isNull);
      });

      test("In case there are variants with empty data, it should not set", () {
        item.setVariant({
          "variants": <dynamic>[],
          "variant": null
        });

        expect(item.variantModel, isNull);
        expect(item.variants, isNull);
      });

      test('In case variants are empty but data is available, variant should not set', () {
        item.setVariant({
          "variants": <dynamic>[],
          "variant": variant.toJson()
        });

        expect(item.variantModel, isNull);
        expect(item.variants, isNull);
      });

      test('In case variants are not empty and data is available, variant should set', () {
        item.setVariant({
          "variants": <dynamic>[
            variant.toJson()
          ],
          "variant": variant.toLimitedJson()
        });

        expect(item.variantModel, isNotNull);
        expect(item.variantModel!.name, variant.name);
        expect(item.variants, isNotNull);
        expect(item.variants, hasLength(1));
      });
    });

    group('When variant data is not directly available in "variants" key', () {
      setUp(() {
        item.variantModel = null;
        item.variants = null;
      });

      test("In case there are no variants, it should not set", () {
        item.setVariant({});
        expect(item.variantModel, isNull);
        expect(item.variants, isNull);
      });

      test("In case there are variants with empty data, it should not set", () {
        item.setVariant({
          "variants": {
            'data': <dynamic>[],
          },
          "variant": null
        });

        expect(item.variantModel, isNull);
        expect(item.variants, isNull);
      });

      test('In case variants are empty but data is available, variant should not set', () {
        item.setVariant({
          "variants": {
            'data': <dynamic>[],
          },
          "variant": variant.toLimitedJson()
        });

        expect(item.variantModel, isNull);
        expect(item.variants, isNull);
      });

      test('In case variants are not empty and data is available, variant should set', () {
        item.setVariant({
          "variants": {
            'data': [
              variant.toJson()
            ]
          },
          "variant": variant.toLimitedJson()
        });

        expect(item.variantModel, isNotNull);
        expect(item.variantModel!.name, variant.name);
        expect(item.variants, isNotNull);
        expect(item.variants, hasLength(1));
      });
    });

    group('Product variants should be updated from line item variants', () {
      setUp(() {
        item.variantModel = null;
        item.variants = null;
      });

      test("In case product is not available, variants should not be updated", () {
        item.product = null;
        item.setVariant({
          "variants": [
            variant.toJson()
          ]
        });

        expect(item.product?.variants, isNull);
      });

      test("In case product is available, variants should be updated", () {
        item.product = FinancialProductModel();
        item.setVariant({
          "variants": [
            variant.toJson()
          ]
        });

        expect(item.product?.variants, hasLength(1));
      });
    });

    group("Set Variant data Tests", () {
      test('Sets variant correctly when variants data is available', () {
        item.setVariant({
          "variants": {
            'data': [
              variant.toJson()
            ]
          },
          "variant": variant.toLimitedJson()
        });
        expect(item.variantModel, isNotNull);
        expect(item.variantModel!.name, variant.name);
        expect(item.variants, isNotNull);
        expect(item.variants, hasLength(1));
      });

      test('Sets default variant when variants data is not available', () {
        item.setVariant({
          "variants": {
            'data': [
              variant.toJson()
            ]
          },
          "variant": null
        });
        expect(item.variantModel, isNotNull);
        expect(item.variantModel!.name, variant.name);
        expect(item.variants, isNotNull);
        expect(item.variants, hasLength(1));
      });
    });
  });

  group("SheetLineItemModel.setVariantOnMacro should set up line data on importing macro", () {
    group("Variant should be set properly", () {
      setUp(() {
        item.variantModel = null;
        item.variants = [];
      });

      test("Variant should not be set if not set on macro and line item has no variants", () {
        item.setVariant({});
        item.setVariantOnMacro();
        expect(item.variantModel, isNull);
      });

      test("Variant should not be set if not set on macro and line item has empty variants", () {
        item.variants = [];
        item.setVariantOnMacro();
        expect(item.variantModel, isNull);
      });

      test("Variant should not be updated if set already", () {
        item.variants = [variant];
        item.variantModel = variant;
        item.setVariantOnMacro();
        expect(item.variantModel, isNotNull);
      });

      test("Variant should be set to first variant if not set on macro and line item has variants", () {
        item.setVariant({
          "variants": {
            'data': [
              variant.toJson()
            ]
          }
        });
        item.setVariantOnMacro();
        expect(item.variantModel, isNotNull);
        expect(item.variantModel?.id, variant.id);
      });
    });

    group("UOM should be set from the selected variant", () {
      setUp(() {
        item.variantModel = null;
        item.unit = null;
        item.variants = [];
      });

      test("UOM should not be set if not set on macro and line item has no variants", () {
        item.setVariantOnMacro();
        expect(item.unit, isNull);
      });

      test("UOM should not be set if not set on macro and line item has empty variants", () {
        item.variants = [];
        item.setVariantOnMacro();
        expect(item.unit, isNull);
      });

      test("UOM should not be updated if set already", () {
        item.variants = [variant];
        item.variantModel = variant;
        item.setVariantOnMacro();
        expect(item.unit, isNotNull);
      });

      test("UOM should be set to first variant if not set on macro and line item has variants", () {
        item.setVariant({
          "variants": {
            'data': [
              variant.toJson()
            ]
          }
        });
        item.setVariantOnMacro();
        expect(item.unit, isNotNull);
      });
    });

    group("Product Code should be updated from selected variant", () {
      setUp(() {
        item.product = FinancialProductModel();
        item.variantModel = null;
        item.productCode = null;
        item.variants = [];
      });

      test("Product code should not be set if not set on macro and line item has no variants", () {
        item.setVariantOnMacro();
        expect(item.product?.code, isNull);
        expect(item.productCode, isNull);
      });

      test("Product code should not be set if not set on macro and line item has empty variants", () {
        item.variants = [];
        item.setVariantOnMacro();
        expect(item.product?.code, isNull);
        expect(item.productCode, isNull);
      });

      test("Product code should not be updated if set already", () {
        item.variants = [variant];
        item.variantModel = variant;
        item.setVariantOnMacro();
        expect(item.product?.code, isNotNull);
        expect(item.productCode, isNotNull);
      });

      test("Product code should be set to first variant if not set on macro and line item has variants", () {
        item.variants = [variant];
        item.setVariant({
          "variants": {
            'data': [
              variant.toJson()
            ]
          }
        });
        item.setVariantOnMacro();
        expect(item.product?.code, isNotNull);
        expect(item.productCode, isNotNull);
      });
    });

    group("Item description should be updated from selected variant", () {
      setUp(() {
        item.variants = [variant];
      });

      test("Item description should be set if if already set for product and product has variant", () {
        item.description = "This is description";
        item.setVariantOnMacro();
        expect(item.description, "This is description \n ${'item_code'.tr}: ${item.variantModel?.code}");
      });

      test("Item description should be set if not set for product and product has no variant", () {
        item.variants = [];
        item.variantModel = null;
        item.description = null;
        item.setVariantOnMacro();
        expect(item.description, '${'item_code'.tr}: ${item.productCode}');
      });

      test("Item description should be set if not set for product and product has variant", () {
        item.variantModel = variant;
        item.description = null;
        item.setVariantOnMacro();
        expect(item.description, 'item_code: ABC');
      });
    });
  });

  group("SheetLineItemModel.setMeasurementFormula should set measurement formula", () {
    test('Sets measurement formulas correctly when data is available', () {
      final json = {
        'measurement_formulas': {
          'data': [
            {'id': 1, 'trade_id': 1, 'product_id': 1, 'formula': 'formula1'},
            {'id': 2, 'trade_id': 2, 'product_id': 2, 'formula': 'formula2'},
          ]
        },
        'formula': 'fallbackFormula',
        'trade_id': 1
      };
      item.setMeasurementFormula(json);
      // Assert measurement formulas are set correctly
      expect(item.measurementFormulas?.length, equals(2));
      expect(item.measurementFormulas?[0].formula, equals('formula1'));
      expect(item.measurementFormulas?[1].formula, equals('formula2'));
      // Assert formula is set to the first measurement formula
      expect(item.formula, equals('formula1'));
    });

    test('Sets formula from json when measurement formulas data is empty', () {
      final json = {
        'measurement_formulas': {'data': null},
        'formula': 'fallbackFormula'
      };
      item.measurementFormulas = [];
      item.setMeasurementFormula(json);
      // Assert measurement formulas are not set
      expect(item.measurementFormulas, isEmpty);
      // Assert formula is set to the fallback formula
      expect(item.formula, equals('fallbackFormula'));
    });

    test('Sets formula from json when measurement formulas key is missing', () {
      final json = {
        'formula': 'fallbackFormula'
      };
      item.setMeasurementFormula(json);
      // Assert measurement formulas are not set
      expect(item.measurementFormulas, isEmpty);
      // Assert formula is set to the fallback formula
      expect(item.formula, equals('fallbackFormula'));
    });

    test('Handles null formula and empty measurement formulas', () {
      final json = {
        'measurement_formulas': {'data': null},
        'formula': null
      };
      item.setMeasurementFormula(json);
      // Assert measurement formulas are not set
      expect(item.measurementFormulas, isEmpty);
      // Assert formula is null
      expect(item.formula, isNull);
    });
  });

  group("SheetLineItemModel.toJsonFromJPSingleSelect should converts JPSingleSelectModel to JSON object", () {
    test('Converts JPSingleSelectModel to JSON correctly', () {
      final jpSingleSelectModel = JPSingleSelectModel(id: '123', label: 'Test Label');
      final json = item.toJsonFromJPSingleSelect(jpSingleSelectModel);
      // Assert json is set correctly
      expect(json['id'], equals('123'));
      expect(json['name'], equals('Test Label'));
    });

    test('Handles null JPSingleSelectModel correctly', () {
      final json = item.toJsonFromJPSingleSelect(null);
      // Assert json is not set
      expect(json['id'], isNull);
      expect(json['name'], isNull);
    });
  });

  group("SheetLineItemModel@setTierSubTotals should set tier sub totals", () {
    test("In case of valid non-decimal amounts", () {
      item.setTierSubTotals(WorksheetAmounts(
        subTotal: 100,
        listTotal: 200,
        lineItemProfit: 300,
      ));
      expect(item.totalPrice, '100');
      expect(item.tiersLineTotal, '200');
      expect(item.lineProfitAmt, '300');
    });

    test("In case of valid decimal amounts", () {
      item.setTierSubTotals(WorksheetAmounts(
        subTotal: 100.12,
        listTotal: 200.34,
        lineItemProfit: 300.45,
      ));
      expect(item.totalPrice, '100.12');
      expect(item.tiersLineTotal, '200.34');
      expect(item.lineProfitAmt, '300.45');
    });

    test("In case of valid decimal amounts having more than 2 decimal", () {
      item.setTierSubTotals(WorksheetAmounts(
        subTotal: 100.123,
        listTotal: 200.343,
        lineItemProfit: 300.4533,
      ));
      expect(item.totalPrice, '100.12');
      expect(item.tiersLineTotal, '200.34');
      expect(item.lineProfitAmt, '300.45');
    });

    test("In case of zero amounts", () {
      item.setTierSubTotals(WorksheetAmounts(
        subTotal: 0,
        listTotal: 0,
        lineItemProfit: 0,
      ));
      expect(item.totalPrice, '0');
      expect(item.tiersLineTotal, '0');
      expect(item.lineProfitAmt, '0');
    });
  });

  group('SheetLineItemModel@doHighlightTier should decide whether to highlight tier to show any warning', () {
    setUp(() {
      item.tier = 1;
      item.tierName = 'Tier 1';
      item.subItems = item.subTiers = [];
      item.isMacroNotFound = true;
    });

    test('Tier should be highlighted, when macro is not populated and tier does not have sub-tiers or sub-items', () {
      final result = item.doHighlightTier();
      expect(result, isTrue);
    });

    test('Tier should not be highlighted, when macro is populated and tier does not have sub-tiers or sub-items', () {
      item.isMacroNotFound = false;
      final result = item.doHighlightTier();
      expect(result, isFalse);
    });

    test('Tier should not be highlighted, when macro not is populated and tier does have sub-tiers', () {
      SheetLineItemModel tier = item..type = WorksheetConstants.collection;
      item.subTiers?.add(tier);
      final result = item.doHighlightTier();
      expect(result, isFalse);
    });

    test('Tier should not be highlighted, when macro not is populated and tier does have sub-items', () {
      SheetLineItemModel tier = item..type = WorksheetConstants.item;
      item.subItems?.add(tier);
      final result = item.doHighlightTier();
      expect(result, isFalse);
    });

    tearDown(() {
      item.tier = 0;
      item.tierName = 'Tier 1';
      item.subItems = item.subTiers = [];
      item.isMacroNotFound = false;
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/enums/sheet_line_item_type.dart';
import 'package:jobprogress/common/models/financial_product/financial_product_model.dart';
import 'package:jobprogress/common/models/financial_product/variants_model.dart';
import 'package:jobprogress/common/models/worksheet/settings/index.dart';
import 'package:jobprogress/core/utils/helpers.dart';

void main() {

  FinancialProductModel? product;
  VariantModel variant = VariantModel(
    id: 1,
    branchId: 1,
    branchCode: "ABC",
    name: "Variant 1",
    code: "V1",
    unit: "Unit",
    uom: ["UOM 1", "UOM 2"],
  );

  AddLineItemFormType? pageType;
  WorksheetSettingModel worksheetSettingModel = WorksheetSettingModel();

  group("FinancialProductModel.fromJson should handle product variations correctly", () {
    group("When product has no variants and not other options (color, size & style)", () {
      setUp(() {
        product = FinancialProductModel.fromJson({});
      });

      test("Variations should not be set", () {
        expect(product?.variants, null);
      });

      test("Variations string (comma separated) should not be set", () {
        expect(product?.variantsString, null);
      });

      test("Other options should not be set", () {
        expect(product?.colors, null);
        expect(product?.styles, null);
        expect(product?.sizes, null);
      });
    });

    group("When product has other options available but not variants", () {
      setUp(() {
        product = FinancialProductModel.fromJson({
          "variants": <dynamic>[],
          "colors": ["Red", "Green", "Blue"],
          "styles": ["Style 1", "Style 2"],
          "sizes": ["Small", "Medium", "Large"],
        });
      });

      test("Variations should not be set", () {
        expect(product?.variants, null);
      });

      test("Variations string (comma separated) should not be set", () {
        expect(product?.variantsString, null);
      });

      test("Other options should be set", () {
        expect(product?.colors, ["Red", "Green", "Blue"]);
        expect(product?.styles, ["Style 1", "Style 2"]);
        expect(product?.sizes, ["Small", "Medium", "Large"]);
      });
    });

    group("When product has variants but not other options", () {
      setUp(() {
        product = FinancialProductModel.fromJson({
          "variants": [
            variant.toJson(),
            variant.toJson(),
          ],
        });
      });

      test("Variations should be set", () {
        expect(product?.variants, hasLength(2));
      });

      test("Variations string (comma separated) should be set", () {
        expect(product?.variantsString, "Variant 1, Variant 1");
      });

      test("Other options should not be set", () {
        expect(product?.colors, null);
        expect(product?.styles, null);
        expect(product?.sizes, null);
      });
    });

    group("When product has variants and other options", () {
      setUp(() {
        product = FinancialProductModel.fromJson({
          "variants": [
            variant.toJson(),
          ],
          "colors": ["Red", "Green", "Blue"],
          "styles": ["Style 1", "Style 2"],
          "sizes": ["Small", "Medium", "Large"],
        });
      });

      test("Variations should be set", () {
        expect(product?.variants, hasLength(1));
      });

      test("Variations string (comma separated) should be set", () {
        expect(product?.variantsString, "Variant 1");
      });

      test("Other options should not be set", () {
        expect(product?.colors, isNull);
        expect(product?.styles, isNull);
        expect(product?.sizes, isNull);
      });
    });

    group("'code' should be set correctly on the basis of data coming with product", () {
      test("In case 'code' key has data it should be used as Product Code", () {
        product = FinancialProductModel.fromJson({
          "code": "ABC",
        });
        expect(product?.code, "ABC");
      });

      test("In case 'item_code' key has data it should be used as Product Code", () {
        product = FinancialProductModel.fromJson({
          "item_code": "ABC",
        });
        expect(product?.code, "ABC");
      });

      test("In case Product has variants has data it's code should be used as Product Code", () {
        product = FinancialProductModel.fromJson({
          "variants": [
            variant.toJson(),
          ],
        });
        expect(product?.code, "V1");
      });

      test("If none of the above keys has data then 'code' should be null", () {
        product = FinancialProductModel.fromJson({});
        expect(product?.code, null);
      });
    });
  });

  group('FinancialProductModel@showSellingPriceNotAvailable', () {
    setUpAll(() {
      product = FinancialProductModel();
    });

    setUp(() {
      pageType = null;
      worksheetSettingModel.enableSellingPrice = false;
    });
    test('Selling Price unavailable label should be visible', () {
      pageType = AddLineItemFormType.worksheet;
      worksheetSettingModel.enableSellingPrice = true;
      worksheetSettingModel.isEstimateOrProposalWorksheet = true;
      product?.isSellingPriceNotAvailable = true;

      final result = product?.showSellingPriceNotAvailable(
        pageType,
        Helper.isTrue(worksheetSettingModel.isEstimateOrProposalWorksheet),
        Helper.isTrue(worksheetSettingModel.enableSellingPrice)
      );
      expect(result, true);
    });

    group('Selling Price unavailable label should not be visible', () {
      test('When page type is not worksheet', () {
        pageType = null;

        final result = product?.showSellingPriceNotAvailable(
            pageType,
            Helper.isTrue(worksheetSettingModel.isEstimateOrProposalWorksheet),
            Helper.isTrue(worksheetSettingModel.enableSellingPrice)
        );
        expect(result, false);
      });

      test('When worksheet is not type of estimate or form proposal', () {
        worksheetSettingModel.isEstimateOrProposalWorksheet = false;
        final result = product?.showSellingPriceNotAvailable(
            pageType,
            Helper.isTrue(worksheetSettingModel.isEstimateOrProposalWorksheet),
            Helper.isTrue(worksheetSettingModel.enableSellingPrice)
        );
        expect(result, false);
      });

      test('When Selling Price setting is not active', () {
        worksheetSettingModel.enableSellingPrice = false;

        final result = product?.showSellingPriceNotAvailable(
            pageType,
            Helper.isTrue(worksheetSettingModel.isEstimateOrProposalWorksheet),
            Helper.isTrue(worksheetSettingModel.enableSellingPrice)
        );
        expect(result, false);
      });

      test('When Selling Price setting is not empty or null', () {
        product?.isSellingPriceNotAvailable = false;

        final result = product?.showSellingPriceNotAvailable(
            pageType,
            Helper.isTrue(worksheetSettingModel.isEstimateOrProposalWorksheet),
            Helper.isTrue(worksheetSettingModel.enableSellingPrice)
        );
        expect(result, false);
      });
    });
  });
}
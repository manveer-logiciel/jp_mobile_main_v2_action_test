
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/common/models/worksheet/amounts.dart';
import 'package:jobprogress/common/models/worksheet/settings/index.dart';
import 'package:jobprogress/common/models/worksheet/worksheet_model.dart';
import 'package:jobprogress/common/services/worksheet/calculations.dart';
import 'mocked_data.dart';
import 'models/index.dart';

void main() {

  late WorksheetModel worksheet;

  WorksheetMockedData mockedData = WorksheetMockedData();

  setUpAll(() {
    worksheet = mockedData.plainItems;
  });

  WorksheetAmounts getAmount(List<SheetLineItemModel> items, {
    required WorksheetSettingModel settings
  }) {
    worksheet.lineItems?.clear();
    worksheet.lineItems?.addAll(items);
    return WorksheetCalculations.calculateAmounts(
      lineItems: worksheet.lineItems ?? [],
      settings: settings,
    );
  }

  void testCalculations(WorkSheetCalculationTestModel testData, {
    int? testCase
  }) {
    test(testData.description, () {
      WorkSheetCalculationTestModel test = testData;
      final settings = test.getSettings();

      WorksheetAmounts amounts = getAmount(
          test.lineItems,
          settings: settings
      );

      expect(WorksheetCalculations.convertToFixedNum(amounts.listTotal), test.result.listTotal);
      expect(WorksheetCalculations.convertToFixedNum(amounts.fixedPrice), test.result.fixedPrice);
      expect(WorksheetCalculations.convertToFixedNum(amounts.laborTax), test.result.laborTax);
      expect(WorksheetCalculations.convertToFixedNum(amounts.commission), test.result.commission);
      expect(WorksheetCalculations.convertToFixedNum(amounts.creaditCardFee), test.result.creaditCardFee);
      expect(WorksheetCalculations.convertToFixedNum(amounts.lineItemProfit), test.result.lineItemProfit);
      expect(WorksheetCalculations.convertToFixedNum(amounts.discount), test.result.discount);
      expect(WorksheetCalculations.convertToFixedNum(amounts.lineItemTax), test.result.lineItemTax);
      expect(WorksheetCalculations.convertToFixedNum(amounts.profitMarkup), test.result.profitMarkup);
      expect(WorksheetCalculations.convertToFixedNum(amounts.profitMargin), test.result.profitMargin);
      expect(WorksheetCalculations.convertToFixedNum(amounts.overhead), test.result.overhead);
      expect(WorksheetCalculations.convertToFixedNum(amounts.subTotal), test.result.subTotal);
      expect(WorksheetCalculations.convertToFixedNum(amounts.materialTax), test.result.materialTax);
      expect(WorksheetCalculations.convertToFixedNum(amounts.displayTotal), test.result.displayTotal);
      expect(WorksheetCalculations.convertToFixedNum(amounts.noChargeAmount), test.result.noChargeAmount);
      expect(WorksheetCalculations.convertToFixedNum(amounts.profitLossAmount), test.result.profitLossAmount);
      expect(WorksheetCalculations.convertToFixedNum(amounts.taxAll), test.result.taxAll);
      expect(WorksheetCalculations.convertToFixedNum(amounts.processingFee), test.result.processingFee);
    });
  }

  void testCalculationCases(String description, List<WorkSheetCalculationTestModel> cases) {
    group(description, () {
      for (WorkSheetCalculationTestModel details in cases) {
        testCalculations(details);
      }
    });
  }

  WorksheetAmounts getAmountFromResource(WorksheetModel worksheet) {
    return WorksheetCalculations.calculateAmountForResource(worksheet);
  }

  void testCalculationsFromResource(WorkSheetCalculationTestModel testData, {
    int? testCase
  }) {
    test(testData.description, () {
      WorkSheetCalculationTestModel test = testData;
      WorksheetAmounts amounts = getAmountFromResource(test.worksheet!);

      expect(WorksheetCalculations.convertToFixedNum(amounts.listTotal), test.result.listTotal);
      expect(WorksheetCalculations.convertToFixedNum(amounts.fixedPrice), test.result.fixedPrice);
      expect(WorksheetCalculations.convertToFixedNum(amounts.laborTax), test.result.laborTax);
      expect(WorksheetCalculations.convertToFixedNum(amounts.commission), test.result.commission);
      expect(WorksheetCalculations.convertToFixedNum(amounts.creaditCardFee), test.result.creaditCardFee);
      expect(WorksheetCalculations.convertToFixedNum(amounts.lineItemProfit), test.result.lineItemProfit);
      expect(WorksheetCalculations.convertToFixedNum(amounts.lineItemTax), test.result.lineItemTax);
      expect(WorksheetCalculations.convertToFixedNum(amounts.profitMarkup), test.result.profitMarkup);
      expect(WorksheetCalculations.convertToFixedNum(amounts.profitMargin), test.result.profitMargin);
      expect(WorksheetCalculations.convertToFixedNum(amounts.overhead), test.result.overhead);
      expect(WorksheetCalculations.convertToFixedNum(amounts.subTotal), test.result.subTotal);
      expect(WorksheetCalculations.convertToFixedNum(amounts.materialTax), test.result.materialTax);
      expect(WorksheetCalculations.convertToFixedNum(amounts.displayTotal), test.result.displayTotal);
      expect(WorksheetCalculations.convertToFixedNum(amounts.noChargeAmount), test.result.noChargeAmount);
      expect(WorksheetCalculations.convertToFixedNum(amounts.profitLossAmount), test.result.profitLossAmount);
      expect(WorksheetCalculations.convertToFixedNum(amounts.taxAll), test.result.taxAll);
      expect(WorksheetCalculations.convertToFixedNum(amounts.processingFee), test.result.processingFee);
    });
  }

  void testCalculationFromResourceCases(String description, List<WorkSheetCalculationTestModel> cases) {
    group(description, () {
      for (WorkSheetCalculationTestModel details in cases) {
        testCalculationsFromResource(details);
      }
    });
  }

  group("WorksheetCalculations@calculateAmounts should calculate all the prices", () {
    testCalculations(mockedData.withoutLineItems);
    testCalculations(mockedData.withLineItems);

    group("Applied tax should be added to calculations correctly", () {
      testCalculationCases("When only material tax is applied", mockedData.onlyMaterialTaxCases);
      testCalculationCases("When only labor tax is applied", mockedData.onlyLaborTaxCases);
      testCalculationCases("When only tax all is applied", mockedData.onlyTaxAllCases);
      testCalculationCases("When only line item tax is applied", mockedData.onlyLineItemTaxCases);
      testCalculationCases("When random taxes are applied", mockedData.randomTaxCases);
    });

    testCalculationCases("Applied overhead should be added to calculation correctly", mockedData.onlyOverHeadCases);
    testCalculationCases("Applied commission should be added to calculation correctly", mockedData.onlyCommissionCases);
    testCalculationCases("Applied discount should be added to calculation correctly", mockedData.onlyDiscountCases);
    testCalculationCases("Applied card fee should be added to calculation correctly", mockedData.onlyCardFeeCases);
    testCalculationCases("Applied markup profit should be added to calculation correctly", mockedData.onlyOverallMarkupProfitCases);
    testCalculationCases("Applied margin profit should be added to calculation correctly", mockedData.onlyOverallMarginProfitCases);
    testCalculationCases("Applied line item markup profit should be added to calculation correctly", mockedData.onlyLineItemMarkupProfit);
    testCalculationCases("Applied line item margin profit should be added to calculation", mockedData.onlyLineItemMarginProfit);
    testCalculationCases("Testing real scenarios data", mockedData.realWorksheetResponses);
  });

  group('WorksheetCalculations@percentToAmount should convert percentage to amount', () {

    group('When percentage is not given', () {
      test("Total amount is zero", () {
        final result = WorksheetCalculations.percentToAmount(null, 0);
        expect(result, 0);
      });

      test("Total amount is not zero", () {
        final result = WorksheetCalculations.percentToAmount(null, 100);
        expect(result, 0);
      });

      test("Total amount is negative", () {
        final result = WorksheetCalculations.percentToAmount(null, -10);
        expect(result, 0);
      });
    });

    group('When percentage is given', () {
      test("Total amount is zero", () {
        final result = WorksheetCalculations.percentToAmount(5, 0);
        expect(result, 0);
      });

      test("Total amount is not zero", () {
        final result = WorksheetCalculations.percentToAmount(5, 100);
        expect(result, 5);
      });

      test("Total amount is negative", () {
        final result = WorksheetCalculations.percentToAmount(5, -10);
        expect(result, -0.5);
      });
    });

    test('When requested amount is margin amount', () {
      final result = WorksheetCalculations.percentToAmount(5, 100, margin: true);
      expect(result, 5.263157894736835);
    });

    test('When requested amount is not margin amount', () {
      final result = WorksheetCalculations.percentToAmount(5, 100, margin: false);
      expect(result, 5);
    });
  });

  group('WorksheetCalculations@amountToPercent should convert amount to percentage', () {

    group('When amount is not given', () {
      test("Total amount is zero", () {
        final result = WorksheetCalculations.amountToPercent(null, 0);
        expect(result, 0);
      });

      test("Total amount is positive", () {
        final result = WorksheetCalculations.amountToPercent(null, 100);
        expect(result, 0);
      });

      test("Total amount is negative", () {
        final result = WorksheetCalculations.amountToPercent(null, -10);
        expect(result, 0);
      });
    });

    group('When amount is given', () {
      test("Total amount is zero", () {
        final result = WorksheetCalculations.amountToPercent(5, 0);
        expect(result, 0);
      });

      test("Total amount is positive", () {
        final result = WorksheetCalculations.amountToPercent(5, 100);
        expect(result, 5);
      });

      test("Total amount is negative", () {
        final result = WorksheetCalculations.amountToPercent(5, -10);
        expect(result, 0);
      });
    });

    test('When requested percentage is margin percent', () {
      final result = WorksheetCalculations.amountToPercent(5, 100, margin: true);
      expect(result, 4.761904761904759);
    });

    test('When requested percentage is not margin percent', () {
      final result = WorksheetCalculations.amountToPercent(5, 100, margin: false);
      expect(result, 5);
    });
  });

  group("WorksheetCalculations@convertToFixedNum should format amount or value give to fixed decimals", () {
    test("When -ve value is given", () {
      final result = WorksheetCalculations.convertToFixedNum(-500);
      expect(result, -500);
    });

    test("When 0 values is given", () {
      final result = WorksheetCalculations.convertToFixedNum(0);
      expect(result, 0);
    });

    test("When +ve values is given", () {
      final result = WorksheetCalculations.convertToFixedNum(10);
      expect(result, 10);
    });

    test("When single digit decimal is given", () {
      final result = WorksheetCalculations.convertToFixedNum(10.5);
      expect(result, 10.5);
    });

    test("When two digit decimal is given", () {
      final result = WorksheetCalculations.convertToFixedNum(10.55);
      expect(result, 10.55);
    });

    group("When more than 2 digit decimal is given", () {
      test("When 3rd digit is less than 5", () {
        final result = WorksheetCalculations.convertToFixedNum(10.552);
        expect(result, 10.55);
      });

      test("When 3rd digit is 5", () {
        final result = WorksheetCalculations.convertToFixedNum(10.552);
        expect(result, 10.55);
      });

      test("When 3rd digit is greater than 5", () {
        final result = WorksheetCalculations.convertToFixedNum(10.557);
        expect(result, 10.56);
      });

      test("When long digit decimal is give", () {
        final result = WorksheetCalculations.convertToFixedNum(10.5572343253);
        expect(result, 10.56);
      });
    });
  });

  group("WorksheetCalculations@calculateAmountForResource should calculate amounts for resource files", () {
    testCalculationFromResourceCases("Processing fee should be calculated from processing fee rate", mockedData.processingFeeResponse);
    testCalculationFromResourceCases("Line Item Profit should be calculated from total line profit", mockedData.lineItemProfitResponse);
    testCalculationFromResourceCases("Line & Worksheet Profit should be calculated correctly", mockedData.lineAndWorksheetProfit);
  });
}
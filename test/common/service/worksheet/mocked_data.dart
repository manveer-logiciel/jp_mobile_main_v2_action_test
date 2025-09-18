import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/common/models/worksheet/amounts.dart';
import 'package:jobprogress/common/models/worksheet/settings/index.dart';
import 'package:jobprogress/common/models/worksheet/worksheet_detail_category_model.dart';
import 'package:jobprogress/common/models/worksheet/worksheet_meta.dart';
import 'package:jobprogress/common/models/worksheet/worksheet_model.dart';
import 'package:jobprogress/core/constants/financial_constants.dart';
import 'models/index.dart';
import 'models/mocked_responses.dart';

class WorksheetMockedData {
  WorksheetModel get plainItems => WorksheetModel(lineItems: []);

  WorkSheetCalculationTestModel withoutLineItems = WorkSheetCalculationTestModel(
    description: "When no item exists",
    lineItems: [],
    result: WorksheetAmounts(),
  );

  WorkSheetCalculationTestModel get withLineItems => WorkSheetCalculationTestModel(
      description: "When line items exist without tax and profit",
      lineItems: set1Items,
      result: WorksheetAmounts(
        subTotal: 979.50,
        listTotal: 979.50,
      ),
  );

  List<WorkSheetCalculationTestModel> get onlyMaterialTaxCases => [
    WorkSheetCalculationTestModel(
        description: "Case 1: When applied material tax is 0",
        lineItems: set1Items,
        result: WorksheetAmounts(
          subTotal: 979.50,
          listTotal: 979.50,
          materialTax: 0,
        ),
        worksheet: WorksheetModel(
            materialTaxRate: '0'
        )
    ),
    WorkSheetCalculationTestModel(
        description: "Case 2: When applied material tax is grater than zero",
        lineItems: set1Items,
        result: WorksheetAmounts(
          subTotal: 979.50,
          listTotal: 1053.06,
          materialTax: 73.56,
        ),
        worksheet: WorksheetModel(
            materialTaxRate: '8'
        )
    ),
    WorkSheetCalculationTestModel(
        description: "Case 3: When applied material tax is less than zero",
        lineItems: set1Items,
        result: WorksheetAmounts(
          subTotal: 979.50,
          listTotal: 701.50,
          materialTax: -278.0,
        ),
        worksheet: WorksheetModel(
            materialTaxRate: '-30.234'
        )
    ),
    WorkSheetCalculationTestModel(
        description: "Case 4: When applied material tax is in decimals",
        lineItems: set1Items,
        result: WorksheetAmounts(
          subTotal: 979.50,
          listTotal: 1024.42,
          materialTax: 44.92,
        ),
        worksheet: WorksheetModel(
            materialTaxRate: '4.885'
        )
    ),
    WorkSheetCalculationTestModel(
        description: "Case 5: When applied material tax is in decimals",
        lineItems: set1Items,
        result: WorksheetAmounts(
          subTotal: 979.50,
          listTotal: 1257.50,
          materialTax: 278.00,
        ),
        worksheet: WorksheetModel(
            materialTaxRate: '30.234'
        )
    ),
  ];

  List<WorkSheetCalculationTestModel> get onlyLaborTaxCases => [
    WorkSheetCalculationTestModel(
        description: "Case 1: When applied labor tax is 0",
        lineItems: set1Items,
        result: WorksheetAmounts(
          subTotal: 979.50,
          listTotal: 979.50,
          laborTax: 0,
        ),
        worksheet: WorksheetModel(
          laborTaxRate: '0'
        )
    ),
    WorkSheetCalculationTestModel(
        description: "Case 2: When applied labor tax is less than zero",
        lineItems: set1Items,
        result: WorksheetAmounts(
          subTotal: 979.50,
          listTotal: 979.50,
          laborTax: 0,
        ),
        worksheet: WorksheetModel(
            laborTaxRate: '0'
        )
    ),
    WorkSheetCalculationTestModel(
        description: "Case 3: When applied labor tax is grater than zero",
        lineItems: set1Items,
        result: WorksheetAmounts(
          subTotal: 979.50,
          listTotal: 982.50,
          laborTax: 3,
        ),
        worksheet: WorksheetModel(
            laborTaxRate: '5'
        )
    ),
    WorkSheetCalculationTestModel(
        description: "Case 4: When applied labor tax is in decimals",
        lineItems: set1Items,
        result: WorksheetAmounts(
          subTotal: 979.50,
          listTotal: 982.43,
          laborTax: 2.93
        ),
        worksheet: WorksheetModel(
            laborTaxRate: '4.885'
        )
    ),
    WorkSheetCalculationTestModel(
        description: "Case 5: When applied labor tax is in decimals",
        lineItems: set1Items,
        result: WorksheetAmounts(
          subTotal: 979.50,
          listTotal: 997.64,
          laborTax: 18.14,
        ),
        worksheet: WorksheetModel(
            laborTaxRate: '30.234'
        )
    ),
  ];

  List<WorkSheetCalculationTestModel> get onlyTaxAllCases => [
    WorkSheetCalculationTestModel(
        description: "Case 1: When applied tax is 0",
        lineItems: set1Items,
        result: WorksheetAmounts(
          subTotal: 979.50,
          listTotal: 979.50,
          taxAll: 0
        ),
        worksheet: WorksheetModel(
            taxRate: '0'
        )
    ),
    WorkSheetCalculationTestModel(
        description: "Case 2: When applied tax is less than zero",
        lineItems: set1Items,
        result: WorksheetAmounts(
            subTotal: 979.50,
            listTotal: 979.50,
            taxAll: 0
        ),
        worksheet: WorksheetModel(
            taxRate: '0'
        )
    ),
    WorkSheetCalculationTestModel(
        description: "Case 3: When applied tax is grater than zero",
        lineItems: set1Items,
        result: WorksheetAmounts(
            subTotal: 979.50,
            listTotal: 1028.48,
            taxAll: 48.98
        ),
        worksheet: WorksheetModel(
            taxRate: '5'
        )
    ),
    WorkSheetCalculationTestModel(
        description: "Case 4: When applied tax is in decimals",
        lineItems: set1Items,
        result: WorksheetAmounts(
            subTotal: 979.50,
            listTotal: 1060.80,
            taxAll: 81.30
        ),
        worksheet: WorksheetModel(
            taxRate: '8.3'
        )
    ),
    WorkSheetCalculationTestModel(
        description: "Case 5: When applied tax is in decimals",
        lineItems: set1Items,
        result: WorksheetAmounts(
          subTotal: 979.50,
          listTotal: 1027.35,
          taxAll: 47.85,
        ),
        worksheet: WorksheetModel(
            taxRate: '4.885'
        )
    ),
  ];

  List<WorkSheetCalculationTestModel> get onlyLineItemTaxCases => [
    WorkSheetCalculationTestModel(
        description: "Case 1: When applied tax rate is 0 for all items",
        lineItems: set2Items(taxRate: '0'),
        result: WorksheetAmounts(
          subTotal: 979.50,
          listTotal: 979.50,
          lineItemTax: 0
        ),
        worksheet: WorksheetModel(
          lineTax: 1
        )
    ),
    WorkSheetCalculationTestModel(
        description: "Case 2: When applied tax rate is less than for all items",
        lineItems: set2Items(taxRate: '-5'),
        result: WorksheetAmounts(
          subTotal: 979.50,
          listTotal: 930.52,
          lineItemTax: -48.98
        ),
        worksheet: WorksheetModel(
          lineTax: 1
        )
    ),
    WorkSheetCalculationTestModel(
        description: "Case 3: When applied tax rate is greater than zero for all items",
        lineItems: set2Items(taxRate: '5'),
        result: WorksheetAmounts(
          subTotal: 979.50,
          listTotal: 1028.48,
          lineItemTax: 48.98
        ),
        worksheet: WorksheetModel(
          lineTax: 1
        )
    ),
    WorkSheetCalculationTestModel(
        description: "Case 4: When applied tax rate is in decimal for all items",
        lineItems: set2Items(taxRate: '5.23'),
        result: WorksheetAmounts(
          subTotal: 979.50,
          listTotal: 1030.73,
          lineItemTax: 51.23
        ),
        worksheet: WorksheetModel(
          lineTax: 1
        )
    ),
    WorkSheetCalculationTestModel(
        description: "Case 5: When applied tax rate is in decimal for all items",
        lineItems: set2Items(taxRate: '52.95'),
        result: WorksheetAmounts(
          subTotal: 979.50,
          listTotal: 1498.15,
          lineItemTax: 518.65
        ),
        worksheet: WorksheetModel(
          lineTax: 1
        )
    ),
    WorkSheetCalculationTestModel(
        description: "Case 6: When different tax applied to individual items",
        lineItems: set2Items(),
        result: WorksheetAmounts(
          subTotal: 979.50,
          listTotal: 1030.66,
          lineItemTax: 51.16
        ),
        worksheet: WorksheetModel(
          lineTax: 1
        )
    ),
    WorkSheetCalculationTestModel(
        description: "Case 7: When tax values exist but tax is not applied",
        lineItems: set2Items(),
        result: WorksheetAmounts(
          subTotal: 979.50,
          listTotal: 979.50,
          lineItemTax: 0
        ),
        worksheet: WorksheetModel(
          lineTax: 0
        )
    ),
  ];

  List<WorkSheetCalculationTestModel> get randomTaxCases => [
    WorkSheetCalculationTestModel(
        description: "Case 1: When random taxes are applied",
        lineItems: set1Items,
        result: WorksheetAmounts(
          subTotal: 979.50,
          listTotal: 1056.06,
          materialTax: 73.56,
          laborTax: 3.00
        ),
        worksheet: WorksheetModel(
            materialTaxRate: '8',
            laborTaxRate: '5',
        ),
    ),
    WorkSheetCalculationTestModel(
        description: "Case 2: When random taxes are applied",
        lineItems: set1Items,
        result: WorksheetAmounts(
          subTotal: 979.50,
          listTotal: 1442.18,
          materialTax: 459.75,
          laborTax: 2.93
        ),
        worksheet: WorksheetModel(
            materialTaxRate: '50',
            laborTaxRate: '4.885',
        ),
    ),
    WorkSheetCalculationTestModel(
        description: "Case 3: When random taxes are applied",
        lineItems: set1Items,
        result: WorksheetAmounts(
          subTotal: 979.50,
          listTotal: 1523.48,
          materialTax: 459.75,
          laborTax: 2.93,
          taxAll: 81.30
        ),
        worksheet: WorksheetModel(
            materialTaxRate: '50',
            laborTaxRate: '4.885',
            taxRate: '8.3',
        ),
    ),
    WorkSheetCalculationTestModel(
        description: "Case 4: When random taxes are applied",
        lineItems: set1Items,
        result: WorksheetAmounts(
          subTotal: 979.50,
          listTotal: 2209.62,
          materialTax: 422.51,
          laborTax: 15,
          taxAll: 792.61
        ),
        worksheet: WorksheetModel(
            materialTaxRate: '45.95',
            laborTaxRate: '25',
            taxRate: '80.92',
        ),
    ),
    WorkSheetCalculationTestModel(
        description: "Case 5: When random taxes are applied",
        lineItems: set1Items,
        result: WorksheetAmounts(
          subTotal: 979.50,
          listTotal: 1084.99,
          materialTax: 45.52,
          laborTax: 1.2,
          taxAll: 58.77
        ),
        worksheet: WorksheetModel(
            materialTaxRate: '4.95',
            laborTaxRate: '2',
            taxRate: '6',
        ),
    ),
    WorkSheetCalculationTestModel(
        description: "Case 6: When random taxes are applied",
        lineItems: set1Items,
        result: WorksheetAmounts(
          subTotal: 979.50,
          listTotal: 1090.21,
          materialTax: 21.46,
          taxAll: 89.25
        ),
        worksheet: WorksheetModel(
            materialTaxRate: '2.334',
            taxRate: '9.112',
        ),
    ),
    WorkSheetCalculationTestModel(
        description: "Case 7: When random taxes are applied",
        lineItems: set1Items,
        result: WorksheetAmounts(
          subTotal: 979.50,
          listTotal: 2187.84,
          materialTax: 490.46,
          taxAll: 717.88
        ),
        worksheet: WorksheetModel(
            materialTaxRate: '53.34',
            taxRate: '73.29',
        ),
    ),
    WorkSheetCalculationTestModel(
        description: "Case 8: When random taxes are applied",
        lineItems: set1Items,
        result: WorksheetAmounts(
          subTotal: 979.50,
          listTotal: 1729.38,
          laborTax: 32.00,
          taxAll: 717.88
        ),
        worksheet: WorksheetModel(
            laborTaxRate: '53.34',
            taxRate: '73.29',
        ),
    ),
    WorkSheetCalculationTestModel(
        description: "Case 9: When random taxes are applied",
        lineItems: set2Items(taxRate: '86.54'),
        result: WorksheetAmounts(
            subTotal: 979.50,
            listTotal: 1827.16,
            lineItemTax: 847.66
        ),
        worksheet: WorksheetModel(
            lineTax: 1
        )
    ),
    WorkSheetCalculationTestModel(
        description: "Case 10: When random taxes are applied",
        lineItems: set2Items(taxRate: '1.2233'),
        result: WorksheetAmounts(
            subTotal: 979.50,
            listTotal: 991.48,
            lineItemTax: 11.98
        ),
        worksheet: WorksheetModel(
            lineTax: 1
        )
    ),
  ];

  List<WorkSheetCalculationTestModel> get onlyOverHeadCases => [
    WorkSheetCalculationTestModel(
        description: "Case 1: When overhead rate zero",
        lineItems: set1Items,
        result: WorksheetAmounts(
            subTotal: 979.50,
            listTotal: 979.50,
            overhead: 0
        ),
        worksheet: WorksheetModel(
            overhead: '0'
        )
    ),
    WorkSheetCalculationTestModel(
        description: "Case 2: When overhead rate is less than zero",
        lineItems: set1Items,
        result: WorksheetAmounts(
            subTotal: 979.50,
            listTotal: 979.50,
            overhead: 0
        ),
        worksheet: WorksheetModel(
            overhead: '-5'
        )
    ),
    WorkSheetCalculationTestModel(
        description: "Case 3: When overhead rate is greater than zero",
        lineItems: set1Items,
        result: WorksheetAmounts(
            subTotal: 979.50,
            listTotal: 1028.48,
            overhead: 48.98
        ),
        worksheet: WorksheetModel(
            overhead: '5'
        )
    ),
    WorkSheetCalculationTestModel(
        description: "Case 4: When overhead rate is in decimal",
        lineItems: set1Items,
        result: WorksheetAmounts(
            subTotal: 979.50,
            listTotal: 1061.19,
            overhead: 81.69
        ),
        worksheet: WorksheetModel(
            overhead: '8.34'
        )
    ),
    WorkSheetCalculationTestModel(
        description: "Case 5: When overhead rate is in decimal",
        lineItems: set1Items,
        result: WorksheetAmounts(
            subTotal: 979.50,
            listTotal: 1534.39,
            overhead: 554.89
        ),
        worksheet: WorksheetModel(
            overhead: '56.65'
        )
    ),
  ];

  List<WorkSheetCalculationTestModel> get onlyCommissionCases => [
    WorkSheetCalculationTestModel(
        description: "Case 1: When commission rate zero",
        lineItems: set1Items,
        result: WorksheetAmounts(
            subTotal: 979.50,
            listTotal: 979.50,
            commission: 0
        ),
        worksheet: WorksheetModel(
            commission: '0'
        )
    ),
    WorkSheetCalculationTestModel(
        description: "Case 2: When commission rate is less than zero",
        lineItems: set1Items,
        result: WorksheetAmounts(
            subTotal: 979.50,
            listTotal: 930.52,
            commission: -48.98
        ),
        worksheet: WorksheetModel(
            commission: '-5'
        )
    ),
    WorkSheetCalculationTestModel(
        description: "Case 3: When commission rate is greater than zero",
        lineItems: set1Items,
        result: WorksheetAmounts(
            subTotal: 979.50,
            listTotal: 1028.48,
            commission: 48.98
        ),
        worksheet: WorksheetModel(
            commission: '5'
        )
    ),
    WorkSheetCalculationTestModel(
        description: "Case 4: When commission rate is in decimal",
        lineItems: set1Items,
        result: WorksheetAmounts(
            subTotal: 979.50,
            listTotal: 1061.19,
            commission: 81.69
        ),
        worksheet: WorksheetModel(
            commission: '8.34'
        )
    ),
    WorkSheetCalculationTestModel(
        description: "Case 5: When commission rate is in decimal",
        lineItems: set1Items,
        result: WorksheetAmounts(
            subTotal: 979.50,
            listTotal: 1534.39,
            commission: 554.89
        ),
        worksheet: WorksheetModel(
            commission: '56.65'
        )
    ),
  ];

  List<WorkSheetCalculationTestModel> get onlyCardFeeCases => [
    WorkSheetCalculationTestModel(
        description: "Case 1: When card fee rate is zero",
        lineItems: set1Items,
        result: WorksheetAmounts(
            subTotal: 979.50,
            listTotal: 979.50,
            creaditCardFee: 0
        ),
        worksheet: WorksheetModel(
            processingFee: '0'
        )
    ),
    WorkSheetCalculationTestModel(
        description: "Case 2: When card fee rate is less than zero",
        lineItems: set1Items,
        result: WorksheetAmounts(
            subTotal: 979.50,
            listTotal: 979.50,
            creaditCardFee: -48.98
        ),
        worksheet: WorksheetModel(
            processingFee: '-5'
        )
    ),
    WorkSheetCalculationTestModel(
        description: "Case 3: When card fee rate is greater than zero",
        lineItems: set1Items,
        result: WorksheetAmounts(
            subTotal: 979.50,
            listTotal: 979.50,
            creaditCardFee: 48.98
        ),
        worksheet: WorksheetModel(
            processingFee: '5'
        )
    ),
    WorkSheetCalculationTestModel(
        description: "Case 4: When card rate is in decimal",
        lineItems: set1Items,
        result: WorksheetAmounts(
            subTotal: 979.50,
            listTotal: 979.50,
            creaditCardFee: 81.69
        ),
        worksheet: WorksheetModel(
            processingFee: '8.34'
        )
    ),
    WorkSheetCalculationTestModel(
        description: "Case 5: When card fee rate is in decimal",
        lineItems: set1Items,
        result: WorksheetAmounts(
            subTotal: 979.50,
            listTotal: 979.50,
            creaditCardFee: 554.89
        ),
        worksheet: WorksheetModel(
            processingFee: '56.65'
        )
    ),
  ];

  List<WorkSheetCalculationTestModel> get onlyOverallMarkupProfitCases => [
    WorkSheetCalculationTestModel(
        description: "Case 1: When applied profit rate is zero",
        lineItems: set1Items,
        result: WorksheetAmounts(
            subTotal: 979.50,
            listTotal: 979.50,
            profitMarkup: 0,
        ),
        worksheet: WorksheetModel(
            profit: '0',
            margin: 0
        ),
    ),
    WorkSheetCalculationTestModel(
        description: "Case 2: When applied profit is less than zero",
        lineItems: set1Items,
        result: WorksheetAmounts(
            subTotal: 979.50,
            listTotal: 979.50,
            profitMarkup: 0,
        ),
        worksheet: WorksheetModel(
            profit: '-5',
            margin: 0
        ),
    ),
    WorkSheetCalculationTestModel(
        description: "Case 3: When applied profit is greater than zero",
        lineItems: set1Items,
        result: WorksheetAmounts(
            subTotal: 979.50,
            listTotal: 1077.45,
            profitMarkup: 97.95,
        ),
        worksheet: WorksheetModel(
            profit: '10',
            margin: 0
        ),
    ),
    WorkSheetCalculationTestModel(
        description: "Case 4: When applied profit is in decimal",
        lineItems: set1Items,
        result: WorksheetAmounts(
            subTotal: 979.50,
            listTotal: 1213.70,
            profitMarkup: 234.20,
        ),
        worksheet: WorksheetModel(
            profit: '23.91',
            margin: 0
        ),
    ),
    WorkSheetCalculationTestModel(
        description: "Case 5: When applied profit is in decimal",
        lineItems: set1Items,
        result: WorksheetAmounts(
            subTotal: 979.50,
            listTotal: 1523.61,
            profitMarkup: 544.11,
        ),
        worksheet: WorksheetModel(
            profit: '55.55',
            margin: 0
        ),
    ),
  ];

  List<WorkSheetCalculationTestModel> get onlyDiscountCases => [
    WorkSheetCalculationTestModel(
        description: "Case 1: When discount is zero",
        lineItems: set1Items,
        result: WorksheetAmounts(
            subTotal: 979.50,
            listTotal: 979.50,
            commission: 0,
            discount: 0
        ),
        worksheet: WorksheetModel(
            discount: '0'
        )
    ),
    WorkSheetCalculationTestModel(
        description: "Case 2: When discount is less than zero",
        lineItems: set1Items,
        result: WorksheetAmounts(
            subTotal: 979.50,
            listTotal: 979.50,
            discount: 0,
            commission: 0,
        ),
        worksheet: WorksheetModel(
            discount: '-5'
        )
    ),
    WorkSheetCalculationTestModel(
        description: "Case 3: When discount is greater than zero",
        lineItems: set1Items,
        result: WorksheetAmounts(
            subTotal: 979.50,
            listTotal: 930.52,
            discount: 48.98,
        ),
        worksheet: WorksheetModel(
            discount: '5'
        )
    ),
    WorkSheetCalculationTestModel(
        description: "Case 4: When discount is in decimal",
        lineItems: set1Items,
        result: WorksheetAmounts(
            subTotal: 979.50,
            listTotal: 897.81,
            discount: 81.69,
        ),
        worksheet: WorksheetModel(
            discount: '8.34'
        )
    ),
  ];

  List<WorkSheetCalculationTestModel> get onlyOverallMarginProfitCases => [
    WorkSheetCalculationTestModel(
      description: "Case 1: When applied profit rate is zero",
      lineItems: set1Items,
      result: WorksheetAmounts(
        subTotal: 979.50,
        listTotal: 979.50,
        profitMargin: 0,
      ),
      worksheet: WorksheetModel(
          profit: '0',
          margin: 1
      ),
    ),
    WorkSheetCalculationTestModel(
      description: "Case 2: When applied profit is less than zero",
      lineItems: set1Items,
      result: WorksheetAmounts(
        subTotal: 979.50,
        listTotal: 979.50,
        profitMargin: 0,
      ),
      worksheet: WorksheetModel(
          profit: '-5',
          margin: 1
      ),
    ),
    WorkSheetCalculationTestModel(
      description: "Case 3: When applied profit is greater than zero",
      lineItems: set1Items,
      result: WorksheetAmounts(
        subTotal: 979.50,
        listTotal: 1088.33,
        profitMargin: 108.83,
      ),
      worksheet: WorksheetModel(
          profit: '10',
          margin: 1
      ),
    ),
    WorkSheetCalculationTestModel(
      description: "Case 4: When applied profit is in decimal",
      lineItems: set1Items,
      result: WorksheetAmounts(
        subTotal: 979.50,
        listTotal: 1287.29,
        profitMargin: 307.79,
      ),
      worksheet: WorksheetModel(
          profit: '23.91',
          margin: 1
      ),
    ),
    WorkSheetCalculationTestModel(
      description: "Case 5: When applied profit is in decimal",
      lineItems: set1Items,
      result: WorksheetAmounts(
        subTotal: 979.50,
        listTotal: 2203.60,
        profitMargin: 1224.10,
      ),
      worksheet: WorksheetModel(
          profit: '55.55',
          margin: 1
      ),
    ),
  ];

  List<WorkSheetCalculationTestModel> get onlyLineItemMarkupProfit => [
    WorkSheetCalculationTestModel(
      description: "Case 1: When applied profit rate is zero",
      lineItems: set3Items(profitRate: '0'),
      result: WorksheetAmounts(
        subTotal: 979.50,
        listTotal: 979.50,
        lineItemProfit: 0,
      ),
      worksheet: WorksheetModel(
        lineMarginMarkup: 1
      ),
    ),
    WorkSheetCalculationTestModel(
      description: "Case 2: When applied profit rate is less than zero",
      lineItems: set3Items(profitRate: '-5'),
      result: WorksheetAmounts(
        subTotal: 979.50,
        listTotal: 930.52,
        lineItemProfit: -48.98,
      ),
      worksheet: WorksheetModel(
          lineMarginMarkup: 1
      ),
    ),
    WorkSheetCalculationTestModel(
      description: "Case 3: When applied profit rate is greater than zero",
      lineItems: set3Items(profitRate: '5'),
      result: WorksheetAmounts(
        subTotal: 979.50,
        listTotal: 1028.48,
        lineItemProfit: 48.98,
      ),
      worksheet: WorksheetModel(
          lineMarginMarkup: 1
      ),
    ),
    WorkSheetCalculationTestModel(
      description: "Case 4: When applied profit rate is in decimal",
      lineItems: set3Items(profitRate: '44.23'),
      result: WorksheetAmounts(
        subTotal: 979.50,
        listTotal: 1412.74,
        lineItemProfit: 433.24,
      ),
      worksheet: WorksheetModel(
          lineMarginMarkup: 1
      ),
    ),
    WorkSheetCalculationTestModel(
      description: "Case 5: When applied profit rate is in decimal",
      lineItems: set3Items(profitRate: '3.91'),
      result: WorksheetAmounts(
        subTotal: 979.50,
        listTotal: 1017.80,
        lineItemProfit: 38.30,
      ),
      worksheet: WorksheetModel(
          lineMarginMarkup: 1
      ),
    ),
    WorkSheetCalculationTestModel(
      description: "Case 6: When different line profit rate is applied to items",
      lineItems: set3Items(),
      result: WorksheetAmounts(
        subTotal: 979.50,
        listTotal: 1030.66,
        lineItemProfit: 51.16,
      ),
      worksheet: WorksheetModel(
          lineMarginMarkup: 1
      ),
    ),
  ];

  List<WorkSheetCalculationTestModel> get onlyLineItemMarginProfit => [
    WorkSheetCalculationTestModel(
      description: "Case 1: When applied profit rate is zero",
      lineItems: set3Items(profitRate: '0', isMarkup: false),
      result: WorksheetAmounts(
        subTotal: 979.50,
        listTotal: 979.50,
        lineItemProfit: 0,
      ),
      worksheet: WorksheetModel(
          lineMarginMarkup: 1
      ),
    ),
    WorkSheetCalculationTestModel(
      description: "Case 2: When applied profit rate is less than zero",
      lineItems: set3Items(profitRate: '-5', isMarkup: false),
      result: WorksheetAmounts(
        subTotal: 979.50,
        listTotal: 932.85,
        lineItemProfit: -46.65,
      ),
      worksheet: WorksheetModel(
          lineMarginMarkup: 1
      ),
    ),
    WorkSheetCalculationTestModel(
      description: "Case 3: When applied profit rate is greater than zero",
      lineItems: set3Items(profitRate: '5', isMarkup: false),
      result: WorksheetAmounts(
        subTotal: 979.50,
        listTotal: 1031.06,
        lineItemProfit: 51.56,
      ),
      worksheet: WorksheetModel(
          lineMarginMarkup: 1
      ),
    ),
    WorkSheetCalculationTestModel(
      description: "Case 4: When applied profit rate is in decimal",
      lineItems: set3Items(profitRate: '44.23', isMarkup: false),
      result: WorksheetAmounts(
        subTotal: 979.50,
        listTotal: 1756.32,
        lineItemProfit: 776.82,
      ),
      worksheet: WorksheetModel(
          lineMarginMarkup: 1
      ),
    ),
    WorkSheetCalculationTestModel(
      description: "Case 5: When applied profit rate is in decimal",
      lineItems: set3Items(profitRate: '3.91', isMarkup: false),
      result: WorksheetAmounts(
        subTotal: 979.50,
        listTotal: 1019.35,
        lineItemProfit: 39.85,
      ),
      worksheet: WorksheetModel(
          lineMarginMarkup: 1
      ),
    ),
    WorkSheetCalculationTestModel(
      description: "Case 6: When different line profit rate is applied to items",
      lineItems: set3Items(isMarkup: false),
      result: WorksheetAmounts(
        subTotal: 979.50,
        listTotal: 1033.57,
        lineItemProfit: 54.07,
      ),
      worksheet: WorksheetModel(
          lineMarginMarkup: 1
      ),
    ),
  ];


  List<WorkSheetCalculationTestModel> get realWorksheetResponses => [
    WorkSheetCalculationTestModel(
      description: "Case 1: Worksheet with no data",
      result: WorksheetAmounts(
        subTotal: 0.0,
        listTotal: 0.0,
      ),
      worksheet: WorksheetModel.fromWorksheetJson({}),
    ),
    WorkSheetCalculationTestModel(
      description: "Case 2: Worksheet with no additional amounts",
      result: WorksheetAmounts(
        subTotal: 785.0,
        listTotal: 785.0,
      ),
      worksheet: WorksheetModel.fromWorksheetJson(WorksheetMockedResponse.response1),
    ),
    WorkSheetCalculationTestModel(
      description: "Case 3.1: When all tax are applied",
      result: WorksheetAmounts(
        subTotal: 979.50,
        listTotal: 1137.36,
        taxAll: 81.30,
        materialTax: 73.56,
        laborTax: 3.00
      ),
      worksheet: WorksheetModel.fromWorksheetJson(WorksheetMockedResponse.response2),
    ),
    WorkSheetCalculationTestModel(
      description: "Case 3.2: When all tax are applied",
      result: WorksheetAmounts(
        subTotal: 120678.11,
        listTotal: 187019.79,
        taxAll: 6033.91,
        materialTax: 60304.38,
        laborTax: 3.39
      ),
      worksheet: WorksheetModel.fromWorksheetJson(WorksheetMockedResponse.response3),
    ),
    WorkSheetCalculationTestModel(
      description: "Case 3.3: When all tax are applied",
      result: WorksheetAmounts(
        subTotal: 102575.09,
        listTotal: 184642.97,
        taxAll: 76931.32,
        materialTax: 4997.18,
        laborTax: 139.38
      ),
      worksheet: WorksheetModel.fromWorksheetJson(WorksheetMockedResponse.response4),
    ),
    WorkSheetCalculationTestModel(
      description: "Case 4.1: When line tax is applied",
      result: WorksheetAmounts(
        listTotal: 107658.58,
        subTotal: 102572.15,
        lineItemTax: 5086.43
      ),
      worksheet: WorksheetModel.fromWorksheetJson(WorksheetMockedResponse.response5),
    ),
    WorkSheetCalculationTestModel(
      description: "Case 4.2: When line tax is applied",
      result: WorksheetAmounts(
        listTotal: 128215.19,
        subTotal: 102572.15,
        lineItemTax: 25643.04
      ),
      worksheet: WorksheetModel.fromWorksheetJson(WorksheetMockedResponse.response6),
    ),
    WorkSheetCalculationTestModel(
      description: "Case 5.1: When overall margin profit is applied",
      result: WorksheetAmounts(
        listTotal: 136028.38,
        subTotal: 119704.97,
        profitMargin: 16323.41
      ),
      worksheet: WorksheetModel.fromWorksheetJson(WorksheetMockedResponse.response8),
    ),
    WorkSheetCalculationTestModel(
      description: "Case 5.1: When overall margin profit is applied",
      result: WorksheetAmounts(
        listTotal: 136028.38,
        subTotal: 119704.97,
        profitMargin: 16323.41
      ),
      worksheet: WorksheetModel.fromWorksheetJson(WorksheetMockedResponse.response8),
    ),
    WorkSheetCalculationTestModel(
      description: "Case 5.2: When overall margin profit is applied",
      result: WorksheetAmounts(
        listTotal: 4888.05,
        subTotal: 4696.93,
        profitMargin: 191.12
      ),
      worksheet: WorksheetModel.fromWorksheetJson(WorksheetMockedResponse.response9),
    ),
    WorkSheetCalculationTestModel(
      description: "Case 5.3: When overall markup profit is applied",
      result: WorksheetAmounts(
        listTotal: 6824.64,
        subTotal: 4696.93,
        profitMarkup: 2127.71
      ),
      worksheet: WorksheetModel.fromWorksheetJson(WorksheetMockedResponse.response10),
    ),
    WorkSheetCalculationTestModel(
      description: "Case 5.4: When overall markup profit is applied",
      result: WorksheetAmounts(
        listTotal: 9794.86,
        subTotal: 8683.39,
        profitMarkup: 1111.47
      ),
      worksheet: WorksheetModel.fromWorksheetJson(WorksheetMockedResponse.response11),
    ),
    WorkSheetCalculationTestModel(
      description: "Case 6.1: When line item margin profit is applied",
      result: WorksheetAmounts(
        listTotal: 9867.48,
        subTotal: 8683.39,
        lineItemProfit: 1184.09
      ),
      worksheet: WorksheetModel.fromWorksheetJson(WorksheetMockedResponse.response12),
    ),
    WorkSheetCalculationTestModel(
      description: "Case 6.2: When line item margin profit is applied",
      result: WorksheetAmounts(
          listTotal: 8821.89,
          subTotal: 8683.39,
          lineItemProfit: 138.50
      ),
      worksheet: WorksheetModel.fromWorksheetJson(WorksheetMockedResponse.response13),
    ),
    WorkSheetCalculationTestModel(
      description: "Case 6.3: When line item markup profit is applied",
      result: WorksheetAmounts(
          listTotal: 9088.90,
          subTotal: 8683.39,
          lineItemProfit: 405.51
      ),
      worksheet: WorksheetModel.fromWorksheetJson(WorksheetMockedResponse.response14),
    ),
    WorkSheetCalculationTestModel(
      description: "Case 6.4: When line item markup profit is applied",
      result: WorksheetAmounts(
          listTotal: 13604.26,
          subTotal: 8683.39,
          lineItemProfit: 4920.87
      ),
      worksheet: WorksheetModel.fromWorksheetJson(WorksheetMockedResponse.response15),
    ),
    WorkSheetCalculationTestModel(
      description: "Case 7.1: When rates are applied randomly",
      result: WorksheetAmounts(
          listTotal: 24121.26,
          subTotal: 8683.39,
          lineItemProfit: 4920.87,
          overhead: 4341.7,
          commission: 2691.89,
          taxAll: 1712.94,
          materialTax: 278.41,
          laborTax: 1492.06,
      ),
      worksheet: WorksheetModel.fromWorksheetJson(WorksheetMockedResponse.response16),
    ),
    WorkSheetCalculationTestModel(
      description: "Case 7.2: When rates are applied randomly",
      result: WorksheetAmounts(
          listTotal: 22963.50,
          subTotal: 9271.39,
          lineItemProfit: 5254.09,
          overhead: 464.50,
          commission: 274.32,
          taxAll: 745.66,
          materialTax: 4715.46,
          laborTax: 2238.08,
      ),
      worksheet: WorksheetModel.fromWorksheetJson(WorksheetMockedResponse.response17),
    ),
    WorkSheetCalculationTestModel(
      description: "Case 7.3: When rates are applied randomly",
      result: WorksheetAmounts(
          listTotal: 15475.89,
          subTotal: 9271.39,
          lineItemProfit: 5254.09,
          overhead: 180.79,
          commission: 223.54,
          lineItemTax: 546.08
      ),
      worksheet: WorksheetModel.fromWorksheetJson(WorksheetMockedResponse.response18),
    ),
    WorkSheetCalculationTestModel(
      description: "Case 7.4: When rates are applied randomly",
      result: WorksheetAmounts(
          listTotal: 6827993.99,
          subTotal: 5212396.39,
          lineItemProfit: 402838.35,
          overhead: 307010.15,
          commission: 598738.96,
          lineItemTax: 307010.14
      ),
      worksheet: WorksheetModel.fromWorksheetJson(WorksheetMockedResponse.response19),
    ),
    WorkSheetCalculationTestModel(
      description: "Case 7.5: When rates are applied randomly",
      result: WorksheetAmounts(
          listTotal: 10849214.49,
          subTotal: 5212396.39,
          lineItemProfit: 823963.07,
          overhead: 266353.46,
          commission: 637204.28,
          materialTax: 3907059.21,
          laborTax: 2238.08
      ),
      worksheet: WorksheetModel.fromWorksheetJson(WorksheetMockedResponse.response20),
    ),
    WorkSheetCalculationTestModel(
      description: "Case 8: Worksheet with no charge amount",
      result: WorksheetAmounts(
          listTotal: 9459.38,
          subTotal: 6396.39,
          noChargeAmount: 1000,
          overhead: 32.62,
          commission: 952.39,
          profitMargin: 897.10,
          materialTax: 1031.67,
          laborTax: 149.21
      ),
      worksheet: WorksheetModel.fromWorksheetJson(WorksheetMockedResponse.response21),
    ),
    WorkSheetCalculationTestModel(
      description: "Case 9: Worksheet with fixed amount",
      result: WorksheetAmounts(
          listTotal: 234.00,
          subTotal: 6396.39,
          noChargeAmount: 1000,
          overhead: 32.62,
          commission: 835.77,
          materialTax: 1031.67,
          laborTax: 149.21,
          profitLossAmount: -8211.66,
          fixedPrice: 234,
      ),
      worksheet: WorksheetModel.fromWorksheetJson(WorksheetMockedResponse.response22),
    ),
    WorkSheetCalculationTestModel(
      description: "Case10: Worksheet with card fee applied",
      result: WorksheetAmounts(
          listTotal: 234.00,
          subTotal: 6396.39,
          noChargeAmount: 1000,
          overhead: 32.62,
          commission: 835.77,
          materialTax: 1031.67,
          laborTax: 149.21,
          profitLossAmount: -8211.66,
          fixedPrice: 234,
          creaditCardFee: 23.4
      ),
      worksheet: WorksheetModel.fromWorksheetJson(WorksheetMockedResponse.response23),
    ),
     WorkSheetCalculationTestModel(
      description: "Case10: Worksheet discount fee applied ",
      result: WorksheetAmounts(
          listTotal: 234.00,
          subTotal: 6396.39,
          noChargeAmount: 1000,
          overhead: 32.62,
          commission: 578.61,
          profitLossAmount: -7311.6,
          discount: 642.9,
          materialTax: 1031.67,
          laborTax: 149.21,
          fixedPrice: 234,

      ),
      worksheet: WorksheetModel.fromWorksheetJson(WorksheetMockedResponse.response24),
    ),
  ];

  List<WorkSheetCalculationTestModel> get processingFeeResponse => [
    WorkSheetCalculationTestModel(
      description: "Case 1: Worksheet with no data",
      result: WorksheetAmounts(
        subTotal: 0.0,
        listTotal: 0.0,
        processingFee: 0.0
      ),
      worksheet: WorksheetModel.fromWorksheetJson({}),
    ),
    WorkSheetCalculationTestModel(
      description: "Case 2: Worksheet with zero processing fee rate",
      result: WorksheetAmounts(
        subTotal: 785.0,
        listTotal: 785.0,
        processingFee: 0
      ),
      worksheet: WorksheetModel.fromWorksheetJson(WorksheetMockedResponse.response1)
        ..processingFee = "0",
    ),
    WorkSheetCalculationTestModel(
      description: "Case 3: Worksheet with valid processing fee rate",
      result: WorksheetAmounts(
          subTotal: 785.0,
          listTotal: 785.0,
          processingFee: 0
      ),
      worksheet: WorksheetModel.fromWorksheetJson(WorksheetMockedResponse.response1)
        ..processingFee = "10",
    ),
    WorkSheetCalculationTestModel(
      description: "Case 4: Worksheet with valid processing fee rate having 3 decimals",
      result: WorksheetAmounts(
          subTotal: 785.0,
          listTotal: 785.0,
      ),
      worksheet: WorksheetModel.fromWorksheetJson(WorksheetMockedResponse.response1)
        ..processingFee = "10.531",
    ),
  ];

  List<WorkSheetCalculationTestModel> get lineItemProfitResponse => [
    WorkSheetCalculationTestModel(
      description: "Case 1: Worksheet with no data",
      result: WorksheetAmounts(
        subTotal: 0.0,
        listTotal: 0.0,
        lineItemProfit: 0.0
      ),
      worksheet: WorksheetModel.fromWorksheetJson({}),
    ),
    WorkSheetCalculationTestModel(
      description: "Case 2: Worksheet with no line profit applied",
      result: WorksheetAmounts(
        subTotal: 785.0,
        listTotal: 785.0,
        lineItemProfit: 0
      ),
      worksheet: WorksheetModel.fromWorksheetJson(WorksheetMockedResponse.response1)
        ..lineMarginMarkup = 0,
    ),
    WorkSheetCalculationTestModel(
      description: "Case 3: Worksheet with zero total line profit",
      result: WorksheetAmounts(
          subTotal: 785.0,
          listTotal: 785.0,
          lineItemProfit: 0
      ),
      worksheet: WorksheetModel.fromWorksheetJson(WorksheetMockedResponse.response1)
        ..lineMarginMarkup = 1
        ..meta = WorksheetMeta(totalLineProfit: 0),
    ),
    WorkSheetCalculationTestModel(
      description: "Case 4: Worksheet with valid total line profit",
      result: WorksheetAmounts(
          subTotal: 785.0,
          listTotal: 795.0,
          lineItemProfit: 10
      ),
      worksheet: WorksheetModel.fromWorksheetJson(WorksheetMockedResponse.response1)
        ..lineMarginMarkup = 1
        ..meta = WorksheetMeta(totalLineProfit: 10)
    ),
  ];

  List<WorkSheetCalculationTestModel> get lineAndWorksheetProfit => [
    WorkSheetCalculationTestModel(
      description: "Case 1: Worksheet with no data",
      result: WorksheetAmounts(
        subTotal: 0.0,
        listTotal: 0.0,
        lineItemProfit: 0.0,
        profitMargin: 0.0,
        profitMarkup: 0.0
      ),
      worksheet: WorksheetModel.fromWorksheetJson({}),
    ),
    WorkSheetCalculationTestModel(
      description: "Case 2: Worksheet with no line profit applied and no worksheet profit",
      result: WorksheetAmounts(
        subTotal: 785.0,
        listTotal: 785.0,
        lineItemProfit: 0,
        profitMargin: 0.0,
        profitMarkup: 0.0
      ),
      worksheet: WorksheetModel.fromWorksheetJson(WorksheetMockedResponse.response1)
        ..lineMarginMarkup = 0
        ..profit = '0',
    ),
    WorkSheetCalculationTestModel(
      description: "Case 3: Worksheet with zero total line profit and worksheet profit",
      result: WorksheetAmounts(
          subTotal: 785.0,
          listTotal: 785.0,
          lineItemProfit: 0,
          profitMargin: 0.0,
          profitMarkup: 0.0
      ),
      worksheet: WorksheetModel.fromWorksheetJson(WorksheetMockedResponse.response1)
        ..lineMarginMarkup = 1
        ..profit = '0'
        ..meta = WorksheetMeta(totalLineProfit: 0),
    ),
    WorkSheetCalculationTestModel(
      description: "Case 4: Worksheet with valid total line profit and worksheet profit",
      result: WorksheetAmounts(
          subTotal: 785.0,
          listTotal: 874.5,
          lineItemProfit: 10,
          profitMargin: 0.0,
          profitMarkup: 79.5
      ),
      worksheet: WorksheetModel.fromWorksheetJson(WorksheetMockedResponse.response1)
        ..lineMarginMarkup = 1
        ..profit = '10'
        ..meta = WorksheetMeta(totalLineProfit: 10)
    ),
    WorkSheetCalculationTestModel(
        description: "Case 5: Worksheet with margin total line profit and worksheet profit",
        result: WorksheetAmounts(
            subTotal: 785.0,
            listTotal: 883.33,
            lineItemProfit: 10,
            profitMargin: 88.33,
            profitMarkup: 0
        ),
        worksheet: WorksheetModel.fromWorksheetJson(WorksheetMockedResponse.response1)
          ..lineMarginMarkup = 1
          ..profit = '10'
          ..margin = 1
          ..meta = WorksheetMeta(totalLineProfit: 10)
    ),
  ];

  /// Set 1 contains plain items only with price and quantity
  List<SheetLineItemModel> set1Items = [
    SheetLineItemModel(
      productId: "1",
      title: "",
      price: "205",
      qty: "2.9",
      totalPrice: "400",
      category: WorksheetDetailCategoryModel(
        slug: FinancialConstant.material,
      ),
    ),
    SheetLineItemModel(
      productId: "1",
      title: "",
      price: "12",
      qty: "5",
      totalPrice: "60",
      category: WorksheetDetailCategoryModel(
        slug: FinancialConstant.labor,
      ),
    ),
    SheetLineItemModel(
      productId: "1",
      title: "",
      price: "65",
      qty: "5",
      totalPrice: "325",
      category: WorksheetDetailCategoryModel(
        slug: FinancialConstant.material,
      ),
    ),
  ];

  /// Set 2 contains plain items with price, quantity and line item tax
  List<SheetLineItemModel> set2Items({String? taxRate}) => [
    SheetLineItemModel(
        productId: "1",
        title: "",
        price: "205",
        qty: "2.9",
        totalPrice: "624.23",
        lineTax: taxRate ?? '5',
        category: WorksheetDetailCategoryModel(
          slug: FinancialConstant.material,
        ),
        workSheetSettings: WorksheetSettingModel()
          ..addLineItemTax = true
          ..lineItemTaxPercent = null
    ),
    SheetLineItemModel(
        productId: "1",
        title: "",
        price: "12",
        qty: "5",
        totalPrice: "65.18",
        lineTax: taxRate ?? '8.63',
        category: WorksheetDetailCategoryModel(
          slug: FinancialConstant.labor,
        ),
        workSheetSettings: WorksheetSettingModel()
          ..addLineItemTax = true
          ..lineItemTaxPercent = null
    ),
    SheetLineItemModel(
        productId: "1",
        title: "",
        price: "65",
        qty: "5",
        totalPrice: "341.25",
        lineTax: taxRate ?? '5',
        category: WorksheetDetailCategoryModel(
          slug: FinancialConstant.material,
        ),
        workSheetSettings: WorksheetSettingModel()
          ..addLineItemTax = true
          ..lineItemTaxPercent = null
    ),
  ];

  /// Set 2 contains plain items with price, quantity and line item profit
  List<SheetLineItemModel> set3Items({String? profitRate, bool isMarkup = true}) => [
    SheetLineItemModel(
        productId: "1",
        title: "",
        price: "205",
        qty: "2.9",
        totalPrice: "624.23",
        lineProfit: profitRate ?? '5',
        category: WorksheetDetailCategoryModel(
          slug: FinancialConstant.material,
        ),
        workSheetSettings: WorksheetSettingModel()
          ..applyLineItemProfit = true
          ..lineItemProfitPercent = null
          ..isLineItemProfitMarkup = isMarkup

    ),
    SheetLineItemModel(
        productId: "1",
        title: "",
        price: "12",
        qty: "5",
        totalPrice: "65.18",
        lineProfit: profitRate ?? '8.63',
        category: WorksheetDetailCategoryModel(
          slug: FinancialConstant.labor,
        ),
        workSheetSettings: WorksheetSettingModel()
          ..applyLineItemProfit = true
          ..lineItemProfitPercent = null
          ..isLineItemProfitMarkup = isMarkup
    ),
    SheetLineItemModel(
        productId: "1",
        title: "",
        price: "65",
        qty: "5",
        totalPrice: "341.25",
        lineProfit: profitRate ?? '5',
        category: WorksheetDetailCategoryModel(
          slug: FinancialConstant.material,
        ),
        workSheetSettings: WorksheetSettingModel()
          ..applyLineItemProfit = true
          ..lineItemProfitPercent = null
          ..isLineItemProfitMarkup = isMarkup
    ),
  ];
}

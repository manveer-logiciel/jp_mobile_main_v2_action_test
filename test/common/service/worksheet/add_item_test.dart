import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/worksheet.dart';
import 'package:jobprogress/common/models/company_trades/company_trades_model.dart';
import 'package:jobprogress/common/models/financial_product/financial_product_model.dart';
import 'package:jobprogress/common/models/financial_product/variants_model.dart';
import 'package:jobprogress/common/models/forms/worksheet/add_item.dart';
import 'package:jobprogress/common/models/forms/worksheet/add_item_params.dart';
import 'package:jobprogress/common/models/sheet_line_item/measurement_formula_model.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/common/models/suppliers/beacon/account.dart';
import 'package:jobprogress/common/models/suppliers/suppliers.dart';
import 'package:jobprogress/common/models/worksheet/settings/index.dart';
import 'package:jobprogress/common/models/worksheet/worksheet_detail_category_model.dart';
import 'package:jobprogress/common/services/files_listing/forms/worksheet_form/add_item.dart';
import 'package:jobprogress/common/services/files_listing/forms/worksheet_form/add_item_conditions.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/financial_constants.dart';
import 'package:jobprogress/core/constants/worksheet.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/modules/worksheet/widgets/add_item_sheet/controller.dart';
import 'package:jobprogress/modules/worksheet/widgets/add_item_sheet/widgets/fields/note/index.dart';
import 'package:jobprogress/modules/worksheet/widgets/add_item_sheet/widgets/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/SingleSelect/model.dart';

import '../../../../integration_test/core/test_helper.dart';

void main() {

  JPSingleSelectModel selectionOptions = JPSingleSelectModel(
      id: '1',
      label: 'Test category 1'
  );

  JPSingleSelectModel supplierOptions = JPSingleSelectModel(
      id: '2',
      label: 'Test category 1',
      additionalData: SuppliersModel()
  );

  List<JPSingleSelectModel> allCategories = [
    JPSingleSelectModel(
        id: '1',
        label: 'Test category 1',
    ),
    JPSingleSelectModel(
        id: '2',
        label: 'Test category 1',
        additionalData: WorksheetDetailCategoryModel(
            id: 2,
            systemCategory: WorksheetDetailCategoryModel(
                id: 1
            ),
            slug: FinancialConstant.material
        )
    ),
  ];

  List<JPSingleSelectModel> tradesWithWorkType = [
    JPSingleSelectModel(
      id: '1',
      label: 'Test category 1',
      additionalData: [
        JPMultiSelectModel(
          id: '1',
          label: 'Test category 1',
          isSelect: false,
        ),
        JPMultiSelectModel(
          id: '2',
          label: 'Test category 2',
          isSelect: false,
        )
      ]
    ),
  ];

  FinancialProductModel emptyProduct = FinancialProductModel();

  FinancialProductModel productWithAllDetails = FinancialProductModel(
    productCategory: WorksheetDetailCategoryModel(id: 1),
    categoryId: 1,
    name: 'Test',
    unit: 'Test',
    sellingPrice: '100',
    unitCost: '50',
    supplier: SuppliersModel(
      id: 1,
      name: 'Test',
    ),
    description: 'Test',
    measurementFormulas: [
      MeasurementFormulaModel(id: 1, tradeId: 1, productId: 1, formula: 'a * b')
    ]
  );

  FinancialProductModel productWithSelectionOptions = FinancialProductModel(
    units: ['1', '2', '3'],
    colors: ['1', '2', '3'],
    sizes: ['1', '2', '3'],
    styles: ['1', '2', '3'],
  );

  SheetLineItemModel lineItem = SheetLineItemModel(
    productId: "1",
    title: "Test Item",
    price: "200",
    unitCost: '50',
    qty: "5",
    totalPrice: "1000",
    supplierId: '1',
    tradeId: 1,
    style: 'Test',
    color: 'Test',
    unit: 'Test',
    size: '1',
    lineProfit: '5',
    lineProfitAmt: '50',
    lineTax: '5',
    lineTaxAmt: '5',
    description: 'Test',
    lineTotalAmount: '500',
    productCategorySlug: FinancialConstant.material,
    product: productWithAllDetails,
    category: WorksheetDetailCategoryModel(
      id: 1,
      systemCategory: WorksheetDetailCategoryModel(
        id: 1
      ),
    )
  );

  List<VariantModel> variants = [
    VariantModel(
      id: 1,
      name: "Variant 1",
      uom: ['LF', 'AC'],
      code: "ABC",
      branchCode: '300',
      branchId: 0
    ),
    VariantModel(
      id: 2,
      name: "Variant 2",
      uom: ['KB', 'MB'],
      code: "DEF",
      branchCode: '300',
      branchId: 0
    ),
    VariantModel(
        id: 2,
        name: "Variant 2",
        code: "DEF",
        branchCode: '300',
        branchId: 0
    )
  ];

  WorksheetAddItemParams params = WorksheetAddItemParams(
      allCategories: allCategories,
      allSuppliers: [selectionOptions],
      allTrade: [selectionOptions],
      settings: WorksheetSettingModel(),
      shipToSequenceId: "",
      worksheetType: WorksheetConstants.estimate,
      isSRSEnabled: false,
      srsBranchCode: ""
  );

  WorksheetAddItemService service = WorksheetAddItemService(
    params: params,
    update: () {}, // used to update ui from service
    validateForm: () {}, // used to validate form from service
  );

  service.conditionsService = WorksheetAddItemConditionsService.forItem(WorksheetAddItemData(params));

  WorksheetAddItemController controller = WorksheetAddItemController(params, (p0) {});

  controller.service = service;

  Widget buildTestableWidget() {
    return TestHelper.buildWidget(
        Material(
          child: SingleChildScrollView(
            child:  WorksheetTypeToFields(controller: controller)
          )
        )
    );
  }

  group("In case of Add item", () {
    group("WorksheetAddItemService should be properly initialized", () {
      test("WorksheetAddItemService data holders should be properly initialized", () {
        expect(service.totalPrice, "0.00");
        expect(service.selectedCategoryId, isEmpty);
        expect(service.selectedSystemCategoryId, isEmpty);
        expect(service.selectedSupplierId, isEmpty);
        expect(service.selectedTradeId, isEmpty);
        expect(service.selectedWorkTypeId, isEmpty);
        expect(service.selectedCategorySlug, isEmpty);
      });

      test("WorksheetAddItemService input controllers should be properly initialized", () {
        expect(service.typeController.text, isEmpty);
        expect(service.nameController.text, isEmpty);
        expect(service.supplierController.text, isEmpty);
        expect(service.tradeTypeController.text, isEmpty);
        expect(service.workTypeController.text, isEmpty);
        expect(service.typeStyleController.text, isEmpty);
        expect(service.colorController.text, isEmpty);
        expect(service.sizeController.text, isEmpty);
        expect(service.unitController.text, isEmpty);
        expect(service.priceController.text, isEmpty);
        expect(service.quantityController.text, isEmpty);
        expect(service.profitPercentController.text, isEmpty);
        expect(service.profitAmountController.text, isEmpty);
        expect(service.descriptionController.text, isEmpty);
        expect(service.noteController.text, isEmpty);
        expect(service.taxPercentController.text, isEmpty);
        expect(service.taxAmountController.text, isEmpty);
      });

      test("WorksheetAddItemService helper lists should be properly initialized", () {
        expect(service.workTypes, isEmpty);
        expect(service.allCategories, isEmpty);
        expect(service.allSuppliers, isEmpty);
      });

      test("WorksheetAddItemService other helpers should be properly initialized", () {
        expect(service.product, isNotNull);
        expect(service.selectedSupplier, isNull);
      });
    });

    group('WorksheetAddItemService@setFormData() should set-up initial json from form-data', () {
      test("Categories and suppliers should be set", () {
        service.setFormData();
        expect(service.allCategories, isNotEmpty);
        expect(service.allSuppliers, isNotEmpty);
      });

      group("Trade Type should be pre-populated conditionally", () {
        setUp(() {
          service.selectedTradeId = "";
          service.tradeTypeController.text = "";
        });

        test("Trade Type should be pre-populated, when default trade type is available", () {
          service.params.tradeTypeDefault = CompanyTradesModel(id: 1, name: "Trade 1");
          service.setFormData();
          expect(service.selectedTradeId, '1');
          expect(service.tradeTypeController.text, "Trade 1");
        });

        test("Trade Type should not be pre-populated, when default trade type is not available", () {
          service.params.tradeTypeDefault = null;
          service.setFormData();
          expect(service.selectedTradeId, isEmpty);
          expect(service.tradeTypeController.text, isEmpty);
        });
      });
    });

    group("WorksheetAddItemService@getProductSearchParams should set product search details", () {
      group("When product does not exist", () {
        test("Search input should be empty", () {
          final search = service.getProductSearchParams("");
          expect(search.title, isEmpty);
        });

        test("Category details should be properly set", () {
          service.selectedSystemCategoryId = '5';
          service.selectedCategoryId = '1';
          service.selectedCategorySlug = WorksheetConstants.materialList;
          final search = service.getProductSearchParams("");
          expect(search.categoryId, service.selectedCategoryId);
          expect(search.systemCategoryId, service.selectedSystemCategoryId);
          expect(search.selectedCategorySlug, WorksheetConstants.materialList);
        });

        test('SRS branch details should be properly set', () {
          service.params.srsBranchCode = '12';
          service.params.shipToSequenceId = '1';
          final search = service.getProductSearchParams("");
          expect(search.srsBranchCode, service.params.srsBranchCode);
          expect(search.shipToSequenceId, service.params.shipToSequenceId);
        });

        group("Pricing should be displayed conditionally", () {
          group("Selling price should be displayed on products", () {
            test("When selling price is enabled from worksheet settings", () {
              service.params.settings.enableSellingPrice = true;
              final search = service.getProductSearchParams("");
              expect(search.isSellingPriceEnabled, isTrue);
            });
          });

          group("Unit price should be displayed on products", () {
            test("When selling price is disabled from worksheet settings", () {
              service.params.settings.enableSellingPrice = false;
              final search = service.getProductSearchParams("");
              expect(search.isSellingPriceEnabled, isFalse);
            });
          });
        });
      });

      group("When product exists", () {
        test("Search input should not be empty", () {
          final search = service.getProductSearchParams("abc");
          expect(search.title, isNotEmpty);
        });
      });
    });

    test("WorksheetAddItemService@setType should set selected category", () {
      service.setType("5");
      expect(service.selectedCategoryId, '5');
    });

    group("WorksheetAddItemService@setSupplier should set selected supplier", () {
      test("When supplier not available in selection options", () {
        service.setSupplier("5");
        expect(service.selectedSupplierId, '5');
        expect(service.product.supplier, isNull);
      });

      test("When supplier is available in selection options", () {
        service.params.allSuppliers.add(supplierOptions);
        service.setSupplier("2");
        expect(service.selectedSupplierId, '2');
        expect(service.product.supplier, isNotNull);
      });
    });

    group("WorksheetAddItemService@setProductCategory should set category details", () {
      group("When worksheet is other than material", () {
        test("When product does not have category", () {
          service.selectedCategoryId = '1';
          service.setProductCategory();
          expect(service.selectedSystemCategoryId, isEmpty);
          expect(service.product.productCategory, isNull);
          expect(service.selectedCategorySlug, isEmpty);
        });

        test("When product does have category", () {
          service.selectedCategoryId = '2';
          service.setProductCategory();
          final selectedCategory = allCategories[1].additionalData as WorksheetDetailCategoryModel;
          // Performance optimization: system category ID only sent when suppliers are enabled
          expect(service.selectedSystemCategoryId, "");
          expect(service.product.productCategory, selectedCategory);
          expect(service.selectedCategorySlug, selectedCategory.slug);
        });
      });

      group("When worksheet is material", () {
        test("Selected category should be material by default", () {
          service.params.worksheetType = WorksheetConstants.materialList;
          service.setProductCategory();
          final selectedCategory = allCategories[1].additionalData;
          // Performance optimization: system category ID only sent when suppliers are enabled
          expect(service.selectedSystemCategoryId, "");
          expect(service.product.productCategory, selectedCategory);
          expect(service.selectedCategorySlug, selectedCategory.slug);
        });
      });

      group("Performance optimization for system category ID", () {
        test("System category ID should be returned when material category with suppliers enabled", () {
          // Enable SRS supplier for this test
          service.params.isSRSEnabled = true;
          service.selectedCategoryId = '2'; // Material category
          service.setProductCategory();
          final selectedCategory = allCategories[1].additionalData as WorksheetDetailCategoryModel;
          expect(service.selectedSystemCategoryId, selectedCategory.systemCategory?.id.toString());
          expect(service.product.productCategory, selectedCategory);
          expect(service.selectedCategorySlug, selectedCategory.slug);
          // Reset for other tests
          service.params.isSRSEnabled = false;
        });

        test("System category ID should be empty when no suppliers enabled", () {
          service.selectedCategoryId = '2'; // Material category
          service.setProductCategory();
          final selectedCategory = allCategories[1].additionalData as WorksheetDetailCategoryModel;
          expect(service.selectedSystemCategoryId, "");
          expect(service.product.productCategory, selectedCategory);
          expect(service.selectedCategorySlug, selectedCategory.slug);
        });
      });
    });

    group("WorksheetAddItemService@getMaterialPropList should give correct selection list as per type", () {
      group("In case of unit", () {
        group("In case variant is selected, but does not have uom (Unit Of Measurement)", () {
          setUp(() {
            service.selectedVariant = variants[2];
          });

          test("When units are empty", () {
            service.product = emptyProduct;
            final list = service.getMaterialPropList(WorksheetMaterialPropType.unit);
            expect(list, isEmpty);
          });

          test("When units are not empty", () {
            service.product = productWithSelectionOptions;
            final list = service.getMaterialPropList(WorksheetMaterialPropType.unit);
            expect(list, isNotEmpty);
          });
        });

        group("In case variant is selected, does have uom (Unit Of Measurement)", () {
          setUp(() {
            service.selectedVariant = variants[1];
          });

          test("When units are empty", () {
            service.product = emptyProduct;
            final list = service.getMaterialPropList(WorksheetMaterialPropType.unit);
            expect(list, isNotEmpty);
          });

          test("When units are not empty", () {
            service.product = productWithSelectionOptions;
            final list = service.getMaterialPropList(WorksheetMaterialPropType.unit);
            expect(list, isNotEmpty);
          });
        });

        group("In case variant is not selected", () {
          test("When units are empty", () {
            service.selectedVariant = null;
            service.product = emptyProduct;
            final list = service.getMaterialPropList(WorksheetMaterialPropType.unit);
            expect(list, isEmpty);
          });

          test("When units are not empty", () {
            service.product = productWithSelectionOptions;
            final list = service.getMaterialPropList(WorksheetMaterialPropType.unit);
            expect(list, isNotEmpty);
          });
        });
      });

      group("In case of color", () {
        test("When colors are empty", () {
          service.product = emptyProduct;
          final list = service.getMaterialPropList(WorksheetMaterialPropType.color);
          expect(list, isEmpty);
        });

        test("When colors are not empty", () {
          service.product = productWithSelectionOptions;
          final list = service.getMaterialPropList(WorksheetMaterialPropType.color);
          expect(list, isNotEmpty);
        });
      });

      group("In case of size", () {
        test("When sizes are empty", () {
          service.product = emptyProduct;
          final list = service.getMaterialPropList(WorksheetMaterialPropType.size);
          expect(list, isEmpty);
        });

        test("When sizes are not empty", () {
          service.product = productWithSelectionOptions;
          final list = service.getMaterialPropList(WorksheetMaterialPropType.size);
          expect(list, isNotEmpty);
        });
      });

      group("In case of style", () {
        test("When styles are empty", () {
          service.product = emptyProduct;
          final list = service.getMaterialPropList(WorksheetMaterialPropType.style);
          expect(list, isEmpty);
        });

        test("When styles are not empty", () {
          service.product = productWithSelectionOptions;
          final list = service.getMaterialPropList(WorksheetMaterialPropType.style);
          expect(list, isNotEmpty);
        });
      });

      group("In case of variants", () {
        test("When variants are not empty", () {
          service.product = productWithSelectionOptions..variants = variants;
          final list = service.getMaterialPropList(WorksheetMaterialPropType.variant);
          expect(list, isNotEmpty);
        });

        test("When variants are empty", () {
          service.product = emptyProduct;
          final list = service.getMaterialPropList(WorksheetMaterialPropType.variant);
          expect(list, isEmpty);
        });
      });
    });

    group("WorksheetAddItemService@geMaterialPropController should give right input controller to update data", () {
      test("When unit is updated via selection", () {
        final controller = service.geMaterialPropController(WorksheetMaterialPropType.unit);
        expect(service.unitController, controller);
      });

      test("When color is updated via selection", () {
        final controller = service.geMaterialPropController(WorksheetMaterialPropType.color);
        expect(service.colorController, controller);
      });

      test("When size is updated via selection", () {
        final controller = service.geMaterialPropController(WorksheetMaterialPropType.size);
        expect(service.sizeController, controller);
      });

      test("When style is updated via selection", () {
        final controller = service.geMaterialPropController(WorksheetMaterialPropType.style);
        expect(service.typeStyleController, controller);
      });
    });

    group("WorksheetAddItemService@updateItemData should fill in product data in form", () {
      group("When selected product has all the data available", () {
        test("Product details should be filled in properly", () {
          service.updateItemData(productWithAllDetails);
          expect(service.product, productWithAllDetails);
          expect(service.nameController.text, productWithAllDetails.name);
          expect(service.unitController.text, productWithAllDetails.unit);
          expect(service.priceController.text, productWithAllDetails.unitCost);
          expect(service.descriptionController.text, productWithAllDetails.description);
        });

        group("Product price should be filled in correctly", () {
          test("Selling price should be filled in price input", () {
            service.params.settings.enableSellingPrice = true;
            service.updateItemData(productWithAllDetails);
            expect(service.priceController.text, productWithAllDetails.sellingPrice);
          });

          test("Unit price should be filled in price input", () {
            service.params.settings.enableSellingPrice = false;
            service.updateItemData(productWithAllDetails);
            expect(service.priceController.text, productWithAllDetails.unitCost);
          });
        });

        test("Supplier details should be filled in correctly", () {
          service.updateItemData(productWithAllDetails);
          expect(service.selectedSupplier, productWithAllDetails.supplier);
          expect(service.supplierController.text, productWithAllDetails.supplier?.name);
          expect(service.selectedSupplierId, productWithAllDetails.supplier?.id.toString());
        });

        test('Variant details should be filled in correctly', () {
          service.updateItemData(productWithAllDetails..variants = variants);
          expect(service.selectedVariant, productWithAllDetails.variants?.first);
          expect(service.variantController.text, productWithAllDetails.variants?.first.name);
          service.updateItemData(productWithAllDetails..variants = null);
        });
      });

      group("When selected product has missing data", () {
        test("Product category should be picked from last selected product if missing", () {
          service.updateItemData(productWithAllDetails);
          service.updateItemData(emptyProduct);
          expect(service.product.productCategory, productWithAllDetails.productCategory);
          expect(service.product.categoryId, productWithAllDetails.categoryId);
        });

        test("Name input should be empty if product has name missing", () {
          service.updateItemData(emptyProduct);
          expect(service.nameController.text, isEmpty);
        });

        test("Quantity input should be empty if product has quantity missing", () {
          service.updateItemData(emptyProduct);
          expect(service.quantityController.text, isEmpty);
        });

        test("Unit input data should remain as it is, if product has name missing", () {
          service.updateItemData(productWithAllDetails);
          service.updateItemData(emptyProduct);
          expect(service.unitController.text, productWithAllDetails.unit);
        });

        test("Description input data should have item code, if product has description missing", () {
          service.updateItemData(productWithAllDetails);
          service.updateItemData(emptyProduct);
          expect(service.descriptionController.text, lineItem.description);
        });

        test("Supplier details should be removed, if product has missing supplier", () {
          service.updateItemData(emptyProduct);
          expect(service.selectedSupplier, isNull);
          expect(service.supplierController.text, isEmpty);
          expect(service.selectedSupplierId, isEmpty);
        });

        test('Variant details should be removed, if product has missing variant', () {
          service.updateItemData(productWithAllDetails..variants = variants);
          service.updateItemData(emptyProduct);
          expect(service.selectedVariant, isNull);
          expect(service.variantController.text, isEmpty);
        });
      });
    });

    group("WorksheetAddItemService@priceQtyChange should update the total price on price quantity change", () {

      group('Total amount should be updated', () {
        setUp(() {
          service.priceController.text = '12';
          service.quantityController.text = '10';
        });

        test("When no changes in price and quantity are made", () {
          service.priceQtyChange("");
          expect(service.totalPrice, JobFinancialHelper.getRoundOff(120, fractionDigits: 2));
        });
      });

      group("Total amount should be updated", () {
        setUp(() {
          service.priceController.text = '12';
          service.quantityController.text = '10';
        });

        test("When changes in price are made", () {
          service.priceController.text = '15';
          service.priceQtyChange("");
          expect(service.totalPrice, JobFinancialHelper.getRoundOff(150, fractionDigits: 2));
        });

        test("When changes in quantity are made", () {
          service.quantityController.text = '5';
          service.priceQtyChange("");
          expect(service.totalPrice, JobFinancialHelper.getRoundOff(60, fractionDigits: 2));
        });
      });
    });

    group("WorksheetAddItemService@onPercentChange should update amount on change in percentage", () {
      group("When changes made in profit percent", () {
        setUp(() {
          service.totalPrice = '50';
        });

        group("Profit amount should be updated", () {
          test("When changes made in profit percentage", () {
            final previousValue = service.profitAmountController.text;
            service.onPercentChange('5');
            expect(service.profitAmountController.text, isNot(previousValue));
          });
        });

        group("Profit amount should not be updated", () {
          test("When no changes made in profit percentage", () {
            final previousValue = service.profitAmountController.text;
            service.onPercentChange('5');
            expect(service.profitAmountController.text, equals(previousValue));
          });
        });

        group("Profit amount should support zero conditionally", () {
          test("Zero should not be filled in when its avoided", () {
            service.onPercentChange('0', avoidZero: true);
            expect(service.profitAmountController.text, isEmpty);
          });

          test("Zero should be filled in when its not avoided", () {
            service.onPercentChange('0', avoidZero: false);
            expect(service.profitAmountController.text, equals('0'));
          });
        });
      });

      group("When changes made in tax percent", () {
        setUp(() {
          service.totalPrice = '50';
        });

        group("Tax amount should be updated", () {
          test("When changes made in tax percentage", () {
            final previousValue = service.taxAmountController.text;
            service.onPercentChange('5', forTax: true);
            expect(service.taxAmountController.text, isNot(previousValue));
          });
        });

        group("Tax amount should not be updated", () {
          test("When no changes made in tax percentage", () {
            final previousValue = service.taxAmountController.text;
            service.onPercentChange('5', forTax: true);
            expect(service.taxAmountController.text, equals(previousValue));
          });
        });
      });

    });

    group("WorksheetAddItemService@onAmountChange should update percentage on change in amount", () {
      group("When changes made in profit amount", () {
        setUp(() {
          service.totalPrice = '50';
        });

        group("Profit percentage should be updated", () {
          test("When changes made in profit amount", () {
            final previousValue = service.profitPercentController.text;
            service.onAmountChange('5');
            expect(service.profitPercentController.text, isNot(previousValue));
          });
        });

        group("Profit percentage should not be updated", () {
          test("When no changes made in profit amount", () {
            final previousValue = service.profitPercentController.text;
            service.onPercentChange('5');
            expect(service.profitPercentController.text, equals(previousValue));
          });
        });

        group("Profit percentage should support zero conditionally", () {
          test("Zero should not be filled in when its avoided", () {
            service.onAmountChange('0', avoidZero: true);
            expect(service.profitPercentController.text, isEmpty);
          });

          test("Zero should be filled in when its not avoided", () {
            service.onAmountChange('0', avoidZero: false);
            expect(service.profitPercentController.text, equals('0'));
          });
        });
      });

      group("When changes made in tax amount", () {
        setUp(() {
          service.totalPrice = '50';
        });

        group("Tax percentage should be updated", () {
          test("When changes made in tax amount", () {
            final previousValue = service.taxPercentController.text;
            service.onAmountChange('5', forTax: true);
            expect(service.taxPercentController.text, isNot(previousValue));
          });
        });

        group("Tax percentage should not be updated", () {
          test("When no changes made in tax amount", () {
            final previousValue = service.taxPercentController.text;
            service.onAmountChange('5', forTax: true);
            expect(service.taxPercentController.text, equals(previousValue));
          });
        });
      });
    });

    group("WorksheetAddItemService@clearForm should clean all the form values", () {
      group("When worksheet is other than material", () {
        setUp(() {
          service.params.worksheetType = WorksheetConstants.estimate;
          service.conditionsService = WorksheetAddItemConditionsService.forItem(service);
        });

        test("Form data helpers should be reinitialized", () {
          service.reInitialiseValues();
          expect(service.totalPrice, '0.00');
          expect(service.selectedCategoryId, isEmpty);
          expect(service.selectedCategorySlug, isEmpty);
          expect(service.selectedSystemCategoryId, isEmpty);
          expect(service.selectedTradeId, isEmpty);
          expect(service.selectedSupplierId, isEmpty);
          expect(service.selectedWorkTypeId, isEmpty);
          expect(service.product.id, isNull);
          expect(service.workTypes, isEmpty);
        });

        test('Form controllers should be cleared', () {
          service.reInitialiseValues();
          expect(service.typeController.text, isEmpty);
          expect(service.nameController.text, isEmpty);
          expect(service.supplierController.text, isEmpty);
          expect(service.tradeTypeController.text, isEmpty);
          expect(service.workTypeController.text, isEmpty);
          expect(service.typeStyleController.text, isEmpty);
          expect(service.colorController.text, isEmpty);
          expect(service.sizeController.text, isEmpty);
          expect(service.unitController.text, isEmpty);
          expect(service.priceController.text, isEmpty);
          expect(service.quantityController.text, isEmpty);
          expect(service.profitPercentController.text, isEmpty);
          expect(service.profitAmountController.text, isEmpty);
          expect(service.descriptionController.text, isEmpty);
          expect(service.noteController.text, isEmpty);
          expect(service.taxPercentController.text, isEmpty);
          expect(service.taxAmountController.text, isEmpty);
        });
      });

      group("When worksheet is material", () {
        setUp(() {
          service.params.worksheetType = WorksheetConstants.materialList;
          service.selectedCategoryId = '1';
          service.typeController.text = '1';
          service.selectedCategorySlug = '1';
          service.selectedSystemCategoryId = '1';
          service.conditionsService = WorksheetAddItemConditionsService.forItem(service);
        });

        test("Category details should not be reinitialized", () {
          service.reInitialiseValues();
          expect(service.selectedCategoryId, isNotEmpty);
          expect(service.typeController.text, isNotEmpty);
          expect(service.selectedCategorySlug, isNotEmpty);
          expect(service.selectedSystemCategoryId, isNotEmpty);
        });

        test("Limited form data helpers should be reinitialized", () {
          service.reInitialiseValues();
          expect(service.totalPrice, '0.00');
          expect(service.selectedTradeId, isEmpty);
          expect(service.selectedSupplierId, isEmpty);
          expect(service.selectedWorkTypeId, isEmpty);
          expect(service.product.id, isNull);
          expect(service.workTypes, isEmpty);
        });

        test('Limited form controllers should be cleared', () {
          service.reInitialiseValues();
          expect(service.nameController.text, isEmpty);
          expect(service.supplierController.text, isEmpty);
          expect(service.tradeTypeController.text, isEmpty);
          expect(service.workTypeController.text, isEmpty);
          expect(service.typeStyleController.text, isEmpty);
          expect(service.colorController.text, isEmpty);
          expect(service.sizeController.text, isEmpty);
          expect(service.unitController.text, isEmpty);
          expect(service.priceController.text, isEmpty);
          expect(service.quantityController.text, isEmpty);
          expect(service.profitPercentController.text, isEmpty);
          expect(service.profitAmountController.text, isEmpty);
          expect(service.descriptionController.text, isEmpty);
          expect(service.noteController.text, isEmpty);
          expect(service.taxPercentController.text, isEmpty);
          expect(service.taxAmountController.text, isEmpty);
        });
      });
    });

    group("WorksheetAddItemService@formatCalcValue should format display amounts", () {
      test("When price is zero", () {
        final result = service.formatCalcValue("0");
        expect(result, '');
      });

      test("When price is greater than zero", () {
        final result = service.formatCalcValue("5");
        expect(result, '5');
      });

      group("When price is in decimals", () {
        test("When decimals are more than 2", () {
          final result = service.formatCalcValue("5.2345");
          expect(result, '5.23');
        });

        test("When decimals digits are zeros", () {
          final result = service.formatCalcValue("5.00");
          expect(result, '5');
        });

        test("When decimals digits are not zeros", () {
          final result = service.formatCalcValue("5.45");
          expect(result, '5.45');
        });
      });
    });

    group("WorksheetAddItemService@toLineItem should generate sheet line item from form details", () {
      group("Category details should be properly converted", () {
        setUp(() {
          service.params.allCategories.clear();
          service.params.allCategories.addAll(allCategories);
        });

        test("When category and product is not selected, category should be empty", () {
          service.selectedCategoryId = "";
          service.product = FinancialProductModel();
          SheetLineItemModel item = service.toLineItem();
          expect(item.category, isNull);
        });

        test("When product has category, it should be used", () {
          service.product = productWithAllDetails;
          SheetLineItemModel item = service.toLineItem();
          expect(item.category, productWithAllDetails.productCategory);
        });

        test("When category is selected manually, it should be used", () {
          service.selectedCategoryId = '2';
          SheetLineItemModel item = service.toLineItem();
          expect(item.category, isNotNull);
        });
      });

      group('Supplier details should be properly converted', () {
        test("When supplier is not selected", () {
          service.product = FinancialProductModel();
          SheetLineItemModel item = service.toLineItem();
          expect(item.supplier, isNull);
        });

        test("When supplier is exist in project, it should be selected", () {
          service.selectedSupplier = productWithAllDetails.supplier;
          SheetLineItemModel item = service.toLineItem();
          expect(item.supplier, productWithAllDetails.supplier);
        });

        test("When supplier is exist in project, it should be selected", () {
          service.allSuppliers.add(supplierOptions);
          service.selectedSupplierId = '2';
          SheetLineItemModel item = service.toLineItem();
          expect(item.supplier, supplierOptions.additionalData);
        });
      });

      group('Trade type should be properly converted', () {
        test("When trade type is selected", () {
          service.params.allTrade.clear();
          service.params.allTrade.add(selectionOptions);
          service.selectedTradeId = '1';
          SheetLineItemModel item = service.toLineItem();
          expect(item.tradeType, selectionOptions);
          expect(item.tradeId, 1);
          expect(item.trade, isNull);
        });

        test("When trade type is not selected", () {
          service.params.allTrade.clear();
          service.selectedTradeId = '';
          SheetLineItemModel item = service.toLineItem();
          expect(item.tradeId, isNull);
          expect(item.trade, isNull);
        });
      });

      group('Work type should be properly converted', () {
        test("When work type is selected", () {
          service.workTypes.clear();
          service.workTypes.add(selectionOptions);
          service.selectedWorkTypeId = '1';
          SheetLineItemModel item = service.toLineItem();
          expect(item.workType, selectionOptions);
          expect(item.workTypeId, 1);
          expect(item.workTypeModel, isNull);
        });

        test("When work type is not selected", () {
          service.workTypes.clear();
          service.selectedWorkTypeId = '';
          SheetLineItemModel item = service.toLineItem();
          expect(item.workTypeId, isNull);
          expect(item.workTypeModel, isNull);
        });
      });

      test('Filled inputs should be properly converted', () {
        SheetLineItemModel item = service.toLineItem();
        expect(item.productName, service.nameController.text);
        expect(item.style, service.typeStyleController.text);
        expect(item.color, service.colorController.text);
        expect(item.size, service.sizeController.text);
        expect(item.unit, service.unitController.text);
        expect(item.description, service.descriptionController.text);
        expect(item.note, service.noteController.text);
        expect(item.title, service.nameController.text);
        expect(item.qty, service.quantityController.text);
      });

      group('Price should be properly converted', () {
        group("When selling price is enabled", () {
          test("Unit cost should be equal to products unit cost", () {
            SheetLineItemModel item = service.toLineItem();
            expect(item.unitCost, service.product.unitCost ?? '');
          });

          test("Selling should be equal to filled in price", () {
            SheetLineItemModel item = service.toLineItem();
            expect(item.price, service.priceController.text);
          });
        });

        group("When selling price is disabled", () {
          setUp(() {
            service.params.settings.enableSellingPrice = false;
          });

          test("Unit cost should be equal to filled in price", () {
            SheetLineItemModel item = service.toLineItem();
            expect(item.unitCost, service.priceController.text);
          });

          test("Selling should be equal to products selling price", () {
            SheetLineItemModel item = service.toLineItem();
            expect(item.price, service.product.sellingPrice ?? "");
          });
        });
      });

      group('Additional line amounts should be properly converted', () {
        test("Line profit rate and amount should be properly converted", () {
          SheetLineItemModel item = service.toLineItem();
          expect(item.lineProfit, service.profitPercent);
          expect(item.lineProfitAmt, service.profitAmount);
        });

        test("Line tax rate and amount should be properly converted", () {
          SheetLineItemModel item = service.toLineItem();
          expect(item.lineTax, service. taxPercent);
          expect(item.lineTaxAmt, service.taxAmount);
        });
      });

      test("Total amount should be properly set", () {
        SheetLineItemModel item = service.toLineItem();
        expect(item.lineTotalAmount, service.totalPrice);
      });

      group("Measurement formulas should set properly", () {
        group("Measurement formulas should not set", () {
          test("When product does not have measurement formulas", () {
            service.product = emptyProduct;
            SheetLineItemModel item = service.toLineItem();
            expect(item.measurementFormulas, isNull);
            expect(item.formula, isNull);
          });

          test("When trade does not matches with formula", () {
            service.product = productWithAllDetails;
            service.selectedTradeId = '5';
            SheetLineItemModel item = service.toLineItem();
            expect(item.measurementFormulas, isNotEmpty);
            expect(item.formula, isNull);
          });
        });

        group("Measurement formulas should set", () {
          test("When product has measurement formula with matching trade id", () {
            service.product = productWithAllDetails;
            service.selectedTradeId = '1';
            SheetLineItemModel item = service.toLineItem();
            expect(item.measurementFormulas, isNotEmpty);
            expect(item.formula, productWithAllDetails.measurementFormulas?.first.formula);
          });
        });

        test("Product details should be set", () {
          service.product = productWithAllDetails;
          SheetLineItemModel item = service.toLineItem();
          expect(item.product, isNotNull);
        });

        group("Branch code should be set", () {
          test("In case branch code does not exist", () {
            service.product = productWithAllDetails..branchCode = null;
            SheetLineItemModel item = service.toLineItem();
            expect(item.branchCode, isNull);
          });

          test("In case branch code exists", () {
            service.product = productWithAllDetails..branchCode = '300';
            SheetLineItemModel item = service.toLineItem();
            expect(item.branchCode, '300');
          });
        });

        group("Variant should be set", () {
          test('In case product has no variants', () {
            service.product.variants = null;
            SheetLineItemModel item = service.toLineItem();
            expect(item.variantModel, isNull);
          });

          group('In case product has variants', () {
            setUp(() {
              service.product.variants = variants;
            });

            test('When no variant is selected, it should not be set', () {
              service.selectedVariant = null;
              SheetLineItemModel item = service.toLineItem();
              expect(item.variantModel, isNull);
            });

            test('When variant is selected, it should be set', () {
              service.selectedVariant = variants[0];
              SheetLineItemModel item = service.toLineItem();
              expect(item.variantModel, variants[0]);
            });
          });
        });
      });
    });

    group("WorksheetAddItemService@setWorkTypesList should set work types for selected trade type", () {
      group("When work types exist from selected trade type", () {

        test("Work type list should properly set up ", () {
          service.params.allTrade.clear();
          service.params.allTrade.addAll(tradesWithWorkType);
          service.setWorkTypesList('1', workTypeId: '1');
          expect(service.workTypes, isNotEmpty);
        });

        test('Work type input field should be filled', () {
          expect(service.workTypeController.text, isNotEmpty);
        });

        test("Work type should be selected by default", () {
          expect(service.selectedWorkTypeId, isNotEmpty);
        });
      });

      group("When work types do not exist for selected trade type", () {
        test("Work type input field data should be removed", () {
          service.setWorkTypesList('2', workTypeId: '1');
          expect(service.workTypeController.text, isEmpty);
        });

        test("Work type list should be cleared", () {
          expect(service.workTypes, isEmpty);
        });
      });
    });

    group("WorksheetAddItemService@setVariant should set variant data on product or variant selection", () {
      group("In case of product selection", () {
        setUp(() {
          service.product = productWithAllDetails..variants = variants;
          service.setVariant(variant: variants[0]);
        });

        test('Variant details should be set correctly', () {
          expect(service.selectedVariant, variants[0]);
          expect(service.variantController.text, variants[0].name);
        });

        test('Unit should be set as the first uom if available', () {
          expect(service.unitController.text, variants[0].uom?[0] ?? "");
        });
      });

      group("In case of variant selection", () {
        setUp(() {
          service.product = productWithAllDetails..variants = variants;
          service.setVariant(val: variants[0].name);
        });

        test('Variant details should be set correctly', () {
          expect(service.selectedVariant, variants[0]);
          expect(service.variantController.text, variants[0].name);
        });

        test('Unit should be set as the first uom if available', () {
          expect(service.unitController.text, variants[0].uom?[0] ?? "");
        });
      });

      group("In case of no selection", () {
        setUp(() {
          service.product = productWithAllDetails..variants = variants;
          service.setVariant();
        });

        test('Variant details should be removed', () {
          expect(service.selectedVariant, isNull);
          expect(service.variantController.text, "");
        });

        test('Unit should be set as last known unit', () {
          expect(service.unitController.text, isNotEmpty);
        });
      });
    });
  });

  group('In case of edit item', () {
    setUp(() {
      service.params.lineItem = lineItem;
    });

    group("WorksheetAddItemService should be properly initialized", () {
      test("WorksheetAddItemService data holders should be properly initialized", () {
        service.setFormData();
        expect(service.totalPrice, lineItem.lineTotalAmount ?? lineItem.totalPrice);
        expect(service.selectedCategoryId, lineItem.category?.id.toString() ?? "");
        // Performance optimization: system category ID only sent when suppliers are enabled
        expect(service.selectedSystemCategoryId, "");
        expect(service.selectedSupplierId, lineItem.supplierId ?? "");
        expect(service.selectedTradeId, lineItem.tradeId?.toString() ?? "");
        expect(service.selectedCategorySlug, lineItem.productCategorySlug ?? "");
      });

      test("WorksheetAddItemService input controllers should be properly initialized", () {
        service.setFormData();
        expect(service.nameController.text, lineItem.title);
        expect(service.typeStyleController.text, lineItem.style);
        expect(service.colorController.text, lineItem.color);
        expect(service.sizeController.text, lineItem.size);
        expect(service.unitController.text, lineItem.unit);
        expect(service.quantityController.text, service.formatCalcValue(lineItem.qty));
        expect(service.profitPercentController.text, service.formatCalcValue(lineItem.lineProfit));
        expect(service.profitAmountController.text, service.formatCalcValue(lineItem.lineProfitAmt));
        expect(service.descriptionController.text, lineItem.description);
        expect(service.noteController.text, lineItem.note ?? '');
        expect(service.taxPercentController.text, service.formatCalcValue(lineItem.lineTax));
        expect(service.taxAmountController.text, service.formatCalcValue(lineItem.lineTaxAmt));
      });

      group("Supplier should be properly initialized", () {
        test("When supplier does not exist", () {
          service.params.lineItem?.supplier = null;
          service.selectedSupplier = null;
          service.params.allSuppliers.clear();
          service.allSuppliers.clear();
          service.setFormData();
          expect(service.selectedSupplier, isNull);
          expect(service.product.supplier, isNull);
          expect(service.allSuppliers, isEmpty);
        });

        test("When supplier exists in selection options", () {
          service.params.lineItem?.supplierId = '2';
          service.params.lineItem?.supplier = null;
          service.params.allSuppliers.add(supplierOptions);
          service.setFormData();
          expect(service.selectedSupplier, isNull);
          expect(service.product.supplier, isNotNull);
          expect(service.allSuppliers, isNotEmpty);
        });

        group("When supplier exists but not in selection options", () {
          setUp(() {
            service.params.lineItem?.supplierId = '1';
            service.params.lineItem?.supplier = productWithAllDetails.supplier;
            service.params.allSuppliers.clear();
          });

          test("Product supplier should not be empty", () {
            service.setFormData();
            expect(service.selectedSupplier, isNotNull);
            expect(service.product.supplier, isNotNull);
          });

          test("Supplier options list should not be empty", () {
            service.setFormData();
            expect(service.allSuppliers, isNotEmpty);
          });
        });
      });

      group("Category should be properly initialized", () {
        group("When selected category exists in selection options", () {
          setUp(() {
            service.params.allCategories.clear();
            service.params.allCategories.add(selectionOptions);
            service.params.lineItem?.categoryId = 1;
            service.setFormData();
          });

          test("Category list should be initialized", () {
            expect(service.allCategories, isNotEmpty);
          });

          test("Category input should be filled", () {
            expect(service.typeController.text, isNotEmpty);
          });
        });

        group("When selected category does not exists in selection options but item has category details", () {
          setUp(() {
            service.params.allCategories.clear();
            service.params.lineItem?.categoryId = 1;
            service.setFormData();
          });

          test("Category list should be initialized", () {
            expect(service.allCategories, isNotEmpty);
          });

          test("Category input should be filled", () {
            expect(service.typeController.text, isNotEmpty);
          });
        });
      });

      group('Price should be properly initialized', () {
        group("When selling price is enabled", () {
          test("Filled in price should be selling price", () {
            params.settings.enableSellingPrice = true;
            service.setFormData();
            expect(service.priceController.text, lineItem.price);
          });
        });

        group("When selling price is disabled", () {
          test("Filled in price should be unit cost", () {
            params.settings.enableSellingPrice = false;
            service.setFormData();
            expect(service.priceController.text, lineItem.unitCost);
          });
        });
      });

      test('Product details should be properly initialized', () {
        service.setFormData();
        expect(service.product, isNotNull);
      });

      group("Variant details should be set properly", () {
        group("In case line item has not variant", () {
          setUp(() {
            service.selectedVariant = null;
            service.params.lineItem?.variantModel = null;
            service.setFormData();
          });

          test("Variant details should not be initialized", () {
            expect(service.selectedVariant, isNull);
            expect(service.variantController.text, isEmpty);
          });

          test('Unit should be set from the lime item unit', () {
            expect(service.unitController.text, lineItem.unit);
          });
        });

        group("In case line item has variant", () {
          setUp(() {
            service.params.lineItem?.variantModel = variants[0];
            service.setFormData();
          });

          test("Variant details should be initialized", () {
            expect(service.selectedVariant, isNotNull);
            expect(service.variantController.text, variants[0].name);
          });
        });
      });
    });

    group("Trade Type should not be pre-populated from default trade type", () {
      setUp(() {
        service.selectedTradeId = "";
        service.tradeTypeController.text = "";
      });

      test("Trade Type should be populated from Line Item, when default trade type is available", () {
        service.params.tradeTypeDefault = CompanyTradesModel(id: 5, name: "Trade 1");
        service.setFormData();
        expect(service.selectedTradeId, '1');
        expect(service.tradeTypeController.text, "Test category 1");
      });

      test("Trade Type should be populated from Line Item, when default trade type is not available", () {
        service.params.tradeTypeDefault = null;
        service.setFormData();
        expect(service.selectedTradeId, '1');
        expect(service.tradeTypeController.text, "Test category 1");
      });
    });
  });

  group('In case of add Beacon product while adding or editing item', () {
    setUpAll(() {
      controller.service.conditionsService.itemData.product = FinancialProductModel(
        supplier: SuppliersModel()
      );
      controller.service.conditionsService.settings.hidePricing = controller.service.conditionsService.settings.applyLineItemProfit = controller.service.conditionsService.settings.addLineItemTax = false;
      controller.service.totalPrice = '0';
      Get.locale = const Locale('en');
    });
    testWidgets('Add Note option should be visible', (widgetTester) async {
      service.conditionsService.itemData.product.supplier?.id = Helper.getSupplierId(key: CommonConstants.beaconId);
      await widgetTester.pumpWidget(buildTestableWidget());
      expect(find.byType(WorksheetAddItemAddNoteField), findsOneWidget);
    });

    testWidgets('Add Note option should not be visible', (widgetTester) async {
      service.conditionsService.itemData.product.supplier?.id = null;
      await widgetTester.pumpWidget(buildTestableWidget());
      expect(find.byType(WorksheetAddItemAddNoteField), findsNothing);
    });
  });

  group('WorksheetAddItemService@getPriceListParams should returns params', () {
    test('When SRS is enabled', () {
      params.isBeaconEnabled = false;
      params.isSRSEnabled = true;
      params.srsBranchCode = 'branch123';
      params.shipToSequenceId = 'seq456';
      service.product.code = 'prod123';
      service.product.name = 'Product Name';
      service.selectedVariant = VariantModel(code: 'var123', unit: 'unit123');
      params.srsSupplierId = 181; // SRS v2 id

      final result = service.getPriceListParams();

      expect(result, {
        'stop_price_compare': '1',
        'product_detail[0][product_code]': 'prod123',
        'product_detail[0][product_name]': 'Product Name',
        'product_detail[0][variant_code]': 'var123',
        'product_detail[0][unit]': 'unit123',
        'branch_code': 'branch123',
        'supplier_id': 181,
        'ship_to_sequence_number': 'seq456'
      });
    });

    test('When Beacon is enabled', () {
      params.isSRSEnabled = false;
      params.isBeaconEnabled = true;
      params.beaconBranchCode = 'branch456';
      params.beaconAccount = BeaconAccountModel(accountId: 789);
      params.beaconJobNumber = 'job123';
      service.selectedVariant = VariantModel(code: 'var456', unit: 'unit456');

      final result = service.getPriceListParams();

      expect(result, {
        'stop_price_compare': '1',
        'item_detail[0][item_code]': 'var456',
        'item_detail[0][unit]': 'unit456',
        'branch_code': 'branch456',
        'account_id': 789,
        'supplier_id': Helper.getSupplierId(key: CommonConstants.beaconId),
        'job_number': 'job123',
        'ignoreToast': true
      });
    });

    test('When Beacon and SRS are disabled', () {
      params.isBeaconEnabled = false;
      params.isSRSEnabled = false;
      final result = service.getPriceListParams();

      expect(result, {
        'stop_price_compare': '1'
      });
    });
  });
}
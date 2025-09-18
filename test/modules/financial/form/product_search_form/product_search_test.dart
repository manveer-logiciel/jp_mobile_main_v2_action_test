
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/sheet_line_item_type.dart';
import 'package:jobprogress/common/enums/supplier_form_type.dart';
import 'package:jobprogress/common/models/financial_product/financial_product_model.dart';
import 'package:jobprogress/common/models/financial_product/variants_model.dart';
import 'package:jobprogress/common/models/financial_product_search/financial_product_search.dart';
import 'package:jobprogress/common/models/suppliers/beacon/account.dart';
import 'package:jobprogress/modules/financial_product_search/controller.dart';

void main() {

  FinancialProductController controller = FinancialProductController();

  final financialProducts = [
    FinancialProductModel(name: 'Product 1'),
    FinancialProductModel(name: 'Product 2'),
    FinancialProductModel(name: 'Product 3'),
  ];

  test('FinancialProductController should be initialized with correct values', () {
    expect(controller.isLoading, false);
    expect(controller.isLoadMore, false);
    expect(controller.canShowLoadMore, false);
    expect(controller.enableAddButton, true);
    expect(controller.filterKeys, isA<FinancialProductSearchModel>());
  });

  group('FinancialProductController@setAddButtonVisibility should set isAddButtonVisible correctly ', () {
    test('When isRestrictCustomProduct is false and enableAddButton is true', () {
      controller.isRestrictCustomProduct = false;
      controller.enableAddButton = true;

      controller.setAddButtonVisibility();

      expect(controller.isAddButtonVisible, true);
    });

    test('When isRestrictCustomProduct is false and enableAddButton is false', () {
      controller.isRestrictCustomProduct = false;
      controller.enableAddButton = false;

      controller.setAddButtonVisibility();

      expect(controller.isAddButtonVisible, true);
    });

    test('When isRestrictCustomProduct is true and enableAddButton is true', () {
      controller.isRestrictCustomProduct = true;
      controller.enableAddButton = true;

      controller.setAddButtonVisibility();

      expect(controller.isAddButtonVisible, true);
    });

    test('When isRestrictCustomProduct is true and enableAddButton is false', () {
      controller.isRestrictCustomProduct = true;
      controller.enableAddButton = false;

      controller.setAddButtonVisibility();

      expect(controller.isAddButtonVisible, false);
    });
  });

  group('FinancialProductController@getFinancialProduct should return a FinancialProductModel with correct value', () {
    controller.financialProducts = financialProducts;
    
    test('When index is null', () {
      controller.searchTextController.text = 'example name';
      final FinancialProductModel financialProduct = controller.getFinancialProduct(null);
      final String financialProductName = financialProduct.name!;
      expect(financialProductName, 'example name');
    });

    test('When index is not null', () {
      final FinancialProductModel financialProduct = controller.getFinancialProduct(1);
      expect(financialProduct, financialProducts[1]);
    });
  });

  group('FinancialProductController@getHintText should return the correct hint text', () {
    test('In case of insuranceForm', () {
      controller.pageType = AddLineItemFormType.insuranceForm;
      final String hintText = controller.getHintText();
      expect(hintText, 'search_material_product_here'.tr.capitalize!);
    });

    test('In case of worksheet', () {
      controller.pageType = AddLineItemFormType.worksheet;
      controller.filterKeys.title = 'example title';
      final String hintText = controller.getHintText();
      expect(hintText, '${'search'.tr} ${controller.filterKeys.title!.toLowerCase()} ${'here'.tr}');
    });

    test('In default case', () {
      controller.pageType = null;
      final String hintText = controller.getHintText();
      expect(hintText, 'search_financial_product_here'.tr);
    });
  });

  group("FinancialProductController@getSupplierType should return the correct supplier type", () {
    test("In case of SRS branch code is available, supplier type should be srs", () {
      controller.filterKeys.srsBranchCode = '1';
      expect(controller.getSupplierType(), MaterialSupplierType.srs);
      controller.filterKeys.srsBranchCode = null;
    });

    test("In case of beacon branch code is available, supplier type should be beacon", () {
      controller.filterKeys.beaconBranchCode = '1';
      expect(controller.getSupplierType(), MaterialSupplierType.beacon);
      controller.filterKeys.beaconBranchCode = null;
    });
  });

  group("FinancialProductController@getPriceListParams should give the correct price list payload", () {
    test("In case of SRS supplier type", () {
      controller.filterKeys.srsBranchCode = '1';
      controller.filterKeys.shipToSequenceId = '1';
      final Map<String, dynamic> params = controller.getPriceListParams([
        FinancialProductModel(name: 'Product 1', code: 'abc', unit: 'kg'),
        FinancialProductModel(name: 'Product 2', code: 'def', unit: 'kg'),
      ]);
      expect(params['ship_to_sequence_number'], '1');
      expect(params['branch_code'], '1');
      expect(params['item_detail'], [{'item_code': 'abc', 'unit': 'kg'}, {'item_code': 'def', 'unit': 'kg'}]);
      controller.filterKeys.srsBranchCode = null;
    });

    test("In case of SRS v2 supplier type", () {
      controller.filterKeys.srsBranchCode = '1';
      controller.filterKeys.shipToSequenceId = '1';
      controller.filterKeys.srsSupplierId = 181; // SRS v2 id
      final Map<String, dynamic> params = controller.getPriceListParams([
        FinancialProductModel(name: 'Product 1', code: 'abc', unit: 'kg'),
        FinancialProductModel(name: 'Product 2', code: 'def', unit: 'kg'),
      ]);
      expect(params['ship_to_sequence_number'], '1');
      expect(params['branch_code'], '1');
      expect(params['product_detail'], [{'item_code': 'abc', 'unit': 'kg'}, {'item_code': 'def', 'unit': 'kg'}]);
      controller.filterKeys.srsBranchCode = null;
      controller.filterKeys.srsSupplierId = null;
    });

    test("In case of beacon supplier type", () {
      controller.filterKeys.beaconBranchCode = '1';
      controller.filterKeys.beaconJobNumber = '1';
      controller.filterKeys.beaconAccount = BeaconAccountModel(accountId: 1);
      final Map<String, dynamic> params = controller.getPriceListParams([
        FinancialProductModel(variants: [VariantModel(code: "123")]),
        FinancialProductModel(variants: [VariantModel(code: "345")]),
      ]);
      expect(params['branch_code'], '1');
      expect(params['account_id'], 1);
      expect(params['job_number'], '1');
      expect(params['item_detail'][0]['item_code'], "123");
      expect(params['item_detail'][1]['item_code'], "345");
      controller.filterKeys.beaconBranchCode = null;
    });

    test("Products missing code should be ignored", () {
      controller.filterKeys.beaconBranchCode = '1';
      controller.filterKeys.beaconJobNumber = '1';
      controller.filterKeys.beaconAccount = BeaconAccountModel(accountId: 1);
      final Map<String, dynamic> params = controller.getPriceListParams([
        FinancialProductModel(variants: [VariantModel(code: "123")]),
        FinancialProductModel(variants: [VariantModel(code: "345")]),
      ]);
      expect(params['branch_code'], '1');
      expect(params['account_id'], 1);
      expect(params['job_number'], '1');
      expect(params['item_detail'][0]['item_code'], "123");
      expect(params['item_detail'][1]['item_code'], "345");
      controller.filterKeys.beaconBranchCode = null;
    });
  });

}
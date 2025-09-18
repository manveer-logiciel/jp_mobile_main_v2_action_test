
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/financial_product_search/financial_product_search.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';

void main() {
  group("FinancialProductSearchModel@toJson() should give correct payload for product search", () {
    test("In case no material supplier is selected", () {
      final model = FinancialProductSearchModel(
        limit: 10,
        page: 1,
        src: 'all',
        name: 'Test Product',
        description: 'Test Description',
        categoryName: 'Test Category',
        categoryId: '1234',
        systemCategoryId: '5678',
        includeSrsProducts: true,
        title: 'Test Title',
        selectedCategorySlug: 'test-category',
        isSellingPriceEnabled: true,
        shipToSequenceId: '123',
        beaconBranchCode: 'BEA-123',
        beaconJobNumber: 'JOB-123',
      );
      
      model.srsBranchCode = null;
      model.beaconBranchCode = null;
      
      final payload = model.toJson();
      expect(payload['limit'], 10);
      expect(payload['page'], 1);
      expect(payload['src'], 'all');
      expect(payload['name'], 'Test Product');
      expect(payload['description'], 'Test Description');
      expect(payload['category_name'], 'Test Category');
      expect(payload['categories_ids[0]'], '1234');
      // systemCategoryId should be included since it has a value
      expect(payload['categories_ids[1]'], '5678');
      expect(payload['include_beacon_products'], isNull);
      expect(payload['supplier_id'], isNull);
      expect(payload['with_beacon'], isNull);
      expect(payload['include_srs_products'], isNull);
      expect(payload['with_srs'], isNull);
      expect(payload['only_qbd_products'], isNull);
    });

    test("In case material SRS supplier is selected", () {
      final model = FinancialProductSearchModel(
        limit: 10,
        page: 1,
        src: 'all',
        name: 'Test Product',
        description: 'Test Description',
        categoryName: 'Test Category',
        categoryId: '1234',
        systemCategoryId: '5678',
        includeSrsProducts: true,
        srsBranchCode: '300',
        title: 'Test Title',
        selectedCategorySlug: 'test-category',
        isSellingPriceEnabled: true,
        shipToSequenceId: '123',
        beaconJobNumber: 'JOB-123',
      );
      
      model.beaconBranchCode = null;
      
      final payload = model.toJson();
      expect(payload['limit'], 10);
      expect(payload['page'], 1);
      expect(payload['src'], 'all');
      expect(payload['name'], 'Test Product');
      expect(payload['description'], 'Test Description');
      expect(payload['category_name'], 'Test Category');
      expect(payload['categories_ids[0]'], '1234');
      // systemCategoryId should be included since it has a value
      expect(payload['categories_ids[1]'], '5678');
      expect(payload['include_beacon_products'], isNull);
      // When SRS branch is set, supplier_id should be set from Helper.getSupplierId()
      expect(payload['supplier_id'], Helper.getSupplierId(key: CommonConstants.srsId));
      expect(payload['with_beacon'], isNull);
      expect(payload['include_srs_products'], 1);
      expect(payload['with_srs'], '300');
      expect(payload['only_qbd_products'], isNull);
    });

    test("In case material Beacon supplier is selected", () {
      final model = FinancialProductSearchModel(
        limit: 10,
        page: 1,
        src: 'all',
        name: 'Test Product',
        description: 'Test Description',
        categoryName: 'Test Category',
        categoryId: '1234',
        systemCategoryId: '5678',
        includeSrsProducts: true,
        title: 'Test Title',
        selectedCategorySlug: 'test-category',
        isSellingPriceEnabled: true,
        shipToSequenceId: '123',
        beaconBranchCode: '300',
        beaconJobNumber: 'JOB-123',
      );
      
      model.srsBranchCode = null;
      
      final payload = model.toJson();
      expect(payload['limit'], 10);
      expect(payload['page'], 1);
      expect(payload['src'], 'all');
      expect(payload['name'], 'Test Product');
      expect(payload['description'], 'Test Description');
      expect(payload['category_name'], 'Test Category');
      expect(payload['categories_ids[0]'], '1234');
      // systemCategoryId should be included since it has a value
      expect(payload['categories_ids[1]'], '5678');
      expect(payload['include_beacon_products'], 1);
      expect(payload['supplier_id'], Helper.getSupplierId(key: CommonConstants.beaconId));
      expect(payload['with_beacon'], '300');
      expect(payload['include_srs_products'], isNull);
      expect(payload['with_srs'], isNull);
      expect(payload['only_qbd_products'], isNull);
    });

    // New test cases for conditional systemCategoryId behavior
    test("systemCategoryId should NOT be included when it's null", () {
      final model = FinancialProductSearchModel(
        limit: 10,
        page: 1,
        src: 'all',
        name: 'Test Product',
        categoryId: '1234',
        systemCategoryId: null, // Explicitly null
      );

      final payload = model.toJson();
      expect(payload['categories_ids[0]'], '1234');
      // Should not include systemCategoryId when null
      expect(payload.containsKey('categories_ids[1]'), false);
    });

    test("systemCategoryId should NOT be included when it's empty", () {
      final model = FinancialProductSearchModel(
        limit: 10,
        page: 1,
        src: 'all',
        name: 'Test Product',
        categoryId: '1234',
        systemCategoryId: '', // Explicitly empty
      );

      final payload = model.toJson();
      expect(payload['categories_ids[0]'], '1234');
      // Should not include systemCategoryId when empty
      expect(payload.containsKey('categories_ids[1]'), false);
    });

    test("systemCategoryId should be included when it has a valid value", () {
      final model = FinancialProductSearchModel(
        limit: 10,
        page: 1,
        src: 'all',
        name: 'Test Product',
        categoryId: '1234',
        systemCategoryId: '5678', // Valid value
      );

      final payload = model.toJson();
      expect(payload['categories_ids[0]'], '1234');
      // Should include systemCategoryId when it has a value
      expect(payload['categories_ids[1]'], '5678');
    });

    test("All products should be searched, when order is not placed", () {
      final model = FinancialProductSearchModel(
        limit: 10,
        page: 1,
        src: 'all',
        name: 'Test Product',
        forSupplierId: null,
      );
      
      final payload = model.toJson();
      expect(payload['src'], 'all');
    });

    test("Only supplier products should be searched, when order is placed", () {
      final model = FinancialProductSearchModel(
        limit: 10,
        page: 1,
        src: 'all',
        name: 'Test Product',
        forSupplierId: 123,
      );
      
      final payload = model.toJson();
      expect(payload['src'], 'supplier');
    });
  });
}
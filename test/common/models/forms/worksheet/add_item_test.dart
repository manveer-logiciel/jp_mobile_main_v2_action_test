import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/forms/worksheet/add_item.dart';
import 'package:jobprogress/common/models/forms/worksheet/add_item_params.dart';
import 'package:jobprogress/common/models/worksheet/worksheet_detail_category_model.dart';
import 'package:jobprogress/common/models/worksheet/settings/index.dart';
import 'package:jobprogress/core/constants/worksheet.dart';

void main() {
  group("WorksheetAddItemData@getSelectedSystemCategoryId should implement performance optimization", () {
    late WorksheetAddItemData addItemData;

    setUp(() {
      final params = WorksheetAddItemParams(
        allCategories: [],
        allSuppliers: [],
        allTrade: [],
        worksheetType: 'worksheet',
        isSRSEnabled: true,
        isBeaconEnabled: false,
        isAbcEnabled: false,
        shipToSequenceId: '123',
        settings: WorksheetSettingModel(),
      );
      addItemData = WorksheetAddItemData(params);
    });

    test("Should return system category ID when material category with suppliers enabled", () {
      // Create a material category with system category
      final materialCategory = WorksheetDetailCategoryModel(
        slug: WorksheetConstants.categoryMaterials,
        systemCategory: WorksheetDetailCategoryModel(id: 12345),
      );

      // Should return system category ID for material with suppliers
      final result = addItemData.getSelectedSystemCategoryId(materialCategory);
      expect(result, '12345');
    });

    test("Should return empty string when material category but no suppliers enabled", () {
      // Create params with no suppliers enabled
      final paramsNoSuppliers = WorksheetAddItemParams(
        allCategories: [],
        allSuppliers: [],
        allTrade: [],
        worksheetType: 'worksheet',
        isSRSEnabled: false,
        isBeaconEnabled: false,
        isAbcEnabled: false,
        shipToSequenceId: '123',
        settings: WorksheetSettingModel(),
      );
      final addItemDataNoSuppliers = WorksheetAddItemData(paramsNoSuppliers);

      final materialCategory = WorksheetDetailCategoryModel(
        slug: WorksheetConstants.categoryMaterials,
        systemCategory: WorksheetDetailCategoryModel(id: 12345),
      );

      // Should return empty string when no suppliers enabled
      final result = addItemDataNoSuppliers.getSelectedSystemCategoryId(materialCategory);
      expect(result, '');
    });

    test("Should return empty string when non-material category with suppliers enabled", () {
      // Create a non-material category
      final laborCategory = WorksheetDetailCategoryModel(
        slug: 'labor', // Not materials
        systemCategory: WorksheetDetailCategoryModel(id: 12345),
      );

      // Should return empty string for non-material categories
      final result = addItemData.getSelectedSystemCategoryId(laborCategory);
      expect(result, '');
    });

    test("Should return empty string when category is null", () {
      // Should handle null category gracefully
      final result = addItemData.getSelectedSystemCategoryId(null);
      expect(result, '');
    });

    test("Should return empty string when material category but no system category", () {
      final materialCategoryNoSystem = WorksheetDetailCategoryModel(
        slug: WorksheetConstants.categoryMaterials,
        systemCategory: null, // No system category
      );

      // Should return empty string when no system category
      final result = addItemData.getSelectedSystemCategoryId(materialCategoryNoSystem);
      expect(result, '');
    });

    test("Should return empty string when material category has system category with null ID", () {
      final materialCategoryNullId = WorksheetDetailCategoryModel(
        slug: WorksheetConstants.categoryMaterials,
        systemCategory: WorksheetDetailCategoryModel(id: null), // Null ID
      );

      // Should return empty string when system category ID is null
      final result = addItemData.getSelectedSystemCategoryId(materialCategoryNullId);
      expect(result, '');
    });

    test("Should handle case-insensitive material category matching", () {
      // Create category with uppercase slug
      final materialCategoryUpper = WorksheetDetailCategoryModel(
        slug: 'MATERIALS', // Uppercase
        systemCategory: WorksheetDetailCategoryModel(id: 12345),
      );

      // Should handle case-insensitive matching
      final result = addItemData.getSelectedSystemCategoryId(materialCategoryUpper);
      expect(result, '12345');
    });

    test("Should work correctly with different supplier combinations", () {
      // Test with Beacon enabled
      final paramsBeacon = WorksheetAddItemParams(
        allCategories: [],
        allSuppliers: [],
        allTrade: [],
        worksheetType: 'worksheet',
        isSRSEnabled: false,
        isBeaconEnabled: true,
        isAbcEnabled: false,
        shipToSequenceId: '123',
        settings: WorksheetSettingModel(),
      );
      final addItemDataBeacon = WorksheetAddItemData(paramsBeacon);

      final materialCategory = WorksheetDetailCategoryModel(
        slug: WorksheetConstants.categoryMaterials,
        systemCategory: WorksheetDetailCategoryModel(id: 12345),
      );

      // Should work with Beacon supplier enabled
      final result = addItemDataBeacon.getSelectedSystemCategoryId(materialCategory);
      expect(result, '12345');
    });

    test("Should work correctly with multiple suppliers enabled", () {
      // Test with multiple suppliers enabled
      final paramsMultiple = WorksheetAddItemParams(
        allCategories: [],
        allSuppliers: [],
        allTrade: [],
        worksheetType: 'worksheet',
        isSRSEnabled: true,
        isBeaconEnabled: true,
        isAbcEnabled: true,
        shipToSequenceId: '123',
        settings: WorksheetSettingModel(),
      );
      final addItemDataMultiple = WorksheetAddItemData(paramsMultiple);

      final materialCategory = WorksheetDetailCategoryModel(
        slug: WorksheetConstants.categoryMaterials,
        systemCategory: WorksheetDetailCategoryModel(id: 12345),
      );

      // Should work with multiple suppliers enabled
      final result = addItemDataMultiple.getSelectedSystemCategoryId(materialCategory);
      expect(result, '12345');
    });
  });
} 
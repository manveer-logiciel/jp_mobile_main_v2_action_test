import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/forms/worksheet/add_item_params.dart';
import 'package:jobprogress/common/models/worksheet/settings/index.dart';

void main() {
  group("WorksheetAddItemParams@isAnySupplierEnabled should correctly detect supplier integration status", () {
    test("Should return true when SRS is enabled", () {
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
      
      // Should detect SRS supplier integration
      expect(params.isAnySupplierEnabled(), true);
    });

    test("Should return true when Beacon is enabled", () {
      final params = WorksheetAddItemParams(
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
      
      // Should detect Beacon supplier integration
      expect(params.isAnySupplierEnabled(), true);
    });

    test("Should return true when ABC is enabled", () {
      final params = WorksheetAddItemParams(
        allCategories: [],
        allSuppliers: [],
        allTrade: [],
        worksheetType: 'worksheet',
        isSRSEnabled: false,
        isBeaconEnabled: false,
        isAbcEnabled: true,
        shipToSequenceId: '123',
        settings: WorksheetSettingModel(),
      );
      
      // Should detect ABC supplier integration
      expect(params.isAnySupplierEnabled(), true);
    });

    test("Should return true when multiple suppliers are enabled", () {
      final params = WorksheetAddItemParams(
        allCategories: [],
        allSuppliers: [],
        allTrade: [],
        worksheetType: 'worksheet',
        isSRSEnabled: true,
        isBeaconEnabled: true,
        isAbcEnabled: false,
        shipToSequenceId: '123',
        settings: WorksheetSettingModel(),
      );
      
      // Should detect multiple supplier integrations
      expect(params.isAnySupplierEnabled(), true);
    });

    test("Should return false when no suppliers are enabled", () {
      final params = WorksheetAddItemParams(
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
      
      // Should detect no supplier integrations
      expect(params.isAnySupplierEnabled(), false);
    });

    test("Should return false when suppliers are null", () {
      final params = WorksheetAddItemParams(
        allCategories: [],
        allSuppliers: [],
        allTrade: [],
        worksheetType: 'worksheet',
        isSRSEnabled: null,
        isBeaconEnabled: null,
        isAbcEnabled: null,
        shipToSequenceId: '123',
        settings: WorksheetSettingModel(),
      );
      
      // Should handle null supplier flags gracefully
      expect(params.isAnySupplierEnabled(), false);
    });
  });
} 
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/run_mode.dart';
import 'package:jobprogress/common/enums/worksheet.dart';
import 'package:jobprogress/common/models/forms/measurement/measurement.dart';
import 'package:jobprogress/common/models/forms/worksheet/index.dart';
import 'package:jobprogress/common/models/launchdarkly/flag_model.dart';
import 'package:jobprogress/common/models/launchdarkly/flags.dart';
import 'package:jobprogress/common/models/macros/index.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/common/models/workflow/tier_service_params.dart';
import 'package:jobprogress/common/models/worksheet/settings/index.dart';
import 'package:jobprogress/common/services/files_listing/forms/worksheet_form/tier_quick_actions.dart';
import 'package:jobprogress/common/services/run_mode/index.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/core/constants/worksheet.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';

void main() {

  List<JPQuickActionModel> actions = [];

  SheetLineItemModel lineItem = SheetLineItemModel(
    productId: '1',
    title: 'Test',
    price: '100',
    qty: '2',
    totalPrice: '200',
  );

  SheetLineItemModel lineItem2 = SheetLineItemModel(
    productId: '1',
    title: 'Test',
    price: '100',
    qty: '2',
    totalPrice: '200',
  );

  SheetLineItemModel tier1 = SheetLineItemModel.tier(
    title: 'Test 1',
    totalPrice: '200',
    tier: 1,
    workSheetSettings: WorksheetSettingModel(),
  );

  SheetLineItemModel tier2 = SheetLineItemModel.tier(
    title: 'Test 2',
    totalPrice: '200',
    tier: 2,
    workSheetSettings: WorksheetSettingModel(),
  );

  SheetLineItemModel tier3 = SheetLineItemModel.tier(
    title: 'Test 2',
    totalPrice: '200',
    tier: 3,
    workSheetSettings: WorksheetSettingModel(),
  );

  MacroListingModel macroItem = MacroListingModel(
    tradeId: 1,
    fixedPrice: 100,
    details: [
      tier1,
      tier2
    ],
  );

  final data = WorksheetFormData(
    worksheetType: '',
    formType: WorksheetFormType.add,
  );

  WorksheetTierParams params = WorksheetTierParams(
      lineItem: tier1,
      jobId: 1212,
      data: data,
      rootItem: tier1,
      totalCollections: 1,
      worksheetJson:  (List<SheetLineItemModel> lineItems, {
        String? name,
        bool isPreview = false,
        bool isForUnsavedDB = false,
      }) => {},
      onActionComplete: (String actionId, {dynamic data}) {}
  );

  bool tierActionExists(String value) {
    return actions.any((action) => action.id == value);
  }

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    RunModeService.setRunMode(RunMode.unitTesting);
    Get.testMode = true;
  });

  group("WorksheetTierQuickActionService@getQuickActionList should be properly initialized", () {

    test("Default actions should be properly initialized", () {
      actions = WorksheetTierQuickActionService.getQuickActionList(params);
      expect(tierActionExists(WorksheetConstants.srsSmartTemplate), isFalse);
      expect(tierActionExists(WorksheetConstants.linkedMeasurement), isFalse);
      expect(tierActionExists(WorksheetConstants.reapplyMeasurement), isFalse);
      expect(tierActionExists(WorksheetConstants.discardMeasurement), isFalse);
      expect(tierActionExists(WorksheetConstants.deleteTierWithItems), isFalse);
      expect(tierActionExists(WorksheetConstants.addSubTier), isTrue);
      expect(tierActionExists(WorksheetConstants.addItem), isTrue);
      expect(tierActionExists(WorksheetConstants.addDescription), isTrue);
      expect(tierActionExists(WorksheetConstants.rename), isTrue);
      expect(tierActionExists(WorksheetConstants.macros), isTrue);
      expect(tierActionExists(WorksheetConstants.createNew), isTrue);
      expect(tierActionExists(WorksheetConstants.applyMeasurement), isTrue);
      expect(tierActionExists(WorksheetConstants.deleteTier), isTrue);
    });

    group("Add Sub Tier action should be displayed conditionally", () {
      test("Action should be displayed for tier level 1", () {
        params.lineItem = tier1;
        actions = WorksheetTierQuickActionService.getQuickActionList(params);
        expect(tierActionExists(WorksheetConstants.addSubTier), isTrue);
      });

      test("Action should be displayed for tier level 2", () {
        params.lineItem = tier2;
        actions = WorksheetTierQuickActionService.getQuickActionList(params);
        expect(tierActionExists(WorksheetConstants.addSubTier), isTrue);
      });

      test("Action should not be displayed for tier level 3", () {
        params.lineItem = tier3;
        actions = WorksheetTierQuickActionService.getQuickActionList(params);
        expect(tierActionExists(WorksheetConstants.addSubTier), isFalse);
      });
    });

    group("Add Item Action should be displayed conditionally", () {
      test("Action should be displayed when tier has no item", () {
        params.lineItem = tier1;
        actions = WorksheetTierQuickActionService.getQuickActionList(params);
        expect(tierActionExists(WorksheetConstants.addItem), isTrue);
      });

      test("Action should be displayed when tier has items", () {
        params.lineItem = tier1..subItems = [lineItem];
        actions = WorksheetTierQuickActionService.getQuickActionList(params);
        expect(tierActionExists(WorksheetConstants.addItem), isTrue);
      });

      test("Action should not be displayed when tier has sub tiers", () {
        params.lineItem = tier1..subTiers = [tier2];
        actions = WorksheetTierQuickActionService.getQuickActionList(params);
        expect(tierActionExists(WorksheetConstants.addItem), isFalse);
      });
    });

    group("Add Macro should be displayed conditionally", () {
      test("Action should be displayed when tier has no item", () {
        params.lineItem = tier1
          ..subItems = []
          ..subTiers = [];
        actions = WorksheetTierQuickActionService.getQuickActionList(params);
        expect(tierActionExists(WorksheetConstants.macros), isTrue);
      });

      test("Action should be displayed when tier has items", () {
        params.lineItem = tier1..subItems = [lineItem];
        actions = WorksheetTierQuickActionService.getQuickActionList(params);
        expect(tierActionExists(WorksheetConstants.macros), isTrue);
      });

      test("Action should not be displayed when tier has sub tiers", () {
        params.lineItem = tier1..subTiers = [tier2];
        actions = WorksheetTierQuickActionService.getQuickActionList(params);
        expect(tierActionExists(WorksheetConstants.macros), isFalse);
      });
    });

    group("SRS Smart Template actions should be displayed conditionally", () {
      LDFlagModel? flagDetails;
      setUpAll(() {
        flagDetails = LDFlags.allFlags[LDFlagKeyConstants.srsV2MaterialIntegration];
        params.lineItem.subTiers = [];
      });

      test("Action should be displayed if SRS feature is enabled and SRS v2 is inactive", () {
        data.isSRSEnable = true;
        flagDetails?.value = false;
        actions = WorksheetTierQuickActionService.getQuickActionList(params);
        expect(tierActionExists(WorksheetConstants.srsSmartTemplate), isTrue);
      });

      group('Action should not be displayed', () {
        test("When SRS feature is disabled and SRS v2 is active", () {
          data.isSRSEnable = false;
          flagDetails?.value = true;
          actions = WorksheetTierQuickActionService.getQuickActionList(params);
          expect(tierActionExists(WorksheetConstants.srsSmartTemplate), isFalse);
        });

        test("When SRS feature is enabled and SRS v2 is active", () {
          data.isSRSEnable = true;
          flagDetails?.value = true;
          actions = WorksheetTierQuickActionService.getQuickActionList(params);
          expect(tierActionExists(WorksheetConstants.srsSmartTemplate), isFalse);
        });

        test("When SRS feature is disabled and SRS v2 is inactive", () {
          data.isSRSEnable = false;
          flagDetails?.value = false;
          actions = WorksheetTierQuickActionService.getQuickActionList(params);
          expect(tierActionExists(WorksheetConstants.srsSmartTemplate), isFalse);
        });
      });
    });

    group("Show Create New option should be displayed conditionally", () {
      test("Action should be displayed when tier total price is greater than 0", () {
        params.lineItem = tier1..totalPrice = '100';
        actions = WorksheetTierQuickActionService.getQuickActionList(params);
        expect(tierActionExists(WorksheetConstants.createNew), isTrue);
      });

      test("Action should not be displayed when tier price is equal to 0", () {
        params.lineItem = tier1..totalPrice = '0';
        actions = WorksheetTierQuickActionService.getQuickActionList(params);
        expect(tierActionExists(WorksheetConstants.createNew), isFalse);
      });

      test("Action should not be displayed when tier price is less than zero", () {
        params.lineItem = tier1..totalPrice = '-10';
        actions = WorksheetTierQuickActionService.getQuickActionList(params);
        expect(tierActionExists(WorksheetConstants.createNew), isFalse);
      });
    });

    group("Remove sub tier should be displayed conditionally", () {
      test("Action should be displayed if tier has sub tier", () {
        params.lineItem = tier1..subTiers = [tier2];
        actions = WorksheetTierQuickActionService.getQuickActionList(params);
        expect(tierActionExists(WorksheetConstants.deleteTierWithItems), isTrue);
      });

      test("Action should not be displayed if tier has no sub tier", () {
        params.lineItem = tier1
          ..subTiers = []
          ..subItems = [];
        actions = WorksheetTierQuickActionService.getQuickActionList(params);
        expect(tierActionExists(WorksheetConstants.deleteTierWithItems), isFalse);
      });
    });

    group("Apply Measurement should be displayed conditionally", () {
      group("Action should be displayed on the basis of worksheet", () {
        setUp(() {
          params.lineItem.tierMeasurement = null;
          params.lineItem.tierMeasurement = null;
        });

        test("Action can't be displayed for work order worksheet", () {
          params.data.worksheetType = WorksheetConstants.workOrder;
          actions = WorksheetTierQuickActionService.getQuickActionList(params);
          expect(tierActionExists(WorksheetConstants.applyMeasurement), isFalse);
        });

        test("Action should be displayed for estimate worksheet", () {
          params.data.worksheetType = WorksheetConstants.estimate;
          actions = WorksheetTierQuickActionService.getQuickActionList(params);
          expect(tierActionExists(WorksheetConstants.applyMeasurement), isTrue);
        });

        test("Action should be displayed for proposal worksheet", () {
          params.data.worksheetType = WorksheetConstants.proposal;
          actions = WorksheetTierQuickActionService.getQuickActionList(params);
          expect(tierActionExists(WorksheetConstants.applyMeasurement), isTrue);
        });

        test("Action should be displayed for material worksheet", () {
          params.data.worksheetType = WorksheetConstants.materialList;
          actions = WorksheetTierQuickActionService.getQuickActionList(params);
          expect(tierActionExists(WorksheetConstants.applyMeasurement), isTrue);
        });
      });

      test("Action should be displayed when tier has no measurement", () {
        params.lineItem = tier1;
        actions = WorksheetTierQuickActionService.getQuickActionList(params);
        expect(tierActionExists(WorksheetConstants.applyMeasurement), isTrue);
      });

      test("Action should not be displayed when tier has measurement", () {
        params.lineItem = tier1..tierMeasurement = MeasurementModel();
        actions = WorksheetTierQuickActionService.getQuickActionList(params);
        expect(tierActionExists(WorksheetConstants.applyMeasurement), isFalse);
      });
    });

    group("Linked Measurement should be displayed conditionally", () {
      group("Action should be displayed on the basis of worksheet", () {
        setUp(() {
          params.lineItem.tierMeasurementId = 1;
          params.lineItem.tierMeasurement = MeasurementModel();
        });

        test("Action can't be displayed for work order worksheet", () {
          params.data.worksheetType = WorksheetConstants.workOrder;
          actions = WorksheetTierQuickActionService.getQuickActionList(params);
          expect(tierActionExists(WorksheetConstants.linkedMeasurement), isFalse);
        });

        test("Action should be displayed for estimate worksheet", () {
          params.data.worksheetType = WorksheetConstants.estimate;
          actions = WorksheetTierQuickActionService.getQuickActionList(params);
          expect(tierActionExists(WorksheetConstants.linkedMeasurement), isTrue);
        });

        test("Action should be displayed for proposal worksheet", () {
          params.data.worksheetType = WorksheetConstants.proposal;
          actions = WorksheetTierQuickActionService.getQuickActionList(params);
          expect(tierActionExists(WorksheetConstants.linkedMeasurement), isTrue);
        });

        test("Action should be displayed for material worksheet", () {
          params.data.worksheetType = WorksheetConstants.materialList;
          actions = WorksheetTierQuickActionService.getQuickActionList(params);
          expect(tierActionExists(WorksheetConstants.linkedMeasurement), isTrue);
        });
      });

      test("Action should not be displayed when tier has no measurement", () {
        params.lineItem = tier1
          ..tierMeasurement = null
          ..tierMeasurementId = null;
        actions = WorksheetTierQuickActionService.getQuickActionList(params);
        expect(tierActionExists(WorksheetConstants.linkedMeasurement), isFalse);
      });

      test("Action should not be displayed when tier has measurement", () {
        params.lineItem = tier1..tierMeasurement = MeasurementModel();
        actions = WorksheetTierQuickActionService.getQuickActionList(params);
        expect(tierActionExists(WorksheetConstants.linkedMeasurement), isTrue);
      });
    });

    group("Discard Measurement should be displayed conditionally", () {
      group("Action should be displayed on the basis of worksheet", () {
        setUp(() {
          params.lineItem.tierMeasurementId = 1;
          params.lineItem.tierMeasurement = MeasurementModel();
        });

        test("Action can't be displayed for work order worksheet", () {
          params.data.worksheetType = WorksheetConstants.workOrder;
          actions = WorksheetTierQuickActionService.getQuickActionList(params);
          expect(tierActionExists(WorksheetConstants.discardMeasurement), isFalse);
        });

        test("Action should be displayed for estimate worksheet", () {
          params.data.worksheetType = WorksheetConstants.estimate;
          actions = WorksheetTierQuickActionService.getQuickActionList(params);
          expect(tierActionExists(WorksheetConstants.discardMeasurement), isTrue);
        });

        test("Action should be displayed for proposal worksheet", () {
          params.data.worksheetType = WorksheetConstants.proposal;
          actions = WorksheetTierQuickActionService.getQuickActionList(params);
          expect(tierActionExists(WorksheetConstants.discardMeasurement), isTrue);
        });

        test("Action should be displayed for material worksheet", () {
          params.data.worksheetType = WorksheetConstants.materialList;
          actions = WorksheetTierQuickActionService.getQuickActionList(params);
          expect(tierActionExists(WorksheetConstants.discardMeasurement), isTrue);
        });
      });

      test("Action should not be displayed when tier has no measurement", () {
        params.lineItem = tier1
          ..tierMeasurement = null
          ..tierMeasurementId = null;
        actions = WorksheetTierQuickActionService.getQuickActionList(params);
        expect(tierActionExists(WorksheetConstants.discardMeasurement), isFalse);
      });

      test("Action should not be displayed when tier has measurement", () {
        params.lineItem = tier1..tierMeasurement = MeasurementModel();
        actions = WorksheetTierQuickActionService.getQuickActionList(params);
        expect(tierActionExists(WorksheetConstants.discardMeasurement), isTrue);
      });
    });

    group("Delete tier should be displayed conditionally", () {
      test("Action should not be displayed if parent tier has multiple sub tier", () {
        tier1.parent = tier1..parent = lineItem..subTiers = [
          tier2, tier3
        ];
        params.lineItem = tier1;
        actions = WorksheetTierQuickActionService.getQuickActionList(params);
        expect(tierActionExists(WorksheetConstants.deleteTier), isFalse);
        tier1.parent = null;
      });

      test("Action should not be displayed if tier has multiple sub tier", () {
        tier1.parent = tier1..subTiers = [
          tier2, tier3
        ];
        params.lineItem = tier1;
        actions = WorksheetTierQuickActionService.getQuickActionList(params);
        expect(tierActionExists(WorksheetConstants.deleteTier), isFalse);
        tier1.parent = null;
      });

      test("Action should not be displayed if tier is of level 1 with sub-items and there are more than 1 tiers", () {
        params.lineItem = tier1
          ..parent = null
          ..subTiers = []
          ..subItems = [lineItem];
        params.totalCollections = 2;
        actions = WorksheetTierQuickActionService.getQuickActionList(params);
        expect(tierActionExists(WorksheetConstants.deleteTier), isFalse);
      });

      test("Action should be displayed if tier has no sub item and sub tier", () {
        params.lineItem = tier1
          ..subTiers = []
          ..subItems = [];
        actions = WorksheetTierQuickActionService.getQuickActionList(params);
        expect(tierActionExists(WorksheetConstants.deleteTier), isTrue);
      });

      test("Action should be displayed if tier has parent with single tier itself", () {
        params.lineItem = tier1
          ..parent = tier1..subTiers = [tier1]
          ..subTiers = []
          ..subItems = [];
        actions = WorksheetTierQuickActionService.getQuickActionList(params);
        expect(tierActionExists(WorksheetConstants.deleteTier), isTrue);
      });
    });

    group('Delete Tier With Items should be displayed conditionally', () {
      test('Action should not be displayed if tier has no sub item and sub tiers', () {
        params.lineItem = tier1
          ..subItems = []
          ..subTiers = [];
        actions = WorksheetTierQuickActionService.getQuickActionList(params);
        expect(tierActionExists(WorksheetConstants.deleteTierWithItems), isFalse);
      });

      test('Action should be displayed if tier has no sub item and has sub tiers', () {
        params.lineItem = tier1
          ..subItems = []
          ..subTiers = [tier2];
        actions = WorksheetTierQuickActionService.getQuickActionList(params);
        expect(tierActionExists(WorksheetConstants.deleteTierWithItems), isTrue);
      });

      test('Action should be displayed if tier has sub item and has no sub tiers', () {
        params.lineItem = tier1
          ..subItems = [tier2]
          ..subTiers = [];
        actions = WorksheetTierQuickActionService.getQuickActionList(params);
        expect(tierActionExists(WorksheetConstants.deleteTierWithItems), isTrue);
      });
    });
  });

  group('WorksheetTierQuickActionService@getLineItems should give tier line items along with attaching measurement details', () {
    test('All line items for given tier should be returned', () {
      params.lineItem = tier1;
      final result = WorksheetTierQuickActionService.getLineItems(params);
      expect(result, hasLength(1));
    });

    group("When tier level 1 has measurement available", () {
      test("Measurement should not be applied to worksheet level items", () {
        params.lineItem = tier1
          ..subTiers = []
          ..subItems = []
          ..tierMeasurementId = 5;
        final result = WorksheetTierQuickActionService.getLineItems(params, tierLevel: 1);
        expect(result, hasLength(0));
        tier1.tierMeasurementId = null;
      });

      test("Measurement from level 1 tier should be applied to level 1 tier", () {
        tier1.tier1MeasurementId = '1';
        params.lineItem = tier1;
        final result = WorksheetTierQuickActionService.getLineItems(params, tierLevel: 2);
        expect(result, hasLength(0));
      });

      test("Measurement from level 1 tier should be applied to level 2 tier", () {
        params.lineItem = tier1;
        final result = WorksheetTierQuickActionService.getLineItems(params, tierLevel: 2);
        expect(result, hasLength(0));
      });

      test("Measurement from level 1 tier should be applied to level 3 tier", () {
        params.lineItem = tier1;
        final result = WorksheetTierQuickActionService.getLineItems(params, tierLevel: 3);
        expect(result, hasLength(0));
      });
    });
  });

  group('WorksheetTierQuickActionService@addSubTier should add sub tier to tier', () {
    test('Sub tier should be added correctly', () {
      params.lineItem = tier1;
      WorksheetTierQuickActionService.addSubTier(params, tier1.title!);
      expect(params.lineItem.subTiers, hasLength(1));
      expect(params.lineItem.subTiers![0].title, tier1.title!);
      expect(params.lineItem.subTiers![0].tier, params.lineItem.tier! + 1);
    });

    test('Sub tier should not be added if name is replicated', () {
      params.lineItem.subTiers = [
        tier1, tier2,
      ];
      WorksheetTierQuickActionService.addSubTier(params, tier1.title!);
      expect(params.lineItem.subTiers, hasLength(2));
    });

    test('Items should be extracted from parent tier and added to sub tier', () {
      params.lineItem.tier = 2;
      params.lineItem.subTiers?.clear();
      params.lineItem.subItems = [
        lineItem, lineItem2
      ];
      WorksheetTierQuickActionService.addSubTier(params, 'Test 5');
      expect(params.lineItem.subItems, hasLength(0));
      expect(params.lineItem.subTiers, hasLength(1));
      expect(params.lineItem.subTiers![0].subItems, hasLength(2));
      expect(params.lineItem.subTiers![0].totalPrice, '400');
      expect(params.lineItem.subTiers![0].lineTaxAmt, '0');
      expect(params.lineItem.subTiers![0].lineProfitAmt, '0');
      expect(params.lineItem.subTiers![0].tiersLineTotal, '0');
    });

    test('Sub tier should be added to parent tier', () {
      params.lineItem = tier1
        ..subTiers = []
        ..subItems = []
        ..tier = 1;
      WorksheetTierQuickActionService.addSubTier(params, tier1.title!);
      expect(params.lineItem.subTiers, hasLength(1));
      expect(params.lineItem.subTiers![0].title, tier1.title!);
      expect(params.lineItem.subTiers![0].tier, params.lineItem.tier! + 1);
    });

    test('Sub tier cannot be added to level 3 tier', () {
      params.lineItem = tier3;
      WorksheetTierQuickActionService.addSubTier(params, tier1.title!);
      expect(params.lineItem.subTiers, isNull);
    });
  });

  group("WorksheetTierQuickActionService@renameTier should validate and rename tier", () {
    test("Tier should be renamed when tiers replication name is same of that actual name", () {
      params.lineItem = tier1;
      params.data.lineItems = [
        tier1,
        tier2
      ];
      WorksheetTierQuickActionService.renameTier(params, tier1.title!);
      expect(params.lineItem.title, tier1.title!);
    });

    test("Tier should be renamed when tiers replication name is unique", () {
      params.lineItem = tier1;
      params.data.lineItems = [
        tier1,
        tier2
      ];
      WorksheetTierQuickActionService.renameTier(params, 'Test 5');
      expect(params.lineItem.title, 'Test 5');
    });

    test("Tier should not be renamed when tiers replication name is already in use", () {
      params.lineItem = tier1;
      params.data.lineItems = [
        tier1,
        tier2
      ];
      WorksheetTierQuickActionService.renameTier(params, tier2.title!);
      expect(params.lineItem.title, tier1.title);
    });

    test("Sub tier can have same name as one of the parent tier", () {
      params.data.lineItems = [
        tier1,
        tier2..subTiers = [tier1]
      ];
      params.lineItem = tier2.subTiers![0];
      WorksheetTierQuickActionService.renameTier(params, tier1.title!);
      expect(params.lineItem.title, tier1.title);
    });

    test("Sub tier of different tiers can have same name", () {
      params.data.lineItems = [
        tier1..subTiers = [tier2],
        tier2..subTiers = [tier1]
      ];
      params.lineItem = tier2.subTiers![0];
      WorksheetTierQuickActionService.renameTier(params, tier1.title!);
      expect(params.lineItem.title, tier1.title);

      params.lineItem = tier1.subTiers![0];
      WorksheetTierQuickActionService.renameTier(params, tier1.title!);
      expect(params.lineItem.title, tier1.title);
    });
  });

  group('WorksheetTierQuickActionService@removeSubTier should remove sub tier', () {
    test("Tier's sub tier should be removed", () {
      params.lineItem = tier1
        ..subItems = []
        ..subTiers = [
        tier2
          ..subItems = []
          ..subTiers = []
      ];
      WorksheetTierQuickActionService.removeSubTier(params);
      expect(params.lineItem.subTiers, hasLength(0));
    });

    test("All sub tiers should be removed", () {
      params.lineItem = tier1..subTiers = [tier2, tier3];
      WorksheetTierQuickActionService.removeSubTier(params);
      expect(params.lineItem.subTiers, hasLength(0));
    });

    test("Sub tier should be removed from specific index", () {
      params.lineItem = tier1..subTiers = [tier2, tier3];
      WorksheetTierQuickActionService.removeSubTier(params, index: 1);
      expect(params.lineItem.subTiers, hasLength(1));
    });

    test("Sub tier items should also be removed", () {
      params.lineItem = tier1..subTiers = [tier2..subItems = [lineItem, lineItem2]];
      WorksheetTierQuickActionService.removeSubTier(params, removeItems: true);
      expect(params.lineItem.subTiers, hasLength(0));
      expect(params.lineItem.subItems, hasLength(0));
    });

    test("Sub tier items should be added to parent tier", () {
      params.lineItem = tier1
        ..subItems = []
        ..subTiers = [tier2..subItems = [lineItem, lineItem2]];
      WorksheetTierQuickActionService.removeSubTier(params);
      expect(params.lineItem.subTiers, hasLength(0));
      expect(params.lineItem.subItems, hasLength(2));
    });
  });

  group("WorksheetTierQuickActionService@deleteTier should remove ", () {
    group("When tier is of level 1", () {
      test("Tier items should be removed", () {
        params.lineItem = tier1
          ..tier = 1
          ..subItems = [lineItem];
        WorksheetTierQuickActionService.deleteTier(params, removeItems: true);
        expect(params.lineItem.subItems, hasLength(0));
      });

      test("Tier items should not be removed", () {
        params.lineItem = tier1
          ..tier = 1
          ..subItems = [lineItem];
        WorksheetTierQuickActionService.deleteTier(params);
        expect(params.lineItem.subItems, hasLength(1));
      });
    });

    group("When tier is not of level 1", () {
      test("Tier should be removed", () {
        params.lineItem = tier2;
        params.lineItem.parent = tier1..subTiers = [tier2];
        WorksheetTierQuickActionService.deleteTier(params);
        expect(params.lineItem.parent?.subTiers, hasLength(0));
      });

      test("Tier items should be removed", () {
        params.lineItem = tier2..subItems = [lineItem];
        params.lineItem.parent = tier1
          ..subItems = []
          ..subTiers = [tier2];
        WorksheetTierQuickActionService.deleteTier(params, removeItems: true);
        expect(params.lineItem.parent?.subTiers, hasLength(0));
        expect(params.lineItem.parent?.subItems, hasLength(0));
      });

      test("Tier items should not be removed", () {
        params.lineItem = tier2..subItems = [lineItem];
        params.lineItem.parent = tier1
          ..subItems = []
          ..subTiers = [tier2];
        WorksheetTierQuickActionService.deleteTier(params);
        expect(params.lineItem.parent?.subTiers, hasLength(0));
        expect(params.lineItem.parent?.subItems, hasLength(1));
      });
    });
  });

  group("WorksheetTierQuickActionService@deleteTierWithItems should remove tier with items", () {
    test("Tier should be removed when there are not items", () {
      params.lineItem = tier2;
      params.lineItem.parent = tier1..subTiers = [tier2];
      WorksheetTierQuickActionService.deleteTierWithItems(params);
      expect(params.lineItem.parent?.subTiers, hasLength(0));
    });

    test("Tier should be removed when there are items", () {
      params.lineItem = tier2..subItems = [lineItem];
      params.lineItem.parent = tier1..subTiers = [tier2];
      WorksheetTierQuickActionService.deleteTierWithItems(params);
      expect(params.lineItem.parent?.subTiers, hasLength(0));
    });

    test("Tier items should be removed", () {
      params.lineItem = tier2..subItems = [lineItem];
      params.lineItem.parent = tier1
        ..subItems = []
        ..subTiers = [tier2];
      WorksheetTierQuickActionService.deleteTierWithItems(params);
      expect(params.lineItem.parent?.subTiers, hasLength(0));
      expect(params.lineItem.parent?.subItems, hasLength(0));
    });
  });

  group("WorksheetTierQuickActionService@addMacros should add line items from macros", () {
    test("When macro list is empty no items should be removed", () {
      params.lineItem = tier1;
      List<MacroListingModel> macros = [];
      WorksheetTierQuickActionService.addMacros(macros, params);
      expect(params.lineItem.subItems, hasLength(0));
    });

    test("When macro list is not empty it should be added to ", () {
      params.lineItem = tier1;
      List<MacroListingModel> macros = [
        macroItem
      ];
      WorksheetTierQuickActionService.addMacros(macros, params);
      expect(params.lineItem.subItems, hasLength(2));
    });

    test("Existing items should not be replaced by new items", () {
      List<MacroListingModel> macros = [
        macroItem
      ];
      WorksheetTierQuickActionService.addMacros(macros, params);
      expect(params.lineItem.subItems, hasLength(4));
    });
  });

  group("WorksheetTierQuickActionService@discardMeasurement should unlink the linked measurement", () {
    test("Worksheet measurement should be removed", () {
      params.lineItem.tierMeasurement = MeasurementModel();
      WorksheetTierQuickActionService.discardMeasurement(params);
      expect(params.lineItem.tierMeasurement, isNull);
    });

    test("Measurement id should be removed", () {
      params.lineItem.tierMeasurementId = 5;
      WorksheetTierQuickActionService.discardMeasurement(params);
      expect(params.lineItem.tierMeasurementId, isNull);
    });

    test("Parent measurement should be used if it's available", () {
      params.lineItem.tierMeasurement = MeasurementModel();
      params.lineItem.parent = tier1..tierMeasurement = MeasurementModel();
      WorksheetTierQuickActionService.discardMeasurement(params);
      expect(params.lineItem.tierMeasurement, isNull);
    });

    test("Parent measurement should not be used if it's not available", () {
      params.lineItem.tierMeasurement = MeasurementModel();
      params.lineItem.parent?.tierMeasurement = null;
      WorksheetTierQuickActionService.discardMeasurement(params);
      expect(params.lineItem.tierMeasurement, isNull);
    });
  });
}

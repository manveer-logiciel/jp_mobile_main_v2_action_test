import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/run_mode.dart';
import 'package:jobprogress/common/enums/worksheet.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/files_listing/linked_material.dart';
import 'package:jobprogress/common/models/files_listing/my_favourite_entity.dart';
import 'package:jobprogress/common/models/forms/measurement/measurement.dart';
import 'package:jobprogress/common/models/forms/worksheet/index.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job/job_division.dart';
import 'package:jobprogress/common/models/popover_action.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/common/models/suppliers/branch.dart';
import 'package:jobprogress/common/models/templates/form_proposal/template.dart';
import 'package:jobprogress/common/models/workflow/header_action_params.dart';
import 'package:jobprogress/common/models/worksheet/settings/index.dart';
import 'package:jobprogress/common/models/worksheet/worksheet_model.dart';
import 'package:jobprogress/common/services/connected_third_party.dart';
import 'package:jobprogress/common/services/files_listing/forms/worksheet_form/more_actions.dart';
import 'package:jobprogress/common/services/run_mode/index.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/connected_third_party_constants.dart';
import 'package:jobprogress/core/constants/worksheet.dart';
import 'package:jobprogress/core/utils/helpers.dart';

void main() {

  final service = WorksheetMoreActionService();

  List<PopoverActionModel> actions = [];

  final data = WorksheetFormData(
      worksheetType: '',
      formType: WorksheetFormType.add,
  );

  final params = WorksheetHeaderActionParams(data: data, hasTiers: false);

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
    tier: 1,
    workSheetSettings: WorksheetSettingModel(),
  );

  bool moreActionExists(String value) {
    return actions.any((action) => action.value == value);
  }

  final tempJob = JobModel(id: 1, customerId: 1);

  setUpAll(() {
    service.params = params;
    RunModeService.setRunMode(RunMode.unitTesting);
    Get.testMode = true;
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  test("WorksheetMoreActionService@worksheetPricingList should be properly initialized", () {
    final list = WorksheetMoreActionService().worksheetPricingList;
    expect(list, hasLength(2));
  });

  group("WorksheetMoreActionService@getActions should return correct more actions", () {
    group("In case of add worksheet", () {
      test("Limited actions should be available by default", () {
        actions = WorksheetMoreActionService.getActions(params: params);
        expect(moreActionExists(WorksheetConstants.addTier), isTrue);
        
        expect(moreActionExists(WorksheetConstants.attachPhotos), isTrue);
        expect(moreActionExists(WorksheetConstants.macros), isTrue);
        expect(moreActionExists(WorksheetConstants.favourites), isTrue);
        expect(moreActionExists(WorksheetConstants.applyMeasurement), isTrue);
        expect(moreActionExists(WorksheetConstants.calculator), isTrue);
      });

      test("Conditional actions be disabled conditionally", () {
        expect(moreActionExists(WorksheetConstants.removeZeroQuantityItems), isFalse);
        expect(moreActionExists(WorksheetConstants.removeTiers), isFalse);
        expect(moreActionExists(WorksheetConstants.worksheetPricing), isFalse);
        expect(moreActionExists(WorksheetConstants.expandTier), isFalse);
        expect(moreActionExists(WorksheetConstants.collapseTier), isFalse);
        expect(moreActionExists(WorksheetConstants.srs), isFalse);
        expect(moreActionExists(WorksheetConstants.srsSmartTemplate), isFalse);
        expect(moreActionExists(WorksheetConstants.linkedMeasurement), isFalse);
        expect(moreActionExists(WorksheetConstants.reapplyMeasurement), isFalse);
        expect(moreActionExists(WorksheetConstants.discardMeasurement), isFalse);
        expect(moreActionExists(WorksheetConstants.addTemplatePages), isFalse);
        expect(moreActionExists(WorksheetConstants.worksheetSettings), isFalse);
        expect(moreActionExists(WorksheetConstants.preview), isFalse);
      });

      test("Edit quick actions should not be displayed", () {
        expect(moreActionExists(WorksheetConstants.placeSRSOrder), isFalse);
        expect(moreActionExists(WorksheetConstants.markAsFavourite), isFalse);
        expect(moreActionExists(WorksheetConstants.unMarkAsFavourite), isFalse);
        expect(moreActionExists(WorksheetConstants.editTemplatePages), isFalse);
        expect(moreActionExists(WorksheetConstants.saveAs), isFalse);
      });

      group("Apply measurement action should be displayed conditionally", () {
        test("Apply measurement should be displayed for Work Order worksheet", () {
          data.worksheetType = WorksheetConstants.workOrder;
          actions = WorksheetMoreActionService.getActions(params: params);
          expect(moreActionExists(WorksheetConstants.applyMeasurement), isTrue);
        });

        group("When worksheet is other than work order", () {
          test("For material worksheet, Apply measurement should be displayed", () {
            data.worksheetType = WorksheetConstants.materialList;
            actions = WorksheetMoreActionService.getActions(params: params);
            expect(moreActionExists(WorksheetConstants.applyMeasurement), isTrue);
          });

          test("For estimate, Apply measurement should be displayed", () {
            data.worksheetType = WorksheetConstants.estimate;
            actions = WorksheetMoreActionService.getActions(params: params);
            expect(moreActionExists(WorksheetConstants.applyMeasurement), isTrue);
          });

          test("For proposal, Apply measurement should be displayed", () {
            data.worksheetType = WorksheetConstants.proposal;
            actions = WorksheetMoreActionService.getActions(params: params);
            expect(moreActionExists(WorksheetConstants.applyMeasurement), isTrue);
          });
        });
      });
      group("Remove Zero Quantity action should be displayed conditionally", () {
        test("Action should not be displayed, When items are not added", () {
          params.hasTiers = false;
          actions = WorksheetMoreActionService.getActions(params: params);
          expect(moreActionExists(WorksheetConstants.removeZeroQuantityItems), isFalse);
        });

        test("Action should be displayed, When items are added", () {
          data.lineItems.add(lineItem);
          actions = WorksheetMoreActionService.getActions(params: params);
          expect(moreActionExists(WorksheetConstants.removeZeroQuantityItems), isTrue);
          data.lineItems.clear();
        });

        test("Action should not be displayed, When tiers are not added", () {
          params.hasTiers = false;
          actions = WorksheetMoreActionService.getActions(params: params);
          expect(moreActionExists(WorksheetConstants.removeZeroQuantityItems), isFalse);
        });

        test("Action should not be displayed, When tiers are added without items", () {
          params.hasTiers = true;
          actions = WorksheetMoreActionService.getActions(params: params);
          expect(moreActionExists(WorksheetConstants.removeZeroQuantityItems), isFalse);
        });

        test("Action should be displayed, When tiers are added with items", () {
          params.hasTiers = true;
          data.lineItems.add(tier1..subItems = [lineItem]);
          actions = WorksheetMoreActionService.getActions(params: params);
          expect(moreActionExists(WorksheetConstants.removeZeroQuantityItems), isTrue);
        });
      });

      group("Remove Tier action should be displayed conditionally", () {
        test("Action should not be displayed, When tiers are not added", () {
          params.hasTiers = false;
          data.lineItems.clear();
          actions = WorksheetMoreActionService.getActions(params: params);
          expect(moreActionExists(WorksheetConstants.removeTiers), isFalse);
        });

        test("Action should be displayed, When tiers are added", () {
          data.lineItems.clear();
          params.hasTiers = true;
          data.lineItems.add(tier1);
          actions = WorksheetMoreActionService.getActions(params: params);
          expect(moreActionExists(WorksheetConstants.removeTiers), isTrue);
        });

        test("Action should be displayed, When tiers are added without items", () {
          data.lineItems.clear();
          params.hasTiers = true;
          tier1.subItems?.clear();
          data.lineItems.add(tier1);
          actions = WorksheetMoreActionService.getActions(params: params);
          expect(moreActionExists(WorksheetConstants.removeTiers), isTrue);
        });
      });

      group("Expand tier action should be displayed conditionally", () {
        group("When tiers are added", () {
          test("Action should be displayed, when all tiers are collapsed", () {
            tier1.isTierExpanded = false;
            tier2.isTierExpanded = false;
            data.lineItems = [tier1, tier2];
            actions = WorksheetMoreActionService.getActions(params: params);
            expect(moreActionExists(WorksheetConstants.expandTier), isTrue);
          });

          test("Action should not be displayed, when any tier is expanded", () {
            tier1.isTierExpanded = true;
            tier2.isTierExpanded = false;
            data.lineItems = [tier1, tier2];
            actions = WorksheetMoreActionService.getActions(params: params);
            expect(moreActionExists(WorksheetConstants.expandTier), isFalse);
          });

          test("Action should not be displayed, when all tiers are expanded", () {
            tier1.isTierExpanded = true;
            tier2.isTierExpanded = true;
            data.lineItems = [tier1, tier2];
            actions = WorksheetMoreActionService.getActions(params: params);
            expect(moreActionExists(WorksheetConstants.expandTier), isFalse);
          });
        });

        test("Action should not be displays, when only line items are added", () {
          data.lineItems = [lineItem];
          actions = WorksheetMoreActionService.getActions(params: params);
          expect(moreActionExists(WorksheetConstants.expandTier), isFalse);
        });

        test("Action should not be displays, when worksheet is empty", () {
          data.lineItems = [];
          actions = WorksheetMoreActionService.getActions(params: params);
          expect(moreActionExists(WorksheetConstants.expandTier), isFalse);
        });
      });

      group("Collapse tier action should be displayed conditionally", () {
        group("When tiers are added", () {
          test("Action should be displayed, when all tiers are expanded", () {
            tier1.isTierExpanded = true;
            tier2.isTierExpanded = true;
            data.lineItems = [tier1, tier2];
            actions = WorksheetMoreActionService.getActions(params: params);
            expect(moreActionExists(WorksheetConstants.collapseTier), isTrue);
          });

          test("Action should not be displayed, when any tier is expanded", () {
            tier1.isTierExpanded = true;
            tier2.isTierExpanded = false;
            data.lineItems = [tier1, tier2];
            actions = WorksheetMoreActionService.getActions(params: params);
            expect(moreActionExists(WorksheetConstants.collapseTier), isTrue);
          });

          test("Action should not be displayed, when all tiers are collapsed", () {
            tier1.isTierExpanded = false;
            tier2.isTierExpanded = false;
            data.lineItems = [tier1, tier2];
            actions = WorksheetMoreActionService.getActions(params: params);
            expect(moreActionExists(WorksheetConstants.collapseTier), isFalse);
          });
        });

        test("Action should not be displays, when only line items are added", () {
          data.lineItems = [lineItem];
          actions = WorksheetMoreActionService.getActions(params: params);
          expect(moreActionExists(WorksheetConstants.collapseTier), isFalse);
        });

        test("Action should not be displays, when worksheet is empty", () {
          data.lineItems = [];
          actions = WorksheetMoreActionService.getActions(params: params);
          expect(moreActionExists(WorksheetConstants.collapseTier), isFalse);
        });
      });

      group('SRS toggle should be displayed conditionally', () {
        group("When SRS is connected", () {
          setUp(() {
            ConnectedThirdPartyService.setConnectedParty({
              ConnectedThirdPartyConstants.srs: true,
            });
          });

          test("Toggle should be displayed for estimate worksheet", () {
            data.worksheetType = WorksheetConstants.estimate;
            actions = WorksheetMoreActionService.getActions(params: params);
            expect(moreActionExists(WorksheetConstants.srs), isTrue);
          });

          test("Toggle should be displayed for proposal worksheet", () {
            data.worksheetType = WorksheetConstants.proposal;
            actions = WorksheetMoreActionService.getActions(params: params);
            expect(moreActionExists(WorksheetConstants.srs), isTrue);
          });

          test("Toggle should be displayed for material worksheet", () {
            data.worksheetType = WorksheetConstants.materialList;
            actions = WorksheetMoreActionService.getActions(params: params);
            expect(moreActionExists(WorksheetConstants.srs), isTrue);
          });

          test("Toggle should be not be displayed for work order worksheet", () {
            data.worksheetType = WorksheetConstants.workOrder;
            actions = WorksheetMoreActionService.getActions(params: params);
            expect(moreActionExists(WorksheetConstants.srs), isFalse);
          });
        });

        test("Toggle should be not be displayed, when SRS is not connected", () {
          ConnectedThirdPartyService.connectedThirdParty.clear();
          actions = WorksheetMoreActionService.getActions(params: params);
          expect(moreActionExists(WorksheetConstants.srs), isFalse);
        });

        test('Toggle should not be displayed in case of SRS Order', () {
          data.isBeaconEnable = true;
          data.formType = WorksheetFormType.edit;
          data.workSheet = WorksheetModel()
            ..materialList = LinkedMaterialModel(forSupplierId: Helper.getSupplierId(key: CommonConstants.beaconId));
          actions = WorksheetMoreActionService.getActions(params: params);
          expect(moreActionExists(WorksheetConstants.srs), isFalse);
          data.isBeaconEnable = false;
          data.formType = WorksheetFormType.add;
        });
      });

      group("Macros actions should be displayed conditionally", () {
        test("Action should not be displayed, when tiers are added", () {
          params.hasTiers = true;
          data.lineItems = [tier1];
          actions = WorksheetMoreActionService.getActions(params: params);
          expect(moreActionExists(WorksheetConstants.macros), isFalse);
        });

        test("Action should be displayed, when tiers are not added", () {
          params.hasTiers = false;
          data.lineItems.clear();
          actions = WorksheetMoreActionService.getActions(params: params);
          expect(moreActionExists(WorksheetConstants.macros), isTrue);
        });
      });

      group("SRS Smart Template actions should be displayed conditionally", () {
        test("Action should be displayed if SRS is enabled", () {
          data.isSRSEnable = true;
          actions = WorksheetMoreActionService.getActions(params: params);
          expect(moreActionExists(WorksheetConstants.srsSmartTemplate), isTrue);
        });

        test("Action should not be displayed if SRS is disabled", () {
          data.isSRSEnable = false;
          actions = WorksheetMoreActionService.getActions(params: params);
          expect(moreActionExists(WorksheetConstants.srsSmartTemplate), isFalse);
        });
      });

      group("Attach Photos action should be displayed conditionally", () {
        test("Action should not be displayed if SRS is enabled", () {
          data.isSRSEnable = true;  
          actions = WorksheetMoreActionService.getActions(params: params);
          expect(moreActionExists(WorksheetConstants.attachPhotos), isFalse);
        });

        test("Action should be displayed if SRS is disabled", () {
          data.isSRSEnable = false;
          actions = WorksheetMoreActionService.getActions(params: params);
          expect(moreActionExists(WorksheetConstants.attachPhotos), isTrue);
        });
      });

      group("Linked Measurement action should be displayed conditionally", () {
        test("Action should be displayed, When measurement is linked", () {
          data.worksheetType = WorksheetConstants.estimate;
          data.worksheetMeasurement = MeasurementModel();
          actions = WorksheetMoreActionService.getActions(params: params);
          expect(moreActionExists(WorksheetConstants.linkedMeasurement), isTrue);
        });

        test("Action should be displayed for Work Order Worksheet, When measurement is linked", () {
          data.worksheetType = WorksheetConstants.workOrder;
          data.worksheetMeasurement = MeasurementModel();
          actions = WorksheetMoreActionService.getActions(params: params);
          expect(moreActionExists(WorksheetConstants.linkedMeasurement), isTrue);
        });

        test("Action should be displayed, When measurement is saved with worksheet", () {
          data.measurementId = 5;
          actions = WorksheetMoreActionService.getActions(params: params);
          expect(moreActionExists(WorksheetConstants.linkedMeasurement), isTrue);
        });

        test("Action should not be displayed, When measurement is not linked", () {
          data.worksheetMeasurement = null;
          data.measurementId = null;
          actions = WorksheetMoreActionService.getActions(params: params);
          expect(moreActionExists(WorksheetConstants.linkedMeasurement), isFalse);
        });
      });

      group("Reapply Measurement action should be displayed conditionally", () {
        test("Action should be displayed, When measurement is linked", () {
          data.worksheetType = WorksheetConstants.estimate;
          data.worksheetMeasurement = MeasurementModel();
          actions = WorksheetMoreActionService.getActions(params: params);
          expect(moreActionExists(WorksheetConstants.reapplyMeasurement), isTrue);
        });

        test("Action should be displayed for Work Order Worksheet, When measurement is linked", () {
          data.worksheetType = WorksheetConstants.workOrder;
          data.worksheetMeasurement = MeasurementModel();
          actions = WorksheetMoreActionService.getActions(params: params);
          expect(moreActionExists(WorksheetConstants.reapplyMeasurement), isTrue);
        });

        test("Action should be displayed, When measurement is saved with worksheet", () {
          data.measurementId = 5;
          actions = WorksheetMoreActionService.getActions(params: params);
          expect(moreActionExists(WorksheetConstants.reapplyMeasurement), isTrue);
        });

        test("Action should not be displayed, When measurement is not linked", () {
          data.worksheetMeasurement = null;
          data.measurementId = null;
          actions = WorksheetMoreActionService.getActions(params: params);
          expect(moreActionExists(WorksheetConstants.reapplyMeasurement), isFalse);
        });
      });

      group("Discard Measurement action should be displayed conditionally", () {
        test("Action should be displayed, When measurement is linked", () {
          data.worksheetType = WorksheetConstants.estimate;
          data.worksheetMeasurement = MeasurementModel();
          actions = WorksheetMoreActionService.getActions(params: params);
          expect(moreActionExists(WorksheetConstants.discardMeasurement), isTrue);
        });

        test("Action should be displayed for Work Order Worksheet, When measurement is linked", () {
          data.worksheetType = WorksheetConstants.estimate;
          data.worksheetMeasurement = MeasurementModel();
          actions = WorksheetMoreActionService.getActions(params: params);
          expect(moreActionExists(WorksheetConstants.discardMeasurement), isTrue);
        });

        test("Action should be displayed, When measurement is saved with worksheet", () {
          data.measurementId = 5;
          actions = WorksheetMoreActionService.getActions(params: params);
          expect(moreActionExists(WorksheetConstants.discardMeasurement), isTrue);
        });

        test("Action should not be displayed, When measurement is not linked", () {
          data.worksheetMeasurement = null;
          data.measurementId = null;
          actions = WorksheetMoreActionService.getActions(params: params);
          expect(moreActionExists(WorksheetConstants.discardMeasurement), isFalse);
        });
      });

      group("Worksheet Settings action should be displayed conditionally", () {
        test("Action should be displayed, When worksheet has line items", () {
          data.lineItems = [lineItem];
          actions = WorksheetMoreActionService.getActions(params: params);
          expect(moreActionExists(WorksheetConstants.worksheetSettings), isTrue);
        });

        test("Action should not be displayed, When worksheet has no line items", () {
          data.lineItems = [];
          actions = WorksheetMoreActionService.getActions(params: params);
          expect(moreActionExists(WorksheetConstants.worksheetSettings), isFalse);
        });

        test("Action should not be displayed, When worksheet has empty tiers", () {
          params.hasTiers = true;
          data.lineItems = [tier1..subItems = null];
          actions = WorksheetMoreActionService.getActions(params: params);
          expect(moreActionExists(WorksheetConstants.worksheetSettings), isFalse);
        });

        test("Action should be displayed, When worksheet has tiers with items", () {
          params.hasTiers = true;
          data.lineItems = [tier1..subItems = [lineItem]];
          actions = WorksheetMoreActionService.getActions(params: params);
          expect(moreActionExists(WorksheetConstants.worksheetSettings), isTrue);
        });
      });

      group("Preview action should be displayed conditionally", () {
        test("Action should be displayed, When worksheet has line items", () {
          data.lineItems = [lineItem];
          actions = WorksheetMoreActionService.getActions(params: params);
          expect(moreActionExists(WorksheetConstants.preview), isTrue);
        });

        test("Action should not be displayed, When worksheet has no line items", () {
          data.lineItems = [];
          actions = WorksheetMoreActionService.getActions(params: params);
          expect(moreActionExists(WorksheetConstants.preview), isFalse);
        });

        test("Action should not be displayed, When worksheet has empty tiers", () {
          params.hasTiers = true;
          data.lineItems = [tier1..subItems = null];
          actions = WorksheetMoreActionService.getActions(params: params);
          expect(moreActionExists(WorksheetConstants.preview), isFalse);
        });

        test("Action should be displayed, When worksheet has tiers with items", () {
          params.hasTiers = true;
          data.lineItems = [tier1..subItems = [lineItem]];
          actions = WorksheetMoreActionService.getActions(params: params);
          expect(moreActionExists(WorksheetConstants.preview), isTrue);
        });
      });
      
      group("Beacon toggle should be displayed conditionally", () {
        group("When Beacon is connected", () {
          setUp(() {
            ConnectedThirdPartyService.setConnectedParty({
              ConnectedThirdPartyConstants.beacon: true,
            });
          });

          test("Toggle should be displayed for estimate worksheet", () {
            data.worksheetType = WorksheetConstants.estimate;
            actions = WorksheetMoreActionService.getActions(params: params);
            expect(moreActionExists(WorksheetConstants.beacon), isTrue);
          });

          test("Toggle should be displayed for proposal worksheet", () {
            data.worksheetType = WorksheetConstants.proposal;
            actions = WorksheetMoreActionService.getActions(params: params);
            expect(moreActionExists(WorksheetConstants.beacon), isTrue);
          });

          test("Toggle should be displayed for material worksheet", () {
            data.worksheetType = WorksheetConstants.materialList;
            actions = WorksheetMoreActionService.getActions(params: params);
            expect(moreActionExists(WorksheetConstants.beacon), isTrue);
          });

          test("Toggle should be not be displayed for work order worksheet", () {
            data.worksheetType = WorksheetConstants.workOrder;
            actions = WorksheetMoreActionService.getActions(params: params);
            expect(moreActionExists(WorksheetConstants.beacon), isFalse);
          });
        });

        test("Toggle should be not be displayed, when Beacon is not connected", () {
          ConnectedThirdPartyService.connectedThirdParty.clear();
          actions = WorksheetMoreActionService.getActions(params: params);
          expect(moreActionExists(WorksheetConstants.beacon), isFalse);
        });

        test('Toggle should not be displayed in case of SRS Order', () {
          data.isSRSEnable = true;
          data.formType = WorksheetFormType.edit;
          data.workSheet = WorksheetModel()
            ..materialList = LinkedMaterialModel(forSupplierId: Helper.getSupplierId());
          actions = WorksheetMoreActionService.getActions(params: params);
          expect(moreActionExists(WorksheetConstants.beacon), isFalse);
          data.isSRSEnable = false;
          data.formType = WorksheetFormType.add;
        });
      });
    });

    group("In case of edit worksheet", () {
      setUp(() {
        data.formType = WorksheetFormType.edit;
      });

      test("Save As action be displayed by default", () {
        actions = WorksheetMoreActionService.getActions(params: params);
        expect(moreActionExists(WorksheetConstants.saveAs), isTrue);
      });

      group("Mark As Favourite action should be displayed conditionally", () {
        group("Action should be displayed", () {
          test("Items are not added from favourite worksheet", () {
            data.selectedFromFavourite = false;
            actions = WorksheetMoreActionService.getActions(params: params);
            expect(moreActionExists(WorksheetConstants.markAsFavourite), isTrue);
          });

          test("Worksheet has not favourite entity available", () {
            data.selectedFromFavourite = false;
            data.workSheet?.file?.myFavouriteEntity = null;
            actions = WorksheetMoreActionService.getActions(params: params);
            expect(moreActionExists(WorksheetConstants.markAsFavourite), isTrue);
          });
        });

        group("Action should not be displayed", () {
          test("Items are added from favourite worksheet", () {
            data.selectedFromFavourite = true;
            actions = WorksheetMoreActionService.getActions(params: params);
            expect(moreActionExists(WorksheetConstants.markAsFavourite), isFalse);
          });

          test("Worksheet has not favourite entity available", () {
            data.selectedFromFavourite = false;
            data.workSheet = WorksheetModel(
              file: FilesListingModel(
                myFavouriteEntity: MyFavouriteEntity()
              )
            );
            actions = WorksheetMoreActionService.getActions(params: params);
            expect(moreActionExists(WorksheetConstants.markAsFavourite), isFalse);
          });
        });
      });

      group("Unmark As Favourite action should be displayed conditionally", () {
        group("Action should be displayed", () {
          test("Worksheet has favourite entity available", () {
            data.selectedFromFavourite = false;
            data.workSheet = WorksheetModel(
                file: FilesListingModel(
                    myFavouriteEntity: MyFavouriteEntity()
                )
            );
            expect(moreActionExists(WorksheetConstants.unMarkAsFavourite), isTrue);
          });
        });

        group("Action should not be displayed", () {
          test("Items are not added from favourite worksheet", () {
            data.selectedFromFavourite = false;
            data.workSheet?.file?.myFavouriteEntity = null;
            actions = WorksheetMoreActionService.getActions(params: params);
            expect(moreActionExists(WorksheetConstants.unMarkAsFavourite), isFalse);
          });

          test("Items are added from favourite worksheet", () {
            data.selectedFromFavourite = true;
            actions = WorksheetMoreActionService.getActions(params: params);
            expect(moreActionExists(WorksheetConstants.unMarkAsFavourite), isFalse);
          });

          test("Worksheet has not favourite entity available", () {
            data.workSheet?.file?.myFavouriteEntity = null;
            actions = WorksheetMoreActionService.getActions(params: params);
            expect(moreActionExists(WorksheetConstants.markAsFavourite), isFalse);
          });
        });
      });

      group("Add template pages action should be displayed conditionally", () {
        group("Action should not be displayed", () {
          test("When worksheet is not of type proposal", () {
            data.worksheetType = WorksheetConstants.estimate;
            actions = WorksheetMoreActionService.getActions(params: params);
            expect(moreActionExists(WorksheetConstants.addTemplatePages), isFalse);
          });

          test("When there is no line item", () {
            data.lineItems = [];
            actions = WorksheetMoreActionService.getActions(params: params);
            expect(moreActionExists(WorksheetConstants.addTemplatePages), isFalse);
          });

          test("When company templates are empty", () {
            data.companyTemplates = [];
            actions = WorksheetMoreActionService.getActions(params: params);
            expect(moreActionExists(WorksheetConstants.addTemplatePages), isFalse);
          });

          test("When worksheet pages do exists", () {
            data.workSheet?.pagesExist == 1;
            actions = WorksheetMoreActionService.getActions(params: params);
            expect(moreActionExists(WorksheetConstants.addTemplatePages), isFalse);
          });
        });

        test('Action should be displayed when all the conditions are met', () {
          data.worksheetType = WorksheetConstants.proposal;
          data.lineItems = [lineItem];
          data.companyTemplates = [FormProposalTemplateModel()];
          data.workSheet?.pagesExist == 0;
          actions = WorksheetMoreActionService.getActions(params: params);
          expect(moreActionExists(WorksheetConstants.addTemplatePages), isTrue);
        });
      });

      group("Edit template pages action should be displayed conditionally", () {
        group("Action should not be displayed", () {
          test("When worksheet is not of type proposal", () {
            data.worksheetType = WorksheetConstants.estimate;
            actions = WorksheetMoreActionService.getActions(params: params);
            expect(moreActionExists(WorksheetConstants.editTemplatePages), isFalse);
          });

          test("When there is no line item", () {
            data.lineItems = [];
            actions = WorksheetMoreActionService.getActions(params: params);
            expect(moreActionExists(WorksheetConstants.editTemplatePages), isFalse);
          });

          test("When company templates are empty", () {
            data.companyTemplates = [];
            actions = WorksheetMoreActionService.getActions(params: params);
            expect(moreActionExists(WorksheetConstants.editTemplatePages), isFalse);
          });

          test("When worksheet pages do not exists", () {
            data.workSheet?.pagesExist == 0;
            actions = WorksheetMoreActionService.getActions(params: params);
            expect(moreActionExists(WorksheetConstants.editTemplatePages), isFalse);
          });
        });

        test('Action should be displayed when all the conditions are met', () {
          data.worksheetType = WorksheetConstants.proposal;
          data.lineItems = [lineItem];
          data.companyTemplates = [FormProposalTemplateModel()];
          data.workSheet = WorksheetModel(
            pagesExist: 1
          );
          actions = WorksheetMoreActionService.getActions(params: params);
          expect(moreActionExists(WorksheetConstants.editTemplatePages), isTrue);
        });
      });
    });
  });

  group("WorksheetMoreActionService@getLineItems should give parsed line items", () {
    test("Empty list should be returned for no items", () {
      service.params = params;
      data.lineItems = [];
      expect(service.getLineItems(), hasLength(0));
    });

    test("Complete list should be returned for items, when exclude is false", () {
      data.lineItems = [lineItem, lineItem];
      expect(service.getLineItems(), hasLength(2));
    });

    test("Items excluding measurement should be returned", () {
      data.lineItems = [lineItem, lineItem2..tier1MeasurementId = '5'];
      expect(service.getLineItems(excludeMeasurement: true), hasLength(1));
    });
  });

  group("WorksheetMoreActionService@discardMeasurement should unlink the linked measurement", () {
    test("Worksheet measurement should be removed", () {
      params.data.worksheetMeasurement = MeasurementModel();
      service.discardMeasurement();
      expect(params.data.worksheetMeasurement, isNull);
    });

    test("Measurement id should be removed", () {
      params.data.measurementId = 5;
      service.discardMeasurement();
      expect(params.data.measurementId, isNull);
    });
  });

  group("WorksheetMoreActionService@expandCollapseTier should expand/collapse tiers", () {
    test("All tiers should be expanded, when all tiers were collapsed", () {
      tier1.isTierExpanded = tier2.isTierExpanded = false;
      params.data.lineItems = [tier1, tier2];
      service.expandCollapseTier();
      expect(params.data.lineItems[0].isTierExpanded, isTrue);
      expect(params.data.lineItems[1].isTierExpanded, isTrue);
    });

    test("All collapsed tiers should be expanded, when all limited tiers were collapsed", () {
      tier1.isTierExpanded = true;
      tier2.isTierExpanded = false;
      params.data.lineItems = [tier1, tier2];
      service.expandCollapseTier();
      expect(params.data.lineItems[0].isTierExpanded, isTrue);
      expect(params.data.lineItems[1].isTierExpanded, isTrue);
    });

    test("All tiers should be collapsed, when all tiers were expanded", () {
      tier1.isTierExpanded = tier2.isTierExpanded = true;
      params.data.lineItems = [tier1, tier2];
      service.expandCollapseTier(expand: false);
      expect(params.data.lineItems[0].isTierExpanded, isFalse);
      expect(params.data.lineItems[1].isTierExpanded, isFalse);
    });

    test("All expanded tiers should be collapsed, when all limited tiers were expanded", () {
      tier1.isTierExpanded = true;
      tier2.isTierExpanded = false;
      params.data.lineItems = [tier1, tier2];
      service.expandCollapseTier(expand: false);
      expect(params.data.lineItems[0].isTierExpanded, isFalse);
      expect(params.data.lineItems[1].isTierExpanded, isFalse);
    });
  });

  group("WorksheetMoreActionService@removeAllTiers should remove all the tier", () {
    test("Where there are no tiers, nothing should happen", () {
      params.data.lineItems = [lineItem];
      service.removeAllTiers();
      expect(params.data.lineItems, hasLength(1));
    });

    test("Where there are empty tiers, they should be removed", () {
      params.data.lineItems = [tier1..subItems=[]];
      params.hasTiers = true;
      service.removeAllTiers();
      expect(params.data.lineItems, hasLength(0));
    });

    test("Where there are non-empty tiers, they should be removed but line items should left", () {
      params.data.lineItems = [tier1..subItems = [lineItem, lineItem2]];
      service.removeAllTiers();
      expect(params.data.lineItems, hasLength(2));
    });

    test("Worksheet tiers setting should be disabled on removing all tiers", () {
      params.data.lineItems = [tier1..subItems = [lineItem, lineItem2]];
      params.data.settings = WorksheetSettingModel.fromJson({});
      service.removeAllTiers();
      expect(params.data.settings?.hasTier, isFalse);
    });
  });

  group("WorksheetMoreActionService@removeZeroQuantityItems should remove all the items with zero quantity", () {
    test("When there are no zero quantity items, nothing should happen", () {
      params.hasTiers = false;
      params.data.lineItems = [
        lineItem..qty = '5',
        lineItem2..qty = '5',
      ];
      service.removeZeroQuantityItems();
      expect(params.data.lineItems, hasLength(2));
    });

    test("When there are zero quantity items, they should be removed", () {
      params.data.lineItems = [
        lineItem..qty = '0',
        lineItem2..qty = '5',
      ];
      service.removeZeroQuantityItems();
      expect(params.data.lineItems, hasLength(1));
    });

    test("When there are no quantity items, they should be removed", () {
      params.data.lineItems = [
        lineItem..qty = null,
        lineItem2..qty = '5',
      ];
      service.removeZeroQuantityItems();
      expect(params.data.lineItems, hasLength(1));
    });

    test("When items with zero quantity exist inside tier, they should be removed", () {
      params.data.lineItems = [
        tier1..subItems = [
          lineItem..qty = '0',
          lineItem2..qty = '5',
        ]
      ];
      params.hasTiers = true;
      service.removeZeroQuantityItems();
      expect(params.data.lineItems, hasLength(1));
    });
  });

  group("WorksheetFormData@isAnySupplierEnabled should check is any material supplier enabled or not", () {
    test("When SRS is enabled, it should return true", () {
      data.isSRSEnable = true;
      expect(data.isAnySupplierEnabled, isTrue);
    });

    test("When Beacon is enabled, it should return true", () {
      data.isBeaconEnable = true;
      expect(data.isAnySupplierEnabled, isTrue);
    });

    test("When no supplier is enabled, it should return false", () {
      data.isBeaconEnable = false;
      data.isSRSEnable = false;
      expect(data.isAnySupplierEnabled, isFalse);
    });
  });

  group("WorksheetFormData@getSupplierDetails should return supplier details", () {
    test('Returns SRS branch details when SRS is enabled', () {
      data.isSRSEnable = true;
      data.selectedSrsBranch = SupplierBranchModel(
          name: 'BRANCH_NAME',
          branchCode: '300'
      );
      expect(data.getSupplierDetails, contains('SRS branch: BRANCH_NAME (300)'));
    });

    test('Returns Beacon branch details when Beacon is enabled', () {
      data.isSRSEnable = false;
      data.isBeaconEnable = true;
      data.selectedBeaconBranch = SupplierBranchModel(
          name: 'BRANCH_NAME',
          branchCode: '300'
      );
      expect(data.getSupplierDetails, contains('qxo branch: BRANCH_NAME (300)'));
    });

    test('Returns empty string when neither SRS nor Beacon is enabled', () {
      data.isSRSEnable = false;
      data.isBeaconEnable = false;
      expect(data.getSupplierDetails, isEmpty);
    });
  });

  group("WorksheetMoreActionService@getTierSubTotalsActions should give tier subtotal actions", () {
    test("All tiers should be expanded, when all tiers were collapsed", () {
      final result = WorksheetMoreActionService.getTierSubTotalsActions();
      expect(result, hasLength(4));
      expect(result[0].value, WorksheetConstants.tierSubTotal);
      expect(result[1].value, WorksheetConstants.tierLineTotal);
      expect(result[2].value, WorksheetConstants.tierProfit);
      expect(result[3].value, WorksheetConstants.tierTax);
    });
  });

  group("WorksheetMoreActionService@doSkipDivisionCheck should conditionally skip division check", () {
    setUp(() {
      service.data.job = tempJob;
    });

    test('Division check should be skipped if job has no division', () {
      service.data.job?.division = null;
      final favFile = FilesListingModel(division: DivisionModel(id: 1));
      expect(service.doSkipDivisionCheck(favFile), isTrue);
    });

    test('Division check should be skipped if favourite file has no division', () {
      service.data.job?.division = DivisionModel(id: 1);
      final favFile = FilesListingModel(division: null);
      expect(service.doSkipDivisionCheck(favFile), isTrue);
    });

    test('Division check should be skipped when job division and favourite file division are the same', () {
      service.data.job?.division = DivisionModel(id: 1);
      final favFile = FilesListingModel(division: DivisionModel(id: 1));
      expect(service.doSkipDivisionCheck(favFile), isTrue);
    });

    test('Division check should be executed when job division and favourite file division are different', () {
      service.data.job?.division = DivisionModel(id: 1);
      final favFile = FilesListingModel(division: DivisionModel(id: 2));
      expect(service.doSkipDivisionCheck(favFile), isFalse);
    });
  });
}
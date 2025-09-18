import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/enums/macro.dart';
import 'package:jobprogress/common/enums/run_mode.dart';
import 'package:jobprogress/common/enums/supplier_form_type.dart';
import 'package:jobprogress/common/models/address/address.dart';
import 'package:jobprogress/common/models/financial_product/variants_model.dart';
import 'package:jobprogress/common/models/job/job_division.dart';
import 'package:jobprogress/common/models/sql/company/company.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/models/suppliers/beacon/default_branch_model.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/financial_product/financial_product_model.dart';
import 'package:jobprogress/common/models/forms/measurement/measurement.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job_financial/tax_model.dart';
import 'package:jobprogress/common/models/launchdarkly/flags.dart';
import 'package:jobprogress/common/models/macros/index.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/common/models/sql/state/state.dart';
import 'package:jobprogress/common/models/suppliers/beacon/account.dart';
import 'package:jobprogress/common/models/suppliers/beacon/job.dart';
import 'package:jobprogress/common/models/suppliers/branch.dart';
import 'package:jobprogress/common/models/suppliers/srs/srs_ship_to_address.dart';
import 'package:jobprogress/common/models/suppliers/suppliers.dart';
import 'package:jobprogress/common/models/worksheet/settings/index.dart';
import 'package:jobprogress/common/models/worksheet/worksheet_model.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/common/services/connected_third_party.dart';
import 'package:jobprogress/common/services/run_mode/index.dart';
import 'package:jobprogress/common/services/worksheet/helpers.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/connected_third_party_constants.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/core/constants/worksheet.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

void main() {

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

  List<SheetLineItemModel> lineItemWithCategories = [
    SheetLineItemModel(
      productId: '1',
      title: 'Test',
      price: '100',
      qty: '2',
      totalPrice: '200',
    )..categoryName = 'Category A',
    SheetLineItemModel(
      productId: '1',
      title: 'Test',
      price: '100',
      qty: '2',
      totalPrice: '200',
    )..categoryName = 'Category B',
  ];

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
    parent: tier1
  );

  SheetLineItemModel tier3 = SheetLineItemModel.tier(
    title: 'Test 3',
    totalPrice: '200',
    tier: 3,
    workSheetSettings: WorksheetSettingModel(),
    parent: tier2,
  );

  MacroListingModel macroItem = MacroListingModel(
    tradeId: 1,
    fixedPrice: 100,
    details: [
      tier1,
      tier2
    ],
  );

  List<MacroListingModel> macrosList = [
    MacroListingModel(tradeId: 1, fixedPrice: 100),
    MacroListingModel(tradeId: 2, fixedPrice: 200),
  ];

  List<JPSingleSelectModel> selectableTrades = [
    JPSingleSelectModel(id: "1", label: 'Trade 1'),
    JPSingleSelectModel(id: "2", label: 'Trade 2'),
  ];

  List<SheetLineItemModel> lineItems = [
    lineItem,
    lineItem,
    lineItem,
    lineItem,
  ];

  List<SheetLineItemModel> tiers = [
    tier3,
    tier2,
  ];

  FinancialProductModel product = FinancialProductModel();
  VariantModel variantModel = VariantModel();

  setUpAll(() {
    RunModeService.setRunMode(RunMode.unitTesting);
    Get.testMode = true;
    tier1.subItems = [tier2];
    tier2.subItems = [tier3];
    tier3.subItems = [lineItem];
    AuthService.userDetails = UserModel(
        id: '1',
        firstName: 'Dummy',
        fullName: 'Dummy User',
        email: 'test@demo.com',
        companyDetails: CompanyModel(
            id: 1,
            companyName: 'Demo'
        )
    );
  });

  WorksheetModel worksheet = WorksheetModel(
    materialTaxRate: '5',
    laborTaxRate: '5',
    taxRate: '5'
  );

  WorksheetModel emptyWorksheet = WorksheetModel();

  WorksheetModel worksheetWithSRS = WorksheetModel(
    supplierBranch: SupplierBranchModel(),
    srsShipToAddressModel: SrsShipToAddressModel(),
    lineItems: [
      lineItem
    ],
    suppliers: [
      SuppliersModel(
        id: Helper.getSupplierId(key: CommonConstants.srsId),
      )
    ]
  );

  WorksheetModel worksheetWithBeacon = WorksheetModel(
      supplierBranch: SupplierBranchModel(),
      srsShipToAddressModel: SrsShipToAddressModel(),
      lineItems: [
        lineItem
      ],
      suppliers: [
        SuppliersModel(
          id: Helper.getSupplierId(key: CommonConstants.beaconId),
        )
      ]
  );

  JobModel jobWithTax = JobModel(
    id: 1,
    customerId: 1,
    address: AddressModel(
      id: 1,
      state: StateModel(
        id: 1,
        name: 'Test',
        code: 'TT',
        countryId: 4,
        tax: TaxModel(
          materialTaxRate: 15,
          laborTaxRate: 15,
          taxRate: 15,
        )
      ),
      stateTax: 15
    )
  );

  List<DivisionModel> divisions = [
    DivisionModel()
  ];

  DefaultBranchModel defaultBranchModel = DefaultBranchModel();

  SrsShipToAddressModel? selectedSrsShipToAddress = SrsShipToAddressModel(shipToSequenceId: '1');
  SupplierBranchModel? selectedSrsBranch = SupplierBranchModel(branchId: '3');
  SupplierBranchModel? selectedBeaconBranch =  SupplierBranchModel(branchId: '4');
  SrsShipToAddressModel? selectedAbcAccount =  SrsShipToAddressModel(shipToId: '2');
  SupplierBranchModel? selectedAbcBranch = SupplierBranchModel(branchId: '4');

  group("WorksheetHelpers@getParsedItems should convert tier hierarchy into linear items", () {
    group("Items should remain as it is", () {
      test("When line items does not exist", () {
        final items = WorksheetHelpers.getParsedItems(lineItems: []);
        expect(items, isEmpty);
      });

      test("When line items are already linear", () {
        final items = WorksheetHelpers.getParsedItems(lineItems: lineItems);
        expect(items, lineItems);
      });
    });

    group("Hierarchical items should be converted to linear items", () {
      test("When only single tier exists", () {
        final items = WorksheetHelpers.getParsedItems(lineItems: [tier3]);
        expect(items.length, equals(1));
      });

      test("When single tier exists with nested tiers", () {
        final items = WorksheetHelpers.getParsedItems(lineItems: [tier1]);
        expect(items.length, equals(1));
      });

      test("When list of tier exists with nested tiers", () {
        final items = WorksheetHelpers.getParsedItems(lineItems: tiers);
        expect(items.length, equals(2));
      });

      test("Tier should not be the part of line items", () {
        final items = WorksheetHelpers.getParsedItems(lineItems: [tier3]);
        expect(items.length, isNot(equals(2)));
      });
    });

    group("Tier details should be attached with items", () {
      setUp(() {
        lineItems.first.tier1 = null;
        lineItems.first.tier1Description = null;
        lineItems.first.tier2 = null;
        lineItems.first.tier2Description = null;
        lineItems.first.tier3 = null;
        lineItems.first.tier3Description = null;
      });

      group("Tier details should not be attached", () {
        test("When items are already linear", () {
          final items = WorksheetHelpers.getParsedItems(lineItems: lineItems, attachTierDetails: false);
          expect(items.first.tier1, isNull);
        });

        test("When tier details are not requested", () {
          final items = WorksheetHelpers.getParsedItems(lineItems: [tier3], attachTierDetails: false);
          expect(items.first.tier1, isNull);
          expect(items.first.tier1Description, isNull);
          expect(items.first.tier2, isNull);
          expect(items.first.tier2Description, isNull);
          expect(items.first.tier3, isNull);
          expect(items.first.tier3Description, isNull);
        });
      });

      group("Tier details should be attached", () {
        test("In case of single level tier", () {
          final items = WorksheetHelpers.getParsedItems(lineItems: [tier1], attachTierDetails: true);
          expect(items.first.tier1, isNotNull);
          expect(items.first.tier1Description, isNotNull);
          expect(items.first.tier2, isNull);
          expect(items.first.tier2Description, isNull);
          expect(items.first.tier3, isNull);
          expect(items.first.tier3Description, isNull);
        });

        test("In case of two level tier", () {
          final items = WorksheetHelpers.getParsedItems(lineItems: [tier2], attachTierDetails: true);
          expect(items.first.tier1, isNotNull);
          expect(items.first.tier1Description, isNotNull);
          expect(items.first.tier2, isNotNull);
          expect(items.first.tier2Description, isNotNull);
          expect(items.first.tier3, isNull);
          expect(items.first.tier3Description, isNull);
        });

        test("In case of three level tier", () {
          final items = WorksheetHelpers.getParsedItems(lineItems: [tier3], attachTierDetails: true);
          expect(items.first.tier1, isNotNull);
          expect(items.first.tier1Description, isNotNull);
          expect(items.first.tier2, isNotNull);
          expect(items.first.tier2Description, isNotNull);
          expect(items.first.tier3, isNotNull);
          expect(items.first.tier3Description, isNotNull);
        });

        test("When list of tier exists with nested tiers", () {
          final items = WorksheetHelpers.getParsedItems(lineItems: tiers, attachTierDetails: true);
          expect(items[0].tier1, isNotNull);
          expect(items[0].tier1Description, isNotNull);
          expect(items[0].tier2, isNotNull);
          expect(items[0].tier2Description, isNotNull);
          expect(items[0].tier3, isNotNull);
          expect(items[0].tier3Description, isNotNull);
          expect(items[1].tier1, isNotNull);
          expect(items[1].tier1Description, isNotNull);
          expect(items[1].tier2, isNotNull);
          expect(items[1].tier2Description, isNotNull);
          expect(items[1].tier3, isNull);
          expect(items[1].tier3Description, isNull);
        });
      });
    });

    group('Tier details should start from a specific index', () {
      group("In case tier is 3 level deep", () {
        group("When tier index is 3", () {
          List<SheetLineItemModel> items = [];
          setUp(() {
            items = WorksheetHelpers.getParsedItems(
              lineItems: [tier3],
              tierIndex: 3,
              attachTierDetails: true,
            );
          });

          test("Details should be attached for level 1 only", () {
            expect(items.first.tier1, isNotNull);
            expect(items.first.tier1Description, isNotNull);
          });

          test("Details should not be attached for level 2 and 3", () {
            expect(items.first.tier2, isNull);
            expect(items.first.tier2Description, isNull);
            expect(items.first.tier3, isNull);
            expect(items.first.tier3Description, isNull);
          });
        });

        group("When tier index is 2", () {
          List<SheetLineItemModel> items = [];
          setUp(() {
            items = WorksheetHelpers.getParsedItems(
              lineItems: [tier3],
              tierIndex: 2,
              attachTierDetails: true,
            );
          });

          test("Details should be attached for level 1 and level 2", () {
            expect(items.first.tier1, isNotNull);
            expect(items.first.tier1Description, isNotNull);
            expect(items.first.tier2, isNotNull);
            expect(items.first.tier2Description, isNotNull);
          });

          test("Details should not be attached for level 3", () {
            expect(items.first.tier3, isNull);
            expect(items.first.tier3Description, isNull);
          });
        });

        group("When tier index is 1", () {
          List<SheetLineItemModel> items = [];
          setUp(() {
            items = WorksheetHelpers.getParsedItems(
              lineItems: [tier3],
              tierIndex: 1,
              attachTierDetails: true,
            );
          });

          test("Details should be attached for all the levels", () {
            expect(items.first.tier1, isNotNull);
            expect(items.first.tier1Description, isNotNull);
            expect(items.first.tier2, isNotNull);
            expect(items.first.tier2Description, isNotNull);
            expect(items.first.tier3, isNotNull);
            expect(items.first.tier3Description, isNotNull);
          });
        });
      });

      group("In case tier is 2 level deep", () {
        group("When tier index is 3", () {
          List<SheetLineItemModel> items = [];
          setUp(() {
            items = WorksheetHelpers.getParsedItems(
              lineItems: [tier2],
              tierIndex: 3,
              attachTierDetails: true,
            );
          });

          test("Details should be attached for level 1 only", () {
            expect(items.first.tier1, isNotNull);
            expect(items.first.tier1Description, isNotNull);
          });

          test("Details should not be attached for level 2 and 3", () {
            expect(items.first.tier2, isNull);
            expect(items.first.tier2Description, isNull);
            expect(items.first.tier3, isNull);
            expect(items.first.tier3Description, isNull);
          });
        });

        group("When tier index is 2", () {
          List<SheetLineItemModel> items = [];
          setUp(() {
            items = WorksheetHelpers.getParsedItems(
              lineItems: [tier2],
              tierIndex: 2,
              attachTierDetails: true,
            );
          });

          test("Details should be attached for level 1", () {
            expect(items.first.tier1, isNotNull);
            expect(items.first.tier1Description, isNotNull);
          });

          test("Details should not be attached for level 2 and 3", () {
            expect(items.first.tier2, isNull);
            expect(items.first.tier2Description, isNull);
            expect(items.first.tier3, isNull);
            expect(items.first.tier3Description, isNull);
          });
        });

        group("When tier index is 1", () {
          List<SheetLineItemModel> items = [];
          setUp(() {
            items = WorksheetHelpers.getParsedItems(
              lineItems: [tier2],
              tierIndex: 1,
              attachTierDetails: true,
            );
          });

          test("Details should be attached for level 1 and 2", () {
            expect(items.first.tier1, isNotNull);
            expect(items.first.tier1Description, isNotNull);
            expect(items.first.tier2, isNotNull);
            expect(items.first.tier2Description, isNotNull);
          });

          test("Details should not be attached for level 3", () {
            expect(items.first.tier3, isNull);
            expect(items.first.tier3Description, isNull);
          });
        });
      });

      group("In case tier is 1 level deep", () {
        group("When tier index is 3", () {
          List<SheetLineItemModel> items = [];
          setUp(() {
            items = WorksheetHelpers.getParsedItems(
              lineItems: [tier1],
              tierIndex: 3,
              attachTierDetails: true,
            );
          });

          test("Details should be attached for level 1 only", () {
            expect(items.first.tier1, isNotNull);
            expect(items.first.tier1Description, isNotNull);
          });

          test("Details should not be attached for level 2 and 3", () {
            expect(items.first.tier2, isNull);
            expect(items.first.tier2Description, isNull);
            expect(items.first.tier3, isNull);
            expect(items.first.tier3Description, isNull);
          });
        });

        group("When tier index is 2", () {
          List<SheetLineItemModel> items = [];
          setUp(() {
            items = WorksheetHelpers.getParsedItems(
              lineItems: [tier1],
              tierIndex: 2,
              attachTierDetails: true,
            );
          });

          test("Details should be attached for level 1", () {
            expect(items.first.tier1, isNotNull);
            expect(items.first.tier1Description, isNotNull);
          });

          test("Details should not be attached for level 2 and 3", () {
            expect(items.first.tier2, isNull);
            expect(items.first.tier2Description, isNull);
            expect(items.first.tier3, isNull);
            expect(items.first.tier3Description, isNull);
          });
        });

        group("When tier index is 1", () {
          List<SheetLineItemModel> items = [];
          setUp(() {
            items = WorksheetHelpers.getParsedItems(
              lineItems: [tier1],
              tierIndex: 1,
              attachTierDetails: true,
            );
          });

          test("Details should be attached for level 1", () {
            expect(items.first.tier1, isNotNull);
            expect(items.first.tier1Description, isNotNull);
          });

          test("Details should not be attached for level 2 and 3", () {
            expect(items.first.tier2, isNull);
            expect(items.first.tier2Description, isNull);
            expect(items.first.tier3, isNull);
            expect(items.first.tier3Description, isNull);
          });
        });
      });
    });

    group("Tier details should contain empty line item for missing macro tiers", () {
      test("Empty line item should be added to the list", () {
        List<SheetLineItemModel> items = WorksheetHelpers.getParsedItems(
            lineItems: [
              tier1
                ..isMacroNotFound = true
                ..subItems = []
                ..subTiers = [],
            ],
            addEmptyTier: true
        );

        expect(items.length, equals(1));
      });

      test("Empty line item should be added to the list, is [addEmptyTier] is false", () {
        List<SheetLineItemModel> items = WorksheetHelpers.getParsedItems(
            lineItems: [
              tier1
                ..isMacroNotFound = true
                ..subItems = []
                ..subTiers = [],
            ],
            addEmptyTier: false
        );

        expect(items.length, equals(0));
      });

      test("Empty line item should not be added to the list if macro is not missing", () {
        List<SheetLineItemModel> items = WorksheetHelpers.getParsedItems(
            lineItems: [
              tier1
                ..isMacroNotFound = false
                ..subItems = []
                ..subTiers = [],
            ],
            addEmptyTier: true
        );

        expect(items.length, equals(0));
      });

      test("Empty line item should not be added to the list if tier has sub items", () {
        List<SheetLineItemModel> items = WorksheetHelpers.getParsedItems(
            lineItems: [
              tier1
                ..isMacroNotFound = true
                ..subItems = [lineItem]
                ..subTiers = [],
            ],
            addEmptyTier: true
        );
        expect(items.length, equals(1));
      });

      test("Empty line item should not be added to the list if tier has sub tiers", () {
        List<SheetLineItemModel> items = WorksheetHelpers.getParsedItems(
            lineItems: [
              tier1
                ..isMacroNotFound = true
                ..subItems = []
                ..subTiers = [tier2],
            ],
            addEmptyTier: true
        );
        expect(items.length, equals(1));
      });
    });
  });

  group("WorksheetHelpers@tierIterator should iterate over single line item for manipulating data", () {
    test("Data manipulation should not happen when action is empty", () {
      WorksheetHelpers.tierIterator(lineItem, action: (_) {});
      expect(lineItem.price, '100');
    });

    test("Data manipulation should happen when action is given", () {
      WorksheetHelpers.tierIterator(lineItem, action: (item) {
        item.price = '200';
      });
      expect(lineItem.price, '200');
    });
  });

  group("WorksheetHelpers@tierListIterator should iterate over list of line item for manipulating data", () {
    test("Data manipulation should not happen when action is empty", () {
      WorksheetHelpers.tierListIterator(lineItems, action: (_) {});
      expect(lineItem.price, '200');
    });

    test("Data manipulation should happen when action is given", () {
      WorksheetHelpers.tierListIterator(lineItems, action: (item) {
        item.price = '100';
      });
      expect(lineItem.price, '100');
    });
  });

  group("WorksheetHelpers@reCalculateLineTotal should re-calculate line total", () {
    group("Line item total should be updated correctly", () {
      test("When no changes made in item details", () {
        WorksheetHelpers.reCalculateLineTotal(lineItems);
        expect(lineItems.first.totalPrice, lineItem.totalPrice);
      });

      test("When changes made in item details", () {
        lineItem.qty = '3';
        WorksheetHelpers.reCalculateLineTotal(lineItems);
        expect(lineItems.first.totalPrice, lineItem.totalPrice);
      });
    });

    group("Item quantity should be overridden in case of measurement is attached", () {

      group("Actual quantity not available", () {
        setUp(() {
          lineItem.actualQty = null;
          lineItem.qty = '3';
        });

        test("When actual quantity is not available and request is for reset quantity", () {
          WorksheetHelpers.reCalculateLineTotal([lineItem], resetQuantity: true);
          expect(lineItem.qty, '0');
          expect(lineItem.actualQty, isNull);
        });
      });

      group("Item quantity should be updated", () {
        setUp(() {
          lineItem.actualQty = '5';
          lineItem.qty = '3';
        });

        test("When actual quantity is available and request is for reset quantity", () {
          WorksheetHelpers.reCalculateLineTotal([lineItem], resetQuantity: true);
          expect(lineItem.qty, lineItem.actualQty);
        });
      });

      group("Item quantity should not be updated", () {
        setUp(() {
          lineItem.actualQty = '5';
          lineItem.qty = '3';
        });

        test("When reset quantity is not requested", () {
          WorksheetHelpers.reCalculateLineTotal([lineItem], resetQuantity: false);
          expect(lineItem.qty, isNot(equals(lineItem.actualQty)));
        });

        test("When actual quantity does not exist", () {
          lineItem.actualQty = null;
          WorksheetHelpers.reCalculateLineTotal([lineItem], resetQuantity: true);
          expect(lineItem.qty, isNot(equals(lineItem.actualQty)));
        });
      });
    });
  });

  group("WorksheetHelpers@getMaterialTaxRate should give correct material tax rate to be applied by default", () {
    group("When quickbook or QBD is connected", () {
      group("When quick book is connected", () {
        setUp(() {
          ConnectedThirdPartyService.connectedThirdParty.clear();
          ConnectedThirdPartyService.connectedThirdParty.addAll({
            ConnectedThirdPartyConstants.quickbook: {
              ConnectedThirdPartyConstants.quickbookCompanyId: '1',
            }
          });
        });

        group("Material tax rate coming along with worksheet should be used", () {
          test("When material tax rate exists", () {
            num rate = WorksheetHelpers.getMaterialTaxRate(worksheet: worksheet);
            expect(rate, 5);
          });

          test("When material tax rate doed not exists", () {
            num rate = WorksheetHelpers.getMaterialTaxRate(worksheet: emptyWorksheet);
            expect(rate, 0);
          });
        });
      });

      group("When QBD is connected", () {
        setUp(() {
          ConnectedThirdPartyService.connectedThirdParty.clear();
          ConnectedThirdPartyService.connectedThirdParty.addAll({
            ConnectedThirdPartyConstants.quickbookDesktop: true
          });
        });

        group("Material tax rate coming along with worksheet should be used", () {
          test("When material tax rate exists", () {
            num rate = WorksheetHelpers.getMaterialTaxRate(worksheet: worksheet);
            expect(rate, 5);
          });

          test("When material tax rate doed not exists", () {
            num rate = WorksheetHelpers.getMaterialTaxRate(worksheet: emptyWorksheet);
            expect(rate, 0);
          });
        });
      });
    });

    group('When quickbook or QBD is not connected', () {
      setUp(() {
        ConnectedThirdPartyService.connectedThirdParty.clear();
      });

      test("If worksheet has custom material tax it should be used", () {
        worksheet.customMaterialTax = TaxModel(taxRate: 8);
        num rate = WorksheetHelpers.getMaterialTaxRate(worksheet: worksheet);
        expect(rate, worksheet.customMaterialTax?.taxRate);
        worksheet.customMaterialTax = null;
      });

      group("If worksheet custom material tax does not exist and job state tax is available", () {
        group("When worksheet is created for multi project job", () {
          test("In case of project, state material tax should be used from parent job", () {
            jobWithTax.isProject = true;
            jobWithTax.parent = jobWithTax;
            num rate = WorksheetHelpers.getMaterialTaxRate(jobModel: jobWithTax);
            expect(rate, jobWithTax.parent?.address?.state?.tax?.materialTaxRate);
            jobWithTax.isProject = false;
            jobWithTax.parent = null;
          });
          test("In case of parent job, state material tax should be used from job directly", () {
            jobWithTax.parent = jobWithTax;
            num rate = WorksheetHelpers.getMaterialTaxRate(jobModel: jobWithTax);
            expect(rate, jobWithTax.address?.state?.tax?.materialTaxRate);
            jobWithTax.parent = null;
          });
        });

        group("When worksheet is created for non multi project job", () {
          test("State material tax should be used from job directly", () {
            num rate = WorksheetHelpers.getMaterialTaxRate(jobModel: jobWithTax);
            expect(rate, jobWithTax.address?.state?.tax?.materialTaxRate);
          });
        });
      });

      group("If worksheet custom material tax does not exist and job state tax is not available", () {
        group("When company settings has material tax rate available", () {
          setUp(() {
            CompanySettingsService.setCompanySettings([{
              'key': CompanySettingConstants.materialTaxRate,
              'value': 0.2,
            }]);
          });

          test("Tax rate from company settings should be used", () {
            num rate = WorksheetHelpers.getMaterialTaxRate();
            expect(rate, 0.2);
          });
        });

        group("When company settings does not have material tax rate available", () {
          setUp(() {
            CompanySettingsService.companySettings.clear();
          });

          test("Tax rate from company settings should be used", () {
            num rate = WorksheetHelpers.getMaterialTaxRate();
            expect(rate, 0);
          });
        });
      });
    });
  });

  group("WorksheetHelpers@getLaborTaxRate should give correct material tax rate to be applied by default", () {
    group("When quickbook or QBD is connected", () {
      group("When quick book is connected", () {
        setUp(() {
          ConnectedThirdPartyService.connectedThirdParty.clear();
          ConnectedThirdPartyService.connectedThirdParty.addAll({
            ConnectedThirdPartyConstants.quickbook: {
              ConnectedThirdPartyConstants.quickbookCompanyId: '1',
            }
          });
        });

        group("Labor tax rate coming along with worksheet should be used", () {
          test("When material tax rate exists", () {
            num rate = WorksheetHelpers.getLaborTaxRate(worksheet: worksheet);
            expect(rate, 5);
          });

          test("When labor tax rate does not exists", () {
            num rate = WorksheetHelpers.getLaborTaxRate(worksheet: emptyWorksheet);
            expect(rate, 0);
          });
        });
      });

      group("When QBD is connected", () {
        setUp(() {
          ConnectedThirdPartyService.connectedThirdParty.clear();
          ConnectedThirdPartyService.connectedThirdParty.addAll({
            ConnectedThirdPartyConstants.quickbookDesktop: true
          });
        });

        group("Labor tax rate coming along with worksheet should be used", () {
          test("When labor tax rate exists", () {
            num rate = WorksheetHelpers.getLaborTaxRate(worksheet: worksheet);
            expect(rate, 5);
          });

          test("When labor tax rate does not exists", () {
            num rate = WorksheetHelpers.getLaborTaxRate(worksheet: emptyWorksheet);
            expect(rate, 0);
          });
        });
      });
    });

    group('When quickbook or QBD is not connected', () {
      setUp(() {
        ConnectedThirdPartyService.connectedThirdParty.clear();
      });

      test("If worksheet has custom labor tax it should be used", () {
        worksheet.customLaborTax = TaxModel(taxRate: 8);
        num rate = WorksheetHelpers.getLaborTaxRate(worksheet: worksheet);
        expect(rate, worksheet.customLaborTax?.taxRate);
        worksheet.customMaterialTax = null;
      });

      group("If worksheet custom labor does not exist and job state tax is available", () {
        group("When worksheet is created for multi project job", () {
          test("In case of project, state labor tax should be used from parent job", () {
            jobWithTax.isProject = true;
            jobWithTax.parent = jobWithTax;
            num rate = WorksheetHelpers.getLaborTaxRate(jobModel: jobWithTax);
            expect(rate, jobWithTax.parent?.address?.state?.tax?.laborTaxRate);
            jobWithTax.isProject = false;
            jobWithTax.parent = null;
          });
          test("In case of parent job, state labor tax should be used from job directly", () {
            jobWithTax.parent = jobWithTax;
            num rate = WorksheetHelpers.getLaborTaxRate(jobModel: jobWithTax);
            expect(rate, jobWithTax.address?.state?.tax?.laborTaxRate);
            jobWithTax.parent = null;
          });
        });

        group("When worksheet is created for non multi project job", () {
          test("State labor tax should be used from job directly", () {
            num rate = WorksheetHelpers.getLaborTaxRate(jobModel: jobWithTax);
            expect(rate, jobWithTax.address?.state?.tax?.laborTaxRate);
          });
        });
      });

      group("If worksheet custom labor tax does not exist and job state tax is not available", () {

        test("Tax rate from company settings should be used if it exists", () {
          CompanySettingsService.setCompanySettings([{
            'key': CompanySettingConstants.laborTaxRate,
            'value': 0.2,
          }]);
          num rate = WorksheetHelpers.getLaborTaxRate();
          expect(rate, 0.2);
        });

        test("Tax rate should be zero if is is not available in company settings", () {
          CompanySettingsService.companySettings.clear();
          num rate = WorksheetHelpers.getLaborTaxRate();
          expect(rate, 0);
        });
      });
    });
  });

  group("WorksheetHelpers@getTaxAllRate should give correct material tax rate to be applied by default", () {
    group("When quickbook or QBD is connected", () {
      group("When quick book is connected", () {
        setUp(() {
          ConnectedThirdPartyService.connectedThirdParty.clear();
          ConnectedThirdPartyService.connectedThirdParty.addAll({
            ConnectedThirdPartyConstants.quickbook: {
              ConnectedThirdPartyConstants.quickbookCompanyId: '1',
            }
          });
        });

        group("Tax rate coming along with worksheet should be used", () {
          test("When tax rate exists", () {
            num rate = WorksheetHelpers.getTaxAllRate(worksheet: worksheet);
            expect(rate, 5);
          });

          test("When tax rate does not exists", () {
            num rate = WorksheetHelpers.getTaxAllRate(worksheet: emptyWorksheet);
            expect(rate, 0);
          });
        });
      });

      group("When QBD is connected", () {
        setUp(() {
          ConnectedThirdPartyService.connectedThirdParty.clear();
          ConnectedThirdPartyService.connectedThirdParty.addAll({
            ConnectedThirdPartyConstants.quickbookDesktop: true
          });
        });

        group("Tax rate coming along with worksheet should be used", () {
          test("When tax rate exists", () {
            num rate = WorksheetHelpers.getTaxAllRate(worksheet: worksheet);
            expect(rate, 5);
          });

          test("When tax rate does not exists", () {
            num rate = WorksheetHelpers.getTaxAllRate(worksheet: emptyWorksheet);
            expect(rate, 0);
          });
        });
      });
    });

    group('When quickbook or QBD is not connected', () {
      setUp(() {
        ConnectedThirdPartyService.connectedThirdParty.clear();
      });

      test("If worksheet has custom tax it should be used", () {
        worksheet.customTax = TaxModel(taxRate: 8);
        num rate = WorksheetHelpers.getTaxAllRate(worksheet: worksheet);
        expect(rate, worksheet.customTax?.taxRate);
        worksheet.customTax = null;
      });

      group("If worksheet custom tax does not exist and job state tax is available", () {
        group("When worksheet is created for multi project job", () {
          test("In case of project, state tax should be used from parent job", () {
            jobWithTax.isProject = true;
            jobWithTax.parent = jobWithTax;
            num rate = WorksheetHelpers.getTaxAllRate(jobModel: jobWithTax);
            expect(rate, jobWithTax.parent?.address?.state?.tax?.taxRate);
            jobWithTax.isProject = false;
            jobWithTax.parent = null;
          });
          test("In case of parent job, state tax should be used from job directly", () {
            jobWithTax.parent = jobWithTax;
            num rate = WorksheetHelpers.getTaxAllRate(jobModel: jobWithTax);
            expect(rate, jobWithTax.address?.stateTax);
            jobWithTax.parent = null;
          });
        });

        group("When worksheet is created for non multi project job", () {
          test("State tax should be used from job directly", () {
            num rate = WorksheetHelpers.getTaxAllRate(jobModel: jobWithTax);
            expect(rate, jobWithTax.address?.stateTax);
          });
        });
      });

      group("If worksheet custom tax does not exist and job state tax is not available", () {

        test("Tax rate from company settings should be used if it exists", () {
          CompanySettingsService.setCompanySettings([{
            'key': CompanySettingConstants.taxRate,
            'value': 0.2,
          }]);
          num rate = WorksheetHelpers.getTaxAllRate();
          expect(rate, 0.2);
        });

        test("Tax rate should be zero if is is not available in company settings", () {
          CompanySettingsService.companySettings.clear();
          num rate = WorksheetHelpers.getTaxAllRate();
          expect(rate, 0);
        });
      });
    });
  });

  group('WorksheetHelpers@getOverHeadRate should give correct overhead rate to be applied by default', () {
    test('Overhead should be zero when overHead is not available in company settings', () {
      var result = WorksheetHelpers.getOverHeadRate();
      expect(result, 0);
    });

    test('Overhead available in company settings should be used as default', () {
      CompanySettingsService.setCompanySettings([{
        'key': CompanySettingConstants.jobCostOverhead,
        'value': {
          'overhead': 5
        }
      }]);
      var result = WorksheetHelpers.getOverHeadRate();
      expect(result, 5);
    });

    test('Default overhead value should be parsed properly', () {
      CompanySettingsService.setCompanySettings([{
        'key': CompanySettingConstants.jobCostOverhead,
        'value': {
          'overhead': '5'
        }
      }]);
      var result = WorksheetHelpers.getOverHeadRate();
      expect(result, 5);
    });
  });

  group("WorksheetHelpers@getParentMeasurementItem should give parent line item having measurement linked", () {
    test('No line item should be used when all tiers are without measurement', () {
      final result = WorksheetHelpers.getParentMeasurementItem(tier3);
      expect(result, isNull);
    });

    test('Tier level 1 should be used if it has measurement available', () {
      tier1.tierMeasurement = MeasurementModel();
      final result = WorksheetHelpers.getParentMeasurementItem(tier3);
      expect(result, equals(tier1));
      tier1.tierMeasurement = null;
    });

    test('Tier level 2 should be used if it has measurement available', () {
      tier2.tierMeasurement = MeasurementModel();
      final result = WorksheetHelpers.getParentMeasurementItem(tier3);
      expect(result, equals(tier2));
      tier2.tierMeasurement = null;
    });

    test('Tier level 3 should be used if it has measurement available', () {
      tier3.tierMeasurement = MeasurementModel();
      final result = WorksheetHelpers.getParentMeasurementItem(tier3);
      expect(result, equals(tier3));
      tier3.tierMeasurement = null;
    });
  });

  group('WorksheetHelpers@getFavouriteParamsFromType should give correct params as per worksheet', () {
    test('Estimate params should be should returned for estimate worksheet', () {
      final result = WorksheetHelpers.getFavouriteParamsFromType(WorksheetConstants.estimate);
      expect(result, {
        'includes[0]': 'estimate',
        'includes[1]': 'division.address',
        'type[]': 'estimate',
      });
    });

    test('Material params should be should returned for material worksheet', () {
      final result = WorksheetHelpers.getFavouriteParamsFromType(WorksheetConstants.materialList);
      expect(result, {
        'includes[0]': 'material_list',
        'includes[1]': 'division.address',
        'type[]': 'material_list',
      });
    });

    test('Proposal params should be should returned for proposal worksheet', () {
      final result = WorksheetHelpers.getFavouriteParamsFromType(WorksheetConstants.proposal);
      expect(result, {
        'includes[0]': 'proposal',
        'includes[1]': 'division.address',
        'type[]': 'proposal',
      });
    });

    test('Work order params should be should returned for work order worksheet', () {
      final result = WorksheetHelpers.getFavouriteParamsFromType(WorksheetConstants.workOrder);
      expect(result, {
        'includes[0]': 'work_order',
        'includes[1]': 'division.address',
        'type[]': 'work_order',
      });
    });
  });

    group('WorksheetHelpers@getFavouriteParams should give correct params', () {
      final flagDetails = LDFlags.allFlags[LDFlagKeyConstants.srsV2MaterialIntegration];

      test('When SRS v1 supplier is active', () {
        flagDetails?.value = false;
        final result = WorksheetHelpers.getFavouriteParams(WorksheetConstants.estimate, 3);
        expect(result.containsKey('exclude_suppliers[]'), isFalse);
        expect(result['includes[2]'], 'job');
        expect(result['includes[3]'], 'job.rep_ids');
        expect(result['includes[4]'], 'job.estimator_ids');
        expect(result['includes[5]'], 'job.sub_ids');
      });

      test('When SRS v2 supplier is active', () {
        flagDetails?.value = true;
        final result = WorksheetHelpers.getFavouriteParams(WorksheetConstants.estimate, 181);
        expect(result.containsKey('exclude_suppliers[]'), isTrue);
        expect(result['includes[2]'], 'job');
        expect(result['includes[3]'], 'job.rep_ids');
        expect(result['includes[4]'], 'job.estimator_ids');
        expect(result['includes[5]'], 'job.sub_ids');
      });
    });

  group('WorksheetHelpers@getMarcoListType should give appropriate macro type as per worksheet', () {
    test('Estimate worksheet should open macro in estimate type', () {
      final result = WorksheetHelpers.getMarcoListType(WorksheetConstants.estimate);
      expect(result, MacrosListType.estimateProposal);
    });

    test('Material worksheet should open macro in material type', () {
      final result = WorksheetHelpers.getMarcoListType(WorksheetConstants.materialList);
      expect(result, MacrosListType.materialList);
    });

    test('Proposal worksheet should open macro in proposal type', () {
      final result = WorksheetHelpers.getMarcoListType(WorksheetConstants.proposal);
      expect(result, MacrosListType.estimateProposal);
    });

    test('Work order worksheet should open macro in work order type', () {
      final result = WorksheetHelpers.getMarcoListType(WorksheetConstants.workOrder);
      expect(result, MacrosListType.workOrder);
    });

    group("Macros for only suppliers should be loaded", () {
      test("Macros should only be opened for SRS Macros, When worksheet is SRS order", () {
        final result = WorksheetHelpers.getMarcoListType(WorksheetConstants.estimate, forSupplierId: Helper.getSupplierId(key: CommonConstants.srsId));
        expect(result, MacrosListType.srs);
      });

      test("Macros should only be opened for Beacon Macros, When worksheet is Beacon order", () {
        final result = WorksheetHelpers.getMarcoListType(WorksheetConstants.estimate, forSupplierId: Helper.getSupplierId(key: CommonConstants.beaconId));
        expect(result, MacrosListType.beacon);
      });

      test("In case supplier is not known, All macros should load", () {
        final result = WorksheetHelpers.getMarcoListType(WorksheetConstants.estimate, forSupplierId: 0);
        expect(result, MacrosListType.estimateProposal);
      });
    });
  });

  group('WorksheetHelpers@parseMacroToLineItems should properly parse macro\'s list to sheet line items', () {
    test('Empty macros list should return an empty line items list', () {
      final result = WorksheetHelpers.parseMacroToLineItems([], settings: null, allTrades: []);
      expect(result, isEmpty);
    });

    test('Single macro with details should be parsed correctly', () {
      final macros = [macroItem];

      final settings = WorksheetSettingModel();
      final allTrades = [selectableTrades[0]];

      final result = WorksheetHelpers.parseMacroToLineItems(macros, settings: settings, allTrades: allTrades);

      expect(result, hasLength(2));
      expect(result[0].workSheetSettings, equals(settings));
      expect(result[0].tradeId, equals(1));
      expect(result[0].tradeType, equals(allTrades[0]));
      expect(result[1].workSheetSettings, equals(settings));
      expect(result[1].tradeId, equals(1));
      expect(result[1].tradeType, equals(allTrades[0]));
    });

    test('Fixed price should be accumulated correctly', () {
      final settings = WorksheetSettingModel();
      WorksheetHelpers.parseMacroToLineItems(macrosList, settings: settings, allTrades: selectableTrades);
      expect(settings.fixedPriceAmount, equals(300));
    });
  });

  group("WorksheetHelpers@verifyTierName should check whether tier with same name exists or not", () {
    test('Empty list of items should return false', () {
      final result = WorksheetHelpers.verifyTierName([], 'Tier 1');
      expect(result, isFalse);
    });

    test('No item with the given name should return false', () {
      final items = [
        tier1
      ];

      final result = WorksheetHelpers.verifyTierName(items, 'Test 4');
      expect(result, isFalse);
    });

    test('An item with the given name should return true', () {
      final items = [
        tier1
      ];

      final result = WorksheetHelpers.verifyTierName(items, 'Test 1');
      expect(result, isTrue);
    });

    test('An item with the given name but marked as avoidName should return false', () {
      final items = [
        tier1
      ];

      final result = WorksheetHelpers.verifyTierName(items, 'Test 1', avoidName: 'Test 1');
      expect(result, isFalse);
    });

    test('An item with avoidName but not with the given name should return false', () {
      final items = [
        tier1
      ];

      final result = WorksheetHelpers.verifyTierName(items, 'Test 5', avoidName: 'Test 1');
      expect(result, isFalse);
    });
  });

  group('WorksheetHelpers@worksheetTypeToTitle should give correct title on the basis of worksheet', () {
    group('While showing worksheet title', () {
      test('Estimate worksheet should display correct title', () {
        final result = WorksheetHelpers.worksheetTypeToTitle(WorksheetConstants.estimate);
        expect(result, equals('save_estimate'.tr));
      });

      test('Proposal worksheet should display correct title', () {
        final result = WorksheetHelpers.worksheetTypeToTitle(WorksheetConstants.proposal);
        expect(result, equals('save_proposal'.tr));
      });

      test('Material worksheet should display correct title', () {
        final result = WorksheetHelpers.worksheetTypeToTitle(WorksheetConstants.materialList);
        expect(result, equals('save_material_list'.tr));
      });

      test('Work order worksheet should display correct title', () {
        final result = WorksheetHelpers.worksheetTypeToTitle(WorksheetConstants.workOrder);
        expect(result, equals('save_work_order'.tr));
      });

      test('Beacon worksheet should display correct title', () {
        final result = WorksheetHelpers.worksheetTypeToTitle(WorksheetConstants.beaconMaterialList);
        expect(result, equals('save_beacon_order_form'.tr));
      });

      test('Invalid type should display nothing', () {
        final result = WorksheetHelpers.worksheetTypeToTitle('invalid_type');
        expect(result, isEmpty);
      });
    });

    group('While showing save as title', () {
      test('Estimate worksheet should display correct title for save as', () {
        final result = WorksheetHelpers.worksheetTypeToTitle(WorksheetConstants.estimate, saveAs: true);
        expect(result, equals('save_as_estimate'.tr));
      });

      test('Proposal worksheet should display correct title for save as', () {
        final result = WorksheetHelpers.worksheetTypeToTitle(WorksheetConstants.proposal, saveAs: true);
        expect(result, equals('save_as_proposal'.tr));
      });

      test('Material worksheet should display correct title for save as', () {
        final result = WorksheetHelpers.worksheetTypeToTitle(WorksheetConstants.materialList, saveAs: true);
        expect(result, equals('save_as_material_list'.tr));
      });

      test('Work order worksheet should display correct title for save as', () {
        final result = WorksheetHelpers.worksheetTypeToTitle(WorksheetConstants.workOrder, saveAs: true);
        expect(result, equals('save_as_work_order'.tr));
      });

      test('Beacon worksheet should display correct title for save as', () {
        final result = WorksheetHelpers.worksheetTypeToTitle(WorksheetConstants.beaconMaterialList, saveAs: true);
        expect(result, equals('save_as_beacon_order_form'.tr));
      });
    });
  });

  group('WorksheetHelpers@getDefaultSaveName should check and give default save name for worksheet', () {
    group('In case of edit worksheet', () {
      test('For "workOrder" type and worksheet with a name, should return the worksheet name', () {
        final worksheet = WorksheetModel(name: 'Custom Work Order Name');
        final result = WorksheetHelpers.getDefaultSaveName(WorksheetConstants.workOrder, worksheet: worksheet);
        expect(result, equals('Custom Work Order Name'));
      });

      test('For "materialList" type and worksheet with a name, should return the worksheet name', () {
        final worksheet = WorksheetModel(name: 'Custom Material List Name');
        final result = WorksheetHelpers.getDefaultSaveName(WorksheetConstants.materialList, worksheet: worksheet);
        expect(result, equals('Custom Material List Name'));
      });

      test('For "proposal" type and worksheet with a name, should return the worksheet name', () {
        final worksheet = WorksheetModel(name: 'Custom Proposal Name');
        final result = WorksheetHelpers.getDefaultSaveName(WorksheetConstants.proposal, worksheet: worksheet);
        expect(result, equals('Custom Proposal Name'));
      });

      test('For "estimate" type and worksheet with a name, should return the worksheet name', () {
        final worksheet = WorksheetModel(name: 'Custom Estimate Name');
        final result = WorksheetHelpers.getDefaultSaveName(WorksheetConstants.estimate, worksheet: worksheet);
        expect(result, equals('Custom Estimate Name'));
      });

      test('For unknown type and worksheet with a name, should return the worksheet name', () {
        final worksheet = WorksheetModel(name: 'Custom Worksheet Name');
        final result = WorksheetHelpers.getDefaultSaveName('unknown_type', worksheet: worksheet);
        expect(result, equals('Custom Worksheet Name'));
      });
    });

    group('In case of save worksheet', () {
      test('For "workOrder" type and no worksheet, should return default name', () {
        final result = WorksheetHelpers.getDefaultSaveName(WorksheetConstants.workOrder);
        expect(result, equals('work_order'.tr));
      });

      test('For "materialList" type and no worksheet, should return default name', () {
        final result = WorksheetHelpers.getDefaultSaveName(WorksheetConstants.materialList);
        expect(result, equals('material_list'.tr.capitalize!));
      });

      test('For "proposal" type and no worksheet, should return default name', () {
        final result = WorksheetHelpers.getDefaultSaveName(WorksheetConstants.proposal);
        expect(result, equals('document'.tr.capitalize!));
      });

      test('For "estimate" type and no worksheet, should return default name', () {
        final result = WorksheetHelpers.getDefaultSaveName(WorksheetConstants.estimate);
        expect(result, equals('estimate'.tr.capitalize!));
      });

      test('For unknown type and no worksheet, should return an empty string', () {
        final result = WorksheetHelpers.getDefaultSaveName('unknown_type');
        expect(result, isEmpty);
      });
    });
  });

  group('WorksheetHelpers@isColorMissing should check whether color is missing from any line items', () {
    test('Color check should not be performed when there are no supplier', () {
      final worksheet = WorksheetModel(suppliers: []);
      final result = WorksheetHelpers.isColorMissing(worksheet);
      expect(result, isFalse);
    });

    group("When SRS is linked to worksheet", () {
      test('No line items should return false', () {
        final worksheet = WorksheetModel(
          supplierBranch: SupplierBranchModel(),
          srsShipToAddressModel: SrsShipToAddressModel(),
          lineItems: null,
        );
        final result = WorksheetHelpers.isColorMissing(worksheet);
        expect(result, isFalse);
      });

      test('No line item with missing color should return false', () {
        lineItem.product = FinancialProductModel(colors: ['Red']);
        lineItem.supplierId = '3';
        lineItem.color = 'Red';
        final result = WorksheetHelpers.isColorMissing(worksheetWithSRS);
        expect(result, isFalse);
      });

      test('Line item with missing supplierId should return false', () {
        lineItem.product = FinancialProductModel(colors: null);
        lineItem.supplierId = null;
        lineItem.color = null;
        final result = WorksheetHelpers.isColorMissing(worksheetWithSRS);
        expect(result, isFalse);
      });

      test('Line item with missing colors should return false', () {
        lineItem.product = FinancialProductModel(colors: null);
        lineItem.supplierId = '3';
        lineItem.color = null;
        final result = WorksheetHelpers.isColorMissing(worksheetWithSRS);
        expect(result, isFalse);
      });

      test('Line item with missing color selection should return true', () {
        lineItem.product = FinancialProductModel(colors: ['Red']);
        lineItem.supplierId = '3';
        lineItem.color = null;
        final result = WorksheetHelpers.isColorMissing(worksheetWithSRS);
        expect(result, isTrue);
      });
    });

    group("When Beacon is linked to worksheet", () {
      test('No line items should return false', () {
        final worksheet = WorksheetModel(
          lineItems: null,
        );
        final result = WorksheetHelpers.isColorMissing(worksheet);
        expect(result, isFalse);
      });

      test('No line item with missing color should return false', () {
        lineItem.product = FinancialProductModel(colors: ['Red']);
        lineItem.supplierId = Helper.getSupplierId(key: CommonConstants.beaconId).toString();
        lineItem.color = 'Red';
        final result = WorksheetHelpers.isColorMissing(worksheetWithSRS);
        expect(result, isFalse);
      });

      test('Line item with missing supplierId should return false', () {
        lineItem.product = FinancialProductModel(colors: null);
        lineItem.supplierId = null;
        lineItem.color = null;
        final result = WorksheetHelpers.isColorMissing(worksheetWithBeacon);
        expect(result, isFalse);
      });

      test('Line item with missing colors selection list should return false', () {
        lineItem.product = FinancialProductModel(colors: null);
        lineItem.supplierId = Helper.getSupplierId(key: CommonConstants.beaconId).toString();
        lineItem.color = null;
        final result = WorksheetHelpers.isColorMissing(worksheetWithBeacon);
        expect(result, isFalse);
      });

      test('Line item with missing color selection should return true', () {
        lineItem.product = FinancialProductModel(colors: ['Red']);
        lineItem.supplierId = Helper.getSupplierId(key: CommonConstants.beaconId).toString();
        lineItem.color = null;
        final result = WorksheetHelpers.isColorMissing(worksheetWithBeacon);
        expect(result, isTrue);
      });
    });
  });

  group('WorksheetHelpers@extractLineItems give the items that can be saved in generated worksheet', () {
    test('No line items, should return an empty list', () {
      final result = WorksheetHelpers.extractLineItems(emptyWorksheet);
      expect(result, isEmpty);
    });

    group("When items filter slugs are not given", () {
      test('When isSrs is enabled, should extract all SRS line items', () {
        worksheet.lineItems = [];
        worksheet.lineItems?.addAll([
          lineItem,
          lineItem2..supplierId = Helper.getSupplierId(key: CommonConstants.srsId).toString(),
        ]);
        final result = WorksheetHelpers.extractLineItems(worksheet, isSrs: true);
        expect(result, hasLength(1));
        worksheet.lineItems = [];
      });

      test('When isBeacon is enabled, should extract all Beacon line items', () {
        worksheet.lineItems = [
          lineItem..supplierId = null,
          lineItem2..supplierId = Helper.getSupplierId(key: CommonConstants.beaconId).toString(),
        ];
        final result = WorksheetHelpers.extractLineItems(worksheet, isBeacon: true);
        expect(result, hasLength(1));
        worksheet.lineItems = [];
      });

      test('When allowAll is enabled, should extract all line items', () {
        worksheet.lineItems = lineItems;
        final result = WorksheetHelpers.extractLineItems(worksheet, allowAll: true);
        expect(result, hasLength(4));
        worksheet.lineItems = [];
      });
    });

    group("When items filter slugs are given", () {
      test('Line items matching slugs should be extracted', () {
        final worksheet = WorksheetModel(lineItems: lineItemWithCategories);
        final result = WorksheetHelpers.extractLineItems(worksheet, slugs: ['Category B']);
        expect(result, hasLength(1));
        expect(result[0].categoryName, equals('Category B'));
      });

      test('When slugs are provided and worksheet has srs connected, should return all line items', () {
        final worksheet = WorksheetModel(lineItems: lineItemWithCategories);
        final result = WorksheetHelpers.extractLineItems(worksheet, slugs: ['Category B'], isSrs: true);
        expect(result, hasLength(0));
      });

      test('When slugs are provided and allowAll is enabled, should return all line items', () {
        final worksheet = WorksheetModel(lineItems: lineItemWithCategories);
        final result = WorksheetHelpers.extractLineItems(worksheet, slugs: ['Category B'], allowAll: true);
        expect(result, hasLength(2));
      });

      test('When no conditions are met, should return an empty list', () {
        final worksheet = WorksheetModel(lineItems: lineItemWithCategories);
        final result = WorksheetHelpers.extractLineItems(worksheet);
        expect(result, isEmpty);
      });
    });
  });

  group('WorksheetHelpers@typeToFLModule give the file module to save worksheet in', () {
    test('Material worksheet should be saved in materials', () {
      final result = WorksheetHelpers.typeToFLModule(WorksheetConstants.materialList);
      expect(result, equals(FLModule.materialLists));
    });

    test('SRS Material order should be saved in materials', () {
      final result = WorksheetHelpers.typeToFLModule(WorksheetConstants.srsMaterialList);
      expect(result, equals(FLModule.materialLists));
    });

    test('Beacon Material order should be saved in materials', () {
      final result = WorksheetHelpers.typeToFLModule(WorksheetConstants.beaconMaterialList);
      expect(result, equals(FLModule.materialLists));
    });

    test('Work order worksheet should be saved in work orders', () {
      final result = WorksheetHelpers.typeToFLModule(WorksheetConstants.workOrder);
      expect(result, equals(FLModule.workOrder));
    });

    test('Proposal worksheet should be saved in job proposals', () {
      final result = WorksheetHelpers.typeToFLModule(WorksheetConstants.proposal);
      expect(result, equals(FLModule.jobProposal));
    });

    test('Invalid type should return nothing', () {
      final result = WorksheetHelpers.typeToFLModule('invalid_type');
      expect(result, isNull);
    });
  });

  group('WorksheetHelpers@isAllItemColorSelected checks whether color is selected for all the items', () {
    test('No line items, should return true', () {
      final lineItems = <SheetLineItemModel>[];
      final result = WorksheetHelpers.isAllItemColorSelected(lineItems);
      expect(result, isTrue);
    });

    test('Line items with no colors should return true', () {
      final lineItems = <SheetLineItemModel>[
        lineItem..product?.colors = null,
      ];
      final result = WorksheetHelpers.isAllItemColorSelected(lineItems);
      expect(result, isTrue);
    });

    test('Line items with all colors selected should return true', () {
      lineItem.product = FinancialProductModel(colors: ['Red', 'Blue']);
      lineItem.color = 'Red';
      final result = WorksheetHelpers.isAllItemColorSelected([lineItem]);
      expect(result, isTrue);
    });

    test('Line items with at least one color not selected should return false', () {
      lineItem.product = FinancialProductModel(colors: ['Red', 'Blue']);
      lineItem.color = null;
      lineItem.supplierId = "3";
      final result = WorksheetHelpers.isAllItemColorSelected([lineItem]);
      expect(result, isFalse);
    });

    test('Line items with all colors not selected should return false', () {
      lineItems[0].product = FinancialProductModel(colors: ['Red', 'Blue']);
      lineItems[0].color = null;
      lineItems[1].product = FinancialProductModel(colors: ['Red', 'Blue']);
      lineItems[1].color = null;
      lineItem.supplierId = "3";
      final result = WorksheetHelpers.isAllItemColorSelected(lineItems);
      expect(result, isFalse);
    });
  });

  group("WorksheetHelpers@hasSuppliersProduct should check whether worksheet has supplier product or not", () {
    test("When there are not line items, result should be false", () {
      final result = WorksheetHelpers.hasSuppliersProduct(CommonConstants.beaconId, []);
      expect(result, isFalse);
    });

    test("When there are line items, but with other than 3rd party supplier", () {
      final result = WorksheetHelpers.hasSuppliersProduct('known', []);
      expect(result, isFalse);
    });

    test("When there are line items, but with other than supplier is not known", () {
      final result = WorksheetHelpers.hasSuppliersProduct('unknown', []);
      expect(result, isFalse);
    });

    test("When there are line items, with SRS supplier", () {
      final result = WorksheetHelpers.hasSuppliersProduct(CommonConstants.srsId, [
        lineItem..supplier = SuppliersModel(id: Helper.getSupplierId(key: CommonConstants.srsId)),
      ]);
      expect(result, isTrue);
    });

    test("When there are line items, with Beacon supplier", () {
      final result = WorksheetHelpers.hasSuppliersProduct(CommonConstants.beaconId, [
        lineItem..supplier = SuppliersModel(id: Helper.getSupplierId(key: CommonConstants.beaconId)),
      ]);
      expect(result, isTrue);
    });
  });

  group("MacroListingModel@getViewSelectedMacroParams() Selected Macro Params Tests", () {
    test('Should returns params when selected macros are not beacon macros', () {
      final params = MacroListingModel.getViewSelectedMacroParams(['macro1', 'macro2']);
      expect(params['includes[0]'], equals('details'));
      expect(params['includes[1]'], equals('details.measurement_formulas'));
      expect(params['includes[2]'], equals('details.financial_product_detail'));
      expect(params['includes[3]'], equals('trade'));
      expect(params.containsKey('includes[4]'), isFalse);
      expect(params.containsKey('branch_code'), isFalse);
      expect(params['macro_ids[0]'], equals('macro1'));
      expect(params['macro_ids[1]'], equals('macro2'));
    });

    test('Should returns params when selected macros are beacon macros', () {
      final params = MacroListingModel.getViewSelectedMacroParams(['macro1', 'macro2'], branchCode: '123');
      expect(params['includes[0]'], equals('details'));
      expect(params['includes[1]'], equals('details.measurement_formulas'));
      expect(params['includes[2]'], equals('details.financial_product_detail'));
      expect(params['includes[3]'], equals('trade'));
      expect(params['includes[4]'], equals('details.variants'));
      expect(params['branch_code'], equals('123'));
      expect(params['macro_ids[0]'], equals('macro1'));
      expect(params['macro_ids[1]'], equals('macro2'));
    });
  });

  group("MacroListingModel@getViewMacrosParams() Macros Params Tests", () {
    test('Should returns params when selected macro is not a beacon macro', () {
      final params = MacroListingModel.getViewMacrosParams('macro1');
      expect(params['includes[0]'], equals('details'));
      expect(params['includes[1]'], equals('details.financial_product_detail'));
      expect(params['includes[2]'], equals('branch'));
      expect(params['includes[3]'], equals('details.ship_to_address'));
      expect(params['includes[4]'], equals('branch.beacon_account'));
      expect(params.containsKey('includes[5]'), isFalse);
      expect(params.containsKey('branch_code'), isFalse);
      expect(params['macro_id'], equals('macro1'));
    });

    test('Should returns params when selected macro is a beacon macro', () {
      final params = MacroListingModel.getViewMacrosParams('macro1', branchCode: '123');
      expect(params['includes[0]'], equals('details'));
      expect(params['includes[1]'], equals('details.financial_product_detail'));
      expect(params['includes[2]'], equals('branch'));
      expect(params['includes[3]'], equals('details.ship_to_address'));
      expect(params['includes[4]'], equals('branch.beacon_account'));
      expect(params['includes[5]'], equals('details.variants'));
      expect(params['branch_code'], equals('123'));
      expect(params['macro_id'], equals('macro1'));
    });
  });

  group("WorksheetHelpers@checkAndAddProcessingFeeItem should conditionally add processing fee line item to given worksheet", () {
    group("Processing fee line item should not be added", () {
      test("When [metro-bath] feature flag is not enabled", () {
        worksheet.lineItems = [lineItem];
        WorksheetHelpers.checkAndAddProcessingFeeItem(worksheet);
        expect(worksheet.lineItems, hasLength(1));
      });

      test("When processing fee is not enabled for a worksheet", () {
        worksheet.processingFee = null;
        worksheet.lineItems = [lineItem];
        WorksheetHelpers.checkAndAddProcessingFeeItem(worksheet);
        expect(worksheet.lineItems, hasLength(1));
      });

      test("When processing fee is invalid", () {
        worksheet.processingFee = "";
        worksheet.lineItems = [lineItem];
        WorksheetHelpers.checkAndAddProcessingFeeItem(worksheet);
        expect(worksheet.lineItems, hasLength(1));
      });
    });

    group("Processing fee line item should be added when [metro-bath] feature flag is enabled and processing fee is valid", () {
      setUp(() {
        LDFlags.metroBathFeature.value = true;
        worksheet.processingFeeAmount = "5";
        worksheet.lineItems = [lineItem];
        worksheet.sellingPriceTotal = "100";
        worksheet.total = "100";
        WorksheetHelpers.checkAndAddProcessingFeeItem(worksheet);
      });

      test("Extra line item should be added", () {
        expect(worksheet.lineItems, hasLength(2));
      });

      test("Title of the Processing Fee line item should be 'Processing Fee'", () {
        expect(worksheet.lineItems![1].title, "processing_fee".tr);
      });

      test("Quantity of the Processing Fee line item should be '1'", () {
        expect(worksheet.lineItems![1].qty, "1");
      });

      test("All the Processing Fee line item should be set correctly", () {
        expect(worksheet.lineItems![1].totalPrice, "5");
        expect(worksheet.lineItems![1].price, "5");
        expect(worksheet.lineItems![1].sellingPrice, "5");
        expect(worksheet.lineItems![1].unitCost, "5");
      });
    });
  });

  group("WorksheetHelpers@getFileWorksheetParams should give correct params for actions", () {
    group("'total' should be calculated correctly", () {
      test("In case of no file 'total' should be null", () {
        final params = WorksheetHelpers.getFileWorksheetParams(null);
        expect(params?['total'], isNull);
      });

      test("In case of file with no worksheet 'total' should be null", () {
        final params = WorksheetHelpers.getFileWorksheetParams(FilesListingModel());
        expect(params?['total'], isNull);
      });

      group("In case of file having worksheet and worksheet is non taxable", () {
        group("Processing Fee should be added conditionally in 'total' amount", () {
          test("In case worksheet does not have processing Fee, It should not be added", () {
            worksheet
              ..processingFeeAmount = null
              ..lineItems = lineItems
              ..total = '100';
            final params = WorksheetHelpers.getFileWorksheetParams(FilesListingModel(worksheet: worksheet));
            expect(params?['total'], 100.0);
          });

          test("In case worksheet does have processing Fee, It should be added", () {
            worksheet
              ..processingFeeAmount = '5'
              ..lineItems = lineItems
              ..total = '100';
            final params = WorksheetHelpers.getFileWorksheetParams(FilesListingModel(worksheet: worksheet));
            expect(params?['total'], 105.0);
          });
        });
      });
    });
  });

  group('WorksheetHelpers@isDefaultBranchSaved()', () {
    group('When SRS is enabled', () {
      setUpAll(() {
        defaultBranchModel = DefaultBranchModel(
            srsShipToAddress: SrsShipToAddressModel(shipToSequenceId: '1'),
            branch: SupplierBranchModel(branchId: '3')
        );
      });
      setUp(() {
        CompanySettingsService.companySettings[CompanySettingConstants.srsDefaultBranch] =
        {
          'value': {
            'address': selectedSrsShipToAddress.toJson(),
            'branch': selectedSrsBranch.toJson(),
          }
        };
      });

      test('When there is no default srs branch saved', () {
        CompanySettingsService.companySettings[CompanySettingConstants.srsDefaultBranch] = null;
        expect(WorksheetHelpers.isDefaultBranchSaved(defaultBranchModel, MaterialSupplierType.srs), isFalse);
      });

      test('When selected srs branch is empty and type is invoice / change order', () {
        expect(WorksheetHelpers.isDefaultBranchSaved(DefaultBranchModel(), MaterialSupplierType.srs, isInvoiceFormType: true), isTrue);
      });

      test('When selected srs branch is empty and type is worksheet', () {
        expect(WorksheetHelpers.isDefaultBranchSaved(DefaultBranchModel(), MaterialSupplierType.srs), isTrue);
      });

      test('When selected srs branch matches default srs branch', () {
        expect(WorksheetHelpers.isDefaultBranchSaved(defaultBranchModel, MaterialSupplierType.srs), isTrue);
      });

      test('When selected srs branch does not match default srs branch', () {
        final selectedModel = DefaultBranchModel(
            srsShipToAddress: SrsShipToAddressModel(shipToSequenceId: '2'),
            branch: SupplierBranchModel(branchId: 'branch1')
        );
        expect(WorksheetHelpers.isDefaultBranchSaved(selectedModel, MaterialSupplierType.srs), isFalse);
      });

      test('When selected srs branch matches default srs branch and type is invoice / change order', () {
        expect(WorksheetHelpers.isDefaultBranchSaved(defaultBranchModel, MaterialSupplierType.srs, isInvoiceFormType: true), isTrue);
      });
    });

    group('When Beacon is enabled', () {
      setUpAll(() {
        defaultBranchModel = DefaultBranchModel(
          beaconAccount: BeaconAccountModel(accountId: 2),
          branch: SupplierBranchModel(branchId: '4'),
          jobAccount: BeaconJobModel(jobNumber: 'job1')
        );
      });
      setUp(() {
        CompanySettingsService.companySettings[CompanySettingConstants.beaconDefaultBranch] =
        {
          'value': {
            'account': {
              'account_id': '2'
            },
            'branch': {
              'branch_id': '4'
            },
            'job_account': {
              'job_number': 'job1'
            }
          }
        };
      });

      test('When there is no default beacon branch saved', () {
        CompanySettingsService.companySettings[CompanySettingConstants.beaconDefaultBranch] = null;
        expect(WorksheetHelpers.isDefaultBranchSaved(defaultBranchModel, MaterialSupplierType.beacon), isFalse);
      });

      test('When selected beacon branch is empty and type is invoice / change order', () {
        expect(WorksheetHelpers.isDefaultBranchSaved(DefaultBranchModel(), MaterialSupplierType.beacon, isInvoiceFormType: true), isTrue);
      });

      test('When selected beacon branch is empty and type is worksheet', () {
        expect(WorksheetHelpers.isDefaultBranchSaved(DefaultBranchModel(), MaterialSupplierType.beacon), isTrue);
      });

      test('When selected beacon branch matches default beacon branch', () {
        expect(WorksheetHelpers.isDefaultBranchSaved(defaultBranchModel, MaterialSupplierType.beacon), isTrue);
      });

      test('When selected beacon branch does not match default beacon branch', () {
        final selectedModel = DefaultBranchModel(
          beaconAccount: BeaconAccountModel(accountId: 4),
          branch: SupplierBranchModel(branchId: 'branch1'),
          jobAccount: BeaconJobModel(jobNumber: 'job2')
        );
        expect(WorksheetHelpers.isDefaultBranchSaved(selectedModel, MaterialSupplierType.beacon), isFalse);
      });

      test('When selected beacon branch matches default beacon branch and type is invoice / change order', () {
        expect(WorksheetHelpers.isDefaultBranchSaved(defaultBranchModel, MaterialSupplierType.beacon, isInvoiceFormType: true), isTrue);
      });
    });

    group('When ABC is enabled', () {
      setUpAll(() {
        defaultBranchModel = DefaultBranchModel(
          abcAccount: SrsShipToAddressModel(shipToId: '2'),
          branch: SupplierBranchModel(branchId: '4')
        );
      });
      setUp(() {
        CompanySettingsService.companySettings[CompanySettingConstants.abcDefaultBranch] =
        {
          'value': {
            'address': {
              'account_id': selectedAbcAccount.shipToId,
              'name': selectedAbcAccount.addressLine1
            },
            'branch': selectedAbcBranch.toJson(),
          }
        };
      });

      test('When there is no default abc branch saved', () {
        CompanySettingsService.companySettings[CompanySettingConstants.abcDefaultBranch] = null;
        expect(WorksheetHelpers.isDefaultBranchSaved(defaultBranchModel, MaterialSupplierType.abc), isFalse);
      });

      test('When selected abc branch is empty and type is invoice / change order', () {
        expect(WorksheetHelpers.isDefaultBranchSaved(DefaultBranchModel(), MaterialSupplierType.abc, isInvoiceFormType: true), isTrue);
      });

      test('When selected abc branch is empty and type is worksheet', () {
        expect(WorksheetHelpers.isDefaultBranchSaved(DefaultBranchModel(), MaterialSupplierType.abc), isTrue);
      });

      test('When selected abc branch matches default abc branch', () {
        expect(WorksheetHelpers.isDefaultBranchSaved(defaultBranchModel, MaterialSupplierType.abc), isTrue);
      });

      test('When selected abc branch does not match default abc branch', () {
        final selectedModel = DefaultBranchModel(
            abcAccount: SrsShipToAddressModel(shipToId: '4'),
            branch: SupplierBranchModel(branchId: 'branch1'),
        );
        expect(WorksheetHelpers.isDefaultBranchSaved(selectedModel, MaterialSupplierType.abc), isFalse);
      });

      test('When selected abc branch matches default abc branch and type is invoice / change order', () {
        expect(WorksheetHelpers.isDefaultBranchSaved(defaultBranchModel, MaterialSupplierType.abc, isInvoiceFormType: true), isTrue);
      });
    });
  });

  group('WorksheetHelpers@resetDefaultBranchSettings should add or replace company setting with correct values', () {
    test('When SRS supplier is selected', () {
      String defaultBranchKey = CompanySettingConstants.srsDefaultBranch;
      WorksheetHelpers.resetDefaultBranchSettings(defaultBranchKey);
      // Assert
      final expectedMap = {
        'name': defaultBranchKey,
        'key': defaultBranchKey,
        'user_id': '1',
        'company_id': 1,
        'value': '',
      };

      final actualMap = CompanySettingsService.getCompanySettingByKey(defaultBranchKey, onlyValue: false);

      expect(actualMap, expectedMap);
    });

    test('When Beacon supplier is selected', () {
      String defaultBranchKey = CompanySettingConstants.beaconDefaultBranch;
      WorksheetHelpers.resetDefaultBranchSettings(defaultBranchKey);
      // Assert
      final expectedMap = {
        'name': defaultBranchKey,
        'key': defaultBranchKey,
        'user_id': '1',
        'company_id': 1,
        'value': '',
      };

      final actualMap = CompanySettingsService.getCompanySettingByKey(defaultBranchKey, onlyValue: false);

      expect(actualMap, expectedMap);
    });

    test('When ABC supplier is selected', () {
      String defaultBranchKey = CompanySettingConstants.abcDefaultBranch;
      WorksheetHelpers.resetDefaultBranchSettings(defaultBranchKey);
      // Assert
      final expectedMap = {
        'name': defaultBranchKey,
        'key': defaultBranchKey,
        'user_id': '1',
        'company_id': 1,
        'value': '',
      };

      final actualMap = CompanySettingsService.getCompanySettingByKey(defaultBranchKey, onlyValue: false);

      expect(actualMap, expectedMap);
    });
  });

  group('WorksheetHelpers@isBeaconQuantityZero should check', () {
    test('When worksheet line item neither Beacon and ABC items and has no quantity', () {
      lineItems[0].supplierId = '13'; // Invalid Beacon id
      lineItems[0].qty = '0';
      expect(WorksheetHelpers.isBeaconOrABCQuantityZero(lineItems), isFalse);
    });

    test('When worksheet line item has Beacon and ABC item but has no quantity', () {
      lineItems[0].supplierId = '173'; // Valid Beacon id
      lineItems[0].qty = '0';
      expect(WorksheetHelpers.isBeaconOrABCQuantityZero(lineItems), isTrue);
    });

    test('When worksheet line item has no Beacon and ABC item but has 1 quantity', () {
      lineItems[0].supplierId = '13'; // Invalid Beacon id
      lineItems[0].qty = '1';
      expect(WorksheetHelpers.isBeaconOrABCQuantityZero(lineItems), isFalse);
    });

    test('When worksheet line item has Beacon and ABC item and has 1 quantity', () {
      lineItems[0].supplierId = '173'; // Valid Beacon id
      lineItems[0].qty = '1';
      expect(WorksheetHelpers.isBeaconOrABCQuantityZero(lineItems), isFalse);
    });
  });

  group('WorksheetHelper@getBranchCode should return the branch code', () {
    test('When the SRS is enabled', () {
      String srsBranchCode = 'SRS123';
      String? branchCode = WorksheetHelpers.getBranchCode(srsBranchCode, null, null);
      expect(branchCode, srsBranchCode);
    });

    test('When the Beacon is enabled', () {
      String beaconBranchCode = 'BEACON456';
      String? branchCode = WorksheetHelpers.getBranchCode(null, beaconBranchCode, null);
      expect(branchCode, beaconBranchCode);
    });

    test('When the ABC is enabled', () {
      String abcBranchCode = 'ABC789';
      String? branchCode = WorksheetHelpers.getBranchCode(null, null, abcBranchCode);
      expect(branchCode, abcBranchCode);
    });

    test('When no single supplier is enabled', () {
      String? branchCode = WorksheetHelpers.getBranchCode(null, null, null);
      expect(branchCode, isNull);
    });
  });

  group('WorksheetHelper@getSupplierId should return the supplier id', () {
    test('When the SRS is enabled', () {
      String srsBranchCode = 'SRS789';
      int srsSupplierId = 3;
      int?  supplierId = WorksheetHelpers.getSupplierId(srsBranchCode, null, srsSupplierId);
      expect(supplierId, srsSupplierId);
    });

    test('When the ABC is enabled', () {
      String abcBranchCode = 'ABC789';
      int abcSupplierId = 188;
      int?  supplierId = WorksheetHelpers.getSupplierId(null, abcBranchCode, abcSupplierId);
      expect(supplierId, abcSupplierId);
    });

    test('When no single supplier is enabled', () {
      int? supplierId = WorksheetHelpers.getSupplierId(null, null, null);
      expect(supplierId, isNull);
    });
  });

  group('WorksheetHelpers@setItemCodeInDescription should be get', () {
    group('In case Item code is available', () {
      setUpAll(() {
        product.supplier = SuppliersModel(id: 22);
      });
      test('When SRS v2 supplier id is available', () {
        product.supplier?.id = 181; // It should be Beacon, ABC or Other Supplier id
        variantModel.code = 'DEF456';
        product.code = '123';
        product.description = 'Dummy';

        String? resultDescription = WorksheetHelpers.getItemCodeInDescription(
            supplierId: product.supplier?.id,
            productCode: product.code,
            variantCode: variantModel.code,
            productDescription: product.description,
            lineItemDescription: lineItem.description
        );
        expect(resultDescription, '${'item_code'.tr}: 123');
      });

      group('When SRS v2 supplier id is not available', () {
        setUpAll(() {
          product.supplier?.id = 173; // It should be any supplier id except SRS v2
        });

        test('Product Description is available', () {
          product.description = 'Dummy Text';
          product.code = 'DEF456';

          String? resultDescription = WorksheetHelpers.getItemCodeInDescription(
              supplierId: product.supplier?.id,
              productCode: product.code,
              variantCode: variantModel.code,
              productDescription: product.description,
              lineItemDescription: lineItem.description
          );
          expect(resultDescription, 'Dummy Text \n ${'item_code'.tr}: DEF456');
        });

        test('When Item code is already exist in line item description', () {
          product.description = null;
          product.code = 'DEF456';
          lineItem.description = '${'item_code'.tr}: 41322';

          String? resultDescription = WorksheetHelpers.getItemCodeInDescription(
              supplierId: product.supplier?.id,
              productCode: product.code,
              variantCode: variantModel.code,
              productDescription: product.description,
              lineItemDescription: lineItem.description
          );
          expect(resultDescription, '${'item_code'.tr}: DEF456');
        });

        test('When line Item Description is available', () {
          product.description = null;
          product.code = 'DEF456';
          lineItem.description = 'Dummy Text';

          String? resultDescription = WorksheetHelpers.getItemCodeInDescription(
              supplierId: product.supplier?.id,
              productCode: product.code,
              variantCode: variantModel.code,
              productDescription: product.description,
              lineItemDescription: lineItem.description
          );
          expect(resultDescription, 'Dummy Text \n ${'item_code'.tr}: DEF456');
        });

        test('When description is not available', () {
          product.description = null;
          product.code = 'DEF456';
          lineItem.description = null;

          String? resultDescription = WorksheetHelpers.getItemCodeInDescription(
              supplierId: product.supplier?.id,
              productCode: product.code,
              variantCode: variantModel.code,
              productDescription: product.description,
              lineItemDescription: lineItem.description
          );
          expect(resultDescription, '${'item_code'.tr}: DEF456');
        });
      });
    });

    test('In case Item code is not available', () {
      variantModel.code = null;
      product = FinancialProductModel(code: null);

      String? resultDescription = WorksheetHelpers.getItemCodeInDescription(
          supplierId: product.supplier?.id,
          productCode: product.code,
          variantCode: variantModel.code,
          productDescription: product.description,
          lineItemDescription: lineItem.description
      );
      expect(resultDescription, isNull);
    });
  });

  group('WorksheetHelpers@getLineItemAbove should give line item to the above of new line to be added', () {
    group("In case there are no tiers", () {
      test('If there are no line items nothing should be returned', () {
        final result = WorksheetHelpers.getLineItemAbove(lineItems: []);
        expect(result, isNull);
      });

      test("In case there is one line item, it should be returned", () {
        final result = WorksheetHelpers.getLineItemAbove(lineItems: [lineItem]);
        expect(result, lineItem);
      });

      test("In case there are multiple line items, the last one should be returned", () {
        final result = WorksheetHelpers.getLineItemAbove(lineItems: [lineItem, lineItem2]);
        expect(result, lineItem2);
      });
    });

    group("In case there are tiers", () {
      group("In case there is only one tier", () {
        test('If there are no line items within tiers, nothing should be returned', () {
          final result = WorksheetHelpers.getLineItemAbove(lineItems: [tier1..subItems = []..subTiers = []], tierIndex: 0);
          expect(result, isNull);
        });

        test("While adding new item within the same tier having one line item, it should be returned", () {
          final result = WorksheetHelpers.getLineItemAbove(lineItems: [tier1..subItems = [lineItem]], tierIndex: 0);
          expect(result, lineItem);
        });

        test("While adding new item within the same tier having multiple line items, the last one should be returned", () {
          final result = WorksheetHelpers.getLineItemAbove(lineItems: [tier1..subItems = [lineItem, lineItem2]], tierIndex: 0);
          expect(result, lineItem2);
        });
      });

      group("In case there are multiple tiers", () {
        test('If there are no line items within tiers, nothing should be returned', () {
          final result = WorksheetHelpers.getLineItemAbove(lineItems: [tier1..subItems = [], tier2..subItems = []], tierIndex: 1);
          expect(result, isNull);
        });

        test("While adding new item within the next tier having one line item, it should be returned", () {
          final result = WorksheetHelpers.getLineItemAbove(lineItems: [tier1..subItems = [], tier2..subItems = [lineItem]], tierIndex: 1);
          expect(result, lineItem);
        });

        test("While adding new item within the next tier having multiple line items, the last one should be returned", () {
          final result = WorksheetHelpers.getLineItemAbove(lineItems: [tier1..subItems = [], tier2..subItems = [lineItem, lineItem2]], tierIndex: 1);
          expect(result, lineItem2);
        });

        test("While adding new item within the next tier having single line items in tier above it, the last one from the above tier should be returned", () {
          final result = WorksheetHelpers.getLineItemAbove(lineItems: [tier1..subItems = [lineItem], tier2..subItems = []], tierIndex: 1);
          expect(result, lineItem);
        });

        test("While adding new item within the next tier having multiple line items in tier above it, the last one from the above tier should be returned", () {
          final result = WorksheetHelpers.getLineItemAbove(lineItems: [tier1..subItems = [lineItem, lineItem2], tier2..subItems = []], tierIndex: 1);
          expect(result, lineItem2);
        });

        test("While adding new item within a middle tier with no item, it should pick last item from the above tier", () {
          final result = WorksheetHelpers.getLineItemAbove(lineItems: [tier1..subItems = [lineItem], tier2..subItems = [], tier3..subItems = [lineItem2]], tierIndex: 1);
          expect(result, lineItem);
        });

        test("While adding new item within a middle tier with one item, it should pick last item from its available items", () {
          final result = WorksheetHelpers.getLineItemAbove(lineItems: [tier1..subItems = [lineItem], tier2..subItems = [lineItem2], tier3..subItems = []], tierIndex: 1);
          expect(result, lineItem2);
        });
      });
    });
  });

  group('WorksheetHelpers@isDivisionMatches should check whether its match job division or not', () {
    setUpAll(() {
      divisions.first.id = 1;
    });
    test('When job Division does matches from supplier division', () {
      expect(WorksheetHelpers.isDivisionMatches(divisions, 1), isTrue);
    });

    test('When job Division does not matches from supplier division', () {
      expect(WorksheetHelpers.isDivisionMatches(divisions, 2), isFalse);
    });
  });

  group('WorksheetHelpers@getSupplierBranch should get supplier default branch', () {
    test('When SRS is enabled', () {
      SupplierBranchModel? branch = WorksheetHelpers.getSupplierBranch(MaterialSupplierType.srs, selectedSrsBranch: selectedSrsBranch);
      expect(branch?.branchId, selectedSrsBranch.branchId);
    });

    test('When Beacon is enabled', () {
      SupplierBranchModel? branch = WorksheetHelpers.getSupplierBranch(MaterialSupplierType.beacon, selectedBeaconBranch: selectedBeaconBranch);
      expect(branch?.branchId, selectedBeaconBranch.branchId);
    });

    test('When ABC is enabled', () {
      SupplierBranchModel? branch = WorksheetHelpers.getSupplierBranch(MaterialSupplierType.abc, selectedAbcBranch: selectedAbcBranch);
      expect(branch?.branchId, selectedAbcBranch.branchId);
    });
  });

  group('WorksheetHelpers@typeToSettingsKey should convert worksheet type to corresponding company settings key', () {
    test('Should return estimate worksheet key for estimate type', () {
      final result = WorksheetHelpers.typeToSettingsKey(WorksheetConstants.estimate);
      expect(result, equals(CompanySettingConstants.estimateWorksheet));
    });

    test('Should return material worksheet key for material list type', () {
      final result = WorksheetHelpers.typeToSettingsKey(WorksheetConstants.materialList);
      expect(result, equals(CompanySettingConstants.materialWorksheet));
    });

    test('Should return work order worksheet key for work order type', () {
      final result = WorksheetHelpers.typeToSettingsKey(WorksheetConstants.workOrder);
      expect(result, equals(CompanySettingConstants.workOrderWorksheet));
    });

    test('Should return proposal worksheet key for proposal type', () {
      final result = WorksheetHelpers.typeToSettingsKey(WorksheetConstants.proposal);
      expect(result, equals(CompanySettingConstants.proposalWorksheet));
    });

    test('Should return empty string for unrecognized worksheet type', () {
      final result = WorksheetHelpers.typeToSettingsKey('unknown_type');
      expect(result, isEmpty);
    });
  });

  group('WorksheetHelpers@getWorksheetDefaultSettings should retrieve default settings for worksheet type', () {
    setUp(() {
      // Clear any previous company settings before each test
      CompanySettingsService.removeSettings();
    });

    test('Should return settings when valid settings exist in company settings', () {
      // Setup mock company settings
      CompanySettingsService.setCompanySettings([{
        'key': CompanySettingConstants.estimateWorksheet,
        'value': {
          'settings': {
            'hide_pricing': true,
            'show_discount': true,
            'show_taxes': false
          }
        }
      }]);

      final result = WorksheetHelpers.getWorksheetDefaultSettings(
        worksheetType: WorksheetConstants.estimate
      );

      expect(result, isNotNull);
      expect(result?.hidePricing, equals(true));
      expect(result?.showDiscount, equals(true));
      expect(result?.showTaxes, equals(false));
    });

    test('Should return empty settings when settings key exists but settings property is null', () {
      // Setup mock company settings with null settings property
      CompanySettingsService.setCompanySettings([{
        'key': CompanySettingConstants.materialWorksheet,
        'value': {
          'settings': null
        }
      }]);

      final result = WorksheetHelpers.getWorksheetDefaultSettings(
        worksheetType: WorksheetConstants.materialList
      );

      expect(result, isNotNull);
      expect(result?.hidePricing, isFalse);
      expect(result?.showDiscount, isFalse);
    });

    test('Should return empty settings when company settings key does not exist', () {
      // Company settings is already empty from setUp

      final result = WorksheetHelpers.getWorksheetDefaultSettings(
        worksheetType: WorksheetConstants.workOrder
      );

      expect(result, isNotNull);
      expect(result?.hidePricing, isFalse);
      expect(result?.showDiscount, isFalse);
    });

    test('Should return empty settings when company settings value is boolean', () {
      // Setup mock company settings with boolean value
      CompanySettingsService.companySettings[CompanySettingConstants.proposalWorksheet] = {'value': false};

      final result = WorksheetHelpers.getWorksheetDefaultSettings(
        worksheetType: WorksheetConstants.proposal
      );

      expect(result, isNotNull);
      expect(result?.hidePricing, isFalse);
      expect(result?.showDiscount, isFalse);
    });

    test('Should return empty settings for unrecognized worksheet type', () {
      final result = WorksheetHelpers.getWorksheetDefaultSettings(
        worksheetType: 'unknown_type'
      );

      expect(result, isNotNull);
      expect(result?.hidePricing, isFalse);
      expect(result?.showDiscount, isFalse);
    });
  });

  group('WorksheetHelpers@doShowDefaultSettingsSelector should determine when to show default settings selector', () {
    test('Should return true for work order worksheet type', () {
      final result = WorksheetHelpers.doShowDefaultSettingsSelector(WorksheetConstants.workOrder);
      expect(result, isTrue);
    });

    test('Should return true for material list worksheet type', () {
      final result = WorksheetHelpers.doShowDefaultSettingsSelector(WorksheetConstants.materialList);
      expect(result, isTrue);
    });

    test('Should return true for proposal worksheet type', () {
      final result = WorksheetHelpers.doShowDefaultSettingsSelector(WorksheetConstants.proposal);
      expect(result, isTrue);
    });

    test('Should return false for estimate worksheet type', () {
      final result = WorksheetHelpers.doShowDefaultSettingsSelector(WorksheetConstants.estimate);
      expect(result, isFalse);
    });

    test('Should return false for SRS material list worksheet type', () {
      final result = WorksheetHelpers.doShowDefaultSettingsSelector(WorksheetConstants.srsMaterialList);
      expect(result, isFalse);
    });

    test('Should return false for Beacon material list worksheet type', () {
      final result = WorksheetHelpers.doShowDefaultSettingsSelector(WorksheetConstants.beaconMaterialList);
      expect(result, isFalse);
    });

    test('Should return false for ABC material list worksheet type', () {
      final result = WorksheetHelpers.doShowDefaultSettingsSelector(WorksheetConstants.abcMaterialList);
      expect(result, isFalse);
    });

    test('Should return false for unrecognized worksheet type', () {
      final result = WorksheetHelpers.doShowDefaultSettingsSelector('unknown_type');
      expect(result, isFalse);
    });
  });

  group('WorksheetHelpers@hasIntegratedSupplier should check weather integrated supplier exists', () {
    test('When Supplier list is null', () {
      worksheet.suppliers = null;
      expect(WorksheetHelpers.hasIntegratedSupplier(null), false);
    });

    test('When Supplier list is empty', () {
      worksheet.suppliers = [];
      expect(WorksheetHelpers.hasIntegratedSupplier(worksheet), false);
    });

    test('When integrated suppliers not available', () {
      worksheet.suppliers = [
        SuppliersModel(id: 1)
      ];
      expect(WorksheetHelpers.hasIntegratedSupplier(worksheet), false);
    });

    test('When integrated suppliers are available', () {
      worksheet.suppliers = [
        SuppliersModel(id: 181) // SRS v2 supplier id
      ];
      expect(WorksheetHelpers.hasIntegratedSupplier(worksheet), true);
    });
  });

  group('WorksheetHelpers@formatPercentage should format percentage values according to the specified rules', () {
    test('Should return "0" when percentage is zero', () {
      expect(WorksheetHelpers.formatPercentage(0), '0');
      expect(WorksheetHelpers.formatPercentage(0.0), '0');
    });

    test('Should return "<1" when percentage is positive but less than 0.01', () {// Based on implementation, all small values return "<1"
      expect(WorksheetHelpers.formatPercentage(0.001), '<1');
      expect(WorksheetHelpers.formatPercentage(0.0001), '<1');
      expect(WorksheetHelpers.formatPercentage(0.000001), '<1');
    });

    test('Should return exact rounded value when percentage and rounded value are equal', () {
      expect(WorksheetHelpers.formatPercentage(1.25), '1.25');
      expect(WorksheetHelpers.formatPercentage(10.5), '10.5');
      expect(WorksheetHelpers.formatPercentage(99.99), '99.99');
    });

    test('Should return "~" + rounded value when percentage and rounded value are not equal', () {
      expect(WorksheetHelpers.formatPercentage(0.009), '~0.01');
      expect(WorksheetHelpers.formatPercentage(0.0099), '~0.01');
      expect(WorksheetHelpers.formatPercentage(1.2524), '~1.25');
      expect(WorksheetHelpers.formatPercentage(10.567), '~10.57');
      expect(WorksheetHelpers.formatPercentage(99.999), '~100');
    });

    test('Should handle trailing zeros correctly', () {
      expect(WorksheetHelpers.formatPercentage(1.2500), '1.25');
      expect(WorksheetHelpers.formatPercentage(10.5000), '10.5');
      expect(WorksheetHelpers.formatPercentage(10.50), '10.5');
    });

    test('Should respect fractionDigits parameter', () {
      expect(WorksheetHelpers.formatPercentage(1.2345, fractionDigits: 3), '~1.235');
      expect(WorksheetHelpers.formatPercentage(1.2345, fractionDigits: 1), '~1.2');
      expect(WorksheetHelpers.formatPercentage(1.2345, fractionDigits: 4), '1.2345');
    });

    test('Should handle edge cases correctly', () {
      // Very small percentage - should return "<1"
      expect(WorksheetHelpers.formatPercentage(0.000001), '<1');

      // Very large percentage
      expect(WorksheetHelpers.formatPercentage(999999.99), '999999.99');

      // Negative percentage - should format without special handling
      expect(WorksheetHelpers.formatPercentage(-1.25), '-1.25');
      expect(WorksheetHelpers.formatPercentage(-0.009), '~-0.01');

      // Percentage exactly equal to 0.01
      expect(WorksheetHelpers.formatPercentage(0.01), '0.01');
    });
  });

  group('WorksheetHelpers@isVariationConfirmationRequired should check weather variation confirmation is required or not', () {
    test('When any item requires variation confirmation and variation is not confirmed', () {
      final items = [
        SheetLineItemModel(
          productId: '1',
          title: 'Test',
          price: '100',
          qty: '2',
          totalPrice: '200',
          isConfirmedVariationRequired: true,
          isConfirmedVariation: false
        ),
        SheetLineItemModel(
            productId: '2',
            title: 'Test',
            price: '100',
            qty: '2',
            totalPrice: '200',
            isConfirmedVariationRequired: false,
            isConfirmedVariation: false
        ),
      ];
      expect(WorksheetHelpers.isVariationConfirmationRequired(items), isTrue);
    });

    test('When all items that require variation confirmation are already confirmed', () {
      final items = [
        SheetLineItemModel(
            productId: '1',
            title: '',
            price: '',
            qty: '',
            totalPrice: '',
            isConfirmedVariationRequired: true,
            isConfirmedVariation: true
        ),
        SheetLineItemModel(
            productId: '2',
            title: '',
            price: '',
            qty: '',
            totalPrice: '',
            isConfirmedVariationRequired: false,
            isConfirmedVariation: false
        ),
      ];
      expect(WorksheetHelpers.isVariationConfirmationRequired(items), isFalse);
    });

    test('When no items require variation confirmation', () {
      final items = [
        SheetLineItemModel(
            productId: '1',
            title: '',
            price: '',
            qty: '',
            totalPrice: '',
            isConfirmedVariationRequired: false,
            isConfirmedVariation: false
        ),
        SheetLineItemModel(
            productId: '2',
            title: '',
            price: '',
            qty: '',
            totalPrice: '',
            isConfirmedVariationRequired: false,
            isConfirmedVariation: true
        ),
      ];
      expect(WorksheetHelpers.isVariationConfirmationRequired(items), isFalse);
    });

    test('When list is empty', () {
      expect(WorksheetHelpers.isVariationConfirmationRequired([]), isFalse);
    });

    test('In case of multiple items, at least one requires variation confirmation and variation is not confirmed', () {
      final items = [
        SheetLineItemModel(
            productId: '1',
            title: '',
            price: '',
            qty: '',
            totalPrice: '',
            isConfirmedVariationRequired: false,
            isConfirmedVariation: false
        ),
        SheetLineItemModel(
            productId: '2',
            title: '',
            price: '',
            qty: '',
            totalPrice: '',
            isConfirmedVariationRequired: true,
            isConfirmedVariation: false
        ),
        SheetLineItemModel(
            productId: '3',
            title: '',
            price: '',
            qty: '',
            totalPrice: '',
            isConfirmedVariationRequired: true,
            isConfirmedVariation: true
        ),
      ];
      expect(WorksheetHelpers.isVariationConfirmationRequired(items), isTrue);
    });
  });
}
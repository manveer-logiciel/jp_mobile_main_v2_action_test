import 'package:flutter_test/flutter_test.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:jobprogress/common/enums/supplier_form_type.dart';
import 'package:jobprogress/common/models/forms/worksheet/supplier_form_params.dart';
import 'package:jobprogress/common/models/suppliers/beacon/account.dart';
import 'package:jobprogress/common/models/suppliers/branch.dart';
import 'package:jobprogress/common/models/suppliers/srs/srs_ship_to_address.dart';
import 'package:jobprogress/core/constants/supplier_constant.dart';
import 'package:jobprogress/core/constants/worksheet.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/select_supplier_branch/controller.dart';
import 'package:jp_mobile_flutter_ui/SingleSelect/model.dart';

void main() {

  late MaterialSupplierFormController controller;

  final SrsShipToAddressModel tempSelectedShipToAddress = SrsShipToAddressModel(
    id: 1, 
    addressLine1: '123 MAIN BLVD', 
    city: 'MCKINNEY', 
    state: 'TX', 
    zipCode: '75070',
  );
  final SupplierBranchModel tempSelectedBranch = SupplierBranchModel(
    id: 1, 
    branchCode: 'SSKEL', 
    name: 'SOUTHERN SHINGLES - AUBREY',
  );

  final List<SrsShipToAddressModel> tempShipToAddressList = [
    SrsShipToAddressModel(id: 1, shipToId: '23', addressLine1: '123 MAIN BLVD', city: 'MCKINNEY', state: 'TX', zipCode: '75070'),
    SrsShipToAddressModel(id: 2, shipToId: '24', addressLine1: '456 LAKESIDE SQ', city: 'ALLEN', state: 'TX', zipCode: '75013'),
  ];
  final List<SupplierBranchModel> tempBranchList = [
    SupplierBranchModel(id: 1, branchCode: 'SSKEL', name: 'SOUTHERN SHINGLES - AUBREY'),
    SupplierBranchModel(id: 2, branchCode: 'RLTEM', name: 'ROOF LINE - TEMPE'),
  ];

  setUpAll(() {
    controller = MaterialSupplierFormController(
        params: MaterialSupplierFormParams(
            srsBranch: null,
            srsShipToAddress: null,
            type: MaterialSupplierType.srs
        )
    );
  });

  group('In case of select srs branch', () {

    test('SelectSrsBranchSheetController should be initialized with correct values', () {
      expect(controller.getTitle, 'srs_distribution_account_verification'.tr.toUpperCase());
      expect(controller.isLoading, false);
      expect(controller.accountController.text, '');
      expect(controller.branchController.text, '');
      expect(controller.params.srsShipToAddress, null);
      expect(controller.params.srsBranch, null);
      expect(shipToAddressList.isEmpty, true);
      expect(srsBranchList.isEmpty, true);
    });

    group("SelectSrsBranchSheetController@toggleIsLoading should toggle form loading state", () {

      test("Srs Branch Shimmer should be displayed", () {
        controller.toggleIsLoading();
        expect(controller.isLoading, true);
      });

      test("Srs Branch Form should be displayed", () {
        controller.toggleIsLoading();
        expect(controller.isLoading, false);
      });
    });

    test('getDataFromShipToAddress() should be assign value in account address field', () {
      shipToAddressList = tempShipToAddressList;
      controller.getDataFromShipToAddress(tempShipToAddressList[0].id!.toString());
      expect(shipToAddressList.isEmpty, false);
      expect(controller.params.srsShipToAddress, tempShipToAddressList[0]);
      expect(controller.accountController.text, Helper.getAccountName(tempShipToAddressList[0]));
    });

    test('getDataFromBranch() should be assign value in branch field', () {
      srsBranchList = tempBranchList;
      controller.getDataFromBranch(tempBranchList[0].branchCode!.toString());
      expect(srsBranchList.isEmpty, false);
      expect(controller.params.srsBranch, tempBranchList[0]);
      expect(controller.branchController.text, tempBranchList[0].name!);
    });
  });

  group('In case of change srs branch', () {

    setUp(() {
      controller = MaterialSupplierFormController(
          params: MaterialSupplierFormParams(
            srsBranch: tempSelectedBranch,
            srsShipToAddress: tempSelectedShipToAddress,
            type: MaterialSupplierType.srs
          ),
      );
      shipToAddressList = tempShipToAddressList;
      srsBranchList = tempBranchList;
      controller.getDataFromBranch(tempSelectedBranch.branchCode!.toString());
    });

    test('SelectSrsBranchSheetController should be initialized with correct values', () {
      expect(controller.getTitle, 'srs_distribution_account_verification'.tr.toUpperCase());
      expect(controller.isLoading, false);
      expect(shipToAddressList.length, tempShipToAddressList.length);       
      expect(srsBranchList.length, tempBranchList.length);
      expect(controller.params.srsShipToAddress?.toJson(), tempSelectedShipToAddress.toJson());
      expect(controller.branchController.text, tempSelectedBranch.name);
      expect(controller.params.srsBranch?.toJson(), tempSelectedBranch.toJson());
    });

  });

  group("MaterialSupplierFormController@getTitle should give supplier selector title as per type", () {
    setUp(() {
      controller = MaterialSupplierFormController(
        params: MaterialSupplierFormParams(),
      );
    });

    test("In case of SRS while adding supplier for the first time", () {
      controller.isEdit = false;
      controller.params.type = MaterialSupplierType.srs;
      expect(controller.getTitle, 'srs_distribution_account_verification'.tr.toUpperCase());
    });

    test("In case of SRS while editing supplier", () {
      controller.isEdit = true;
      controller.params.type = MaterialSupplierType.srs;
      expect(controller.getTitle, 'confirm_srs_account'.tr.toUpperCase());
    });

    test("In case of Beacon while adding supplier for the first time", () {
      controller.isEdit = false;
      controller.params.type = MaterialSupplierType.beacon;
      expect(controller.getTitle, 'beacon_distribution_account_verification'.tr.toUpperCase());
    });

    test("In case of Beacon while editing supplier", () {
      controller.isEdit = true;
      controller.params.type = MaterialSupplierType.beacon;
      expect(controller.getTitle, 'confirm_beacon_account'.tr.toUpperCase());
    });
  });

  group("MaterialSupplierFormController@getSubtitle should give supplier selector sub title as per type", () {
    setUp(() {
      controller = MaterialSupplierFormController(
        params: MaterialSupplierFormParams(
          worksheetType: WorksheetConstants.estimate
        ),
      );
    });

    test("In case of SRS while adding supplier for the first time", () {
      controller.isEdit = false;
      controller.params.type = MaterialSupplierType.srs;
      expect(controller.getSubtitle, 'activate_an_srs_distribution'.tr);
    });

    test("In case of SRS while editing supplier", () {
      controller.isEdit = true;
      controller.params.type = MaterialSupplierType.srs;
      expect(controller.getSubtitle, 'activate_an_srs_distribution'.tr);
    });

    test("In case of Beacon while adding supplier for the first time", () {
      controller.isEdit = false;
      controller.params.type = MaterialSupplierType.beacon;
      expect(controller.getSubtitle, 'activate_an_beacon_distribution'.tr);
    });

    test("In case of Beacon while editing supplier", () {
      controller.isEdit = true;
      controller.params.type = MaterialSupplierType.beacon;
      expect(controller.getSubtitle, 'activate_an_beacon_distribution'.tr);
    });

    test("In case of ABC while adding supplier for the first time", () {
      controller.isEdit = false;
      controller.params.type = MaterialSupplierType.abc;
      expect(controller.getSubtitle, 'activate_an_abc_distribution'.tr);
    });

    test("In case of ABC while editing supplier", () {
      controller.isEdit = true;
      controller.params.type = MaterialSupplierType.abc;
      expect(controller.getSubtitle, 'activate_an_abc_distribution'.tr);
    });

    test("In case of type is not worksheet", () {
      controller.params.worksheetType = '';
      expect(controller.getSubtitle, '');
    });
  });

  group("MaterialSupplierFormController@disableForm should conditionally disable the form", () {
    setUp(() {
      controller = MaterialSupplierFormController(
        params: MaterialSupplierFormParams(),
      );
    });

    test("Form should be disabled while loading supplier details", () {
      controller.isLoading = true;
      expect(controller.disableForm, true);
    });

    test("Form should be enabled while not loading supplier details", () {
      controller.isLoading = false;
      expect(controller.disableForm, false);
    });

    test("Form should be disabled while loading job account details", () {
      controller.isLoadingJobAccount = true;
      expect(controller.disableForm, true);
    });

    test("Form should be enabled while not loading job account details", () {
      controller.isLoadingJobAccount = false;
      controller.isLoading = false;
      expect(controller.disableForm, false);
    });
  });

  group("MaterialSupplierFormController@toggleIsLoading should enable and disable form loading", () {
    setUp(() {
      controller = MaterialSupplierFormController(
        params: MaterialSupplierFormParams(),
      );
    });

    test("Form should be disabled while loading supplier details", () {
      controller.isLoading = false;
      controller.toggleIsLoading();
      expect(controller.isLoading, true);
    });

    test("Form should be enabled while not loading supplier details", () {
      controller.isLoading = true;
      controller.toggleIsLoading();
      expect(controller.isLoading, false);
    });
  });

  group("MaterialSupplierFormController@toggleIsLoadingJobAccount should enable and disable job field loading", () {
    setUp(() {
      controller = MaterialSupplierFormController(
        params: MaterialSupplierFormParams(),
      );
    });

    test("Job Fields should be disabled while loading job account details", () {
      controller.isLoadingJobAccount = false;
      controller.toggleIsLoadingJobAccount(true);
      expect(controller.isLoadingJobAccount, true);
    });

    test("Job Field should be enabled while not loading job account details", () {
      controller.isLoadingJobAccount = true;
      controller.toggleIsLoadingJobAccount(false);
      expect(controller.isLoadingJobAccount, false);
    });
  });

  group("MaterialSupplierFormController@getAccountOptions should parse account list to options list", () {
    setUp(() {
      controller = MaterialSupplierFormController(
        params: MaterialSupplierFormParams(),
      );
    });

    test("In case of SRS Ship To Addresses should be converted to options list", () {
      shipToAddressList = [
        SrsShipToAddressModel(
          id: 1,
          shipToSequenceId: '123'
        )
      ];
      controller.params.type = MaterialSupplierType.srs;
      final result = controller.getAccountOptions();
      expect(result, hasLength(1));
      expect(result.first, isA<JPSingleSelectModel>());
      expect(result.first.id, '1');
      expect(result.first.label, '123');
    });

    test("In case of Beacon, Beacon Accounts should be converted to options list", () {
      beaconAccountsList = [
        BeaconAccountModel(
          id: 1,
          name: '123',
        )
      ];
      controller.params.type = MaterialSupplierType.beacon;
      final result = controller.getAccountOptions();
      expect(result, hasLength(1));
      expect(result.first, isA<JPSingleSelectModel>());
      expect(result.first.id, '1');
      expect(result.first.label, '123');
    });
  });

  group("MaterialSupplierFormController@getBranchOptions should parse branch list to options list", () {
    setUp(() {
      controller = MaterialSupplierFormController(
        params: MaterialSupplierFormParams(),
      );
    });

    test("In case of SRS, SRS Branches should be converted to options list", () {
      srsBranchList = [
        SupplierBranchModel(
          branchCode: '1',
          name: 'abc'
        )
      ];
      controller.params.type = MaterialSupplierType.srs;
      final result = controller.getBranchOptions();
      expect(result, hasLength(1));
      expect(result.first, isA<JPSingleSelectModel>());
      expect(result.first.id, '1');
      expect(result.first.label, 'abc');
    });

    test("In case of Beacon, Beacon Branches should be converted to options list", () {
      beaconBranchList = [
        SupplierBranchModel(
          branchCode: '1',
          name: 'abc'
        )
      ];
      controller.params.type = MaterialSupplierType.beacon;
      final result = controller.getBranchOptions();
      expect(result, hasLength(1));
      expect(result.first, isA<JPSingleSelectModel>());
      expect(result.first.id, '1');
      expect(result.first.label, 'abc');
    });

    test("In case of ABC, ABC Branches should be converted to options list", () {
      abcBranchList = [
        SupplierBranchModel(
            branchCode: '1',
            name: 'abc'
        )
      ];
      controller.params.type = MaterialSupplierType.abc;
      final result = controller.getBranchOptions();
      expect(result, hasLength(1));
      expect(result.first, isA<JPSingleSelectModel>());
      expect(result.first.id, '1');
      expect(result.first.label, 'abc');
    });
  });

  group("MaterialSupplierFormController@onBeaconAccountSelected should set beacon account details", () {
    setUp(() {
      controller = MaterialSupplierFormController(
        params: MaterialSupplierFormParams(),
      );
      beaconAccountsList = [
        BeaconAccountModel(
          id: 1,
          name: 'abc',
          supplierBranch: SupplierBranchModel(
            branchCode: '1',
            name: 'xyz'
          )
        ),
        BeaconAccountModel(
          id: 2,
          name: 'xyz'
        )
      ];
      controller.params.type = MaterialSupplierType.beacon;
    });

    test("Beacon account should be selected", () {
      controller.onAccountSelected('1');
      expect(controller.params.beaconAccount, isNotNull);
      expect(controller.params.beaconAccount?.id, 1);
      expect(controller.params.beaconAccount?.name, 'abc');
      expect(controller.accountController.text, 'abc');
    });

    test("Beacon branch should set properly", () {
      controller.onAccountSelected('1');
      expect(controller.params.beaconBranch, isNotNull);
      expect(controller.params.beaconBranch?.branchCode, '1');
      expect(controller.params.beaconBranch?.name, 'xyz');
      expect(controller.branchController.text, 'xyz');
    });

    test("Beacon Job should be removed", () {
      controller.onAccountSelected('1');
      expect(controller.params.beaconJob, isNull);
    });

    test('In case beacon account is not found', () {
      controller.onAccountSelected('4');
      expect(controller.params.beaconAccount, isNull);
      expect(controller.accountController.text, '');
      expect(controller.branchController.text, '');
      expect(controller.params.beaconJob, isNull);
      expect(controller.params.beaconBranch, isNull);
      expect(controller.params.beaconJob, isNull);
    });
  });

  group("'Job Account' field should be displayed conditionally", () {
    setUp(() {
      controller = MaterialSupplierFormController(
        params: MaterialSupplierFormParams(),
      );
    });

    group('In case of Beacon supplier selection', () {
      test("Field should not be displayed when excluded explicitly", () {
        controller.params.type = MaterialSupplierType.beacon;
        controller.params.excludeJob = true;
        expect(controller.showJobAccounts, isFalse);
      });

      test("Field should not be displayed when excluded implicitly", () {
        controller.params.type = MaterialSupplierType.beacon;
        controller.params.excludeJob = false;
        expect(controller.showJobAccounts, isTrue);
      });
    });

    test("Field should not be displayed in case of SRS supplier selection", () {
      controller.params.type = MaterialSupplierType.srs;
      expect(controller.showJobAccounts, isFalse);
    });
  });

  group('MaterialSupplierFormController@getBeaconBranchJobAccounts', () {
    test('When job accounts does not exist', () {
      final result = controller.getBeaconBranchJobAccounts('non_existing_account_id');
      expect(result, isEmpty);
    });

    test('When job accounts does exist', () {
      final result = controller.getBeaconBranchJobAccounts('existing_account_id');
      expect(result, isList);
      expect(result, everyElement(isA<JPSingleSelectModel>()));
    });
  });

  group('MaterialSupplierFormController@getDefaultBeaconBranchId() should return Beacon Account id', () {
    setUp(() {
      beaconAccountsList = [
        BeaconAccountModel(
          accountId: 1,
          supplierBranch: SupplierBranchModel()
        ),
        BeaconAccountModel(
          accountId: 2,
          supplierBranch: SupplierBranchModel()
        )
      ];
    });
    test('When Beacon Account is available', () {
      controller.params.beaconAccount?.accountId = 1;

      String result = controller.getDefaultBeaconBranchId();

      expect(result, '1');
    });

    group('When Beacon Account is not available', () {
      test('Default company branch is saved', () {
        controller.params.beaconAccount?.accountId = null;
        beaconAccountsList[1].supplierBranch?.defaultCompanyBranch = SupplierConstant.defaultCompanyBranch;

        String result = controller.getDefaultBeaconBranchId();

        expect(result, '2');
      });

      test('Default company branch is not saved', () {
        controller.params.beaconAccount?.accountId = null;
        beaconAccountsList[0].accountId = 123;

        String result = controller.getDefaultBeaconBranchId();

        expect(result, '123');
      });
    });
  });

  group('In case of select ABC branch', () {
    test('MaterialSupplierFormController should be initialized with correct values', () {
      controller.params.type = MaterialSupplierType.abc;
      abcAccountList = [];
      abcBranchList = [];
      expect(controller.getTitle, 'abc_distribution_account_verification'.tr.toUpperCase());
      expect(controller.isLoading, false);
      expect(controller.accountController.text, '');
      expect(controller.branchController.text, '');
      expect(controller.params.abcAccount, null);
      expect(controller.params.abcBranch, null);
      expect(abcAccountList.isEmpty, true);
      expect(abcBranchList.isEmpty, true);
    });

    test('getDataFromAbcAddress() should be assign value in account address field', () {
      abcAccountList = tempShipToAddressList;
      controller.getDataFromAbcAddress(tempShipToAddressList[0].id!.toString());
      expect(abcAccountList.isEmpty, false);
      expect(controller.params.abcAccount, tempShipToAddressList[0]);
      expect(controller.accountController.text, Helper.getAbcAccountName(tempShipToAddressList[0]));
    });

    test('getDataFromAbcBranch() should be assign value in branch field', () {
      abcBranchList = tempBranchList;
      controller.getDataFromAbcBranch(tempBranchList[0].branchCode!.toString());
      expect(abcBranchList.isEmpty, false);
      expect(controller.params.abcBranch, tempBranchList[0]);
      expect(controller.branchController.text, tempBranchList[0].name!);
    });
  });

  group('In case of change ABC branch', () {

    setUp(() {
      controller = MaterialSupplierFormController(
        params: MaterialSupplierFormParams(
            abcBranch: tempSelectedBranch,
            abcAccount: tempSelectedShipToAddress,
            type: MaterialSupplierType.abc
        ),
      );
      abcAccountList = tempShipToAddressList;
      abcBranchList = tempBranchList;
      controller.getDataFromAbcBranch(tempSelectedBranch.branchCode!.toString());
    });

    test('MaterialSupplierFormController should be initialized with correct values', () {
      expect(controller.getTitle, 'abc_distribution_account_verification'.tr.toUpperCase());
      expect(controller.isLoading, false);
      expect(abcAccountList.length, tempShipToAddressList.length);
      expect(abcBranchList.length, tempBranchList.length);
      expect(controller.params.abcAccount?.toJson(), tempSelectedShipToAddress.toJson());
      expect(controller.branchController.text, Helper.getAbcBranchName(tempSelectedBranch));
      expect(controller.params.abcBranch?.toJson(), tempSelectedBranch.toJson());
    });
  });

  group('Helper@isIntegratedSupplier should check weather integrated supplier exists', () {
    test('When Supplier is not available', () {
      expect(Helper.isIntegratedSupplier(null), false);
    });

    test('When Integrated supplier is not available', () {
      int? supplierId = 5; // Non Integrated supplier id
      expect(Helper.isIntegratedSupplier(supplierId), false);
    });

    test('When SRS v1 integrated supplier is available', () {
      int? supplierId = 3; // SRS v1 Integrated supplier id
      expect(Helper.isIntegratedSupplier(supplierId), true);
    });

    test('When SRS v2 integrated supplier is available', () {
      int? supplierId = 181; // SRS v2 Integrated supplier id
      expect(Helper.isIntegratedSupplier(supplierId), true);
    });

    test('When Beacon integrated supplier is available', () {
      int? supplierId = 173; // Beacon Integrated supplier id
      expect(Helper.isIntegratedSupplier(supplierId), true);
    });

    test('When ABC integrated supplier is available', () {
      int? supplierId = 188; // ABC Integrated supplier id
      expect(Helper.isIntegratedSupplier(supplierId), true);
    });
  });
}
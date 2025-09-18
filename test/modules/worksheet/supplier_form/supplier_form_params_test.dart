import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/enums/supplier_form_type.dart';
import 'package:jobprogress/common/models/forms/worksheet/supplier_form_params.dart';
import 'package:jobprogress/common/models/suppliers/beacon/account.dart';
import 'package:jobprogress/common/models/suppliers/branch.dart';
import 'package:jobprogress/common/models/suppliers/srs/srs_ship_to_address.dart';

void main() {
  final params = MaterialSupplierFormParams();

  group("MaterialSupplierFormParams@isDataAvailable should decide branch/account details to be prefilled", () {
    test('When no branch details are available they should not be prefilled', () {
      expect(params.isDataAvailable, false);
    });

    test('When SRS branch details are available they should be prefilled', () {
      params.srsShipToAddress = SrsShipToAddressModel();
      params.srsBranch = SupplierBranchModel();
      expect(params.isDataAvailable, true);
    });

    test('When beacon branch details are available they should be prefilled', () {
      params.beaconAccount = BeaconAccountModel();
      params.beaconBranch = SupplierBranchModel();
      expect(params.isDataAvailable, true);
    });
  });

  group("MaterialSupplierFormParams@selectedAccountId should get selected account id for the supplier", () {
    test('SRS ship to address id should be the selected account id', () {
      params.srsShipToAddress = SrsShipToAddressModel(id: 10);
      params.srsBranch = SupplierBranchModel();
      params.type = MaterialSupplierType.srs;
      expect(params.selectedAccountId, params.srsShipToAddress!.id.toString());
    });

    test('Beacon account id should be the selected account id', () {
      params.beaconAccount = BeaconAccountModel(id: 10);
      params.beaconBranch = SupplierBranchModel();
      params.type = MaterialSupplierType.beacon;
      expect(params.selectedAccountId, params.beaconAccount!.id.toString());
    });

    test("When type is missing, no account id should be selected", () {
      params.type = null;
      expect(params.selectedAccountId, "");
    });
  });

  group("MaterialSupplierFormParams@selectedBranchId should get selected branch id for the supplier", () {
    test('SRS branch id should be the selected branch id', () {
      params.srsShipToAddress = SrsShipToAddressModel();
      params.srsBranch = SupplierBranchModel(branchCode: '10');
      params.type = MaterialSupplierType.srs;
      expect(params.selectedBranchId, params.srsBranch!.branchCode.toString());
    });

    test('Beacon branch id should be the selected branch id', () {
      params.beaconAccount = BeaconAccountModel();
      params.beaconBranch = SupplierBranchModel(branchCode: '10');
      params.type = MaterialSupplierType.beacon;
      expect(params.selectedBranchId, params.beaconBranch!.branchCode.toString());
    });

    test('ABC branch id should be the selected branch id', () {
      params.abcAccount = SrsShipToAddressModel();
      params.abcBranch = SupplierBranchModel(branchCode: '10');
      params.type = MaterialSupplierType.abc;
      expect(params.selectedBranchId, params.beaconBranch!.branchCode.toString());
    });

    test("When type is missing, no branch id should be selected", () {
      params.type = null;
      expect(params.selectedBranchId, "");
    });
  });
}
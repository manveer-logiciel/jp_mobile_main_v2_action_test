import 'dart:ui';

import 'package:jobprogress/common/enums/supplier_form_type.dart';
import 'package:jobprogress/common/models/suppliers/beacon/job.dart';
import 'package:jobprogress/common/models/suppliers/branch.dart';
import 'package:jobprogress/common/models/suppliers/srs/srs_ship_to_address.dart';
import 'package:jobprogress/common/models/suppliers/beacon/account.dart';
import 'package:jobprogress/core/utils/helpers.dart';

/// [MaterialSupplierFormParams] holds the form params for material supplier
/// selector, hence different supplier can be selected using same form
class MaterialSupplierFormParams {
  /// [srsShipToAddress] and [srsBranch] hold the data for SRS Supplier
  SrsShipToAddressModel? srsShipToAddress;
  SupplierBranchModel? srsBranch;

  /// [beaconAccount] and [beaconBranch] holds the data for beacon supplier
  BeaconAccountModel? beaconAccount;
  SupplierBranchModel? beaconBranch;
  BeaconJobModel? beaconJob;

  /// [type] helps in deciding the type of supplier selector form to be displayed
  MaterialSupplierType? type;

  /// [excludeJob] helps in excluding job field in case of Beacon
  /// [True] - Job Account filed will not be shown
  /// [False] or [Null] - Job Account filed will be shown in case when [type] is [MaterialSupplierType.beacon]
  bool? excludeJob;

  /// [isBranchMakeDefault] helps in saving default branch
  bool isBranchMakeDefault;

  /// [isDefaultBranchSaved] helps in showing default branch
  bool isDefaultBranchSaved;

  /// [isChooseDifferentBranch] helps in showing branch bottom sheet
  bool isChooseDifferentBranch;

  VoidCallback? onChooseDifferentBranch;

  int? srsSupplierId;

  /// [abcAccount] and [abcBranch] hold the data for SRS Supplier
  SrsShipToAddressModel? abcAccount;
  SupplierBranchModel? abcBranch;

  String? worksheetType;

  MaterialSupplierFormParams({
    this.srsShipToAddress,
    this.srsBranch,
    this.beaconAccount,
    this.beaconBranch,
    this.beaconJob,
    this.type = MaterialSupplierType.srs,
    this.excludeJob,
    this.isBranchMakeDefault = false,
    this.isDefaultBranchSaved = false,
    this.isChooseDifferentBranch = false,
    this.onChooseDifferentBranch,
    this.srsSupplierId,
    this.abcAccount,
    this.abcBranch,
    this.worksheetType
  });

  /// [isDataAvailable] is used to check whether supplier details are already selected or not
  /// so that Supplier Selector Form can be pre-filled with available details
  bool get isDataAvailable =>
      (srsShipToAddress != null && srsBranch != null)
          || (beaconAccount != null && beaconBranch != null)
          || (abcAccount != null && abcBranch != null);

  /// [selectedAccountId] is used to get selected account id for the supplier
  /// on the basis of selected supplier [type]
  String get selectedAccountId {
    switch (type) {
      case MaterialSupplierType.srs:
        return (srsShipToAddress?.id ?? "").toString();
      case MaterialSupplierType.beacon:
        return (beaconAccount?.id ?? "").toString();
      case MaterialSupplierType.abc:
        return (abcAccount?.id ?? "").toString();
      default:
        return "";
    }
  }

  /// [selectedBranchId] is used to get selected branch id for the supplier
  /// on the basis of selected supplier [type]
  String get selectedBranchId {
    switch (type) {
      case MaterialSupplierType.srs:
        return srsBranch?.branchCode ?? "";
      case MaterialSupplierType.beacon:
        return beaconBranch?.branchCode ?? "";
      case MaterialSupplierType.abc:
        return abcBranch?.branchCode ?? "";
      default:
        return "";
    }
  }

  /// [selectedAccountName] is used to get selected account name for the supplier
  /// on the basis of selected supplier [type]
  String get selectedAccountName {
    switch (type) {
      case MaterialSupplierType.srs:
        return Helper.getAccountName(srsShipToAddress);
      case MaterialSupplierType.beacon:
        return beaconAccount?.name ?? "";
      case MaterialSupplierType.abc:
        return Helper.getAbcAccountName(abcAccount);
      default:
        return "";
    }
  }

  /// [selectedBranchName] is used to get selected branch name for the supplier
  /// on the basis of selected supplier [type]
  String get selectedBranchName {
    switch (type) {
      case MaterialSupplierType.srs:
        return srsBranch?.name ?? "";
      case MaterialSupplierType.beacon:
        return beaconBranch?.name ?? "";
      case MaterialSupplierType.abc:
        return abcBranch?.name ?? "";
      default:
        return "";
    }
  }
}
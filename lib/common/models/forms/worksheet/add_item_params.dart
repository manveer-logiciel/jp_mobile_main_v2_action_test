
import 'package:jobprogress/common/models/company_trades/company_trades_model.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/common/models/suppliers/beacon/account.dart';
import 'package:jobprogress/common/models/suppliers/branch.dart';
import 'package:jobprogress/common/models/worksheet/settings/index.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../enums/file_listing.dart';
import '../../job/job_division.dart';

class WorksheetAddItemParams {

  List<JPSingleSelectModel> allCategories;
  List<JPSingleSelectModel> allTrade;
  List<JPSingleSelectModel> allSuppliers;
  SheetLineItemModel? lineItem;
  WorksheetSettingModel settings;
  String worksheetType;
  String? srsBranchCode;
  String? beaconBranchCode;
  String? beaconJobNumber;
  String? shipToSequenceId;
  bool? isSRSEnabled;
  bool? isBeaconEnabled;
  int? forSupplierId;
  BeaconAccountModel? beaconAccount;
  SupplierBranchModel? supplierBranch;
  FLModule? flModule;
  int? srsSupplierId;
  String? abcBranchCode;
  bool? isAbcEnabled;
  String? supplierAccountId;
  CompanyTradesModel? tradeTypeDefault;
  DivisionModel? jobDivision;

  WorksheetAddItemParams({
    required this.allCategories,
    required this.allTrade,
    required this.allSuppliers,
    required this.worksheetType,
    required this.settings,
    this.lineItem,
    this.srsBranchCode,
    this.beaconBranchCode,
    required this.shipToSequenceId,
    this.isSRSEnabled,
    this.isBeaconEnabled,
    this.beaconJobNumber,
    this.forSupplierId,
    this.beaconAccount,
    this.supplierBranch,
    this.flModule,
    this.srsSupplierId,
    this.abcBranchCode,
    this.isAbcEnabled,
    this.supplierAccountId,
    this.tradeTypeDefault,
    this.jobDivision
  });

  /// [isAnySupplierEnabled] checks if any supplier integration is enabled
  ///
  /// Performance Fix:
  /// Used to determine when system category parameters should be included in API calls.
  /// System categories are only relevant when supplier integrations are active.
  ///
  /// Returns:
  /// - true if any supplier (SRS, Beacon, or ABC) is enabled
  /// - false if no supplier integrations are active
  bool isAnySupplierEnabled() {
    return Helper.isTrue(isSRSEnabled) || Helper.isTrue(isBeaconEnabled) || Helper.isTrue(isAbcEnabled);
  }

}
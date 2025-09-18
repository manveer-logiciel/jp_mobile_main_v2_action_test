import 'package:jobprogress/common/models/suppliers/beacon/account.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import '../../../core/constants/pagination_constants.dart';
import '../job/job_division.dart';
import '../suppliers/branch.dart';

class FinancialProductSearchModel {
  late int limit;
  late int page;
  String? name;
  String? description;
  String? categoryName;
  String? categoryId;
  String? systemCategoryId;
  String? src;
  List<String>? includes;
  late bool includeSrsProducts;
  String? srsBranchCode;
  String? shipToSequenceId;
  String? title;
  String? selectedCategorySlug;
  bool? isSellingPriceEnabled;
  int? onlyQbdProducts;
  /// [beaconBranchCode] is used to search beacon products. In case, [beaconBranchCode]
  /// is not available products will be searched from available material products
  String? beaconBranchCode;
  String? beaconJobNumber;
  int? forSupplierId;
  BeaconAccountModel? beaconAccount;
  SupplierBranchModel? supplierBranch;
  int? srsSupplierId;
  String? abcBranchCode;
  String? supplierAccountId;
  DivisionModel? jobDivision;

  FinancialProductSearchModel({
    this.limit = PaginationConstants.pageLimit,
    this.page = 1,
    this.src = 'all',
    this.name,
    this.description,
    this.categoryName,
    this.categoryId,
    this.systemCategoryId,
    this.includes,
    this.includeSrsProducts = false,
    this.srsBranchCode,
    this.title,
    this.selectedCategorySlug,
    this.isSellingPriceEnabled,
    this.shipToSequenceId,
    this.beaconBranchCode,
    this.beaconJobNumber,
    this.forSupplierId,
    this.beaconAccount,
    this.supplierBranch,
    this.srsSupplierId,
    this.abcBranchCode,
    this.supplierAccountId,
    this.jobDivision
  }) {
    disableUnitCostForStandardUser();
  }

  /// [hasSupplier] is used to check whether supplier is available or not
  bool get hasSupplier => !Helper.isValueNullOrEmpty(srsBranchCode)
      || !Helper.isValueNullOrEmpty(beaconBranchCode) || !Helper.isValueNullOrEmpty(abcBranchCode);

  FinancialProductSearchModel.fromJson(Map<String, dynamic> json) {
    limit = int.tryParse(json['limit']?.toString() ?? '')!;
    page = int.tryParse(json['page']?.toString() ?? '')!;
    src = json['src'];
    name = json['name'];
    description = json['description'];
    categoryName = json['category_name'];
    categoryId = json['categories_ids[0]'];
    systemCategoryId = json['categories_ids[1]'];
    includeSrsProducts = Helper.isTrue(json['include_srs_products']);
    srsBranchCode = json['with_srs'];
    disableUnitCostForStandardUser();
  }

  /// [disableUnitCostForStandardUser] helps in disabling unit cost for standard user
  /// when this user-role is not permitted to view unit cost
  void disableUnitCostForStandardUser() {
    if (AuthService.isStandardUser()) {
      if(!PermissionService.hasUserPermissions([PermissionConstants.viewUnitCost])) {
        isSellingPriceEnabled = true;
      }
    }
  }

  /// [toJson] converts the model to JSON format for API requests
  ///
  /// Performance Fix:
  /// - Conditionally sends systemCategoryId only when it has a value
  /// - This prevents unnecessary category parameters that caused 15-20 second delays
  /// - Web doesn't send empty category parameters and performs better
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['limit'] = limit;
    data['page'] = page;
    data['src'] = (forSupplierId != null ? 'supplier' : 'all');
    data['name'] = name;
    data['description'] = description;
    data['category_name'] = categoryName;
    
    // Always send categoryId as it's expected by the API for basic filtering
    data['categories_ids[0]'] = categoryId;
    
    // Performance optimization: Only send systemCategoryId when it has a meaningful value
    // This prevents sending empty/null system category parameters that cause backend delays
    if (!Helper.isValueNullOrEmpty(systemCategoryId)) {
      data['categories_ids[1]'] = systemCategoryId;
    }
    
    // Filtering api request params on the basis of supplier
    if (beaconBranchCode != null) {
      data['include_beacon_products'] = 1;
      data['supplier_id'] = Helper.getSupplierId(key: CommonConstants.beaconId);
      data['with_beacon'] = beaconBranchCode;
    } else if (srsBranchCode != null) {
      data['include_srs_products'] = includeSrsProducts ? 1 : 0;
      data['with_srs'] = srsBranchCode;
      data['supplier_id'] = srsSupplierId ?? Helper.getSupplierId();
    } else if(abcBranchCode != null) {
      data['include_abc_products'] = 1;
      data['with_abc'] = abcBranchCode;
    }

    if (onlyQbdProducts != null) data['only_qbd_products'] = onlyQbdProducts;
    
    for (var i = 0; i < (includes?.length ?? 0); i++) {
      data['includes[$i]'] = includes![i];
    }
    
    return data;
  }
}
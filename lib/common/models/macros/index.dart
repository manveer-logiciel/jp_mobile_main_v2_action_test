import 'package:jobprogress/common/enums/sheet_line_item_type.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/common/models/suppliers/branch.dart';
import 'package:jobprogress/common/services/launch_darkly/index.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';

import '../../../core/utils/helpers.dart';

class MacroListingModel {
  String? macroName;
  String? type;
  String? macroId;
  int? tradeId;
  int? forAllTrades;
  String? createdAt;
  String? updatedAt;
  String? branchCode;
  int? order;
  int? allDivisionsAccess;
  num? fixedPrice;
  int? isDraft;
  String? tradeName;
  List<SheetLineItemModel>? details;
  bool isChecked = false;
  SupplierBranchModel? branch;

  MacroListingModel({this.macroName,
    this.type,
    this.macroId,
    this.tradeId,
    this.forAllTrades,
    this.createdAt,
    this.updatedAt,
    this.branchCode,
    this.order,
    this.allDivisionsAccess,
    this.fixedPrice,
    this.details,
    this.tradeName,
    this.isDraft,
    this.isChecked = false,
    this.branch,
  });

  MacroListingModel.fromJson(Map<String, dynamic> json, {AddLineItemFormType? pageType}) {
    macroName = json['macro_name'];
    type = json['type'];
    macroId = json['macro_id'];
    tradeId = json['trade_id'];
    forAllTrades = json['for_all_trades'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    branchCode = json['branch_code']?.toString();
    branch = SupplierBranchModel.fromJson(json['branch'] ?? {});
    order = json['order'];
    allDivisionsAccess = json['all_divisions_access'];
    fixedPrice = num.tryParse(json['fixed_price']?.toString() ?? "");
    isDraft = json['is_draft'];
    if (json['details']?['data'] is List) {
      details = [];
      json['details']?['data']?.forEach((dynamic data) {
        SheetLineItemModel item;
        switch (pageType) {
          case AddLineItemFormType.worksheet:
            data['trade_id'] = tradeId;
            item = SheetLineItemModel.fromWorkSheetJson(data);
            break;

          case AddLineItemFormType.insuranceForm:
            item = SheetLineItemModel.fromEstimateJson(data);
            break;  

          default:
            item = SheetLineItemModel.fromJson(data);
        }
        // sets up variant on macro if missing
        item.setVariantOnMacro();
        details?.add(item);
      });
    }
    tradeName = json['trade']?['name'];
  }

  MacroListingModel.fromJsonViewDetail(Map<String, dynamic> json) {
    macroName = json['macro_name'];
    type = json['type'];
    macroId = json['macro_id'];
    tradeId = json['trade_id'];
    forAllTrades = json['for_all_trades'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    branchCode = json['branch_code']?.toString();
    order = json['order'];
    allDivisionsAccess = json['all_divisions_access'];
    fixedPrice = json['fixed_price'];
    isDraft = json['is_draft'];
    details = json['details'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['macro_name'] = macroName;
    data['type'] = type;
    data['macro_id'] = macroId;
    data['trade_id'] = tradeId;
    data['for_all_trades'] = forAllTrades;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['branch_code'] = branchCode?.toString();
    data['order'] = order;
    data['all_divisions_access'] = allDivisionsAccess;
    data['fixed_price'] = fixedPrice;
    data['is_draft'] = isDraft;
    return data;
  }

  static Map<String, dynamic> getMacrosParams(String type, {
    String? srsBranchCode,
    String? beaconBranchCode,
    int? srsSupplierId,
    String? abcBranchCode,
    int? jobDivisionId
  }) {
    return {
      'includes[0]': 'trade',
      'includes[1]': 'branch',
      'includes[2]': 'total_product_count',
      'includes[3]': 'divisions',
      'type[0]': type,
      if(jobDivisionId != null)
       'division_ids[]': jobDivisionId,
      // adding additional request params on the basis of selected branch
      if (srsBranchCode != null) ...{
        'type[1]': 'srs',
        'with_srs': 1,
        'branch_code': srsBranchCode,
        if(srsSupplierId != null)
          'supplier_id': srsSupplierId,
        if(Helper.isSRSv2Id(Helper.getSupplierId())) ...{
          'exclude_suppliers[]': Helper.isSRSv1Id(srsSupplierId)
              ? Helper.getSRSV2Supplier() : Helper.getSRSV1Supplier()
        }
      },
      if (beaconBranchCode != null) ...{
        'type[1]': 'beacon',
        'with_beacon': 1,
        'branch_code': beaconBranchCode
      },
      if(abcBranchCode != null) ...{
        'type[1]': 'abc',
        'with_abc': 1,
        'branch_code': abcBranchCode
      },
      'limit': 0,
    };
  }

  static Map<String, dynamic> getViewMacrosParams(String macroId, {String? branchCode, int? supplierId}) {
    return {
      'includes[0]': 'details',
      'includes[1]': 'details.financial_product_detail',
      'includes[2]': 'branch',
      'includes[3]': 'details.ship_to_address',
      'includes[4]': 'branch.beacon_account',
      if(branchCode?.isNotEmpty ?? false)...{
        'includes[5]': 'details.variants',
        if(LDService.hasFeatureEnabled(LDFlagKeyConstants.abcMaterialIntegration))
          'includes[6]': 'branch.supplier_accounts',
        'branch_code': branchCode,
      },
      'macro_id': macroId,
      if(supplierId != null)
        'supplier_id': supplierId
    };
  }

  static Map<String, dynamic> getViewSelectedMacroParams(List<String> macroIds, {String? branchCode, int? supplierId}) {
    return {
      'includes[0]': 'details',
      'includes[1]':'details.measurement_formulas',
      'includes[2]': 'details.financial_product_detail',
      'includes[3]': 'trade',
      if(branchCode?.isNotEmpty ?? false)...{
        'includes[4]': 'details.variants',
        'branch_code': branchCode,
      },
      for(int i = 0; i < macroIds.length; i++)
        'macro_ids[$i]': macroIds[i],
      if(supplierId != null)
        'supplier_id': supplierId
    };
  }
}
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class WorksheetDetailCategoryModel {

  int? id;
  String? name;
  int? theDefault;
  int? order;
  String? slug;
  String? qbDesktopId;
  String? qbDesktopSequenceNumber;
  String? financialAccountId;
  int? active;
  String? deletedAt;
  String? deletedBy;
  int? worksheetsCount;
  WorksheetDetailCategoryModel? systemCategory;

  WorksheetDetailCategoryModel({
    this.id,
    this.name,
    this.theDefault,
    this.order,
    this.slug,
    this.qbDesktopId,
    this.qbDesktopSequenceNumber,
    this.financialAccountId,
    this.active,
    this.deletedAt,
    this.deletedBy,
    this.worksheetsCount,
    this.systemCategory,
  });

  WorksheetDetailCategoryModel.fromJson(Map<String, dynamic>? json) {

    if (json == null) return;

    id = int.tryParse(json['id']?.toString() ?? '');
    name = json['name']?.toString();
    theDefault = int.tryParse(json['default']?.toString() ?? '');
    order = int.tryParse(json['order']?.toString() ?? '');
    slug = json['slug']?.toString();
    qbDesktopId = json['qb_desktop_id']?.toString();
    qbDesktopSequenceNumber = json['qb_desktop_sequence_number']?.toString();
    financialAccountId = json['financial_account_id']?.toString();
    active = int.tryParse(json['active']?.toString() ?? '');
    deletedAt = json['deleted_at']?.toString();
    deletedBy = json['deleted_by']?.toString();
    worksheetsCount = json['worksheets_count'];
    systemCategory = json['system_category'] is Map
        ? WorksheetDetailCategoryModel.fromJson(json['system_category']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['default'] = theDefault;
    data['order'] = order;
    data['slug'] = slug;
    data['qb_desktop_id'] = qbDesktopId;
    data['qb_desktop_sequence_number'] = qbDesktopSequenceNumber;
    data['financial_account_id'] = financialAccountId;
    data['active'] = active;
    data['deleted_at'] = deletedAt;
    data['deleted_by'] = deletedBy;
    return data;
  }

  JPSingleSelectModel toSingleSelect() {
    return JPSingleSelectModel(
      id: id.toString(),
      label: name.toString(),
      additionalData: this,
    );
  }
}
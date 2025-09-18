class AccountingHeadModel {
  int? id;
  String? parentId;
  String? name;
  String? accountType;
  String? accountSubType;
  String? classification;
  String? description;
  String? createdAt;
  String? updatedAt;
  int? quickbookSyncStatus;
  String? origin;
  int? quickbookId;
  String? qbDesktopId;
  int? isActive;
  String? deletedAt;

  AccountingHeadModel({
    this.id,
    this.parentId,
    this.name,
    this.accountType,
    this.accountSubType,
    this.classification,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.quickbookSyncStatus,
    this.origin,
    this.quickbookId,
    this.qbDesktopId,
    this.isActive,
    this.deletedAt,});

  AccountingHeadModel.fromJson(dynamic json) {
    id = json['id'];
    parentId = json['parent_id'];
    name = json['name'];
    accountType = json['account_type'];
    accountSubType = json['account_sub_type'];
    classification = json['classification'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    quickbookSyncStatus = json['quickbook_sync_status'];
    origin = json['origin'];
    quickbookId = json['quickbook_id'];
    qbDesktopId = json['qb_desktop_id'];
    isActive = json['is_active'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['parent_id'] = parentId;
    map['name'] = name;
    map['account_type'] = accountType;
    map['account_sub_type'] = accountSubType;
    map['classification'] = classification;
    map['description'] = description;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['quickbook_sync_status'] = quickbookSyncStatus;
    map['origin'] = origin;
    map['quickbook_id'] = quickbookId;
    map['qb_desktop_id'] = qbDesktopId;
    map['is_active'] = isActive;
    map['deleted_at'] = deletedAt;
    return map;
  }
}
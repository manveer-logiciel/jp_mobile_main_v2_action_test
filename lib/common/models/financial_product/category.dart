
class FinancialProductCategory {
  int? id;
  String? name;
  int? def;
  int? order;
  String? slug;
  String? qbDesktopId;
  String? qbDesktopSequenceNumber;
  String? financialAccountId;
  int? active;
  String? deletedAt;
  String? deletedBy;
  bool? locked;
  bool? isSystemCategory;

  FinancialProductCategory({
    this.id,
    this.name,
    this.def,
    this.order,
    this.slug,
    this.qbDesktopId,
    this.qbDesktopSequenceNumber,
    this.financialAccountId,
    this.active,
    this.deletedAt,
    this.deletedBy,
    this.locked,
    this.isSystemCategory,
  });

  FinancialProductCategory.fromJson(Map<String,dynamic> json) {
    id = json['id'];
    name = json['name'];
    def = json['default'];
    order = json['order'];
    slug = json['slug'];
    qbDesktopId = json['qb_desktop_id'];
    qbDesktopSequenceNumber = json['qb_desktop_sequence_number'];
    financialAccountId = json['financial_account_id'];
    active = json['active'];
    deletedAt = json['deleted_at'];
    deletedBy = json['deleted_by'];
    locked = json['locked'];
    isSystemCategory = json['is_system_category'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['default'] = def;
    map['order'] = order;
    map['slug'] = slug;
    map['qb_desktop_id'] = qbDesktopId;
    map['qb_desktop_sequence_number'] = qbDesktopSequenceNumber;
    map['financial_account_id'] = financialAccountId;
    map['active'] = active;
    map['deleted_at'] = deletedAt;
    map['deleted_by'] = deletedBy;
    map['locked'] = locked;
    map['is_system_category'] = isSystemCategory;
    
    return map;
  }

}
class CompanyContactListingParamModel {
  late int limit;
  String? name;
  late int page;
  String? sortBy;
  String? sortOrder;
  int? tagId;

  CompanyContactListingParamModel({
    this.limit = 20,
    this.page = 1,
    this.name, 
    this.sortBy = 'first_name',
    this.sortOrder = 'asc',
    this.tagId
  });

  CompanyContactListingParamModel.fromJson(Map<String, dynamic> json) {
    limit = json['limit'];
    page = json['page'];
    name = json['name'];
    sortBy = json['sort_by'];
    sortOrder = json['sort_order'];
    tagId = json['tag_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['limit'] = limit;
    data['name'] = name;
    data['page'] = page;
    data['sort_by'] = sortBy;
    data['sort_order'] = sortOrder;
    data['tag_id'] = tagId;
    return data;
  }
}

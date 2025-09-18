/// Relation table modal 
/// for user -> tags
class UserTagModel {
  late int userId;
  late int tagId;
  int? companyId;

  UserTagModel({required this.userId, required this.tagId});

  UserTagModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    tagId = json['tag_id'];
    companyId = json['company_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['tag_id'] = tagId;
    data['company_id'] = companyId;
    return data;
  }
}

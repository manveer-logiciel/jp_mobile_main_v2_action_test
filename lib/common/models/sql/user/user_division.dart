/// Relation table modal 
/// for user -> division
class UserDivisionModel {
  late int userId;
  late int divisionId;

  UserDivisionModel({required this.userId, required this.divisionId});

  UserDivisionModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    divisionId = json['division_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['division_id'] = divisionId;
    return data;
  }
}

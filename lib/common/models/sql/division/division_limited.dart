/// this modal is used in user modal
/// we are using limited keys values in relation
class DivisionLimitedModel {
  late int id;
  late String name;
  String? code;

  DivisionLimitedModel({
    required this.id,
    required this.name,
    this.code,
  });

  DivisionLimitedModel.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['name'] = name;
    return data;
  }
}

/// this modal is used in user modal
/// we are using limited keys values in relation
class TagLimitedModel {
  late int id;
  late String name;

  TagLimitedModel({
    required this.id,
    required this.name
  });

  TagLimitedModel.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

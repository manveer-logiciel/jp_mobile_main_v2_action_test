
class TemplateMultiplicationModel {
  int? first;
  int? second;

  TemplateMultiplicationModel({this.first, this.second});

  TemplateMultiplicationModel.fromJson(Map<String, dynamic>? json) {

    if (json == null) return;

    first = json['first'];
    second = json['second'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first'] = first;
    data['second'] = second;
    return data;
  }
}

class EagleViewOrderStatus {
  int? id;
  String? name;

  EagleViewOrderStatus({this.id, this.name});

  EagleViewOrderStatus.fromJson(Map<String, dynamic>? json) {
    if(json == null) return;
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

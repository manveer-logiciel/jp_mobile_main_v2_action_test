class EmailModel {
  int? id;
  late String email;
  int? isPrimary;

  EmailModel({this.id, required this.email, this.isPrimary});

  EmailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    isPrimary = json['is_primary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['is_primary'] = isPrimary;
    return data;
  }
}

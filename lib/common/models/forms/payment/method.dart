class MethodModel {
  late int id;
  int? companyId;
  String? label;
  String? method;
  

  MethodModel({   
    required this.id,
    this.companyId,
    this.label,
    this.method,
  });

  MethodModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    label = json['label'];
    method = json['method'];

  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['company_id'] = companyId;
    data['label'] = label;
    data['method'] = method;
    
    return data;
  }
}
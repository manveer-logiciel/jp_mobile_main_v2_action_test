import 'dart:ui';

class JobType {
  int? id;
  int? tradeId;
  String? name;
  int? type;
  int? order;
  Color? color;
  bool? insuranceClaim;

  JobType(
      {this.id,
      this.tradeId,
      this.name,
      this.type,
      this.order,
      this.color,
      this.insuranceClaim});

  JobType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tradeId = json['trade_id'];
    name = json['name'];
    type = json['type'];
    order = json['order'];
    color = json['color'];
    insuranceClaim = json['insurance_claim'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['trade_id'] = tradeId;
    data['name'] = name;
    data['type'] = type;
    data['order'] = order;
    data['color'] = color;
    data['insurance_claim'] = insuranceClaim;
    return data;
  }
}

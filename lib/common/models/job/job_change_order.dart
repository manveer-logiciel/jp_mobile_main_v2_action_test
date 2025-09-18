class ChangeOrderModel {

  int? count;
  String? totalAmount;
  List<ChangeOrderModel?>? entities;
  String? amount;
  String? description;

  ChangeOrderModel({
    this.count,
    this.totalAmount,
    this.entities,
    this.amount,
    this.description,
  });

  ChangeOrderModel.fromJson(Map<String, dynamic> json) {
    count = int.tryParse(json['count']?.toString() ?? '');
    totalAmount = json['total_amount']?.toString();
    if (json['entities'] != null && (json['entities'] is List)) {
      entities = <ChangeOrderModel>[];
      json['entities'].forEach((dynamic entity) {
        entities!.add(ChangeOrderModel.fromJson(entity));
      });
    }
    amount = json['amount']?.toString();
    description = json['description']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['count'] = count;
    data['total_amount'] = totalAmount;
    if (entities != null) {
      data['entities'] = <dynamic>[];
      for (var entities in entities!) {
        data['entities'].add(entities!.toJson());
      }
    }
    data['amount'] = amount;
    data['description'] = description;
    return data;
  }
}
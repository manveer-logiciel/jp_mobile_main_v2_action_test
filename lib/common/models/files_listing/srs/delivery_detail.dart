class SrsDeliveryDetailModel {
  String? orderDate;
  String? deliveryAt;
  String? expectedDeliveryDate;

  SrsDeliveryDetailModel({
    this.orderDate,
    this.deliveryAt,
    this.expectedDeliveryDate,
  });

  SrsDeliveryDetailModel.fromJson(Map<String, dynamic> json) {
    orderDate = json['ordered_date'];
    deliveryAt = json['delivered_at'];
    expectedDeliveryDate = json['expected_delivery_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['expected_delivery_date'] = expectedDeliveryDate;
    data['delivered_at'] = deliveryAt;
    data['ordered_date'] = orderDate;
    return data;
  }
}

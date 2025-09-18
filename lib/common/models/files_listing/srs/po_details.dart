class SrsPoDetailsModel {
  String? reference;
  String? jobNumber;
  String? poNumber;
  String? orderDate;
  String? expectedDeliveryDate;
  String? expectedDeliveryTime;
  String? timezone;
  String? orderType;
  String? shippingMethod;
  String? viewShippingMethod;
  String? deliveryType;

  SrsPoDetailsModel(
      {this.reference,
      this.jobNumber,
      this.poNumber,
      this.orderDate,
      this.expectedDeliveryDate,
      this.expectedDeliveryTime,
      this.timezone,
      this.orderType,
      this.shippingMethod,
      this.viewShippingMethod,
      this.deliveryType,
      });

  SrsPoDetailsModel.fromJson(Map<String, dynamic> json) {
    reference = json['reference'];
    jobNumber = json['jobNumber'];
    poNumber = json['poNumber'];
    orderDate = json['orderDate'];
    expectedDeliveryDate = json['expectedDeliveryDate'];
    expectedDeliveryTime = json['expectedDeliveryTime'];
    timezone = json['timezone'];
    orderType = json['orderType'];
    shippingMethod = json['shippingMethod'];
    if(shippingMethod == 'willcall') {
      viewShippingMethod = 'Pickup';
    } else {
      viewShippingMethod = 'Delivery';
      deliveryType = shippingMethod;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['reference'] = reference;
    data['jobNumber'] = jobNumber;
    data['poNumber'] = poNumber;
    data['orderDate'] = orderDate;
    data['expectedDeliveryDate'] = expectedDeliveryDate;
    data['expectedDeliveryTime'] = expectedDeliveryTime;
    data['timezone'] = timezone;
    data['orderType'] = orderType;
    data['shippingMethod'] = shippingMethod;
    return data;
  }
}
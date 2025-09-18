
import '../../../core/utils/helpers.dart';

class ABCOrderDetails {
  int? orderId;
  int? supplierId;
  String? orderStatus;
  String? orderStatusLabel;
  String? supplierOrderId;
  String? supplierType;

  ABCOrderDetails({this.orderId, this.supplierId, this.orderStatus, this.orderStatusLabel, this.supplierOrderId, this.supplierType});

  ABCOrderDetails.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    supplierId = json['supplier_id'];
    orderStatus = json['order_status'];
    orderStatusLabel = Helper.replaceUnderscoreWithSpace(orderStatus);
    supplierOrderId = json['supplier_order_id'];
    supplierType = json['supplier_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['order_id'] = orderId;
    data['supplier_id'] = supplierId;
    data['order_status'] = orderStatus;
    data['supplier_order_id'] = supplierOrderId;
    data['supplier_type'] = supplierType;
    return data;
  }
}

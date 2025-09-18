import '../../../../core/utils/helpers.dart';

class BeaconOrderDetails {
  int? orderId;
  String? orderStatus;
  String? orderStatusLabel;
  String? beaconOrderId;

  BeaconOrderDetails({this.orderId, this.orderStatus, this.beaconOrderId, this.orderStatusLabel});

  BeaconOrderDetails.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    orderStatus = json['order_status'];
    orderStatusLabel = Helper.replaceUnderscoreWithSpace(orderStatus);
    beaconOrderId = json['beacon_order_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['order_id'] = orderId;
    data['order_status'] = orderStatus;
    data['beacon_order_id'] = beaconOrderId;
    return data;
  }
}

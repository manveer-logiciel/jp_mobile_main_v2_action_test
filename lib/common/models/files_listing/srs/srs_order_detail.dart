import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/common/models/files_listing/srs/order_details.dart';
import 'package:jobprogress/core/constants/order_status_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';

class SrsOrderModel {
  int? id;
  String? materialListId;
  String? orderId;
  String? orderStatus;
  String? orderStatusLabel;
  SrsOrderDetailsModel? orderDetails;
  List<AttachmentResourceModel>? attachments;
  String? srsOrderId;
  String? invoiceNumber;
  bool? inProgress;

  SrsOrderModel({
    this.id,
    this.materialListId,
    this.orderId,
    this.orderStatus,
    this.srsOrderId,
    this.orderStatusLabel,
    this.orderDetails,
    this.attachments,
    this.invoiceNumber,
    this.inProgress,
  });

  SrsOrderModel.fromJson(Map<String, dynamic> json) {
    srsOrderId = json['srs_order_id'];
    id = json['id'];
    materialListId = json['material_list_id'];
    orderId = json['order_id'];
    orderStatus = json['order_status'];
    orderStatusLabel = Helper.replaceUnderscoreWithSpace(orderStatus);
    orderDetails = json['order_details'] != null
        ? SrsOrderDetailsModel.fromJson(json['order_details'])
        : null;
    attachments = [];
    json['srs_order_attachments']?['data']?.forEach((dynamic attachment) {
      attachments!.add(AttachmentResourceModel.fromJson(attachment));
    });
    invoiceNumber = json['invoice_number'];
    inProgress = orderStatus == OrderStatusConstants.inRoute || orderStatus == OrderStatusConstants.inProgress;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['srs_order_id'] = srsOrderId;
    data['material_list_id'] = materialListId;
    data['order_id'] = orderId;
    data['order_status'] = orderStatus;
    if (orderDetails != null) {
      data['order_details'] = orderDetails!.toJson();
    }
    data['srs_order_attachments'] = attachments?.map((attachment) => attachment.toJson()).toList();
    data['invoice_number'] = invoiceNumber;

    return data;
  }
}

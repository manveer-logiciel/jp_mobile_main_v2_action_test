
import 'package:get/get.dart';
import 'package:jobprogress/common/models/forms/common/params.dart';
import 'package:jobprogress/core/constants/forms/place_srs_order.dart';

class PlaceSrsOrderFormFieldsData {

  static List<InputFieldParams> companyContactfields = [
    InputFieldParams(key: PlaceSrsOrderFormConstants.companyContact, name: 'company_contact'.tr),
  ];

  static List<InputFieldParams> shippingAddressfields = [
    InputFieldParams(key: PlaceSrsOrderFormConstants.shippingAddress, name: 'shipping_address'.tr, isRequired: true),
  ];

  static List<InputFieldParams> biliingAddressfields = [
    InputFieldParams(key: PlaceSrsOrderFormConstants.billingAddress, name: 'billing_address'.tr),
  ];

  static List<InputFieldParams> placeSRSOrderfields(dynamic Function(String) onDataChange) => [
    InputFieldParams(key: PlaceSrsOrderFormConstants.shippingMethod, name: 'shipping_method'.tr, onDataChange: onDataChange),
    InputFieldParams(key: PlaceSrsOrderFormConstants.placeOrderDetails, name: 'place_order_details'.tr, onDataChange: onDataChange),
    InputFieldParams(key: PlaceSrsOrderFormConstants.timezone, name: 'timezone'.tr, onDataChange: onDataChange),
    InputFieldParams(key: PlaceSrsOrderFormConstants.materialDate, name: 'material_date'.tr, isRequired: true, onDataChange: onDataChange),
    InputFieldParams(key: PlaceSrsOrderFormConstants.materialDeliveryNote, name: 'material_delivery_note'.tr, onDataChange: onDataChange),
    InputFieldParams(key: PlaceSrsOrderFormConstants.requestedDeliveryTime, name: 'requested_delivery_time'.tr, isRequired: true, onDataChange: onDataChange),
    InputFieldParams(key: PlaceSrsOrderFormConstants.estimateBranchArrivalTime, name: 'estimate_branch_arrival_time'.tr, isRequired: true, onDataChange: onDataChange),
    InputFieldParams(key: PlaceSrsOrderFormConstants.deliveryType, name: 'delivery_type'.tr, isRequired: true, onDataChange: onDataChange),
    InputFieldParams(key: PlaceSrsOrderFormConstants.poNumber, name: 'po_number'.tr, isRequired: false, onDataChange: onDataChange),
    InputFieldParams(key: PlaceSrsOrderFormConstants.note, name: 'note'.tr, onDataChange: onDataChange),
  ];

  static List<InputFieldParams> placeBeaconOrderFields(dynamic Function(String) onDataChange) => [
    InputFieldParams(key: PlaceSrsOrderFormConstants.materialDate, name: 'material_date'.tr, isRequired: true, onDataChange: onDataChange),
    InputFieldParams(key: PlaceSrsOrderFormConstants.shippingMethod, name: 'shipping_method'.tr, onDataChange: onDataChange),
    InputFieldParams(key: PlaceSrsOrderFormConstants.deliveryType, name: 'delivery_time'.tr, isRequired: true, onDataChange: onDataChange),
    InputFieldParams(key: PlaceSrsOrderFormConstants.poJobName, name: 'po_or_job_name'.tr, isRequired: true, onDataChange: onDataChange),
    InputFieldParams(key: PlaceSrsOrderFormConstants.note, name: 'note'.tr, onDataChange: onDataChange),
  ];

  static List<InputFieldParams> attachmentField = [
    InputFieldParams(key: PlaceSrsOrderFormConstants.attachment, name: 'attachment'.tr),
  ];

  static List<InputFieldParams> shippingMethodField = [
    InputFieldParams(key: PlaceSrsOrderFormConstants.shippingMethod, name: 'shipping_method'.tr)
  ];

  static List<InputFieldParams> placeABCOrderFields(dynamic Function(String) onDataChange) => [
    InputFieldParams(key: PlaceSrsOrderFormConstants.requestedDeliveryDateLabel, name: 'requested_delivery_date'.tr, isRequired: true, onDataChange: onDataChange),
    InputFieldParams(key: PlaceSrsOrderFormConstants.poJobName, name: 'po_or_job_name'.tr, isRequired: true, onDataChange: onDataChange),
    InputFieldParams(key: PlaceSrsOrderFormConstants.requestedDeliveryTime, name: 'requested_delivery_time'.tr, isRequired: true, onDataChange: onDataChange),
    InputFieldParams(key: PlaceSrsOrderFormConstants.deliveryType, name: 'delivery_type'.tr, isRequired: true, onDataChange: onDataChange),
    InputFieldParams(key: PlaceSrsOrderFormConstants.note, name: 'note'.tr, onDataChange: onDataChange),
  ];

}
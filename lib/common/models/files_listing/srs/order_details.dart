import 'package:jobprogress/common/models/address/address.dart';
import 'package:jobprogress/common/models/files_listing/srs/customer_contact.dart';
import 'package:jobprogress/common/models/files_listing/srs/po_details.dart';
import '../../sql/state/state.dart';

class SrsOrderDetailsModel {
  String? transactionDate;
  SrsPoDetailsModel? poDetails;
  SrsCustomerContactInfoModel? customerContactInfo;
  AddressModel? shipTo;
  AddressModel? billTo;

  SrsOrderDetailsModel(
      {this.transactionDate,
      this.poDetails,
      this.shipTo,
      this.billTo,
      this.customerContactInfo});

  SrsOrderDetailsModel.fromJson(Map<String, dynamic> json) {
    transactionDate = json['transaction_date'];
    poDetails = json['po_details'] != null
        ? SrsPoDetailsModel.fromJson(json['po_details'])
        : null;
    shipTo = json['ship_to'] != null ? AddressModel(
      id: -1,
      address: json['ship_to']['addressLine1'] ?? "",
      addressLine1: json['ship_to']['addressLine2'] ?? "",
      city: json['ship_to']['city'] ?? "",
      state: StateModel(
          id: -1,
          name: json['ship_to']['state'] ?? "",
          code: "",
          countryId: -1),
      zip: json['ship_to']['zipCode'] ?? "",
    ) : null;
    billTo = json['bill_to'] != null ? AddressModel(
      id: -1,
      address: json['bill_to']['addressLine1'] ?? "",
      addressLine1: json['bill_to']['addressLine2'] ?? "",
      city: json['bill_to']['city'] ?? "",
      state: StateModel(
          id: -1,
          name: json['bill_to']['state'] ?? "",
          code: "",
          countryId: -1),
      zip: json['bill_to']['zipCode'] ?? "",
    ) : null;
    customerContactInfo = json['customer_contact_info'] != null
        ? SrsCustomerContactInfoModel.fromJson(json['customer_contact_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['transaction_date'] = transactionDate;
    if (poDetails != null) {
      data['po_details'] = poDetails!.toJson();
    }
    if (shipTo != null) {
      data['ship_to'] = shipTo!.toJson();
    }
    if (billTo != null) {
      data['bill_to'] = billTo!.toJson();
    }
    if (customerContactInfo != null) {
      data['customer_contact_info'] = customerContactInfo!.toJson();
    }
    return data;
  }
}
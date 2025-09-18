import '../../address/address.dart';
import '../../sql/state/state.dart';

class SrsCustomerContactInfoModel {
  String? customerContactName;
  String? customerContactPhone;
  String? customerContactEmail;

  AddressModel? customerContactAddress;

  SrsCustomerContactInfoModel(
      {this.customerContactName,
      this.customerContactPhone,
      this.customerContactEmail,
      this.customerContactAddress});

  SrsCustomerContactInfoModel.fromJson(Map<String, dynamic> json) {
    customerContactName = json['customerContactName'];
    customerContactPhone = json['customerContactPhone'];
    customerContactEmail = json['customerContactEmail'];
    customerContactAddress = json['customerContactAddress'] != null
        ? AddressModel(
      id: -1,
      address: json['customerContactAddress']['addressLine1'] ?? "",
      addressLine1: json['customerContactAddress']['addressLine2'] ?? "",
      city: json['customerContactAddress']['city'] ?? "",
      state: StateModel(
          id: -1,
          name: json['customerContactAddress']['state'] ?? "",
          code: "",
          countryId: -1),
      zip: json['customerContactAddress']['zipCode'] ?? "",
    ) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customerContactName'] = customerContactName;
    data['customerContactPhone'] = customerContactPhone;
    data['customerContactEmail'] = customerContactEmail;
    if (customerContactAddress != null) {
      data['customerContactAddress'] = customerContactAddress!.toJson();
    }
    return data;
  }
}
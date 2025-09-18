import 'package:jobprogress/common/models/address/address.dart';
import 'package:jobprogress/core/utils/helpers.dart';

class DivisionModel {
  int? id;
  int? companyId;
  String? name;
  String? email;
  String? phone;
  String? phoneExt;
  String? color;
  String? code;

  /// [address] - holds the address of the division
  AddressModel? address;

  /// [addressString] - holds the address of the division in string format
  String? addressString;
  bool? enableAllSupplierSearch;

  DivisionModel({
      this.id,
      this.companyId,
      this.name,
      this.email,
      this.phone,
      this.phoneExt,
      this.color,
      this.code,
      this.address,
      this.addressString,
      this.enableAllSupplierSearch
  });

  DivisionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    phoneExt = json['phone_ext'];
    color = json['color'];
    code = json['code'];
    // Parsing address only if is available
    if (json['address'] is Map) {
      address = AddressModel.fromJson(json['address']);
      // Converting address to text format
      addressString = Helper.convertAddress(address);
    }
    enableAllSupplierSearch = Helper.isTrue(json['enable_all_suppliers_search']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['company_id'] = companyId;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['phone_ext'] = phoneExt;
    data['color'] = color;
    data['code'] = code;
    data['enable_all_suppliers_search'] = Helper.isTrueReverse(enableAllSupplierSearch);
    return data;
  }
}

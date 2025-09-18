
import 'package:jobprogress/common/models/address/address.dart';
import 'package:jobprogress/common/models/phone.dart';

class CustomerInfo {

  String label;
  String? email;
  PhoneModel? phone;
  String? addressString;
  AddressModel? address;
  String? leadSource;

  CustomerInfo({
    required this.label,
    this.email,
    this.phone,
    this.address,
    this.addressString,
    this.leadSource,
  });


}
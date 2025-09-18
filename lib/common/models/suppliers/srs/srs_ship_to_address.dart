import 'package:jobprogress/common/models/address/address.dart';
import 'package:jobprogress/common/models/sql/state/state.dart';

class SrsShipToAddressModel {
  int? id;
  String? shipToId;
  String? shipToSequenceId;
  String? city;
  String? state;
  String? zipCode;
  String? addressLine1;
  String? addressLine2;
  String? addressLine3;
  int? totalBranches;

  SrsShipToAddressModel({
    this.id,
    this.shipToId,
    this.shipToSequenceId,
    this.city,
    this.state,
    this.zipCode,
    this.addressLine1,
    this.addressLine2,
    this.addressLine3,
    this.totalBranches,
  });

  SrsShipToAddressModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    if(json['ship_to_id'] != null) {
      shipToId = json['ship_to_id'] as String?;
    } else {
      shipToId = json['account_id'] as String?;
    }

    shipToSequenceId = json['ship_to_sequence_id'] as String?;
    city = json['city'] as String?;
    state = json['state'] as String?;
    zipCode = json['zip_code'] as String?;
    addressLine1 = json['address_line1'] as String?;
    addressLine2 = json['address_line2'] as String?;
    addressLine3 = json['address_line3'] as String?;
    totalBranches = json['total_branches'] as int?;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'ship_to_id': shipToId,
    'ship_to_sequence_id': shipToSequenceId,
    'city': city,
    'state': state,
    'zip_code': zipCode,
    'address_line1': addressLine1,
    'address_line2': addressLine2,
    'address_line3': addressLine3,
    'total_branches': totalBranches,
  };

  AddressModel get addressModel {
    return AddressModel(
      id: id ?? 0,
      address: addressLine1,
      city: city,
      state: state != null ? StateModel(id: 0, name: '', code: state!, countryId: 0) : null,
      zip: zipCode,
      addressLine1: addressLine2,
      addressLine3: addressLine3,
    );
  }
}
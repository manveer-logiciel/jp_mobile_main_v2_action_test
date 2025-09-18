import 'package:jobprogress/common/models/sql/country/country.dart';
import 'package:jobprogress/common/models/sql/state/state.dart';

class AddressModel {
  late int id;
  String? address;
  String? addressLine1;
  String? addressLine3;
  String? city;
  int? stateId;
  StateModel? state;
  int? countryId;
  CountryModel? country;
  String? zip;
  double? lat;
  double? long;
  int? geocodingError;
  int? createdBy;
  int? updatedBy;
  String? createdAt;
  String? updatedAt;
  String? deviceUuid;
  String? updateOrigin;
  String? updatedFrom;
  String? stateStringType;
  String? countryStringType;
  String? name;
  num? stateTax;
  bool? sameAsDefault; // helps in managing addresses that co-relate (eg. customer address & billing address)

  AddressModel({
      required this.id,
      this.address,
      this.addressLine1,
      this.addressLine3,
      this.city,
      this.stateId,
      this.state,
      this.countryId,
      this.country,
      this.zip,
      this.lat,
      this.long,
      this.geocodingError,
      this.createdBy,
      this.updatedBy,
      this.createdAt,
      this.updatedAt,
      this.deviceUuid,
      this.updateOrigin,
      this.countryStringType,
      this.stateStringType,
      this.updatedFrom,
      this.stateTax,
      this.name,
      this.sameAsDefault = true
      });

  factory AddressModel.copy({AddressModel? addressModel}) => AddressModel(
      id: addressModel?.id ?? -1,
      address: addressModel?.address,
      addressLine1: addressModel?.addressLine1,
      addressLine3: addressModel?.addressLine3,
      city: addressModel?.city,
      stateId: addressModel?.stateId,
      state: addressModel?.state,
      countryId: addressModel?.countryId,
      country: addressModel?.country,
      zip: addressModel?.zip,
      lat: addressModel?.lat,
      long: addressModel?.long,
      geocodingError: addressModel?.geocodingError,
      createdBy: addressModel?.createdBy,
      updatedBy: addressModel?.updatedBy,
      createdAt: addressModel?.createdAt,
      updatedAt: addressModel?.updatedAt,
      updateOrigin: addressModel?.updateOrigin,
      updatedFrom: addressModel?.updatedFrom,
      deviceUuid: addressModel?.deviceUuid,
      countryStringType: addressModel?.countryStringType,
      stateStringType: addressModel?.stateStringType,
      stateTax: addressModel?.stateTax,
      name: addressModel?.name,
      sameAsDefault: addressModel?.sameAsDefault
    );

  AddressModel.fromJson(Map<String, dynamic> json) {
      id = int.tryParse(json['id'].toString()) ?? 0;
      address = json['address'];
      addressLine1 = json['address_line_1'];
      addressLine3 = json['address_line_3'];
      city = json['city'];
      stateId = json['state_id'];
      state = json['state'] != null ? StateModel.fromJson(json['state']) : null;
      countryId = json['country_id'];
      country = json['country'] != null ? CountryModel.fromJson(json['country']) : null;
      zip = json['zip'];
      if(json['lat'] != null && json['long'] != null) {
        lat = double.parse(json['lat'].toString());
        long = double.parse(json['long'].toString());
      }
      geocodingError = json['geocoding_error'];
      createdBy = json['created_by'];
      updatedBy = json['updated_by'];
      createdAt = json['created_at'];
      updatedAt = json['updated_at'];
      deviceUuid = json['device_uuid']?.toString();
      updateOrigin = json['update_origin']?.toString();
      updatedFrom = json['updated_from']?.toString();
      stateTax = num.tryParse(json['state_tax']?["tax_rate"]?.toString() ?? "");
      sameAsDefault = true;
  }

  AddressModel.fromCompanyCamJson(Map<String, dynamic> json) {
    address = json['street_address_1'];
    addressLine1 = json['street_address_2'];
    city = json['city'];
    stateStringType = json['state'];
    zip = json['postal_code'];
    countryStringType = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['address'] = address;
    data['street_address_1'] = address;
    data['address_line_1'] = addressLine1;
    data['address_line_3'] = addressLine3;
    data['street_address_2'] = addressLine1;
    data['city'] = city;
    data['state_id'] = stateId;
    if (state != null) {
      data['state'] = state!.toJson();
    }
    data['country_id'] = countryId;
    if (country != null) {
      data['country'] = country!.toJson();
    }
    data['zip'] = zip;
    data['lat'] = lat;
    data['long'] = long;
    data['geocoding_error'] = geocodingError;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['device_uuid'] = deviceUuid;
    data['update_origin'] = updateOrigin;
    data['updated_from'] = updatedFrom;
    return data;
  }

  /// [toFormJson] helps in converting address model to form json
  /// with limited details needed to save address
  Map<String, dynamic> toFormJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (id > 0) {
      data['id'] = id;
    }
    data['address'] = address;
    data['address_line_1'] = addressLine1;
    data['street_address_2'] = addressLine1;
    data['city'] = city;
    data['state_id'] = stateId;
    data['country_id'] = countryId;
    data['zip'] = zip;
    data['lat'] = lat;
    data['long'] = long;
    return data;
  }

  Map<String, dynamic> toPlaceSrsOrderJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["address_line1"] = address;
    data["address_line2"] = addressLine1;
    data["address_line3"] = addressLine3;
    data["city"] = city;
    data["zip_code"] = zip;
    data["state"] = state?.code;

    return data;
  }

  /// [toPlaceBeaconOrderJson] helps in converting address model to place beacon order json
  Map<String, dynamic> toPlaceBeaconOrderJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["address_line_1"] = address;
    data["address_line_2"] = addressLine1;
    data["city"] = city;
    data["zip_code"] = zip;
    data["state"] = state?.code;

    return data;
  }

  /// [toPlaceABCOrderJson] helps in converting address model to place abc order json
  Map<String, dynamic> toPlaceABCOrderJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["address_line_1"] = address;
    data["address_line_2"] = addressLine1;
    data["address_line_3"] = addressLine3;
    data["city"] = city;
    data["zip_code"] = zip;
    data["state"] = state?.code;
    data["country"] = country?.code;

    return data;
  }

}

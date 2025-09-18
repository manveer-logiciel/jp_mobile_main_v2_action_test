import 'address_components.dart';
import 'address_geometry.dart';

class PlaceDetailsModel {

  List<AddressComponentsModel?>? addressComponents;
  String? formattedAddress;
  AddressGeometryModel? geometry;
  String? name;
  String? placeId;
  int? utcOffset;
  String? vicinity;

  PlaceDetailsModel({
    this.addressComponents,
    this.formattedAddress,
    this.geometry,
    this.name,
    this.placeId,
    this.utcOffset,
    this.vicinity,
  });

  PlaceDetailsModel.fromJson(Map<String, dynamic> json) {
    if (json['address_components'] != null && (json['address_components'] is List)) {
      addressComponents = <AddressComponentsModel>[];
      json['address_components'].forEach((dynamic addressComponent) =>
        addressComponents!.add(AddressComponentsModel.fromJson(addressComponent)));
    }
    formattedAddress = json['formatted_address']?.toString();
    geometry = (json['geometry']?["location"] != null && (json['geometry']?["location"] is Map))
        ? AddressGeometryModel.fromJson(json['geometry']?["location"]) : null;
    name = json['name']?.toString();
    placeId = json['place_id']?.toString();
    utcOffset = int.tryParse(json['utc_offset']?.toString() ?? '');
    vicinity = json['vicinity']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (addressComponents != null) {
      data['address_components'] = <dynamic>[];
      for (var addressComponent in addressComponents!) {
        data['address_components'].add(addressComponent!.toJson());
      }
    }
    data['formatted_address'] = formattedAddress;
    if (geometry != null) {
      data['geometry'] = geometry!.toJson();
    }
    data['name'] = name;
    data['place_id'] = placeId;
    data['utc_offset'] = utcOffset;
    data['vicinity'] = vicinity;
    return data;
  }
}
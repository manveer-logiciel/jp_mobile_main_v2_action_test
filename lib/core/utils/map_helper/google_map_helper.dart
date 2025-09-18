import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../common/models/address/address.dart';
import '../../../common/models/google_maps/address_components.dart';
import '../../../common/models/google_maps/address_geometry.dart';
import '../../../common/models/google_maps/place_details.dart';
import '../../../common/models/sql/country/country.dart';
import '../../../common/models/sql/state/state.dart';
import '../helpers.dart';

class GoogleMapHelper {

  static AddressModel convertPlaceDetailsModelToAddressModel (PlaceDetailsModel placeDetails) {

    String tempAddress = "";
    String tempCity = "";
    StateModel? tempState;
    CountryModel? tempCountry;
    String tempZip = "";

    placeDetails.addressComponents?.forEach((element) {
      final types = element?.types ?? [];
      final longNameExists = !Helper.isValueNullOrEmpty(element?.longName);

      /// Formatted Address is combination of street number and route
      /// Adding street number to formatted address
      if (types.contains("street_number") && longNameExists) {
        tempAddress = "${element!.longName!} ";
      }

      /// Adding route to formatted address
      if (types.contains("route") && longNameExists) {
        tempAddress += element!.longName!;
      }

      /// Setting up Zip Code for Address data
      if (types.contains("postal_code") && longNameExists) {
        tempZip = element!.longName!;
      }

      /// Setting up state for address data
      if (types.contains("administrative_area_level_1")) {
        tempState = StateModel(
            id: int.tryParse(element?.id ?? "0") ?? 0,
            name: element?.longName ?? "",
            code: element?.shortName ?? "",
            countryId: 0
        );
      }

      /// Setting up country for address data
      if (types.contains("country")) {
        tempCountry = CountryModel(
          id: int.tryParse(element?.id ?? "0") ?? 0,
          name: element?.longName ?? "",
          code: element?.shortName ?? "",
          currencyName: "",
          currencySymbol: element?.shortName ?? "",
        );
      }

      /// Setting up city for address data
      if (types.contains("locality") && longNameExists) {
        tempCity = element?.longName ?? "";
      }

      /// Setting up city for address data from sublocality if locality does not exists
      if (tempCity.isEmpty && types.contains("sublocality_level_1") && longNameExists) {
        tempCity = element?.longName ?? "";
      }
    });

    return AddressModel(
      id: 0,
      address: tempAddress,
      city: tempCity,
      state: tempState,
      country: tempCountry,
      zip: tempZip,
      lat: placeDetails.geometry?.lat,
      long: placeDetails.geometry?.lng,
    );
  }

  static PlaceDetailsModel convertAddressModelToPlaceDetailsModel(AddressModel addressModel) => PlaceDetailsModel(
    name: "",
    formattedAddress: Helper.convertAddress(addressModel).trim(),
    geometry: AddressGeometryModel(lat: addressModel.lat, lng: addressModel.long),
    addressComponents: [
      AddressComponentsModel(longName: addressModel.address, types: ["premise", "route"]),
      AddressComponentsModel(longName: addressModel.city, types: ["locality"]),
      AddressComponentsModel(id: addressModel.state?.id.toString(), longName: addressModel.state?.name, shortName: addressModel.state?.code, types: ["administrative_area_level_1"]),
      AddressComponentsModel(id: addressModel.country?.id.toString(), longName: addressModel.country?.name, shortName: addressModel.country?.code, types: ["country"]),
      AddressComponentsModel(longName: addressModel.zip, types: ["postal_code"]),
    ],
  );

  static void updateCamera({
    required CameraPosition cameraPosition, required PlaceDetailsModel placeDetail,
    required GoogleMapController mapController, required double cameraZoom,
    double rotationAngle = 0, double tiltAngle = 0}) {
    cameraPosition = CameraPosition(
      target: LatLng(placeDetail.geometry?.lat ?? 0, placeDetail.geometry?.lng ?? 0),
      zoom: cameraZoom,
      bearing: rotationAngle,
      tilt: tiltAngle,
    );
    mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }
}
import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/common/services/launch_darkly/index.dart';
import '../../core/config/app_env.dart';
import '../../core/constants/urls.dart';
import '../models/google_maps/place_details.dart';
import '../models/google_maps/places_auto_complete.dart';
import '../providers/http/interceptor.dart';
import '../services/auth.dart';

class GoogleMapRepository {
  static FlutterGooglePlacesSdk? _placesSdk;

  /// Initialize the Places SDK with the API key
  static FlutterGooglePlacesSdk get placesSdk {
    final apiKey = AppEnv.envConfig['GOOGLE_MAPS_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('Google Maps API key is missing');
    }
try {
    _placesSdk ??= FlutterGooglePlacesSdk(apiKey);
    return _placesSdk!;
  } catch (e) {
    throw Exception('Failed to initialize Google Places SDK: $e');
  }
  }

  /// Check if we should use mobile SDK based on LaunchDarkly feature flag
  static bool get shouldUseMobileSdk {
    return LDService.hasFeatureEnabled(LDFlagKeyConstants.useMobileMapsSdk);
  }

  /// Get country filter for autocomplete predictions
  static List<String>? getCountryFilter() {
    return !Helper.isValueNullOrEmpty(AuthService.userDetails?.companyDetails?.countryCode)
        ? [AuthService.userDetails!.companyDetails!.countryCode!]
        : null;
  }

  /// Convert Places SDK prediction to PlacesAutoCompleteModel
  static PlacesAutoCompleteModel convertPredictionToModel(AutocompletePrediction prediction) {
    final autocompleteModel = PlacesAutoCompleteModel(
      description: prediction.fullText,
      placeId: prediction.placeId,
      reference: prediction.placeId, // Use placeId as reference for consistency
    );

    // Extract primary and secondary text as terms
    autocompleteModel.terms = [
      PlacesAutoCompleteModel(
        offset: 0,
        value: prediction.primaryText,
      ),
      if (prediction.secondaryText.isNotEmpty)
        PlacesAutoCompleteModel(
          offset: prediction.primaryText.length + 2, // +2 for ", " separator
          value: prediction.secondaryText,
        ),
    ];

    return autocompleteModel;
  }

  /// Convert Places SDK response to list of PlacesAutoCompleteModel
  static List<PlacesAutoCompleteModel> convertPredictionsToModels(List<AutocompletePrediction> predictions) {
    return predictions.map((prediction) => convertPredictionToModel(prediction)).toList();
  }

  /// Build address components from placemark
  static List<Map<String, dynamic>> buildAddressComponents(Placemark placemark) {
    List<Map<String, dynamic>> addressComponents = [];

    if (placemark.country != null) {
      addressComponents.add({
        'long_name': placemark.country!,
        'short_name': placemark.isoCountryCode ?? placemark.country!,
        'types': ['country', 'political']
      });
    }

    if (placemark.administrativeArea != null) {
      addressComponents.add({
        'long_name': placemark.administrativeArea!,
        'short_name': placemark.administrativeArea!,
        'types': ['administrative_area_level_1', 'political']
      });
    }

    if (placemark.locality != null) {
      addressComponents.add({
        'long_name': placemark.locality!,
        'short_name': placemark.locality!,
        'types': ['locality', 'political']
      });
    }

    if (placemark.postalCode != null) {
      addressComponents.add({
        'long_name': placemark.postalCode!,
        'short_name': placemark.postalCode!,
        'types': ['postal_code']
      });
    }

    return addressComponents;
  }

  /// Build concise formatted address from placemark
  static String buildFormattedAddress(Placemark placemark) {
    List<String> addressParts = [];

    // Add street/name if it's short and meaningful
    if (placemark.street != null && placemark.street!.length < 50) {
      addressParts.add(placemark.street!);
    }

    // Add locality (city/town)
    if (placemark.locality != null) {
      addressParts.add(placemark.locality!);
    }

    // Add administrative area (state/province)
    if (placemark.administrativeArea != null) {
      addressParts.add(placemark.administrativeArea!);
    }

    // Add postal code
    if (placemark.postalCode != null) {
      addressParts.add(placemark.postalCode!);
    }

    // Add country
    if (placemark.country != null) {
      addressParts.add(placemark.country!);
    }

    return addressParts.join(', ');
  }

  /// Convert placemark to place details JSON
  static Map<String, dynamic> convertPlacemarkToPlaceJson(Placemark placemark, double lat, double lng) {
    return {
      'address_components': buildAddressComponents(placemark),
      'formatted_address': buildFormattedAddress(placemark),
      'geometry': {
        'location': {
          'lat': lat,
          'lng': lng,
        }
      },
      'name': placemark.name ?? placemark.locality ?? 'Unknown Location',
      'place_id': 'geocoding_${lat}_$lng',
      'vicinity': placemark.locality ?? placemark.subLocality ?? placemark.street ?? 'Location at $lat, $lng',
    };
  }

  /// Convert Places SDK Place to place details JSON
  static Map<String, dynamic> convertSdkPlaceToJson(Place place) {
    // Build address components from SDK response
    List<Map<String, dynamic>> addressComponents = [];
    if (place.addressComponents != null) {
      for (final component in place.addressComponents!) {
        addressComponents.add({
          'long_name': component.name,
          'short_name': component.shortName,
          'types': component.types,
        });
      }
    }

    return {
      'address_components': addressComponents,
      'formatted_address': place.address,
      'geometry': place.latLng != null
          ? {
              'location': {
                'lat': place.latLng!.lat,
                'lng': place.latLng!.lng,
              }
            }
          : null,
      'name': place.name,
      'place_id': place.id,
      'vicinity': place.address, // Use address as vicinity fallback
    };
  }

  /// SDK implementation for fetching autocomplete predictions
  Future<Map<String, dynamic>> _fetchSimilarPlacesSDK(String searchText) async {
    try {
      final response = await placesSdk.findAutocompletePredictions(
        searchText,
        countries: getCountryFilter(),
      );

      final list = convertPredictionsToModels(response.predictions);
      return {"list": list};
    } catch (e) {
      rethrow;
    }
  }

  /// HTTP API implementation for fetching autocomplete predictions
  Future<Map<String, dynamic>> _fetchSimilarPlacesHTTP(String searchText) async {
    try {
      Map<String, dynamic> params = {
        "input": searchText,
        "language": "en",
        "components": "country:${AuthService.userDetails?.companyDetails?.countryCode}",
        "types": <dynamic>[],
        "key": AppEnv.envConfig['GOOGLE_MAPS_KEY']
      };

      final response = await dio.get(Urls.googleMapAutocompletePlaces, queryParameters: params);
      final jsonData = json.decode(response.toString());
      List<PlacesAutoCompleteModel> list = [];
      Map<String, dynamic> dataToReturn = {"list": list};

      jsonData["predictions"].forEach((dynamic appointments) => dataToReturn['list'].add(PlacesAutoCompleteModel.fromJson(appointments)));

      return dataToReturn;
    } catch (e) {
      rethrow;
    }
  }

  /// Main method for fetching autocomplete predictions
  Future<Map<String, dynamic>> fetchSimilarPlaces(String searchText) async {
    if (shouldUseMobileSdk) {
      return _fetchSimilarPlacesSDK(searchText);
    } else {
      return _fetchSimilarPlacesHTTP(searchText);
    }
  }

  /// SDK implementation for fetching place details by ID
  Future<PlaceDetailsModel> _fetchPlaceDetailsSDK(String placeId) async {
    try {
      final placeFields = [
        PlaceField.AddressComponents,
        PlaceField.Address,
        PlaceField.Location,
        PlaceField.Name,
        PlaceField.Id,
      ];

      final response = await placesSdk.fetchPlace(placeId, fields: placeFields);
      final place = response.place;

      if (place != null) {
        final placeJson = convertSdkPlaceToJson(place);
        return PlaceDetailsModel.fromJson(placeJson);
      } else {
        return PlaceDetailsModel.fromJson({});
      }
    } catch (e) {
      rethrow;
    }
  }

  /// HTTP API implementation for fetching place details by ID
  Future<PlaceDetailsModel> _fetchPlaceDetailsHTTP(String placeId) async {
    try {
      Map<String, dynamic> params = {
        "placeid": placeId,
        "key": AppEnv.envConfig['GOOGLE_MAPS_KEY']
      };

      final response = await dio.get(Urls.googleMapPlaceDetail, queryParameters: params);
      final jsonData = json.decode(response.toString());
      return PlaceDetailsModel.fromJson(jsonData["result"]);
    } catch (e) {
      rethrow;
    }
  }

  /// Main method for fetching place details by ID
  Future<PlaceDetailsModel> fetchPlaceDetails(String placeId) async {
    if (shouldUseMobileSdk) {
      return _fetchPlaceDetailsSDK(placeId);
    } else {
      return _fetchPlaceDetailsHTTP(placeId);
    }
  }

  /// SDK implementation for reverse geocoding from coordinates
  Future<PlaceDetailsModel> _fetchPlaceDetailsFromLatLngSDK({required double lat, required double lng}) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        final placeJson = convertPlacemarkToPlaceJson(placemark, lat, lng);
        return PlaceDetailsModel.fromJson(placeJson);
      } else {
        return PlaceDetailsModel.fromJson({});
      }
    } catch (e) {
      rethrow;
    }
  }

  /// HTTP API implementation for reverse geocoding from coordinates
  Future<PlaceDetailsModel> _fetchPlaceDetailsFromLatLngHTTP({required double lat, required double lng}) async {
    try {
      Map<String, dynamic> params = {
        "latlng": "$lat,$lng",
        "key": AppEnv.envConfig['GOOGLE_MAPS_KEY']
      };

      final response = await dio.get(Urls.googleMapPlaceDetailFromLatLng, queryParameters: params);
      final jsonData = json.decode(response.toString());
      return PlaceDetailsModel.fromJson(jsonData["results"]?[0]);
    } catch (e) {
      rethrow;
    }
  }

  /// Main method for reverse geocoding from coordinates
  Future<PlaceDetailsModel> fetchPlaceDetailsFromLatLng({required double lat, required double lng}) async {
    if (shouldUseMobileSdk) {
      return _fetchPlaceDetailsFromLatLngSDK(lat: lat, lng: lng);
    } else {
      return _fetchPlaceDetailsFromLatLngHTTP(lat: lat, lng: lng);
    }
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/google_maps/address_components.dart';
import 'package:jobprogress/common/models/google_maps/address_geometry.dart';
import 'package:jobprogress/common/models/google_maps/place_details.dart';
import 'package:jobprogress/global_widgets/search_location/search_screen/controller.dart';

void main() {
  late SearchLocationController controller;

  PlaceDetailsModel placeDetailsModel = PlaceDetailsModel(
    addressComponents: [
      AddressComponentsModel(longName: "Bestech Business Tower", shortName: "Bestech Business Tower", types: ["premise"]),
      AddressComponentsModel(longName: "Sector 66", shortName: "Sector 66", types: ["sublocality_level_1"]),
      AddressComponentsModel(longName: "Sahibzada Ajit Singh Nagar", shortName: "SAS Nagar", types: ["locality"]),
      AddressComponentsModel(longName: "Sahibzada Ajit Singh Nagar", shortName: "Sahibzada Ajit Singh Nagar", types: ["administrative_area_level_3"]),
      AddressComponentsModel(longName: "Ropar Division", shortName: "Ropar Division", types: ["administrative_area_level_2"]),
      AddressComponentsModel(longName: "Punjab", shortName: "PB", types: ["administrative_area_level_1"]),
      AddressComponentsModel(longName: "India", shortName: "IN", types: ["country"]),
      AddressComponentsModel(longName: "160062", shortName: "160062", types: ["160062"]),
    ],
    formattedAddress: "Bestech Business Tower, Parkview Residence Colony, Sector 66, Sahibzada Ajit Singh Nagar, Punjab 160062, India",
    geometry: AddressGeometryModel(lat: 30.6756426, lng: 76.7402769),
    name: "Bestech Business Tower",
    placeId: "ChIJUa1cpAbsDzkRPK2eYN0-9CI",
    utcOffset: 330,
    vicinity: "Sector 66",
  );

  group('In case of fresh search', () {
    test('SearchLocationController should be initialized with correct data', () {
      controller = SearchLocationController();
      expect(controller.searchTextController.text, "");
      expect(controller.placeDetailsModel, null);
      expect(controller.placesList, null);
      expect(controller.isLoading, false);
    });

    test('SearchLocationController@search should search for the location written in search bar', () {
      controller.searchTextController.text = "bestech";
      controller.search(controller.searchTextController.text);
      expect(controller.searchTextController.text, "bestech");
      expect(controller.placeDetailsModel, null);
      expect(controller.placesList, null);
      expect(controller.isLoading, true);
      controller.toggleLoading();
    });

    group('EventFormController@toggleLoading should toggle loading state', () {
      test('Initially loader should not be loading', () {
        expect(controller.isLoading, false);
      });

      test('Loader should be loading', () {
        controller.toggleLoading();
        expect(controller.isLoading, true);
      });

      test('Loader should not be loading', () {
        controller.toggleLoading();
        expect(controller.isLoading, false);
      });
    });
  });

  group('In case of some location is carried forward for search', () {
    test('SearchLocationController should be initialized with carried forward data', () {
      controller = SearchLocationController(placeDetailsModel: placeDetailsModel);
      expect(controller.searchTextController.text, placeDetailsModel.formattedAddress);
      expect(controller.placeDetailsModel != null, true);
      expect(controller.placesList, null);
      expect(controller.isLoading, true);
    });
  });

}
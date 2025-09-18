import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';

import '../../../common/models/address/address.dart';
import '../../../common/models/google_maps/place_details.dart';
import '../../../common/models/google_maps/places_auto_complete.dart';
import '../../../common/repositories/google_maps.dart';
import '../../../core/utils/map_helper/google_map_helper.dart';
import '../../loader/index.dart';

class SearchLocationController extends GetxController {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController searchTextController = TextEditingController();

  final PlaceDetailsModel? placeDetailsModel;

  String? preFilledAddress = Get.arguments?[NavigationParams.address];

  List<PlacesAutoCompleteModel>? placesList;

  bool isLoading = false;

  SearchLocationController({this.placeDetailsModel}) {
    if (placeDetailsModel != null) {
      searchTextController.text = placeDetailsModel?.formattedAddress ?? "";
      search(placeDetailsModel?.formattedAddress ?? "");
    }
  }

  @override
  void onInit() {
    if(preFilledAddress?.isNotEmpty ?? false) {
      searchTextController.text = preFilledAddress!;
      search(preFilledAddress!);
    }
    super.onInit();
  }

  void updateListType() {
    if (searchTextController.text.isNotEmpty) {
      search(searchTextController.text.trim());
    } else {
      update();
    }
  }

  //////////////////////////////   SEARCH    ///////////////////////////////////

  void search(String val) {
    if (val.isEmpty) {
      placesList = null;
      isLoading = false;
    } else {
      fetchPlaces(val);
    }
    update();
  }

  Future<void> fetchPlaces(String val) async {
    try {
      toggleLoading();
      Map<String, dynamic> response = await GoogleMapRepository().fetchSimilarPlaces(val);
      placesList ??= [];
      placesList = response["list"];
    } catch (e) {
      rethrow;
    } finally {
      update();
      toggleLoading();
    }
  }

  void toggleLoading() {
    isLoading = !isLoading;
    update();
  }

  void onAddressSelect(int index, Function(AddressModel params)? callback) {
    getPlaceDetails(placesList![index], callback);
  }

  //////////////////////////////   PLACE DETAILS    ///////////////////////////////////

  Future<void> getPlaceDetails(PlacesAutoCompleteModel placesAutoCompleteModel, void Function(AddressModel params)? callback) async {
    showJPLoader();
    try {
      PlaceDetailsModel response = await GoogleMapRepository().fetchPlaceDetails(placesAutoCompleteModel.placeId ?? "");
      Get.back();
      if (callback != null) {
        Get.back();
        callback(GoogleMapHelper.convertPlaceDetailsModelToAddressModel(response));
      } else {
        Get.back(result: GoogleMapHelper.convertPlaceDetailsModelToAddressModel(response));
      }
    } catch (e) {
      rethrow;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jobprogress/common/models/google_maps/address_geometry.dart';

import '../../common/models/address/address.dart';
import '../../common/models/google_maps/place_details.dart';
import '../../common/repositories/google_maps.dart';
import '../../common/services/location/loaction_service.dart';
import '../../common/services/run_mode/index.dart';
import '../../core/config/maps/gesture_recognizers.dart';
import '../../core/utils/helpers.dart';
import '../../core/utils/map_helper/google_map_helper.dart';
import '../bottom_sheet/index.dart';
import 'address_dailogue/index.dart';

class JPCollapsibleMapController extends GetxController {
  TextEditingController searchTextController = TextEditingController();
  late GoogleMapController mapController;

  double cameraZoom = 18;
  double rotationAngle = 0;
  bool isTiltView = false;
  bool isMapScrolling = false;
  bool canUpdatePin = true;

  MarkerId markerId = const MarkerId('0');

  CameraPosition initialLocation = const CameraPosition(
    target: LatLng(30.7333, 76.7794),
    zoom: 15,
  );

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  AddressModel? initialAddress;
  PlaceDetailsModel placeDetailsModel = PlaceDetailsModel();

  final void Function(bool isMapScrolling) mapDragDetector;

  Function(AddressModel params, {bool? isPinUpdated})? onAddressUpdate;

  JPCollapsibleMapController({this.initialAddress, required this.mapDragDetector, this.onAddressUpdate});

  get mapGestureRecognizers => MapGestureRecognizers(() {
    if (!isMapScrolling) {
      isMapScrolling = true;
      mapDragDetector(isMapScrolling);
    }
    update();
  });

  void setMapScrolling(bool isMapScrolling) {
    this.isMapScrolling = isMapScrolling;
    update();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if ((initialAddress?.address?.isNotEmpty ?? false) || (initialAddress?.addressLine1?.isNotEmpty ?? false)) {
      placeDetailsModel = GoogleMapHelper.convertAddressModelToPlaceDetailsModel(initialAddress!);
      canUpdatePin = placeDetailsModel.geometry == null;
      if(initialAddress?.lat == null || initialAddress?.long == null) {
        searchTextController.text = placeDetailsModel.formattedAddress ?? "";
        setInitialMap();
        fetchAddressId(searchTextController.text);
      } else {
        updateMarker(placeDetailsModel);
      }
    } else {
      canUpdatePin = placeDetailsModel.geometry == null;
      setInitialMap();
    }
  }

  void  setInitialMap() {
    LocationService.getCoordinates().then((location) {
      initialLocation = CameraPosition(
        target: LatLng(location.latitude, location.longitude),
        zoom: cameraZoom,
      );
      GoogleMapHelper.updateCamera(
          cameraPosition: initialLocation,
          placeDetail: PlaceDetailsModel(geometry: AddressGeometryModel(lat: location.latitude, lng: location.longitude)),
          mapController: mapController,
          cameraZoom: cameraZoom);
      Future.delayed(const Duration(milliseconds: 500), () {
        GoogleMapHelper.updateCamera(
            cameraPosition: initialLocation,
            placeDetail: PlaceDetailsModel(geometry: AddressGeometryModel(
                lat: location.latitude + 0.0000001,
                lng: location.longitude + 0.0000001)),
            mapController: mapController,
            cameraZoom: cameraZoom);
      });
    });
  }

  //////////////////////////////   SEARCH    ///////////////////////////////////

  void onLocationSearchResult(AddressModel addressModel, void Function(AddressModel params)? onAddressUpdate) {
    onAddressUpdate!(addressModel);
    placeDetailsModel = GoogleMapHelper.convertAddressModelToPlaceDetailsModel(addressModel);
    canUpdatePin = placeDetailsModel.geometry == null;
    updateMarker(placeDetailsModel);
  }

  /////////////////////////   SEARCH LAT & LNG    //////////////////////////////

  Future<void> fetchAddressId(String val) async {
    try {
      Map<String, dynamic> response = await GoogleMapRepository().fetchSimilarPlaces(val);
      if((response["list"] is List) && response["list"]?.isNotEmpty) {
        fetchAddressDetails(response["list"][0]?.placeId ?? "");
      } else {
        Helper.showToastMessage("no_location_found".tr);
      }
    } catch (e) {
      rethrow;
    } finally {
      update();
    }
  }

  Future<void> fetchAddressDetails(String placeId) async {
    try {
      PlaceDetailsModel response = await GoogleMapRepository().fetchPlaceDetails(placeId);
      placeDetailsModel.geometry?.lat = response.geometry?.lat;
      placeDetailsModel.geometry?.lng = response.geometry?.lng;
      onAddressUpdate?.call(GoogleMapHelper.convertPlaceDetailsModelToAddressModel(placeDetailsModel));
      updateMarker(placeDetailsModel);
    } catch (e) {
      rethrow;
    }
  }

  ////////////////////////////   UPDATE MAP    /////////////////////////////////

  void updateMarker(PlaceDetailsModel placeDetail) {
    Marker marker = Marker(
      markerId: markerId,
      position: LatLng(placeDetail.geometry?.lat ?? 0, placeDetail.geometry?.lng ?? 0),
      icon: BitmapDescriptor.defaultMarker,
      infoWindow: const InfoWindow(title: ""),
    );

    if (markers.isEmpty) {
      markers[markerId] = marker;
    } else {
      markers.update(markerId, (value) => marker);
    }

    GoogleMapHelper.updateCamera(
        cameraPosition: initialLocation,
        placeDetail: placeDetail,
        mapController: mapController,
        cameraZoom: cameraZoom);

    Future.delayed(const Duration(milliseconds: 500), () {
      GoogleMapHelper.updateCamera(
          cameraPosition: initialLocation,
          placeDetail: placeDetail..geometry = AddressGeometryModel(
                lat: (placeDetail.geometry?.lat ?? 0) + 0.0000001,
                lng: (placeDetail.geometry?.lng ?? 0) + 0.0000001),
          mapController: mapController,
          cameraZoom: cameraZoom);
    });

    searchTextController.text = placeDetail.formattedAddress ?? "";
    update();
  }

  void onUpdateMapView(bool isTiltView) {
    this.isTiltView = isTiltView;

    GoogleMapHelper.updateCamera(
      cameraPosition: initialLocation,
      placeDetail: placeDetailsModel,
      mapController: mapController,
      cameraZoom: cameraZoom,
      tiltAngle: this.isTiltView ? 45 : 0,
    );
    update();
  }

  void onRotateMapView(bool isRotateRight) {
    rotationAngle = rotationAngle.abs() == 360 ? 0 : rotationAngle;
    if (isRotateRight) {
      rotationAngle = rotationAngle + 90;
    } else {
      rotationAngle = rotationAngle - 90;
    }

    GoogleMapHelper.updateCamera(
      cameraPosition: initialLocation,
      placeDetail: placeDetailsModel,
      mapController: mapController,
      cameraZoom: cameraZoom,
      rotationAngle: rotationAngle,
      tiltAngle: isTiltView ? 45 : 0,
    );
    update();
  }

  void onTap(LatLng latLng, {void Function(AddressModel params, {bool? isPinUpdated})? onAddressUpdate}) async {
    try {
      placeDetailsModel.geometry?.lat = latLng.latitude;
      placeDetailsModel.geometry?.lng = latLng.longitude;
      updateMarker(placeDetailsModel);
      dropNewPin(false, onAddressUpdate: onAddressUpdate, isPinUpdated: true);
    } catch (e) {
      rethrow;
    }
  }

  void showAddressDialogue({void Function(AddressModel params, {bool? canUpdateMarker})? onAddressUpdate}) {
    showJPGeneralDialog(
      child: (controller) => SearchedAddressDialogueView(
        addressModel: GoogleMapHelper.convertPlaceDetailsModelToAddressModel(placeDetailsModel),
        onApply: (AddressModel addressModel) {
          onAddressUpdate?.call(addressModel, canUpdateMarker: true);
          placeDetailsModel = GoogleMapHelper.convertAddressModelToPlaceDetailsModel(addressModel);
          canUpdatePin = placeDetailsModel.geometry == null;
          updateMarker(placeDetailsModel);
        },
      )
    );
  }

  void dropNewPin(bool canUpdatePin, {void Function(AddressModel params, {bool? isPinUpdated})? onAddressUpdate, bool? isPinUpdated}) {
    this.canUpdatePin = canUpdatePin;
    if(canUpdatePin) {
      markers.remove(markerId);
      initialAddress?.lat = placeDetailsModel.geometry?.lat = null;
      initialAddress?.long = placeDetailsModel.geometry?.lng = null;
    }
    onAddressUpdate?.call(GoogleMapHelper.convertPlaceDetailsModelToAddressModel(placeDetailsModel), isPinUpdated: isPinUpdated);
    update();
  }

  void updateAddress(AddressModel addressModel) {
    initialAddress = AddressModel.copy(addressModel: addressModel);
    placeDetailsModel = GoogleMapHelper.convertAddressModelToPlaceDetailsModel(addressModel);
    canUpdatePin = placeDetailsModel.geometry == null;
    if(!RunModeService.isUnitTestMode) {
      updateMarker(placeDetailsModel);
    }
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }
}

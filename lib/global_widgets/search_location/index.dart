import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jobprogress/common/models/address/address.dart';
import 'package:jp_mobile_flutter_ui/IconButton/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../global_widgets/animated_open_container/index.dart';
import '../../core/constants/widget_keys.dart';
import 'controller.dart';
import 'search_screen/index.dart';

class JPCollapsibleMapView extends StatelessWidget {
  const JPCollapsibleMapView({
    super.key,
    required this.onAddressUpdate,
    required this.mapDragDetector,
    this.initialAddress,
    this.controller,
    this.isMapScrolling = false,
  });

  final AddressModel? initialAddress;
  final bool isMapScrolling;
  final void Function(AddressModel params, {bool? canUpdateMarker, bool? isPinUpdated})? onAddressUpdate;
  final void Function(bool isMapScrolling) mapDragDetector;

  final JPCollapsibleMapController? controller;
  
  @override
  Widget build(BuildContext context) {
    return GetBuilder<JPCollapsibleMapController>(
      global: false,
      init: controller ?? JPCollapsibleMapController(initialAddress: initialAddress, mapDragDetector: mapDragDetector, onAddressUpdate: onAddressUpdate),
      builder: (JPCollapsibleMapController controller) {
        controller.setMapScrolling(isMapScrolling);
        return SliverOverlapAbsorber(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          sliver: SliverPadding(
            padding: const EdgeInsets.only(bottom: 0),
            sliver: SliverAppBar(
              snap: false,
              pinned: true,
              floating: false,
              expandedHeight: 280,
              collapsedHeight: 125,
              backgroundColor: JPColor.transparent,
              centerTitle: true,
              automaticallyImplyLeading: false,
              elevation: 0,
              scrolledUnderElevation: 0,
              title: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: JPOpenContainer(
                  closedColor: JPColor.transparent,
                  borderRadius: 18,
                  closeWidget: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: JPAppTheme.themeColors.base),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  JPIcon(
                                    Icons.search,
                                    color: JPAppTheme.themeColors.dimGray,
                                    size: 25,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: JPText(
                                        text: controller.searchTextController.text.isEmpty
                                          ? "search_location".tr
                                          : controller.searchTextController.text,
                                        overflow: TextOverflow.clip,
                                        textColor: controller.searchTextController.text.isEmpty
                                          ? JPAppTheme.themeColors.dimGray
                                          : JPAppTheme.themeColors.text,
                                        maxLine: 1,
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            JPIconButton(
                              key: const ValueKey(WidgetKeys.measurementFilterKey),
                              backgroundColor: JPColor.transparent,
                              onTap:() => controller.showAddressDialogue(onAddressUpdate: onAddressUpdate),
                              icon: Icons.tune_outlined,
                              iconSize: 25,
                              iconColor: JPAppTheme.themeColors.text,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  openWidget: SearchLocationView(
                    placeDetailsModel: controller.placeDetailsModel,
                    callback: (AddressModel addressModel) =>
                      controller.onLocationSearchResult(addressModel, onAddressUpdate)
                  )
                ),
              ),
              flexibleSpace: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: IgnorePointer(
                  ignoring: controller.isMapScrolling,
                  child: GoogleMap(
                    onMapCreated: controller.onMapCreated,
                    mapType: MapType.satellite,
                    compassEnabled: true,
                    mapToolbarEnabled: false,
                    myLocationButtonEnabled: false,
                    myLocationEnabled: false,
                    buildingsEnabled: false,
                    zoomControlsEnabled: false,
                    initialCameraPosition: controller.initialLocation,
                    markers: controller.markers.values.toSet(),
                    onTap: controller.canUpdatePin && controller.placeDetailsModel.geometry != null
                        ? (LatLng latLng) => controller.onTap(latLng, onAddressUpdate: onAddressUpdate) : null,
                    gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                      Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
                    }..add(Factory<TapAndPanGestureRecognizer>(() => controller.mapGestureRecognizers)),
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(102),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          children: [
                            Visibility(
                              visible: controller.isTiltView,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: JPIconButton(
                                  backgroundColor: JPAppTheme.themeColors.base,
                                  onTap: () => controller.onRotateMapView(true),
                                  icon: Icons.rotate_right_outlined,
                                  iconSize: 20,
                                  iconColor: JPAppTheme.themeColors.primary,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: controller.isTiltView,
                              child: JPIconButton(
                                backgroundColor: JPAppTheme.themeColors.base,
                                onTap: () => controller.onRotateMapView(false),
                                icon: Icons.rotate_left_outlined,
                                iconSize: 20,
                                iconColor: JPAppTheme.themeColors.primary,
                              ),
                            ),
                            Visibility(
                              visible: controller.placeDetailsModel.geometry != null,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: JPIconButton(
                                  backgroundColor: JPAppTheme.themeColors.base,
                                  onTap: () => controller.onUpdateMapView(!controller.isTiltView),
                                  icon: controller.isTiltView
                                      ? Icons.add_box_outlined
                                      : Icons.window,
                                  iconSize: 20,
                                  iconColor: JPAppTheme.themeColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: const BoxDecoration(
                          color: JPColor.white,
                          borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        )
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: JPText(
                                text: "map_pin_update_note".tr,
                                textAlign: TextAlign.start,
                                textSize: JPTextSize.heading5,
                                textColor: JPAppTheme.themeColors.darkGray,
                                fontStyle: FontStyle.italic,
                              )
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: JPButton(
                              onPressed: () => controller.dropNewPin(true, onAddressUpdate: onAddressUpdate),
                              type: JPButtonType.outline,
                              size: JPButtonSize.extraSmall,
                              disabled: controller.canUpdatePin,
                              text: "drop_new_pin".tr,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ),
            ),
          ),
        );
      }
    );
  }
}
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/address/address.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jp_mobile_flutter_ui/Icon/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';
import '../../common/enums/map_type.dart';

class LocationHelper {

  static openMapBottomSheet ({String? query, AddressModel? address}) {

    if(query == null) return;

    List<JPQuickActionModel> quickActionList = [];
    if (Platform.isAndroid) {
      launchMap(query: query, mapType: MapType.googleMap);
    } else if (Platform.isIOS) {
      quickActionList.addAll([
        JPQuickActionModel(id: "appleMap", child: const JPIcon(Icons.location_on_outlined, size: 18), label: 'apple_map'.tr ),
        JPQuickActionModel(id: "googleMap", child: const JPIcon(Icons.location_on_outlined, size: 18), label: 'google_map'.tr ),
      ]);

      showJPBottomSheet(
          child: (_) => JPQuickAction(
            title: "open_in".tr.toUpperCase(),
            mainList: quickActionList,
            onItemSelect: (value) {
              Get.back();
              launchMap(query: query,
                  mapType: value == "appleMap" ? MapType.appleMap : MapType.googleMap);
            },
          ),
          isScrollControlled: true
      );
    }
  }

  static void launchMap({required MapType mapType, required String query}) async {
    String mapUrl = '';
    switch(mapType) {
      case MapType.appleMap:
        mapUrl = Uri.encodeFull('https://maps.apple.com/?q=$query');
        break;
      case MapType.googleMap:
        mapUrl = Uri.encodeFull('https://www.google.com/maps/search/?api=1&&query=$query');
        // mapUrl = Uri.parse('google.navigation:q=$query').path;
        break;
    }
    Helper.launchUrl(mapUrl);
  }
}
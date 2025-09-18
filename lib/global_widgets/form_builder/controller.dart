import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/address/address.dart';
import 'package:jobprogress/global_widgets/search_location/controller.dart';

class JPFormBuilderController extends GetxController {

  JPFormBuilderController({this.initialAddress});

  final AddressModel? initialAddress;
  late ScrollController scrollController;
  late JPCollapsibleMapController? collapsibleMapController;

  bool isMapScrolling = true;
  bool isListScrolling = false;

  @override
  void onInit() {
    super.onInit();
    collapsibleMapController = JPCollapsibleMapController(initialAddress: initialAddress, mapDragDetector: mapDragDetector);
    scrollController = ScrollController()..addListener(() => listDragDetector(isListScrolling: false));
  }

  void mapDragDetector(bool isMapScrolling) {
   if(isMapScrolling) {
     this.isMapScrolling = true;
     isListScrolling = false;
     update();
   }
  }


  void listDragDetector({bool isListScrolling = false}) {
    if(!isListScrolling){
      isListScrolling = true;
      isMapScrolling = false;
      update();
    }
  }
}
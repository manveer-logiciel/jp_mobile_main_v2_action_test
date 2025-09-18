import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';

class TiersSearchController extends GetxController {

  TextEditingController searchTextController = TextEditingController();

  List<String> tiers = Get.arguments?[NavigationParams.list] ?? [];
  List<String> filterTiers = [];

  @override
  void onInit() {
    filterTiers = tiers;
    super.onInit();
  }

  void search(String val) {
    if (val.isNotEmpty) {
      filterTiers = tiers.where((tier) => tier.toLowerCase().contains(searchTextController.text.toLowerCase())).toList();
    } else {
      filterTiers = tiers;
    }
    update();
  }

  void onTapItem({int? index}) {
    final tierName = getSelectedTierName(index: index);
    Get.back(result: tierName);
  }

  String? getSelectedTierName({int? index}) {
    String? tierName;
    if(index == null) {
      tierName = searchTextController.text;
    } else {
      tierName = filterTiers[index];
    }
    return tierName;
  }
}


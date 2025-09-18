import 'package:flutter/material.dart';
import 'package:jobprogress/common/enums/firebase.dart';
import 'package:jobprogress/common/enums/secondary_drawer.dart';

class JPSecondaryDrawerItem {

  /// Icon is used to display icon on tile item
  IconData? icon;

  /// svgAssetsPath is used to display svg icon on tile item
  String? svgAssetsPath;

  /// slug is used to uniquely identify each drawer item
  String slug;

  /// title is used to display name of drawer item
  String title;

  /// whenever we want to navigate on click of drawer item we should pass route to it
  String? route;

  /// number can be used to display count on tile
  int? number;

  /// when count is coming from firebase realtimekeys should be passed
  /// NOTE :- number can be avoided in case of realtimekeys
  List<RealTimeKeyType>? realTimeKeys;

  /// itemType is used to display drawer item default value is [SecondaryDrawerItemType.tile]
  SecondaryDrawerItemType itemType;

  List<String>? permissions;

  JPSecondaryDrawerItem({
    required this.slug,
    this.icon,
    this.svgAssetsPath,
    this.permissions,
    required this.title,
    this.route,
    this.number,
    this.realTimeKeys,
    this.itemType = SecondaryDrawerItemType.tile
  });
}
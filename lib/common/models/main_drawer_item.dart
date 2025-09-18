import 'package:flutter/material.dart';
import 'package:jobprogress/common/enums/firebase.dart';

class MainDrawerItem {
  Widget icon;
  Widget selectedIcon;
  String slug;
  String title;
  String? number;
  List<RealTimeKeyType>? realTimeKeys;
  FireStoreKeyType? fireStoreKeyType;
  List<dynamic>? sumOfKeys;
  List<String>? permissions;
  Widget? trailingWidget;

  MainDrawerItem({
    required this.slug,
    required this.icon,
    required this.selectedIcon,
    required this.title,
    this.number,
    this.realTimeKeys,
    this.permissions,
    this.fireStoreKeyType,
    this.sumOfKeys,
    this.trailingWidget,
  });
}


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/communication_flag_id.dart';
import 'package:jobprogress/core/utils/color_helper.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/color.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';

class FlagModel {
  late int id;
  late String title;
  late String type;
  int? companyId;
  late bool reserved;
  late Color actualColor;
  String? color;
  String? profileImage;


  FlagModel({
    required this.id,
    required this.title,
    required this.type,
    required this.reserved,
    this.color,
    required this.actualColor,
    this.companyId,
    this.profileImage
  });

  static FlagModel get callRequiredFlag => FlagModel(
    id: CommunicationFlagsId.call, 
    reserved: true, 
    actualColor: JPAppTheme.themeColors.inverse, 
    title:'${'call'.tr.capitalize!} ${'required'.tr.capitalize!}', 
    type: 'from job', 
  );

  static FlagModel get appointmentRequiredFlag => FlagModel(
    id: CommunicationFlagsId.appointment, 
    reserved: true, 
    actualColor: JPAppTheme.themeColors.inverse, 
    title: '${'appointment'.tr.capitalize!} ${'required'.tr.capitalize!}', 
    type: 'from job', 
  );

  // converting from local db data -> model
  FlagModel.fromApiJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    type = json['for'];
    companyId = json['company_id'];
    reserved = json['reserved'] == 1;
    color = json['color'] != null ? json['color']['color'] : null;
    actualColor = json['color'] != null ? ColorHelper.getHexColor(json['color']['color']) : JPColor.transparent;
  }

  // converting from local db data -> model
  FlagModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    type = json['for'];
    companyId = json['company_id'];
    reserved = json['reserved'] == 1;
    color = json['color'];
    actualColor = json['color'] != null ? ColorHelper.getHexColor(json['color']) : JPColor.transparent;
  }

  // this function is used while inserting data in to local db
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['for'] = type;
    data['company_id'] = companyId;
    data['local_id'] = '${id}_${companyId}_$type';
    data['reserved'] = reserved ? 1 : 0;
    data['color'] = color;
    return data;
  }
}
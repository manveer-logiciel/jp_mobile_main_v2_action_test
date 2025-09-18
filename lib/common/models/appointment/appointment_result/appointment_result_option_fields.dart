import 'package:flutter/material.dart';

class AppointmentResultOptionFieldModel {
  String? name;
  String? type;
  String? value;
  late TextEditingController controller;

  AppointmentResultOptionFieldModel({
    this.name,
    this.type,
    this.value,
    required this.controller
  });

  AppointmentResultOptionFieldModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    value = json['value'];
    controller = TextEditingController(text: value ?? '');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['type'] = type;
    data['value'] = value;
    return data;
  }

}

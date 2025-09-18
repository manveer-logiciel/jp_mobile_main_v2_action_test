import 'package:jobprogress/common/models/forms/measurement/measurement_unit.dart';
import 'package:jobprogress/core/utils/helpers.dart';

class MeasurementAttributeModel {
  int? id;
  String? name;
  String? slug;
  bool? locked;
  int? active;
  MeasurementUnit? unit;
  String? value;
  List<MeasurementAttributeModel>? subAttributes;
  bool? thirdPartyAttributeEditable;

 factory MeasurementAttributeModel.copy(MeasurementAttributeModel data){
   List<MeasurementAttributeModel> tempSubAttributes = [];
   if(data.subAttributes != null) {
    for (var element in data.subAttributes!) { tempSubAttributes.add(MeasurementAttributeModel.copy(element)); }
   }
    return MeasurementAttributeModel(
      id:data.id,
      name: data.name,
      slug: data.slug,
      locked: data.locked,
      active: data.active,
      unit: data.unit,
      value: data.value,
      subAttributes: tempSubAttributes,
    );
  }
 
  MeasurementAttributeModel({
    this.id, 
    this.name, 
    this.slug, 
    this.locked, 
    this.active,
    this.value, 
    this.unit,
    this.subAttributes,
    this.thirdPartyAttributeEditable
  });

  MeasurementAttributeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    locked = json['locked'];
    active = json['active'];
    unit = json['unit'] != null ? MeasurementUnit.fromJson(json['unit']) : null;
    if (json['sub_attributes'] != null && json['sub_attributes']['data'] != null) {
      subAttributes = <MeasurementAttributeModel>[];
      json['sub_attributes']['data'].forEach((dynamic subAttribute) {
        subAttributes!.add(MeasurementAttributeModel.fromJson(subAttribute));
      });
    }
    thirdPartyAttributeEditable = Helper.isTrue(json['third_party_attribute_editable']);
  }

  MeasurementAttributeModel.fromEditMeasurementJson(Map<String, dynamic> json) {
    id = json['attribute_id'];
    name = json['attribute_name'];
    slug = json['attribute_slug'];
    locked = Helper.isTrue(json['attribute_locked']) ;
    value = json['value'].toString();
    active = json['active'];
    unit = json['unit'] != null ? MeasurementUnit.fromJson(json['unit']) : null;
    if (json['sub_attribute_values_summary'] != null && json['sub_attribute_values_summary']['data'] != null) {
      subAttributes = <MeasurementAttributeModel>[];
      json['sub_attribute_values_summary']['data'].forEach((dynamic subAttribute) {
        subAttributes!.add(MeasurementAttributeModel.fromEditMeasurementJson(subAttribute));
      });
    }
    if (json['sub_attribute_values'] != null && json['sub_attribute_values']['data'] != null) {
      subAttributes = <MeasurementAttributeModel>[];
      json['sub_attribute_values']['data'].forEach((dynamic subAttribute) {
        subAttributes!.add(MeasurementAttributeModel.fromEditMeasurementJson(subAttribute));
      });
    }

    thirdPartyAttributeEditable = Helper.isTrue(json['third_party_attribute_editable']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['locked'] = locked;
    data['active'] = active;
    if (unit != null) {
      data['unit'] = unit!.toJson();
    }
    if (subAttributes != null) {
      for (var v in subAttributes!) {
        data['sub_attributes']['data'].add(v.toJson());
      }
    }
    data['third_party_attribute_editable'] = Helper.isTrue(thirdPartyAttributeEditable) ? '1' : '0';
    return data;
  }
}

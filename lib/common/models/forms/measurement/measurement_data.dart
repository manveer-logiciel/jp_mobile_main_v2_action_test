import 'package:jobprogress/common/models/forms/measurement/measurement_attribute.dart';

class MeasurementDataModel {
  int? id;
  String? name;
  String? color;
  bool isDisable = false;
  bool isAttributeButtonDisable = false;
  List<MeasurementAttributeModel>? attributes;
  List<List<MeasurementAttributeModel>>? values; 

  MeasurementDataModel({
    this.id, 
    this.name, 
    this.color,
    this.attributes,
    this.values,
    this.isAttributeButtonDisable = false,
    this.isDisable = false,
  });

  factory MeasurementDataModel.copy(MeasurementDataModel data) {
    
    List<MeasurementAttributeModel> tempAttributes = [];
    List<List<MeasurementAttributeModel>>? tempValues = [];
      
    for (var element in data.attributes!) {
      tempAttributes.add(MeasurementAttributeModel.copy(element));
    }
    for (var values in data.values ?? []) {
      List<MeasurementAttributeModel> tempValue = [];
      for(var value in values) {
        tempValue.add(MeasurementAttributeModel.copy(value));
      }
      tempValues.add(tempValue);
    }
      
    return MeasurementDataModel(
      id:data.id,
      name: data.name,
      color: data.color,
      attributes: tempAttributes,
      isDisable: data.isDisable,
      isAttributeButtonDisable: data.isAttributeButtonDisable,
      values: tempValues
    );
  }

  MeasurementDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    color = json['color'];
   
    if (json['attributes'] != null && json['attributes']['data'] != null) {
      attributes = <MeasurementAttributeModel>[];
      json['attributes']['data'].forEach((dynamic attribute) {
        attributes!.add(MeasurementAttributeModel.fromJson(attribute));
      });
    }
    if (json['measurement_values_summary'] != null && json['measurement_values_summary']['data'] != null) {
      attributes = <MeasurementAttributeModel>[];
      json['measurement_values_summary']['data'].forEach((dynamic attribute) {
        attributes!.add(MeasurementAttributeModel.fromEditMeasurementJson(attribute));
      });
  }

    if (json['values'] != null && json['values']['data'] != null) {
      values = <List<MeasurementAttributeModel>>[];
      
      json['values']['data'].forEach((dynamic value) {
      if(value != null && value.isNotEmpty) {
        List<MeasurementAttributeModel> subValues = [];
        value.forEach((dynamic subValue){
          subValues.add(MeasurementAttributeModel.fromEditMeasurementJson(subValue));
        });
        values!.add(subValues);
      }  
      });
    }
    if(values?.isNotEmpty ?? false){
      isDisable = values?.length != 1;
    }
  }
  

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['color'] = color;

    return data;
  }

 Map<String, dynamic> toValuesJson(int i) {
    final data = <String, dynamic>{};
      
    data['trade_id'] = id;
      
    List<Map<String, dynamic>> attributesJson = [];
    
    for (int j = 0; j < values![i].length; j++) {
      if(values![i][j].name != 'Name'){
        List<Map<String, dynamic>> subAttributeJson = [];

        if(values![i][j].subAttributes?.isNotEmpty ?? false){
          for(int k= 0; k< values![i][j].subAttributes!.length; k++) {
            subAttributeJson.add({
              'attribute_id' : values![i][j].subAttributes![k].id,
              'value' : values![i][j].subAttributes![k].value,
            });
          }
        }

        attributesJson.add({
          'attribute_id' : values![i][j].id,
          if(values![i][j].subAttributes?.isEmpty ?? true) ...{
            'value' :values![i][j].value
          } else ...{
            'sub_attributes' :subAttributeJson
          },

        });
      }
    }

    data['attributes'] =  attributesJson;
    
    return data;
  }
}

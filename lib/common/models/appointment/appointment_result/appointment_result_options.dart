import 'appointment_result_option_fields.dart';

class AppointmentResultOptionsModel {
  int? id;
  String? name;
  List<AppointmentResultOptionFieldModel>? fields;
  bool? isActive;

  AppointmentResultOptionsModel({
    this.id,
    this.name,
    this.fields,
    this.isActive
  });

  AppointmentResultOptionsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['fields'] != null) {
      fields = <AppointmentResultOptionFieldModel>[];
      json['fields'].forEach((dynamic v) {
        fields!.add(AppointmentResultOptionFieldModel.fromJson(v));
      });
    }
    isActive = json['active'] == 1;
  }

  /// this function returns json for saving appointment results
  static Map<String, dynamic> toSaveFieldsJson({
    required String requestOptionId,
    required List<int> requestOptionIds,
    required List<AppointmentResultOptionFieldModel> fields
  }) {
    final Map<String, dynamic> data = {};
    for(int i=0; i<fields.length; i++) {
      data['result[$i][name]'] = fields[i].name;
      data['result[$i][type]'] = fields[i].type;
      data['result[$i][value]'] = fields[i].controller.text;
    }
    data['result_option_id'] = requestOptionId;
    data['result_option_ids[]'] = requestOptionIds;
    data['includes[0]'] = 'result_option';
    return data;
  }

}
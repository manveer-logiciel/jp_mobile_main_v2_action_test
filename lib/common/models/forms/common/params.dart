
import 'package:get/get.dart';
import 'package:jobprogress/core/utils/helpers.dart';

/// [InputFieldParams] can be used to parse data of the fields
/// coming from company settings.
class InputFieldParams {

  late String key;
  late String name;
  late bool showFieldValue;
  late bool isRequired;
  late bool scrollOnValidate;
  Function(String)? onDataChange;

  InputFieldParams({
    required this.key,
    required this.name,
    this.showFieldValue = true,
    this.isRequired = false,
    this.onDataChange,
    this.scrollOnValidate = true
  });

  InputFieldParams.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    name = (json['key'] ?? json['name']).toString().tr;
    showFieldValue = Helper.isTrue(json['showField']);
    isRequired = Helper.isTrue(json['required']);
    scrollOnValidate = true;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InputFieldParams &&
          runtimeType == other.runtimeType &&
          key == other.key &&
          name == other.name &&
          showFieldValue == other.showFieldValue &&
          isRequired == other.isRequired &&
          scrollOnValidate == other.scrollOnValidate &&
          onDataChange == other.onDataChange;

  @override
  int get hashCode => 0;
}

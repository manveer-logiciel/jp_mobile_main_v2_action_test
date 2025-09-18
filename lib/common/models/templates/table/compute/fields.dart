import 'field.dart';
import 'result.dart';

class TemplateTableComputeFields {
  TemplateTableComputeField? first;
  TemplateTableComputeField? second;
  TemplateTableComputeResult? result;

  TemplateTableComputeFields({
    this.first,
    this.second,
    this.result,
  });

  TemplateTableComputeFields.fromJson(Map<String, dynamic>? json) {
    first = json?['first'] is Map
        ? TemplateTableComputeField.fromJson(json!['first'])
        : null;
    second = json?['second'] is Map
        ? TemplateTableComputeField.fromJson(json!['second'])
        : null;
    result = json?['result'] is Map
        ? TemplateTableComputeResult.fromJson(json!['result'])
        : null;
  }
}

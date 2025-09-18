import 'package:jobprogress/common/models/templates/table/compute/fields.dart';
import 'package:jobprogress/common/models/templates/table/compute/operation.dart';

class TemplateTableComputeDetail {
  TemplateTableComputeOperation? operation;
  TemplateTableComputeFields? fields;

  TemplateTableComputeDetail({
    this.operation,
    this.fields,
  });

  TemplateTableComputeDetail.fromJson(Map<String, dynamic>? json) {
    operation = json?['operation'] is Map
        ? TemplateTableComputeOperation.fromJson(json!['operation'])
        : null;
    fields = json?['fields'] is Map
        ? TemplateTableComputeFields.fromJson(json!['fields'])
        : null;
  }
}

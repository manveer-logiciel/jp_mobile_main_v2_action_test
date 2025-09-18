import 'package:jobprogress/core/utils/helpers.dart';

class TemplateTableComputeField {
  int? tdIndex;
  String? heading;
  bool? col;

  TemplateTableComputeField({
    this.tdIndex,
    this.heading,
    this.col,
  });

  TemplateTableComputeField.fromJson(Map<String, dynamic>? json) {
    tdIndex = int.tryParse((json?['tdIndex']).toString());
    heading = json?['heading']?.toString();
    col = Helper.isTrue(json?['col']);
  }
}

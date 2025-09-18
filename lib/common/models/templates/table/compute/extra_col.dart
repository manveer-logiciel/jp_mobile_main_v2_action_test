class TemplateTableComputeExtraCol {
  int? field;
  String? sign;

  TemplateTableComputeExtraCol({
    this.field,
    this.sign,
  });

  TemplateTableComputeExtraCol.fromJson(Map<String, dynamic>? json) {
    field = int.tryParse((json?['field']).toString());
    sign = json?['sign']?.toString();
  }
}

class TemplateTableComputeOperation {
  String? sign;

  TemplateTableComputeOperation({
    this.sign,
  });

  TemplateTableComputeOperation.fromJson(Map<String, dynamic>? json) {
    sign = json?['sign']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['sign'] = sign;
    return data;
  }
}

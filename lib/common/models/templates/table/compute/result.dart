class TemplateTableComputeResult {
  int? compute;

  TemplateTableComputeResult({
    this.compute,
  });

  TemplateTableComputeResult.fromJson(Map<String, dynamic>? json) {
    compute = int.tryParse((json?['compute']).toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['compute'] = compute;
    return data;
  }
}

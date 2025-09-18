class TemplateTableDependentCol {
  int? type;
  int? mainCol;
  int? depCol;
  int? valCol;

  TemplateTableDependentCol({
    this.type,
    this.mainCol,
    this.depCol,
    this.valCol,
  });

  TemplateTableDependentCol.fromJson(Map<String, dynamic>? json) {

    if (json == null) return;

    type = json['type'];
    mainCol = json['mainCol'];
    depCol = json['depCol'];
    valCol = json['valCol'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['type'] = type;
    data['mainCol'] = mainCol;
    data['depCol'] = depCol;
    data['valCol'] = valCol;
    return data;
  }
}

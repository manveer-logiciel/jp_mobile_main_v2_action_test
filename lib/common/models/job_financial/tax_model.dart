class TaxModel {
  int? id;
  int? stateId;
  int? companyId;
  String? title;
  num? taxRate;
  num? materialTaxRate;
  num? laborTaxRate;
  String? quickbookTaxCodeId;
  String? createdAt;
  String? updatedAt;

  TaxModel({
    this.id,
    this.stateId,
    this.companyId,
    this.title,
    this.taxRate,
    this.materialTaxRate,
    this.laborTaxRate,
    this.quickbookTaxCodeId,
    this.createdAt,
    this.updatedAt,
  });

  TaxModel.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '');
    stateId = int.tryParse(json['state_id']?.toString() ?? '');
    stateId = int.tryParse(json['company_id']?.toString() ?? '');
    title = json['title']?.toString();
    taxRate = num.tryParse(json['tax_rate']?.toString() ?? "");
    materialTaxRate = num.tryParse(json['material_tax_rate']?.toString() ?? "");
    laborTaxRate = num.tryParse(json['labor_tax_rate']?.toString() ?? "");
    quickbookTaxCodeId = json['quickbook_tax_code_id']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['state_id'] = stateId;
    data['company_id'] = companyId;
    data['title'] = title;
    data['tax_rate'] = taxRate;
    data['material_tax_rate'] = materialTaxRate;
    data['labor_tax_rate'] = laborTaxRate;
    data['quickbook_tax_code_id'] = quickbookTaxCodeId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
class DocumentUploadLimitModel {
  int? count;
  int? limit;

  DocumentUploadLimitModel({
    this.count,
    this.limit,
  });

  DocumentUploadLimitModel.fromJson(Map<String, dynamic> json) {    
    count = json['company_document_count'];
    limit = json['free_trial_essential_document_limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['company_document_count'] = count;
    data['free_trial_essential_document_limit'] = limit;
    return data;
  }
}
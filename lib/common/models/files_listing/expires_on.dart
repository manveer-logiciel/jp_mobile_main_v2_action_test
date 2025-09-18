

class ExpiresOnModel {
  String? message;
  DocumentExpiration? documentExpiration;
  int? status;

  ExpiresOnModel({this.message, this.documentExpiration, this.status});

  ExpiresOnModel.fromJson(Map<String, dynamic> json) {
    message = json["message"];
    documentExpiration = json["document_expiration"] == null ? null : DocumentExpiration.fromJson(json["document_expiration"]);
    status = json["status"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data["message"] = message;
    if(documentExpiration != null) {
      data["document_expiration"] = documentExpiration?.toJson();
    }
    data["status"] = status;
    return data;
  }
}

class DocumentExpiration {
  String? expireDate;
  String? description;
  int? id;

  DocumentExpiration({this.expireDate, this.description, this.id});

  DocumentExpiration.fromJson(Map<String, dynamic> json) {
    expireDate = json["expire_date"];
    description = json["description"];
    id = json["id"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data["expire_date"] = expireDate;
    data["description"] = description;
    data["id"] = id;
    return data;
  }
}
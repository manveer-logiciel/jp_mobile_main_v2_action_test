import 'package:jobprogress/common/services/quick_book.dart';

class QuickBookSyncErrorModel {
  String? entityId;
  String? entity;
  String? errorCode;
  String? details;
  String? remedy;
  String? explanation;
  String? errorType;  
  String? message;

  QuickBookSyncErrorModel({
    this.entityId,
    this.entity,
    this.errorCode, 
    this.errorType, 
    this.details, 
    this.explanation, 
    this.message, 
    this.remedy
  });

 QuickBookSyncErrorModel.fromJson(Map<String, dynamic> json) {
    entityId = json['entity_id'].toString();
    entity = json['entity'];
    errorCode = json['error_code'];
    errorType = json['error_type'];
    details = json['details'];
    explanation = json['explanation'];
    message = json['message'];
    remedy = json['remedy'] != null ? 
      QuickBookService.getHtmlData(json['remedy'])
     : null;
  }
}

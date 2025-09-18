import 'dart:convert';
import 'package:jobprogress/common/models/document_count.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';

class UpgradePlanRepository {
  static Future<String> getBillingCode() async {
    try {
      final response = await dio.get(Urls.billingcode);
      final jsonData = json.decode(response.toString()); 
      return jsonData['billing_code'].toString();  
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<DocumentUploadLimitModel> getDocumentUploadLimit() async {
    try {
      final response = await dio.get(Urls.documentCount);
      final jsonData = json.decode(response.toString()); 
        return DocumentUploadLimitModel.fromJson(jsonData);
    
    } catch (e) {
      //Handle error
      rethrow;
    }
  }


}


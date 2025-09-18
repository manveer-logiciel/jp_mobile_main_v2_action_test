import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:jobprogress/common/models/email/template_list.dart';
import 'package:jobprogress/common/models/pagination_model.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';

class EmaiTemplatelListingRepository {
  static Future<Map<String, dynamic>> fetchTemplateList(Map<String, dynamic> emailsParams,String? actionFrom) async {
    try {
      final response = await dio.get(Urls.emailTemplateList, queryParameters: emailsParams);
      final jsonData = json.decode(response.toString());
      List<EmailTemplateListingModel> list = [];
      Map<String, dynamic> dataToReturn ;
      if(actionFrom == 'sale_automation'){
      dataToReturn = {"list": list};  
      } else {
      dataToReturn = {"list": list, "pagination": PaginationModel.fromJson(jsonData["meta"]["pagination"])};
      }

      jsonData["data"].forEach((dynamic emails) => {dataToReturn['list'].add(EmailTemplateListingModel.fromJson(emails))});
      return dataToReturn;
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> sendEmail(Map<String, dynamic> sendEmailParam) async {
    try {
      var formData = FormData.fromMap(sendEmailParam);
      await dio.post(Urls.emailSend, data: formData);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<void> markAsFavorite(Map<String, dynamic> params, String id) async {
    try {
      await dio.put(Urls.favouriteEmailTemplate(id), queryParameters: params);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<void> sendRecurringEmail(Map<String, dynamic> sendRecuuringEmailParam) async {
    try {
      var formData = FormData.fromMap(sendRecuuringEmailParam);
      await dio.post(Urls.dripCampaigns, data: formData);
    } catch (e) {
      //Handle error
      rethrow;
    }
  } 
}
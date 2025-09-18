
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:jobprogress/common/models/email/email.dart';
import 'package:jobprogress/common/models/email/suggestion.dart';
import 'package:jobprogress/common/models/label.dart';
import 'package:jobprogress/common/models/pagination_model.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';

class EmailListingRepository {
  Future<Map<String, dynamic>> fetchEmailList(Map<String, dynamic> emailsParams) async {
    try {
      final response = await dio.get(Urls.email, queryParameters: emailsParams);
      final jsonData = json.decode(response.toString());
      List<EmailListingModel> list = [];

      Map<String, dynamic> dataToReturn = {"list": list, "pagination": PaginationModel.fromJson(jsonData["meta"]["pagination"])};

      jsonData["data"].forEach((dynamic emails) => {dataToReturn['list'].add(EmailListingModel.fromJson(emails))});

      return dataToReturn;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> fetchEmailSuggestion(Map<String, dynamic>? params) async {
    try {
      final response = await dio.get(Urls.emailSuggestion, queryParameters: params);
      final jsonData = json.decode(response.toString());

      Map<String, dynamic> dataToReturn = {
        "email_suggestion": EmailSuggestionModel.fromJson(jsonData['data']),
      };

      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getTemplate(Map<String, dynamic> emailsParams) async {
    try {
      final response = await dio.get(Urls.emailTemplate, queryParameters: emailsParams);
      final jsonData = json.decode(response.toString());
      List<EmailListingModel> list = [];

      Map<String, dynamic> dataToReturn = {"list": list, "pagination": PaginationModel.fromJson(jsonData["meta"]["pagination"])};

      jsonData["data"].forEach((dynamic emails) => {dataToReturn['list'].add(EmailListingModel.fromJson(emails))});

      return dataToReturn;
    } catch (e) {
      rethrow;
    }
  }

  static Future<int?> sentEmailData(Map<String, dynamic>? params) async {
    try {
      var formData = FormData.fromMap(params!);
      final response = await dio.post(Urls.emailSend, data: formData);
      return response.data?['email']?['id'];
    } catch (e) {
      //Handle error
      rethrow;
    } 
  }

  Future<Map<String, dynamic>> fetchLabelList(Map<String, dynamic> emailLabelParams) async {
    try {
      final response = await dio.get(Urls.emailLabel, queryParameters: emailLabelParams);
      final jsonData = json.decode(response.toString());
      List<EmailLabelModel> list = [];

      Map<String, dynamic> dataToReturn = {"list": list};

      jsonData["data"].forEach((dynamic labels) => {dataToReturn['list'].add(EmailLabelModel.fromJson(labels))});
      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<Map<String, dynamic>> emailTrashedList(Map<String, dynamic> emailTrashedParams) async {
    try {
      final response = await dio.get(Urls.emailTrashed, queryParameters: emailTrashedParams);
      final jsonData = json.decode(response.toString());
      List<EmailListingModel> list = [];

      Map<String, dynamic> dataToReturn = {"list": list, "pagination": PaginationModel.fromJson(jsonData["meta"]["pagination"])};

      jsonData["data"].forEach((dynamic emails) => {dataToReturn['list'].add(EmailListingModel.fromJson(emails))});
      return dataToReturn;
    } catch (e) {
      rethrow;
    }
  }

  Future<EmailLabelModel> createNewLabel(Map<String, dynamic> createNewLbelParams) async {
    try {
      final response = await dio.post(Urls.emailLabel, queryParameters: createNewLbelParams);
      final jsonData = json.decode(response.toString());
      return EmailLabelModel.fromJson(jsonData['email_label']);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchEmaildetail(Map<String, dynamic> emailsParams) async {
    try {
      String url = '${Urls.emailDetail}/${emailsParams['id']}';
      final response = await dio.get(url, queryParameters: emailsParams);
      final jsonData = json.decode(response.toString());
      List<EmailListingModel> list = [];
      Map<String, dynamic> dataToReturn = {"list": list};
      jsonData["data"].forEach((dynamic emails) => {dataToReturn['list'].add(EmailListingModel.fromJson(emails))});
      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<EmailListingModel> fetchEmailReply(Map<String, dynamic> emailsParams) async {
    try {
      final response = await dio.get(Urls.singleEmailDetail(emailsParams['id']), queryParameters: emailsParams);
      final jsonData = json.decode(response.toString());
      EmailListingModel reply = EmailListingModel.fromJson(jsonData["data"]);
      return reply;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<dynamic> changeReadState(Map<String, dynamic> changeReadState) async {
    try {
      final response = await dio.post(Urls.emailUnread, queryParameters: changeReadState);
      final jsonData = json.decode(response.toString());
      return jsonData;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<dynamic> deleteEmail(Map<String, dynamic> deleteEmailParams) async {
    try {
      final response = await dio.delete(Urls.emailDelete, queryParameters: deleteEmailParams);
      final jsonData = json.decode(response.toString());
      return jsonData;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<dynamic> moveToEmail(Map<String, dynamic> moveEmailParams) async {
    try {
      final response = await dio.post(Urls.emailMove, queryParameters: moveEmailParams);
      final jsonData = json.decode(response.toString());
      return jsonData;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<dynamic> removeLabel(Map<String, dynamic> removeLabelParams) async {
    try {
      final response = await dio.post(Urls.removeLabel, queryParameters: removeLabelParams);
      final jsonData = json.decode(response.toString());
      return jsonData;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<String> getAttachmentUrl(Map<String, dynamic> params) async {
    try {
      final response = await dio.post(Urls.getAttachmentUrl, queryParameters: params);
      final jsonData = json.decode(response.toString());
      return jsonData['url'];
    } catch (e) {
      //Handle error
      rethrow;
    }
  }
}

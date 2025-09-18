import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:jobprogress/common/models/company_contacts.dart';
import 'package:jobprogress/common/models/sql/tag/tag.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';

import '../models/company_contacts_notes.dart';

class CompanyContactsListingRepository {
  Future<Map<String, dynamic>> fetchCompanyContactsList(
      Map<String, dynamic> companyContactsParams) async {
    try {
      /// same url is using for list & create company contact but in integration testing it showing me error
      /// because it same route path so for differentiate I have added "?" at end of list url.
      final response = await dio.get('${Urls.comapnyContacts}?', queryParameters: companyContactsParams);
      final jsonData = json.decode(response.toString());
      List<CompanyContactListingModel> list = [];

      Map<String, dynamic> dataToReturn = {
        "list": list,
        "pagination": jsonData["meta"]["pagination"]
      };

      jsonData["data"].forEach((dynamic comapnyContacts) => {
            dataToReturn['list']
                .add(CompanyContactListingModel.fromApiJson(comapnyContacts))
          });
      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<CompanyContactListingModel> fetchCompanyContactView(
      Map<String, dynamic> companyContactParams) async {
    try {
      String url = '${Urls.comapnyContacts}/${companyContactParams['id']}';
      final response =
          await dio.get(url, queryParameters: companyContactParams);
      final jsonData = json.decode(response.toString());

      CompanyContactListingModel contacts =
          CompanyContactListingModel.fromApiJson(jsonData['data']);
      return contacts;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchCompanyContactViewNote(
      Map<String, dynamic> companyContactNoteParams) async {
    try {
      String url =
          '${Urls.comapnyContacts}/${companyContactNoteParams['id']}/notes';
      final response =
          await dio.get(url, queryParameters: companyContactNoteParams);
      final jsonData = json.decode(response.toString());
      List<CompanyContactNoteModel> list = [];

      Map<String, dynamic> dataToReturn = {
        "list": list,
        "pagination": jsonData["meta"]["pagination"]
      };
      jsonData["data"].forEach((dynamic companyContactsNote) => {
            dataToReturn['list']
                .add(CompanyContactNoteModel.fromJson(companyContactsNote))
          });
      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<dynamic> addCompanyContactViewNote(
      Map<String, dynamic> addCompanyContactViewParams) async {
    try {
      String url =
          '${Urls.comapnyContacts}/${addCompanyContactViewParams['id']}/notes';
      var formData = FormData.fromMap(addCompanyContactViewParams);
      await dio.post(url, data: formData);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<dynamic> editCompanyContactViewNote(
      Map<String, dynamic> editCompanyContactNoteParams) async {
    try {
      String url =
          '${Urls.comapnyContacts}/${editCompanyContactNoteParams['id']}/notes/${editCompanyContactNoteParams['noteId']}';
      Map<String, dynamic> dataToSend = {
        'note': editCompanyContactNoteParams['note']
      };
      await dio.put(url, data: dataToSend);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<dynamic> deleteCompanyContactViewNote(
      Map<String, dynamic> deleteCompanyContactNoteParams) async {
    try {
      String url =
          '${Urls.comapnyContacts}/${deleteCompanyContactNoteParams['id']}/notes/${deleteCompanyContactNoteParams['noteId']}';
      await dio.delete(url);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

   Future<dynamic> deteleCompanyContact(
      Map<String, dynamic> companyContactsIdParams) async {
    try {
      final response = await dio.delete(Urls.comapnyContacts, queryParameters: companyContactsIdParams);
      final jsonData = json.decode(response.toString());
      return jsonData;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<dynamic> removeFromGroup(
      Map<String, dynamic> removeGroupPramas) async {
    try {
      final response = await dio.post(Urls.removeGroup, queryParameters: removeGroupPramas);
      final jsonData = json.decode(response.toString());
      return jsonData;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }
  
  Future<dynamic> addToGroup(
      Map<String, dynamic> addGroupPramas) async {
    try {
      final response = await dio.post(Urls.addGroup, queryParameters: addGroupPramas);
      final jsonData = json.decode(response.toString());
      return jsonData;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<dynamic> renameGroup(
      Map<String, dynamic> renameGroupPramas) async {
    try {
      final url = '${Urls.tags}/${renameGroupPramas['id']}';
      final response = await dio.put(url, queryParameters: renameGroupPramas);
      final jsonData = json.decode(response.toString());
      return jsonData;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<dynamic> deleteGroup(
      Map<String, dynamic> deleteGroupPramas) async {
    try {
      final url = '${Urls.tags}/${deleteGroupPramas['id']}';
      await dio.delete(url);
      
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

    Future<TagModel> createGroup(
      Map<String, dynamic> renameGroupPramas) async {
    try {
      final response = await dio.post(Urls.tags, queryParameters: renameGroupPramas);
      final jsonData = json.decode(response.toString());
      return TagModel.fromJson(jsonData['data']);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createCompanyContact(Map<String, dynamic> params) async {
    try {

      final formData = FormData.fromMap(params);

      final response = await dio.post(Urls.comapnyContacts, data: formData);
      final jsonData = json.decode(response.toString());
     CompanyContactListingModel companyContacts = CompanyContactListingModel.fromApiJson(jsonData['data']);
      Map<String, dynamic> data = {
        "data" : companyContacts,
        "status" : jsonData['status'] == 200
      };
      return data;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateCompanyContact(Map<String, dynamic> params) async {
    try {
      final response = await dio.put("${Urls.comapnyContacts}/${params['id']}", queryParameters: params);
      final jsonData = json.decode(response.toString());
      CompanyContactListingModel companyContacts = CompanyContactListingModel.fromApiJson(jsonData['data']);
      Map<String, dynamic> data = {
        "data" : companyContacts,
        "status" : jsonData['status'] == 200
      };
      return data;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }
}

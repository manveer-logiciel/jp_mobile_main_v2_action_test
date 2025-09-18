import 'dart:convert';
import 'package:dio/dio.dart';

import 'package:jobprogress/common/models/note_list/note_listing.dart';
import 'package:jobprogress/common/models/pagination_model.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';

class JobNoteListingRepository {
 Future<Map<String, dynamic>> fetcJobNotesList(Map<String, dynamic> jobNoteParams) async {
    try {
      final response = await dio.get(Urls.jobNote, queryParameters: jobNoteParams);
      final jsonData = json.decode(response.toString());
      List<NoteListModel> list = [];

      Map<String, dynamic> dataToReturn = {
        "list": list,
        "pagination": PaginationModel.fromJson(jsonData["meta"]["pagination"])
      };

      jsonData["data"].forEach((dynamic jobNoteList) => {dataToReturn['list'].add(NoteListModel.fromJson(jobNoteList))});
      return dataToReturn;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> deleteJobNote(int id) async {
    try {
      String url = '${Urls.jobNote}/$id';

      final response = await dio.delete(url);
      final jsonData = json.decode(response.toString());
      return jsonData;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }
  
  Future<NoteListModel> getJobNote(Map<String, dynamic> params) async {
    try {
      String url = '${Urls.jobNote}/${params['id']}';

      final response = await dio.get(url, queryParameters: params);
      final jsonData = json.decode(response.toString())['data'];

      NoteListModel note = NoteListModel.fromJson(jsonData);
      return note;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<dynamic> addJobNote({required Map<String, dynamic> addjobNoteParams}) async {
    try {
      String url = Urls.jobNote;
      var formData = FormData.fromMap(addjobNoteParams);
      await dio.post(url, data: formData);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<Map<String, dynamic>> editJobNote({required int id, required Map<String, dynamic> editJobNoteParams}) async {
    try {
      String url = '${Urls.jobNote}/$id';
      final response = await dio.put(url, data: editJobNoteParams,);
      
      final jsonData = json.decode(response.toString());
      return jsonData;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

}

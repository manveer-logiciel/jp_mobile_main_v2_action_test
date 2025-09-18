import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:jobprogress/common/models/note_list/note_listing.dart';
import 'package:jobprogress/common/models/pagination_model.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';

class WorkCrewNotesListingRepository {
  Future<Map<String, dynamic>> fetchWorkCrewNotesList(
      Map<String, dynamic> workCrewNotesParams) async {
    try {
      final response = await dio.get(Urls.workCrewNotes,
          queryParameters: workCrewNotesParams);
      final jsonData = json.decode(response.toString());
      List<NoteListModel> list = [];

      Map<String, dynamic> dataToReturn = {
        "list": list,
        "pagination": PaginationModel.fromJson(jsonData["meta"]["pagination"])
      };

      jsonData["data"].forEach((dynamic workCrewNotesList) => {
            dataToReturn['list'].add(NoteListModel.fromJson(workCrewNotesList))
          });
      return dataToReturn;
    } catch (e) {
      rethrow;
    }
  }

  Future<NoteListModel> addWorkCrewNote(
      Map<String, dynamic> addWorkCrewNoteParams) async {
    try {
      String url = Urls.workCrewNotes;
      var formData = FormData.fromMap(addWorkCrewNoteParams);
      final response = await dio.post(url,
          data: formData, queryParameters: {'include[0]': 'mentions'});
      final jsonData = json.decode(response.toString())['work_crew_note'];

      NoteListModel note = NoteListModel.fromJson(jsonData);
      return note;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<Map<String, dynamic>> deleteNote(
      int id, Map<String, dynamic> deleteNoteParam) async {
    try {
      String url = '${Urls.workCrewNotes}/$id';

      final response = await dio.delete(url, queryParameters: deleteNoteParam);
      final jsonData = json.decode(response.toString());
      return jsonData;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<NoteListModel> editWorkCrewNote(
      int id, Map<String, dynamic> editWorkCrewNoteParams) async {
    try {
      String url = '${Urls.workCrewNotes}/$id';

      final response = await dio.put(url,
          data: editWorkCrewNoteParams,
          queryParameters: {'include[0]': 'mentions'});

      final jsonData = json.decode(response.toString())['work_crew_note'];

      NoteListModel note = NoteListModel.fromJson(jsonData);

      return note;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<NoteListModel> getWorkcrewNote(Map<String, dynamic> params) async {
    try {
      String url = '${Urls.workCrewNotes}/${params['id']}';
      final response = await dio.get(url, queryParameters: params);
      final jsonData = json.decode(response.toString())['data'];

      NoteListModel note = NoteListModel.fromJson(jsonData);
      return note;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }
}

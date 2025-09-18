import 'dart:convert';
import 'package:jobprogress/common/models/note_list/note_listing.dart';
import 'package:jobprogress/common/models/pagination_model.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';

class FollowUpsNoteListingRepository {
 Future<Map<String, dynamic>> fetchFollowUpNotesList(Map<String, dynamic> followUpNoteParams) async {
    try {
      final response = await dio.get(Urls.followUpNote, queryParameters: followUpNoteParams);
      final jsonData = json.decode(response.toString());
      List<NoteListModel> list = [];

      Map<String, dynamic> dataToReturn = {
        "list": list,
        "pagination": PaginationModel.fromJson(jsonData["meta"]["pagination"])
      };

      jsonData["data"].forEach((dynamic followUpNoteList) => {dataToReturn['list'].add(NoteListModel.fromJson(followUpNoteList))});
      return dataToReturn;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> deleteFollowUpsNote(int id) async {
    try {
      String url = '${Urls.followUpNote}/$id';

      final response = await dio.delete(url);
      final jsonData = json.decode(response.toString());
      return jsonData;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<NoteListModel> getfollowUpsNote(Map<String, dynamic> params) async {
    try {
      String url = '${Urls.followUpNote}/${params['id']}';

      final response = await dio.get(url, queryParameters: params);
      final jsonData = json.decode(response.toString());

      NoteListModel note = NoteListModel.fromJson(jsonData);
      return note;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

 Future<dynamic> addFollowUpsNote(Map<String, dynamic> params) async {
    try {
      final response = await dio.post(Urls.followUpNote, queryParameters: params);
      final jsonData = json.decode(response.toString());
      return jsonData["status"] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

   Future<dynamic> closeFollowUpsNote(Map<String, dynamic> params) async {
      try {
        final response = await dio.post(Urls.closeFollowUpNote, queryParameters: params);
        final jsonData = json.decode(response.toString());
        return jsonData["status"] == 200;
      } catch (e) {
        //Handle error
        rethrow;
      }
   }

   Future<dynamic> reopenFollowUpsNote(Map<String, dynamic> params) async {
      try {
        final response = await dio.post(Urls.reopenFollowUpNote, queryParameters: params);
        final jsonData = json.decode(response.toString());
        return jsonData["status"] == 200;
      } catch (e) {
        //Handle error
        rethrow;
      }
   }

}

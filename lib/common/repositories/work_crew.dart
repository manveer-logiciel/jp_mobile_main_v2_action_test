import 'dart:convert';
import 'package:jobprogress/common/models/note_list/note_listing.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';

class WorkCrewRepository {
  Future<NoteListModel> addWorkCrewNote(
      int id, Map<String, dynamic> editWorkCrewNoteParams) async {
    try {
      final response = await dio.put(Urls.workCrew(id.toString()), queryParameters: editWorkCrewNoteParams);
      final jsonData = json.decode(response.toString());

      NoteListModel note = NoteListModel.fromJson(jsonData);

      return note;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }
}

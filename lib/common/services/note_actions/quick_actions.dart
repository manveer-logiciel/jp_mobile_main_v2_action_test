import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/note_listing.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/note_list/note_listing.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/common/repositories/follow_ups_note.dart';
import 'package:jobprogress/common/repositories/job_note.dart';
import 'package:jobprogress/common/repositories/work_crew_notes_listing.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/note_details/index.dart';
import 'package:jp_mobile_flutter_ui/Icon/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';
import '../auth.dart';
class NoteService {

  static List<JPQuickActionModel> getQuickActionList(NoteListModel note, { String? actionFrom, NoteListingType? type }) {
    List<JPQuickActionModel> quickActionList = [
      if(type != NoteListingType.followUpNote) JPQuickActionModel(id: 'edit', child: const JPIcon(Icons.edit_outlined, size: 20), label: 'edit'.tr),
      JPQuickActionModel(id: 'view', child: const JPIcon(Icons.visibility_outlined, size: 20), label: 'view'.tr.capitalize.toString()),
      if((type == NoteListingType.workCrewNote || AuthService.isAdmin())) JPQuickActionModel(id: 'delete', child: const JPIcon(Icons.delete_outlined, size: 20), label: 'delete'.tr.capitalize.toString()),
    ];

    return quickActionList;
  }

  //Setting options and opening quick action bottom sheet
  static openQuickActions(NoteListModel note, Function(NoteListModel, String) callback, NoteListingType type, { String? actionFrom }) {
    List<JPQuickActionModel> quickActionList = getQuickActionList(note, actionFrom: actionFrom, type: type);

    showJPBottomSheet(
      child: (_) => JPQuickAction(
        mainList: quickActionList,
        onItemSelect: (value) {
          Get.back();
          handleQuickActions(value, note, callback, type);
        },
      ),
      isScrollControlled: true
    );
  }

  //Handling quick action tap
  static void handleQuickActions(String action, NoteListModel note, Function(NoteListModel, String) callback, NoteListingType type) async {
    switch (action) {
      case 'edit':
        editNote(note, callback);
        break;
      case 'view':
        callback(note, action);
        break;
      case 'delete':
        deleteNote(note, callback);
        break;
      default:
    }
  }

  //Deleting note
  static void deleteNote(NoteListModel note, Function(NoteListModel, String) callback) {
    callback(note, 'delete');
  }
  static void editNote(NoteListModel note, Function(NoteListModel, String) callback) {
    callback(note, 'edit');
  }


  //Opening note detail bottom sheet
  static openNoteDetail({
    int? id,
    NoteListModel? note,
    Function(NoteListModel, String)? callback,
    NoteListingType? type,
    JobModel? job
  }) async {
    if(note != null){
      showJPBottomSheet(child: (_) => NoteDetail(note: note, callback: callback, type: type!, job: job), isScrollControlled: true);
    } else if (id != null){
      showJPLoader();
      NoteListModel? note;

      Map<String, dynamic> params = {
        "includes[0]": ["created_by"],
        "includes[1]": ["stage"],
        "includes[2]": ["mentions"],
        "includes[3]": ["attachments"],
        'id': id
      };

      try {
        switch (type) {
          case NoteListingType.jobNote:
            note = await JobNoteListingRepository().getJobNote(params);
            break;
          case NoteListingType.workCrewNote:
            note = await WorkCrewNotesListingRepository().getWorkcrewNote(params);
            break;
          case NoteListingType.followUpNote:
            note = await FollowUpsNoteListingRepository().getfollowUpsNote(params);
            break;
          default:
            break;
        }
      } catch (e) {
        rethrow;
      } finally {
        Get.back();
      }

      showJPBottomSheet(child: (_) => NoteDetail(note: note!, callback: callback, type: type!), isScrollControlled: true);

    }
  }

  static getSuggestionsList(JobModel? job) {

    List<Map<String, dynamic>> data = [];

    List<UserLimitedModel?> suggestions = ([job?.customer?.rep]
        + (job?.estimators ?? [])
        + (job?.reps ?? [])
        + (job?.workCrew ?? [])
        + (job?.subContractors ?? [])).toSet().toList();

    for (UserLimitedModel? user in suggestions) {
      if((user == null || user.id < 1)) continue;
      if(data.any((element) => element['id'] == user.id.toString())) continue;
      data.add(user.toSuggestionJson());
    }

    data.sort((a, b) => a['display'].toString().toLowerCase().compareTo(b['display'].toString().toLowerCase()));

    return data;
  }

}
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/note_listing.dart';
import 'package:jobprogress/common/models/note_list/note_listing.dart';
import 'package:jobprogress/common/services/mixpanel/index.dart';
import 'package:jobprogress/core/constants/mix_panel/event/view_events.dart';

class NoteDetailController extends GetxController {

  late NoteListModel note;

  NoteListingType type;

  Function(NoteListModel, String)? callback;

  NoteDetailController(this.type);

  @override
  void onInit() {
    typeToEvent();
    super.onInit();
  }

  void typeToEvent() {
    switch (type) {
      case NoteListingType.workCrewNote:
        MixPanelService.trackEvent(event: MixPanelViewEvent.workCrewNoteDetailView);
        break;

      case NoteListingType.jobNote:
        MixPanelService.trackEvent(event: MixPanelViewEvent.jobNoteDetailView);
        break;

      case NoteListingType.followUpNote:
        MixPanelService.trackEvent(event: MixPanelViewEvent.followUpNoteDetailView);
        break;
    }
  }

  void handleQuickActionUpdate(NoteListModel updatedNote, String action) {
    switch (action) {
      case 'edit':
        break;

      case 'delete':
        Get.back();
        break;
      default:
    }
    
    callback!(updatedNote, action);
    update();
  }
}
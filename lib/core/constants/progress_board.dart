import 'package:get/get.dart';

import '../../common/enums/progressboard_listing.dart';

class PBConstants {

  static Map<String, String> followupLabels  = {
    'none': "none".tr,
    'markAsDone': "mark_as_done".tr,
    'date': "date".tr,
    'input_field': "add_note".tr,
  };

  static PBChooseOptionKey getPBChooseOptionKey(String pbChooseOptionKey) {
    switch(pbChooseOptionKey) {
      case "none":
        return PBChooseOptionKey.none;
      case "markAsDone":
        return PBChooseOptionKey.markAsDone;
      case "date":
        return PBChooseOptionKey.date;
      case "input_field":
        return PBChooseOptionKey.addNote;
      default:
        return PBChooseOptionKey.none;
    }
  }

  static String getPBChooseOptionConstants(PBChooseOptionKey pbChooseOptionKey) {
    switch(pbChooseOptionKey) {
      case PBChooseOptionKey.none:
        return "none";
      case PBChooseOptionKey.markAsDone:
        return "markAsDone";
      case PBChooseOptionKey.date:
        return "date";
      case PBChooseOptionKey.addNote:
        return "input_field";
    }
  }

  static String getPBChooseOptionLabel(PBChooseOptionKey pbChooseOptionKey) {
    return followupLabels.entries.firstWhere((element) => element.key == getPBChooseOptionConstants(pbChooseOptionKey)).value;
  }
}
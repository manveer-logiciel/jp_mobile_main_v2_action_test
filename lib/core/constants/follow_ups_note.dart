
import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

enum FollowUpsNotesKey  {
  call,
  undecided,
  lostJob,
  noActionRequired,
  completed,
}

class FollowUpsNotesConstants {

  static const String completed = 'completed';
  
  static Map<String, String> followupLabels  = {
    'call': "Follow-up",
    'undecided': "Undecided",
    'lost_job': "Lost Job",
    'no_action_required': "No Action Required",
    'completed': "Follow up Closed",
  };

  static Map<String, Color> followupLabelColors  = {
    'call': JPAppTheme.themeColors.success,
    'undecided': JPAppTheme.themeColors.warning,
    'lost_job': JPAppTheme.themeColors.red,
    'no_action_required': JPAppTheme.themeColors.purple,
    'completed': JPAppTheme.themeColors.red,
  };

  static FollowUpsNotesKey getFollowUpsNotesKey(String followUpsNotesKey) {
    switch(followUpsNotesKey) {
      case "call":
        return FollowUpsNotesKey.call;
      case "undecided":
        return FollowUpsNotesKey.undecided;
      case "lost_job":
        return FollowUpsNotesKey.lostJob;
      case "no_action_required":
        return FollowUpsNotesKey.noActionRequired;
      case "completed":
        return FollowUpsNotesKey.completed;
      default:
        return FollowUpsNotesKey.call;
    }
  }

  static String getFollowUpsNotesConstants(FollowUpsNotesKey followUpsNotesKey) {
    switch(followUpsNotesKey) {
      case FollowUpsNotesKey.call:
        return "call";
      case FollowUpsNotesKey.undecided:
        return "undecided";
      case FollowUpsNotesKey.lostJob:
        return "lost_job";
      case FollowUpsNotesKey.noActionRequired:
        return "no_action_required";
      case FollowUpsNotesKey.completed:
        return "completed";
    }
  }

  static String getFollowupLabels(FollowUpsNotesKey followUpsNotesKey) {
    return followupLabels.entries.firstWhere((element) => element.key == getFollowUpsNotesConstants(followUpsNotesKey)).value;
  }

  static Color getFollowupLabelColors(FollowUpsNotesKey followUpsNotesKey) {
    return followupLabelColors.entries.firstWhere((element) => element.key == getFollowUpsNotesConstants(followUpsNotesKey)).value;
  }
}

import 'package:get/get.dart';
import 'package:jobprogress/common/models/popover_action.dart';
import 'package:jobprogress/core/constants/phases_visibility.dart';

class ScheduleDetailsActions {
  static getActions() {
    List<PopoverActionModel> actions = [
      if(PhasesVisibility.canShowSecondPhase)... {
         PopoverActionModel(label: 'duplicate'.tr.capitalizeFirst!, value: 'duplicate'),
         PopoverActionModel(label: 'edit'.tr.capitalizeFirst!, value: 'edit'),
       },
      PopoverActionModel(label: 'delete'.tr.capitalizeFirst!, value: 'deletes'),
    ];

    return actions;
  }
}

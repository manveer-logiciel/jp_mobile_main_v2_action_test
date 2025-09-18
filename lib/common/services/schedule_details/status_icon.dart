import 'package:jobprogress/common/models/popover_action.dart';

class ScheduleStatusActions {
  static getActions() {
    List<PopoverActionModel> actions = [
      PopoverActionModel(label: 'Confirm', value: 'confirm'),
      PopoverActionModel(label: 'Decline', value: 'decline'),
      PopoverActionModel(label: 'Pending', value: 'pending'),
    ];

    return actions;
  }
}

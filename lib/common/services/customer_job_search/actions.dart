import 'package:get/get.dart';

import '../../models/popover_action.dart';

class CustomerJobSearchActions {

  static getActions(bool isJobSelected) {
    List<PopoverActionModel> actions = [
      PopoverActionModel(label: 'job'.tr, value: 'job', isSelected: isJobSelected),
      PopoverActionModel(label: 'customer'.tr, value: 'customer', isSelected: !isJobSelected),
    ];
    return actions;
  }
}
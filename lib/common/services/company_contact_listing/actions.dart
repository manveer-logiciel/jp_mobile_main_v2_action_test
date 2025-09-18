import 'package:get/get.dart';
import 'package:jobprogress/common/models/popover_action.dart';
import 'package:jobprogress/common/models/sql/tag/tag.dart';

class CompanyContactListingActions {
  
  static getActions(bool isMultiSelectionOn, TagModel? tag) {
    List<PopoverActionModel> actions = [
      if(!isMultiSelectionOn && tag != null && (tag.counts == null || (tag.counts != null && tag.counts!.companyContactCount == 0)))
        PopoverActionModel(label: 'delete_group'.tr, value: 'delete_group'),
      
      if(isMultiSelectionOn) PopoverActionModel(label: 'delete_contacts'.tr, value: 'delete_contacts'),
      
      if(isMultiSelectionOn && tag == null) PopoverActionModel(label: 'add_to_group'.tr, value: 'add_to_group'),
      
      if(isMultiSelectionOn && tag != null) PopoverActionModel(label: 'remove_from_group'.tr, value: 'remove_from_group'),
      
      if(!isMultiSelectionOn) PopoverActionModel(label: 'rename_group'.tr, value: 'rename_group'),
    ];

    return actions;
  }
}
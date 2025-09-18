import 'package:get/get.dart';
import 'package:jobprogress/common/models/custom_fields/custom_fields.dart';
import 'package:jobprogress/common/models/custom_fields/custom_form_fields/options.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

/// [CustomFormFieldsModel] provides form data for custom fields form
class CustomFormFieldsModel {

  late int id;
  late bool isTextField;
  late bool isUserField;
  late bool isDropdown;
  late bool active;
  late JPInputBoxController controller;
  late int dropDownOptionsLength;
  String? modelType;
  String? name;
  String? description;
  String? defaultValue;
  bool? isRequired;
  List<CustomFormFieldOption>? options;
  List<JPMultiSelectModel>? usersList;
  List<UserLimitedModel>? defaultuserList;

  CustomFormFieldsModel({
    required this.id,
    this.modelType,
    this.isRequired,
    this.name,
    this.description,
    this.defaultValue,
    this.isTextField = true,
    this.isUserField = false,
    this.isDropdown = false,
    this.usersList,
    this.options,
    required this.controller,
    this.dropDownOptionsLength = 1,
    this.defaultuserList,
    this.active = true
  });

  CustomFormFieldsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    active = Helper.isTrue(json['active']);
    modelType = json['model_type'];
    isRequired = Helper.isTrue(json['required']);
    name = json['name'];
    description = json['description'];
    defaultValue = json['default_value'];
    isTextField = json['type'] == 'text';
    isUserField = json['type'] == 'user';
    isDropdown = json['type'] == 'dropdown';
    if(json['options']?['data']?.isNotEmpty ?? false) {
      options = [];
      json['options']?['data']?.forEach((dynamic option) {
        options?.add(CustomFormFieldOption.fromJson(option));
      });
    }
    dropDownOptionsLength = 1;
    controller = JPInputBoxController(text: defaultValue ?? "");
  }

  CustomFormFieldsModel.fromCustomFieldsModel(CustomFieldsModel model) {
    id = model.id!;
    active = Helper.isTrue(model.active);
    modelType = model.type;
    isRequired = Helper.isTrue(model.requiredData);
    name = model.name;
    defaultValue = model.value;
    isTextField = model.type == 'text';
    isUserField = model.type == 'user';
    isDropdown = model.type == 'dropdown';
    if(!Helper.isValueNullOrEmpty(model.options)) {
      options = [];
      model.options?.forEach((CustomFieldsModel? option) {
        options?.add(CustomFormFieldOption.fromCustomFieldModel(option));
      });
    }
    dropDownOptionsLength = 1;
    controller = JPInputBoxController(text: defaultValue ?? "");
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};

    if (isTextField) {
      if(controller.text.isNotEmpty) {
        data["type"] = 'text';
        data["custom_field_id"] = id;
        data["value"] = controller.text;
      }
    }
    else if(isUserField) {
      List<String>? userIds = usersList?.where((element) => element.isSelect).map((e) => e.id).toList() ?? [];
      
      if(!Helper.isValueNullOrEmpty(userIds)) {
        data['type'] = 'user';
        data['custom_field_id'] = id;
        Map<String, dynamic> userMap = {};
        for(int i = 0; i < userIds.length; i++) {
          userMap['$i'] = userIds[i];
        }
        data['user_ids'] = userMap;
      }
    }
    else if(isDropdown) {
      List<Map<String, dynamic>> tempOptions = [];
      for (int i = 0; i < dropDownOptionsLength; i++) {
        final optionJson = options![i].toJson();
        if (optionJson.containsKey('sub_options')) {
          tempOptions.add(optionJson);
        }
      }
      if (tempOptions.isNotEmpty) {
        data["type"] = "dropdown";
        data["custom_field_id"] = id;
        data["options"] = tempOptions;
      }
    }

    return data;
  }

  /// [fromCustomFieldModel] helps in setting up initial form data
  /// by filling up the fields
  void fromCustomFieldModel(CustomFieldsModel data) {
    isTextField = data.type == 'text';
    isUserField = data.type == 'user';
    isDropdown = data.type == 'dropdown';
    if(isTextField) {
      // setting up text data
      controller.text = data.value ?? "";
    } else if(isDropdown) {
      // setting up dropdown data
      if (data.options?.isNotEmpty ?? false) {

        dropDownOptionsLength = data.options!.length;
        for(int i = 0; i < (options ?? []).length; i++) {
          CustomFieldsModel? formOption = data.options?.firstWhereOrNull((formOption) => formOption?.id == options?[i].id);
          if(options?[i] == null || formOption == null) continue;
          options?[i] = CustomFormFieldOption.fromCustomFieldModel(formOption);
        }
        // setting number of dropdowns to be displayed
        setDropdownDisplayOptionsLength();
      }
    }
  }

  /// [setDropdownDisplayOptionsLength] helps in deciding and updating number
  /// of dropdowns to be displayed to select option from
  void setDropdownDisplayOptionsLength() {
    // setting up start value
    dropDownOptionsLength = 1;
    // scanning options to determine display dropdowns
    for(int index = 0; index < (options?.length ?? 0); index++) {
      if (options![index].selectedItems.isNotEmpty) {
        if (dropDownOptionsLength < options!.length) {
          dropDownOptionsLength++;
        }
      }
    }

    for (int index = 0; index < (options?.length ?? 0); index++) {
      if ((index + 1) < options!.length) {
        final selectedItems = options![index].selectedItems;

        List<int> temp = selectedItems.map((element) => int.parse(element.id)).toList();

        options![index + 1].linkedOptions = temp;

        final difference = options![index + 1].items
            .where((item) => !temp.any((element) => item.additionData?.contains(element) ?? false))
            .map((item) => item.additionData).expand((ids) => ids ?? []) // Flatten the list of lists into a single list, handling null
            .toList();
        options![index + 1].items.removeWhere((element) => element.additionData?.any((int? id) => difference.contains(id)) ?? false);
      }
    }
  }

  /// [checkAndRemoveDropdowns] verifies if there is no selection in
  /// parent field then removes all of it's child fields
  void checkAndRemoveDropdowns(int index) {
    // if no selected items are there then simply return
    // otherwise remove all the child items
    removeDropdownItems(index);
    setDropdownDisplayOptionsLength();
  }

  void removeDropdownItems(int index) {
    if (options![index].selectedItems.isEmpty) {
      for (int i = index; i < options!.length; i++) {
        options![i].items = [];
        options![i].linkedOptions = [];
      }
      return;
    }

    final removeItemsIds = options?.skip(index).expand(
      (field) => field.items.where(
        (element) => !element.isSelect).map(
          (element) => int.parse(element.id))).toList() ?? [];

    if (index < 2 && index + 1 < (options?.length ?? 0)) {
      final temp = options?[index + 1].items.where((element) {
        return element.additionData?.every((int? id) => removeItemsIds.contains(id)) ?? false;
      }).map((element) => int.parse(element.id)).toList();
      options?[index + 1].items.removeWhere((element) => element.additionData?.every((int? id) => removeItemsIds.contains(id)) ?? false);

      if (index < 1 && index + 2 < (options?.length ?? 0)) {
        options![index + 2].items.removeWhere(
        (element) => (element.additionData?.every((int? id) => temp?.contains(id) ?? false) ?? false)
        );
      }
    }
  }
}

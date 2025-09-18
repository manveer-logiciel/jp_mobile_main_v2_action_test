import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/network_multiselect.dart';
import 'package:jobprogress/common/models/custom_fields/custom_form_fields/index.dart';
import 'package:jobprogress/common/models/custom_fields/custom_form_fields/options.dart';
import 'package:jobprogress/common/services/forms/value_selector.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/network_multiselect/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/Theme/form_ui_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class CustomFieldFormController extends GetxController {
  CustomFieldFormController(this.fields);

  List<CustomFormFieldsModel> fields; // holds list of fields to be displayed

  FormUiHelper uiHelper = FormUiHelper(); // helps in manging ui

  final formKey = GlobalKey<FormState>(); // used to validate form

  bool isSectionExpanded = false; // maintains expansion state of section
  bool validateFormOnDataChange = false; // helps in continuous validation after user submits form

  // selectSubOptions(): opens up network multiselect to select options
  Future<void> selectSubOptions(
      CustomFormFieldsModel field, CustomFormFieldOption option, int index) async {
    // additional params
    final params = {
      "active": 1,
      "includes[]": "linked_parent_options",
      'field_id': field.id,
      'option_id': option.id,
    };

    if (option.linkedOptions?.isNotEmpty ?? false) {
      for(int i = 0; i < (option.linkedOptions?.length ?? 0) ; i++) {
        params.addEntries({"linked_options[$i]" : option.linkedOptions![i]}.entries);
      }
    }

    showJPBottomSheet(
        child: (_) => JPNetworkMultiSelect(
              title: "${'select'.tr} ${option.name}",
              additionalParams: params,
              inputHintText: 'search_here'.tr,
              type: JPNetworkMultiSelectType.customFieldSubOptions,
              selectedItems: option.selectedItems,
              onDone: (list) {
                option.items = list;
                field.setDropdownDisplayOptionsLength();
                if (list.isEmpty) field.checkAndRemoveDropdowns(index);
                onValueChanged("");
                update();
              },
            ),
        ignoreSafeArea: false,
        isScrollControlled: true);
  }

  // onAllItemsRemoved(): checks if all items from parent fields are removed
  //                      then removes all of it's child fields also
  void onAllItemsRemoved(CustomFormFieldsModel field, int index) {
    field.checkAndRemoveDropdowns(index);
    onValueChanged("");
    update();
  }

  void onRemoveUser(CustomFormFieldsModel field) {
    if(field.usersList?.every((element) => !element.isSelect) ?? true){
      field.controller.text = "";
    }
    onValueChanged("");
    update();
  }

  // validateForm(): validates form
  bool validateForm({bool scrollOnValidate = true}) {
    validateFormOnDataChange = true;

    bool validationFailed = formKey.currentState?.validate() ?? false;
    if (!validationFailed && scrollOnValidate) {
      scrollToErrorField();
    }
    return !validationFailed;
  }

  void selectUsers(List<JPMultiSelectModel> userList, JPInputBoxController controller) {
    FormValueSelectorService.openMultiSelect(
      title: 'select_users'.tr,
      list: userList,
      controller: controller,
      onSelectionDone: () {
        onValueChanged("");
        update();
      }
    );
  }

  // scrollToErrorField(): in case validation is failed scrolls and focuses that error fields
  Future<void> scrollToErrorField() async {
    await expandSection(); // expanding section if closed

    bool validationFailed = false;

    for (var field in fields) {
      if (!field.isRequired!) continue;

      if (field.options?.isNotEmpty ?? false) {
        // validating drop-down
        validationFailed = validateOptions(field.options ?? []);
      } else {
        // validating text field
        validationFailed =
            FormValidator.requiredFieldValidator(field.controller.text) != null;
        if (validationFailed) field.controller.scrollAndFocus();
      }

      if (validationFailed) break;
    }
  }

  // expandSection(): expands section on validation failed
  Future<void> expandSection() async {
    // if section is already is expanded, no need to expand it again
    if (isSectionExpanded) return;

    isSectionExpanded = true;
    update();
    // additional delay for section to get expanded before focusing error field
    await Future<void>.delayed(const Duration(milliseconds: 300));
  }

  // validateOptions(): helps in validating drop-down fields
  bool validateOptions(List<CustomFormFieldOption> options) {
    bool validationFailed = false;
    for (CustomFormFieldOption option in options) {
      validationFailed =
          FormValidator.requiredDropDownValidator(option.selectedItems) != null;
      if (validationFailed) {
        option.controller.scrollAndFocus();
        break;
      }
    }
    return validationFailed;
  }

  // onSectionExpansionChanged(): manages expansion state of section
  void onSectionExpansionChanged(bool val) {
    isSectionExpanded = val;
  }

  // onValueChanged(): validate data on the go
  void onValueChanged(String val) {
    if (validateFormOnDataChange) {
      formKey.currentState?.validate();
    }
  }
}

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/forms/worksheet/add_item_params.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/common/services/files_listing/forms/worksheet_form/add_item.dart';
import 'package:jp_mobile_flutter_ui/Theme/form_ui_helper.dart';

class WorksheetAddItemController extends GetxController {

  WorksheetAddItemController(this.params, this.onSave);

  /// [params] hold the data coming from parent widget
  final WorksheetAddItemParams params;

  /// [onSave] a callback to parent when data item is saved
  final Function(SheetLineItemModel) onSave;

  String get title {
    if (params.lineItem != null) {
      return "update_item".tr;
    }
    return "add_item".tr;
  }

  String get saveButtonText {
    if (params.lineItem != null) {
      return "update".tr;
    }
    return "save".tr;
  }

  FormUiHelper formUiHelper = FormUiHelper();

  final formKey = GlobalKey<FormState>();

  late WorksheetAddItemService service;

  bool validateFormOnDataChange = false; // helps in continuous validation after user submits form

  @override
  void onInit() {
    service = WorksheetAddItemService(
      update: update,
      params: params,
      validateForm: () => onDataChanged("")
    );
    service.initService();
    super.onInit();
  }

  // onDataChanged() : will validate form as soon as data in input field changes
  void onDataChanged(dynamic val) {
    // realtime changes will take place only once after user tried to submit form
    if (validateFormOnDataChange) {
      validateForm();
    }
  }

  // validateForm(): validates form and returns result
  bool validateForm() {
    bool isValid = formKey.currentState?.validate() ?? false;
    return isValid;
  }

  /// [onTapSave] - validates the form and returns the line items data to
  /// parent widget
  void onTapSave() {
    validateFormOnDataChange = true;
    bool isValid = validateForm();
    if (!isValid) {
      service.scrollAndFocus();
      return;
    }
    final lineItem = service.toLineItem();
    onSave.call(lineItem);
  }

}
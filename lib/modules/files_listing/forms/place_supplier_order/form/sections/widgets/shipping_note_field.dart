import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:jobprogress/common/enums/supplier_form_type.dart';
import 'package:jobprogress/common/models/forms/common/params.dart';
import 'package:jobprogress/common/services/files_listing/forms/place_srs_order_form/index.dart';
import 'package:jobprogress/modules/files_listing/forms/place_supplier_order/controller.dart';
import 'package:jp_mobile_flutter_ui/InputBox/index.dart';
import 'package:jp_mobile_flutter_ui/InputBox/type.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';

class ShippingNoteField extends StatelessWidget {
  const ShippingNoteField({super.key, required this.controller, required this.field});

  final PlaceSupplierOrderFormController controller;
  final InputFieldParams field;

  PlaceSupplierOrderFormService get service => controller.service;

  String get noteText => service.type == MaterialSupplierType.srs ? 'note_for_srs_branch'.tr : field.name;

  @override
  Widget build(BuildContext context) {
    return JPInputBox(
      inputBoxController: service.noteController,
      type: JPInputBoxType.withLabel,
      hintText: 'shopping_note_hint_text'.tr,
      label: noteText,
      maxLines: 5,
      fillColor: JPAppTheme.themeColors.base,
      disabled: !service.isFieldEditable(),       
    );
  }
}
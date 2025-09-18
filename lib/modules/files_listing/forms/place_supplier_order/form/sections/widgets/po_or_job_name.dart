import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/forms/common/params.dart';
import 'package:jobprogress/common/services/files_listing/forms/place_srs_order_form/index.dart';
import 'package:jobprogress/modules/files_listing/forms/place_supplier_order/controller.dart';
import 'package:jp_mobile_flutter_ui/InputBox/index.dart';
import 'package:jp_mobile_flutter_ui/InputBox/type.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';

class PoOrJobNameField extends StatelessWidget {
  const PoOrJobNameField({super.key, required this.controller, required this.field});

  final PlaceSupplierOrderFormController controller;
  final InputFieldParams field;

  PlaceSupplierOrderFormService get service => controller.service;

  @override
  Widget build(BuildContext context) {
    return JPInputBox(
      inputBoxController: service.poJobNameController,
      type: JPInputBoxType.withLabel,
      label: field.name,
      fillColor: JPAppTheme.themeColors.base,
      isRequired: true,
      onChanged: service.onDataChange,
      validator: service.poJobNameValidator,
      maxLength: 22,
      disabled: !service.isFieldEditable(),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/forms/common/params.dart';
import 'package:jobprogress/common/services/files_listing/forms/place_srs_order_form/index.dart';
import 'package:jobprogress/modules/files_listing/forms/place_supplier_order/controller.dart';
import 'package:jp_mobile_flutter_ui/InputBox/index.dart';
import 'package:jp_mobile_flutter_ui/InputBox/type.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';

class TimezoneField extends StatelessWidget {
  const TimezoneField({super.key, required this.controller, required this.field});

  final PlaceSupplierOrderFormController controller;
  final InputFieldParams field;

  PlaceSupplierOrderFormService get service => controller.service;

  @override
  Widget build(BuildContext context) {
    return JPInputBox(
      inputBoxController: service.timeZoneController,
      type: JPInputBoxType.withLabel,
      label: field.name,
      fillColor: JPAppTheme.themeColors.base,
      isRequired: field.isRequired,
      onPressed: service.selectTimeZone,
      disabled: !service.isFieldEditable(),
      readOnly: true,
      suffixChild: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Icon(Icons.keyboard_arrow_down_outlined,color: JPAppTheme.themeColors.text),
      ),
      validator: field.isRequired ? service.fieldValidator : null,
      onChanged: field.onDataChange,
    );
  }
}
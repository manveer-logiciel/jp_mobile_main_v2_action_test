import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/forms/common/params.dart';
import 'package:jobprogress/common/services/files_listing/forms/place_srs_order_form/index.dart';
import 'package:jobprogress/modules/files_listing/forms/place_supplier_order/controller.dart';
import 'package:jp_mobile_flutter_ui/InputBox/index.dart';
import 'package:jp_mobile_flutter_ui/InputBox/type.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';

import '../../../../../../../common/enums/supplier_form_type.dart';

class MaterialDeliveryNoteField extends StatelessWidget {
  const MaterialDeliveryNoteField({super.key, required this.controller, required this.field});

  final PlaceSupplierOrderFormController controller;
  final InputFieldParams field;

  PlaceSupplierOrderFormService get service => controller.service;

  String get noteText => service.type == MaterialSupplierType.srs ? 'note_for_internal_reference'.tr : field.name;

  @override
  Widget build(BuildContext context) {
    return JPInputBox(
      inputBoxController: service.materialDeliveryNoteController,
      type: JPInputBoxType.withLabel,
      label: noteText,
      fillColor: JPAppTheme.themeColors.base,
      maxLines: 5,
      disabled: true,         
      readOnly: true,
    );
  }
}
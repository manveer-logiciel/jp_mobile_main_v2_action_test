import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:jobprogress/common/enums/supplier_form_type.dart';
import 'package:jobprogress/common/models/forms/common/params.dart';
import 'package:jobprogress/common/services/files_listing/forms/place_srs_order_form/index.dart';
import 'package:jobprogress/modules/files_listing/forms/place_supplier_order/controller.dart';
import 'package:jp_mobile_flutter_ui/CheckBox/index.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/font_weight.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/text_size.dart';
import 'package:jp_mobile_flutter_ui/InputBox/index.dart';
import 'package:jp_mobile_flutter_ui/InputBox/type.dart';
import 'package:jp_mobile_flutter_ui/Text/index.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';

class MaterialDeliveryDateField extends StatelessWidget {
  const MaterialDeliveryDateField({super.key, required this.controller, required this.field});

  final PlaceSupplierOrderFormController controller;
  final InputFieldParams field;

  PlaceSupplierOrderFormService get service => controller.service;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        JPText(
          text: getLabel(),
          textAlign: TextAlign.left, 
          textSize: JPTextSize.heading4, 
          fontWeight: JPFontWeight.bold,
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: JPInputBox(
                inputBoxController: service.materialDeliveryDateController,
                type: JPInputBoxType.withLabel,
                label: field.name,
                fillColor: JPAppTheme.themeColors.base,
                disabled: !service.isFieldEditable() || (service.isSrsDeliveryMethod && service.isDateTBDChecked),
                onPressed: service.onTapMaterialDate,
                readOnly: true,
                isRequired: field.isRequired,
                suffixChild: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                  child: Icon(Icons.date_range_outlined, size: 25, color: JPAppTheme.themeColors.tertiary),
                ),
                validator: service.materialDeliveryDateValidator,
                onChanged: field.onDataChange,
              ),
            ),

            if(service.isSrsDeliveryMethod && service.isSrsV2)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: JPCheckbox(
                  selected: service.isDateTBDChecked,
                  padding: EdgeInsets.zero,
                  text: 'date_tbd'.tr,
                  onTap: service.onTapTBDDate,
                ),
              )
          ],
        )
      ],
    );
  }

  String getLabel() {
    if(service.type == MaterialSupplierType.srs) {
      return 'requested_delivery_pickup_date'.tr;
    } else {
      return 'requested_delivery_date'.tr;
    }
  }
}
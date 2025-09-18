import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:jobprogress/common/models/forms/common/params.dart';
import 'package:jobprogress/common/services/files_listing/forms/place_srs_order_form/index.dart';
import 'package:jobprogress/modules/files_listing/forms/place_supplier_order/controller.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/font_weight.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/text_size.dart';
import 'package:jp_mobile_flutter_ui/RadioBox/index.dart';
import 'package:jp_mobile_flutter_ui/RadioBox/radio_data.dart';
import 'package:jp_mobile_flutter_ui/Text/index.dart';

class ShippingMethodField extends StatelessWidget {
  const ShippingMethodField({super.key, required this.controller, required this.field});

  final PlaceSupplierOrderFormController controller;
  final InputFieldParams field;

  PlaceSupplierOrderFormService get service => controller.service;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        JPText(
          text: field.name, 
          textAlign: TextAlign.left, 
          textSize: JPTextSize.heading4, 
          fontWeight: JPFontWeight.bold,
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            JPRadioBox(
              groupValue: service.isDeliveryMethod,
              onChanged: service.changeShippingMethod,
              isTextClickable: true,
              radioData: [
                JPRadioData(
                  value: true,
                  label: 'delivery'.tr,
                  disabled: !service.isFieldEditable(),
                ),
              ],
            ),
            const SizedBox(width: 50),
            JPRadioBox(
              groupValue: service.isDeliveryMethod,
              onChanged: service.changeShippingMethod,
              isTextClickable: true,
              radioData: [
                JPRadioData(
                  value: false,
                  label: 'pickup'.tr,
                  disabled: !service.isFieldEditable(),
                )
              ],
            ),
          ],
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:jobprogress/common/models/forms/common/params.dart';
import 'package:jobprogress/common/services/files_listing/forms/place_srs_order_form/index.dart';
import 'package:jobprogress/core/constants/delivery_service_constant.dart';
import 'package:jobprogress/modules/files_listing/forms/place_supplier_order/controller.dart';
import 'package:jp_mobile_flutter_ui/CheckBox/index.dart';
import 'package:jp_mobile_flutter_ui/InputBox/index.dart';
import 'package:jp_mobile_flutter_ui/InputBox/type.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';

class RequestedDeliveryDateField extends StatelessWidget {
  const RequestedDeliveryDateField({super.key, required this.controller, required this.field});

  final PlaceSupplierOrderFormController controller;
  final InputFieldParams field;

  PlaceSupplierOrderFormService get service => controller.service;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: JPInputBox(
            inputBoxController: service.materialDeliveryDateController,
            type: JPInputBoxType.withLabel,
            label: getLabel(),
            fillColor: JPAppTheme.themeColors.base,
            disabled: !service.isFieldEditable() || service.isDateTBDChecked,
            onPressed: service.onTapMaterialDate,
            readOnly: true,
            isRequired: !service.isDateTBDChecked && field.isRequired,
            suffixChild: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
              child: Icon(Icons.date_range_outlined, size: 25, color: JPAppTheme.themeColors.tertiary),
            ),
            validator: service.materialDeliveryDateValidator,
            onChanged: field.onDataChange,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: JPCheckbox(
            selected: service.isDateTBDChecked,
            padding: EdgeInsets.zero,
            text: 'date_tbd'.tr,
            onTap: service.onTapTBDDate,
          ),
        ),
      ],
    );
  }

  String getLabel() {
    if(service.selectedDeliveryService?.id == DeliveryServiceConstant.willCallCode) {
      return 'requested_will_call_date'.tr;
    } else if(service.selectedDeliveryService?.id == DeliveryServiceConstant.expressPickupCode) {
      return 'requested_express_pickup_date'.tr;
    } else {
      return 'requested_delivery_date'.tr;
    }
  }
}
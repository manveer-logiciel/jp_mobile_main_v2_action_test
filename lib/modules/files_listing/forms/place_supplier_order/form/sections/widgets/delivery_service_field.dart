import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/forms/common/params.dart';
import 'package:jobprogress/common/services/files_listing/forms/place_srs_order_form/index.dart';
import 'package:jobprogress/core/constants/delivery_service_constant.dart';
import 'package:jobprogress/modules/files_listing/forms/place_supplier_order/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class DeliveryServiceField extends StatelessWidget {
  const DeliveryServiceField({super.key, required this.controller, required this.field});

  final PlaceSupplierOrderFormController controller;
  final InputFieldParams field;

  PlaceSupplierOrderFormService get service => controller.service;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: service.deliveryServiceList.map((deliveryService) =>
            JPRadioBox(
              groupValue: service.selectedDeliveryService,
              radioData: [
                JPRadioData(
                  value: deliveryService,
                  label: getLabel(deliveryService.id),
                  disabled: !service.isFieldEditable(),
                )
              ],
              onChanged: service.onDeliveryServiceChange,
            )
        ).toList(),
      ),
    );
  }

  String getLabel(String? deliveryServiceCode) {
    if(deliveryServiceCode == DeliveryServiceConstant.deliveryCode) {
      return 'delivery'.tr;
    } else if(deliveryServiceCode == DeliveryServiceConstant.willCallCode) {
      return 'will_call'.tr;
    } else {
      return 'express_pickup'.tr;
    }
  }
}
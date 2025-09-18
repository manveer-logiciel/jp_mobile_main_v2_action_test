import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/supplier_form_type.dart';
import 'package:jobprogress/common/models/forms/common/params.dart';
import 'package:jobprogress/common/services/files_listing/forms/place_srs_order_form/index.dart';
import 'package:jobprogress/core/constants/delivery_service_constant.dart';
import 'package:jobprogress/modules/files_listing/forms/place_supplier_order/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../../../../common/enums/date_picker_type.dart';
import '../../../../../../../core/constants/date_formats.dart';
import '../../../../../../../core/utils/date_time_helpers.dart';

class RequestedDeliveryTimeDropDownField extends StatelessWidget {
  const RequestedDeliveryTimeDropDownField({super.key, required this.controller, required this.field});

  final PlaceSupplierOrderFormController controller;
  final InputFieldParams field;

  PlaceSupplierOrderFormService get service => controller.service;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: service.type == MaterialSupplierType.abc || service.isDeliveryMethod,
      child: Container(
        decoration: service.isTimeRangeOrSpecificTimeType ? BoxDecoration(
          border: Border.all(
              color: (service.deliveryTimeErrorText?.isNotEmpty ?? false) ? JPAppTheme.themeColors.red : JPAppTheme.themeColors.dimGray,
              width: 1
          ),
          borderRadius: BorderRadius.circular(8),
        ) : null,
        padding: service.isTimeRangeOrSpecificTimeType ? EdgeInsets.all(controller.formUiHelper.suffixPadding) : EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            JPInputBox(
              inputBoxController: service.requestedDeliveryTimeController,
              type: JPInputBoxType.withLabel,
              label: getLabel(),
              fillColor: JPAppTheme.themeColors.base,
              isRequired: field.isRequired,
              onPressed: service.selectRequestedDeliveryTime,
              disabled: !service.isFieldEditable(),
              readOnly: true,
              suffixChild: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Icon(Icons.keyboard_arrow_down_outlined,color: JPAppTheme.themeColors.text),
              ),
              validator: service.requestedDeliveryTimeValidator,
              onChanged: field.onDataChange,
            ),

            if (service.isTimeRangeOrSpecificTimeType)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: service.isSpecificTimeType
                    ? timeField(
                    title: 'enter_preferred_time'.tr.capitalize!,
                    time: service.startDateTime,
                    onPressed: () => service.openTimePicker(datePickerType: DatePickerType.start, initialTime: service.startDateTime)
                ) : Column(
                  children: [
                    timeField(
                        title: 'start_time'.tr.capitalize!,
                        time: service.startDateTime,
                        onPressed: () => service.openTimePicker(datePickerType: DatePickerType.start, initialTime: service.startDateTime)
                    ),
                    const SizedBox(height: 10),
                    timeField(
                      title: 'end_time'.tr.capitalize!,
                      time: service.endDateTime,
                      onPressed: () => service.openTimePicker(datePickerType: DatePickerType.end, initialTime: service.endDateTime),
                    ),
                  ],
                ),
              ),

            Visibility(
              visible: service.deliveryTimeErrorText?.isNotEmpty ?? false,
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: JPText(
                  text: service.deliveryTimeErrorText ?? "",
                  textSize: JPTextSize.heading5,
                  textColor: JPAppTheme.themeColors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getLabel() {
    if(service.selectedDeliveryService == null || service.selectedDeliveryService?.id == DeliveryServiceConstant.deliveryCode) {
      return 'requested_delivery_time'.tr;
    } else if(service.selectedDeliveryService?.id == DeliveryServiceConstant.willCallCode) {
      return 'requested_will_call_time'.tr;
    } else {
      return 'requested_express_pickup_time'.tr;
    }
  }

  Widget timeField({required String title, required String? time, required void Function()? onPressed}) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 17),
          child: JPText(
            text: title,
            textSize: JPTextSize.heading4,
            textColor: JPAppTheme.themeColors.text,
          ),
        ),
        const SizedBox(width: 5),
        JPButton(
          onPressed: onPressed,
          disabled: !service.isFieldEditable(),
          size: JPButtonSize.datePickerButton,
          colorType: JPButtonColorType.lightGray,
          text: DateTimeHelper.format(time, DateFormatConstants.timeOnlyFormat),
          textSize: JPTextSize.heading4,
          textColor: JPAppTheme.themeColors.text,
          iconWidget: JPIcon(
            Icons.schedule_outlined,
            color: JPAppTheme.themeColors.darkGray,
            size: 18,
          ),
        ),
      ],
    );
  }
}
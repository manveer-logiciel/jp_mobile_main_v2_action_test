
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/date_picker_type.dart';
import 'package:jobprogress/common/models/forms/common/params.dart';
import 'package:jobprogress/common/services/files_listing/forms/place_srs_order_form/index.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/modules/files_listing/forms/place_supplier_order/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class RequestDeliveryTimeField extends StatelessWidget {
  const RequestDeliveryTimeField({super.key, required this.controller, required this.field});

  final PlaceSupplierOrderFormController controller;
  final InputFieldParams field;

  PlaceSupplierOrderFormService get service => controller.service;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: (service.deliveryTimeErrorText?.isNotEmpty ?? false) ? JPAppTheme.themeColors.red : JPAppTheme.themeColors.dimGray,
          width: 1
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(controller.formUiHelper.suffixPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              JPText(
                text: field.name,
                textSize: JPTextSize.heading4,
                textColor: JPAppTheme.themeColors.text,
              ),
              JPToggle(
                value: service.isDeliveryTimeEnable,
                disabled: !service.isFieldEditable(),
                onToggle: service.toggleIsDeliveryTime,
              ),
            ],
          ),
    
          if (service.isDeliveryTimeEnable) 
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                children:[
                  Column(
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
    );
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

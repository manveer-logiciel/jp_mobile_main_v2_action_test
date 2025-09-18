import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/supplier_form_type.dart';
import 'package:jobprogress/common/services/files_listing/forms/place_srs_order_form/index.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/modules/files_listing/forms/place_supplier_order/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class PlaceSrsOrderCompanyContactSection extends StatelessWidget {
  const PlaceSrsOrderCompanyContactSection({
    super.key,
    required this.controller
  });

  final PlaceSupplierOrderFormController controller;

  PlaceSupplierOrderFormService get service => controller.service;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: JPAppTheme.themeColors.inverse.withValues(alpha: 0.3),
              border: Helper.isValueNullOrEmpty(service.companyContactErrorText) ? null : Border.all(
                  color: JPAppTheme.themeColors.red,
                  width: 1
              )
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: JPText(
                        text: service.name,
                        fontWeight: JPFontWeight.medium,
                        textAlign: TextAlign.start,
                        textColor: JPAppTheme.themeColors.tertiary,
                      ),
                    ),
                    JPTextButton(
                      text: 'edit'.tr.toUpperCase(),
                      color: JPAppTheme.themeColors.primary,
                      fontWeight: JPFontWeight.medium,
                      textSize: JPTextSize.heading5,
                      onPressed: service.openPersonalDetailBottomSheet,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                if(service.type != MaterialSupplierType.abc)
                  textWithLabel('address'.tr, Helper.convertAddress(service.companyAddress)),
                textWithLabel('phone'.tr, service.getPhoneDetails()),
                if(service.email.isNotEmpty)
                  textWithLabel('email'.tr, service.email),
              ],
            ),
          ),
        ),
        if(!Helper.isValueNullOrEmpty(service.companyContactErrorText))
          Padding(
            padding: const EdgeInsets.only(top: 5.0, left: 5.0),
            child: JPText(
              text: service.companyContactErrorText,
              textSize: JPTextSize.heading5,
              textColor: JPAppTheme.themeColors.red,
            ),
          ),
      ],
    );
  }

  Widget textWithLabel(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          JPText(
            text: "$label: ",
            textColor: JPAppTheme.themeColors.secondaryText,
            textAlign: TextAlign.start,
          ),

          Expanded(
            child: JPText(
              text: value,
              textColor: JPAppTheme.themeColors.tertiary,
              textAlign: TextAlign.start,
            ),
          )
        ],
      ),
    );
  }
}

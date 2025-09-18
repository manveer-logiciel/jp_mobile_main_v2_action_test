import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:jobprogress/common/services/files_listing/forms/place_srs_order_form/index.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/modules/files_listing/forms/place_supplier_order/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class PlaceSrsOrderBillingAddressSection extends StatelessWidget {
  const PlaceSrsOrderBillingAddressSection({
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
        JPText(
          text: 'address'.tr,
          fontWeight: JPFontWeight.medium,
          textAlign: TextAlign.start,
          textColor: JPAppTheme.themeColors.tertiary,
        ),
        const SizedBox(height: 10),
        JPText(
          text: Helper.convertAddress(service.billingAddress.addressModel),
          fontWeight: JPFontWeight.medium,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}

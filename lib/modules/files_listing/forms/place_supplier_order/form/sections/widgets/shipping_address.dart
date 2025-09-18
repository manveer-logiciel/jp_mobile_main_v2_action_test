import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/address_form_type.dart';
import 'package:jobprogress/common/enums/supplier_form_type.dart';
import 'package:jobprogress/common/services/files_listing/forms/place_srs_order_form/index.dart';
import 'package:jobprogress/global_widgets/forms/address/index.dart';
import 'package:jobprogress/modules/files_listing/forms/place_supplier_order/controller.dart';

class PlaceSrsOrderAddressSection extends StatelessWidget {

  const PlaceSrsOrderAddressSection({
    super.key,
    required this.controller,
  });

  final PlaceSupplierOrderFormController controller;

  PlaceSupplierOrderFormService get service => controller.service;

  @override
  Widget build(BuildContext context) {
    return (!service.isLoading) 
      ? AddressForm(
          key: service.shippingAddressFormKey,
          title: 'shipping_address'.tr.toUpperCase(),
          onDataChange: controller.onDataChanged,
          address: service.shippingAddress,
          isRequired: true,
          hideCountryField: service.type != MaterialSupplierType.abc,
          hideAddressLine3Field: service.type == MaterialSupplierType.beacon,
          isDisabled: !service.isFieldEditable(),
          type: AddressFormType.placeSrsOrder,
          isAbcOrder: service.type == MaterialSupplierType.abc
        )
      : const SizedBox.shrink();
  }
}

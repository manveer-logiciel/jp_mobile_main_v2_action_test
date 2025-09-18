import 'package:flutter/material.dart';
import 'package:jobprogress/common/enums/supplier_form_type.dart';
import 'package:jobprogress/common/models/forms/common/params.dart';
import 'package:jobprogress/common/services/files_listing/forms/place_srs_order_form/index.dart';
import 'package:jobprogress/core/constants/forms/place_srs_order.dart';
import 'package:jobprogress/modules/files_listing/forms/place_supplier_order/controller.dart';
import 'package:jobprogress/modules/files_listing/forms/place_supplier_order/form/sections/widgets/add_attachment.dart';
import 'package:jobprogress/modules/files_listing/forms/place_supplier_order/form/sections/widgets/billing_address.dart';
import 'package:jobprogress/modules/files_listing/forms/place_supplier_order/form/sections/widgets/company_contact.dart';
import 'package:jobprogress/modules/files_listing/forms/place_supplier_order/form/sections/widgets/delivery_service_field.dart';
import 'package:jobprogress/modules/files_listing/forms/place_supplier_order/form/sections/widgets/delivery_type_field.dart';
import 'package:jobprogress/modules/files_listing/forms/place_supplier_order/form/sections/widgets/estimate_branch_arrival_time_field.dart';
import 'package:jobprogress/modules/files_listing/forms/place_supplier_order/form/sections/widgets/material_delivery_date_field.dart';
import 'package:jobprogress/modules/files_listing/forms/place_supplier_order/form/sections/widgets/material_delivery_note_field.dart';
import 'package:jobprogress/modules/files_listing/forms/place_supplier_order/form/sections/widgets/po_number.dart';
import 'package:jobprogress/modules/files_listing/forms/place_supplier_order/form/sections/widgets/request_delivery_time_drop_down_field.dart';
import 'package:jobprogress/modules/files_listing/forms/place_supplier_order/form/sections/widgets/request_delivery_time_field.dart';
import 'package:jobprogress/modules/files_listing/forms/place_supplier_order/form/sections/widgets/requested_delivery_date_field.dart';
import 'package:jobprogress/modules/files_listing/forms/place_supplier_order/form/sections/widgets/shipping_address.dart';
import 'package:jobprogress/modules/files_listing/forms/place_supplier_order/form/sections/widgets/shipping_method_field.dart';
import 'package:jobprogress/modules/files_listing/forms/place_supplier_order/form/sections/widgets/shipping_note_field.dart';
import 'package:jobprogress/modules/files_listing/forms/place_supplier_order/form/sections/widgets/timezone_field.dart';

import 'widgets/po_or_job_name.dart';

/// [PlaceSrsOrderFormFields] renders form fields according to there type
class PlaceSrsOrderFormFields extends StatelessWidget {

  const PlaceSrsOrderFormFields({
    super.key,
    required this.controller,
    required this.field,
    this.avoidBottomPadding = false
  });

  final PlaceSupplierOrderFormController controller;

  PlaceSupplierOrderFormService get service => controller.service;

  final InputFieldParams field;

  final bool avoidBottomPadding;

  @override
  Widget build(BuildContext context) {

    final child = keyToField(field);

    return child != null ? Padding(
      padding: EdgeInsets.only(
        bottom: avoidBottomPadding ? 0 : 16
      ),
      child: child,
    ) : const SizedBox();
  }

  // keyToField(): returns the field to be displayed acc. to field key
  Widget? keyToField(InputFieldParams field) {
    String key = field.key;

    switch (key) {
      case PlaceSrsOrderFormConstants.companyContact: 
        return PlaceSrsOrderCompanyContactSection(controller: controller);
      
      case PlaceSrsOrderFormConstants.shippingAddress: 
        return PlaceSrsOrderAddressSection(controller: controller);
            
      case PlaceSrsOrderFormConstants.billingAddress: 
        return PlaceSrsOrderBillingAddressSection(controller: controller);

      case PlaceSrsOrderFormConstants.timezone: 
        return TimezoneField(field: field, controller: controller);

      case PlaceSrsOrderFormConstants.materialDate: 
        return MaterialDeliveryDateField(field: field, controller: controller);

      case PlaceSrsOrderFormConstants.materialDeliveryNote: 
        return service.materialDeliveryNoteController.text.isNotEmpty ? MaterialDeliveryNoteField(field: field, controller: controller) : null;

      case PlaceSrsOrderFormConstants.requestedDeliveryTime:
        if (service.type == MaterialSupplierType.abc || service.isSrsV2) {
          return RequestedDeliveryTimeDropDownField(controller: controller, field: field);
        } else {
          return RequestDeliveryTimeField(controller: controller, field: field);
        }
      case PlaceSrsOrderFormConstants.shippingMethod: 
        if(service.type == MaterialSupplierType.abc) {
          return DeliveryServiceField(controller: controller, field: field);
        } else {
          return ShippingMethodField(field: field, controller: controller);
        }

      case PlaceSrsOrderFormConstants.deliveryType:
        if (service.type == MaterialSupplierType.srs || service.type == MaterialSupplierType.abc) {
          return service.isDeliveryMethod ? DeliveryTypeField(field: field, controller: controller) : null;
        } else {
          return DeliveryTypeField(field: field, controller: controller);
        }

      case PlaceSrsOrderFormConstants.note: 
        return ShippingNoteField(field: field, controller: controller);
      
      case PlaceSrsOrderFormConstants.attachment:
        return PlaceSrsOrderAttachmentSection(controller: controller,);

      case PlaceSrsOrderFormConstants.poJobName:
        return PoOrJobNameField(field: field, controller: controller);

      case PlaceSrsOrderFormConstants.requestedDeliveryDateLabel:
        return RequestedDeliveryDateField(controller: controller, field: field);

      case PlaceSrsOrderFormConstants.estimateBranchArrivalTime:
        return service.isEstimateBranchArrivalTimeFieldVisible ? EstimateBranchArrivalTimeField(field: field, controller: controller) : null;

      case PlaceSrsOrderFormConstants.poNumber:
        return PoNumberField(controller: controller, field: field);
    }

    return null;
  }
}


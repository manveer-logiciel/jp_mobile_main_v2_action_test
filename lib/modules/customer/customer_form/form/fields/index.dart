import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/forms/common/params.dart';
import 'package:jobprogress/common/services/customer/customer_form/add_customer.dart';
import 'package:jobprogress/core/constants/forms/customer_form.dart';
import 'package:jobprogress/global_widgets/forms/address/index.dart';
import 'package:jobprogress/global_widgets/forms/custom_fields/index.dart';
import 'package:jobprogress/global_widgets/forms/email/index.dart';
import 'package:jobprogress/global_widgets/forms/phone/index.dart';
import 'package:jobprogress/modules/customer/customer_form/controller.dart';
import 'package:jobprogress/modules/customer/customer_form/form/fields/single_select.dart';
import 'package:jobprogress/modules/customer/customer_form/form/fields/text_input.dart';
import 'package:jobprogress/modules/customer/customer_form/form/sections/sync_with_qb.dart';
import '../sections/name.dart';

/// [CustomerFormFields] renders form fields according to there type
class CustomerFormFields extends StatelessWidget {

  const CustomerFormFields({
    super.key,
    required this.controller,
    required this.field,
    this.avoidBottomPadding = false
  });

  final CustomerFormController controller;

  CustomerFormService get service => controller.service;

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
      case CustomerFormConstants.customerName:
        field.isRequired = true;
        return !service.isCommercial ? CustomerFormCustomerCompanyName(
          key: const Key(CustomerFormConstants.customerName),
          controller: controller,
          field: field,
          isDisabled: controller.isSavingForm,
        ) : null;

      case CustomerFormConstants.salesManCustomerRep:
        return CustomerFormSingleSelect(
          key: const Key(CustomerFormConstants.salesManCustomerRep),
          field: field,
          textController: service.salesManCustomerRepController,
          isDisabled: controller.isSavingForm,
          validator: (val) => service.validatorSalesManCustomerRep(field, val),
          onTap: () => service.selectSalesManCustomerRep(field.name),
        );

      case CustomerFormConstants.email:
        return EmailsForm(
          key: service.emailFormKey,
          onDataChange: field.onDataChange,
          isRequired: field.isRequired,
          isDisabled: controller.isSavingForm,
          emails: service.emails,
        );

      case CustomerFormConstants.referredBy:
        return CustomerFormSingleSelect(
          key: const Key(CustomerFormConstants.referredBy),
          field: field,
          textController: service.referralController,
          otherController: service.otherReferralController,
          customerController: service.customerReferralController,
          isDisabled: controller.isSavingForm || service.isReferredByDisabled,
          onTap: () => service.selectReferredBy(field.name),
          onTapCustomer: service.selectReferredByCustomer,
          selectionId: service.referralId,
          customerSelectionId: service.referralCustomerId,
          onTapRemoveCustomer: service.removeCustomer,
        );

      case CustomerFormConstants.companyName:
        field.isRequired = service.isCommercial;
        return CustomerFormTextInput(
          key: const Key(CustomerFormConstants.companyName),
          field: field,
          textController: service.companyNameController,
          isDisabled: controller.isSavingForm,
        );

      case CustomerFormConstants.commercialCompanyName:
        return service.isCommercial ? CustomerFormTextInput(
          key: const Key(CustomerFormConstants.commercialCompanyName),
          field: field,
          textController: service.companyNameController,
          isDisabled: controller.isSavingForm,
        ) : null;

      case CustomerFormConstants.commercialCustomerName:
        field.isRequired = false;
        return service.isCommercial ? CustomerFormCustomerCompanyName(
          key: const Key(CustomerFormConstants.commercialCustomerName),
          controller: controller,
          field: field,
          isDisabled: controller.isSavingForm,
        ) : null;

      case CustomerFormConstants.managementCompany:
        return CustomerFormTextInput(
          key: const Key(CustomerFormConstants.managementCompany),
          field: field,
          textController: service.managementCompanyController,
          isDisabled: controller.isSavingForm,
        );

      case CustomerFormConstants.canvasser:
        return CustomerFormSingleSelect(
          key: const Key(CustomerFormConstants.canvasser),
          field: field,
          textController: service.canvasserController,
          otherController: service.otherCanvasserController,
          isDisabled: controller.isSavingForm,
          onTap: () => service.selectCanvasser(field.name),
          selectionId: service.canvasserId,
        );

      case CustomerFormConstants.propertyName:
        return CustomerFormTextInput(
          key: const Key(CustomerFormConstants.propertyName),
          field: field,
          textController: service.propertyNameController,
          isDisabled: controller.isSavingForm,
        );

      case CustomerFormConstants.callCenterRep:
        return CustomerFormSingleSelect(
          key: const Key(CustomerFormConstants.callCenterRep),
          field: field,
          textController: service.callCenterRepController,
          otherController: service.otherCallCenterRepController,
          isDisabled: controller.isSavingForm,
          onTap: () => service.selectCallCenterRep(field.name),
          selectionId: service.callCenterRepId,
        );

      case CustomerFormConstants.customerNote:
        return CustomerFormTextInput(
          key: const Key(CustomerFormConstants.customerNote),
          field: field,
          isMultiline: true,
          textController: service.customerNoteController,
          isDisabled: controller.isSavingForm,
        );

      case CustomerFormConstants.customerAddress:
        return AddressForm(
          key: service.addressFormKey,
          title: 'customer_address'.tr,
          onDataChange: field.onDataChange,
          address: service.address,
          billingAddress: service.billingAddress,
          showBillingName: true,
          isDisabled: controller.isSavingForm,
        );

      case CustomerFormConstants.qbOnline:
        return CustomerFormSyncWithQB(
          key: const Key(CustomerFormConstants.qbOnline),
          service: service,
          isDisabled: controller.isSavingForm,
        );

      case CustomerFormConstants.customFields:
        return CustomFieldsForm(
          key: service.customFieldsFormKey,
          fields: service.customFormFields,
          onDataChange: field.onDataChange,
          isDisabled: controller.isSavingForm,
        );

      case CustomerFormConstants.phone:
        return PhoneForm(
          key: service.phoneFormKey,
          phoneField: service.phones,
          isDisabled: controller.isSavingForm,
          doShowPhoneBook: true,
        );
    }

    return null;
  }
}


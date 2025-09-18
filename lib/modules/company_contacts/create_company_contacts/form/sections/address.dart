import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/company_contact_listing/create_company_contact.dart';
import 'package:jobprogress/global_widgets/forms/address/index.dart';
import 'package:jobprogress/modules/company_contacts/create_company_contacts/controller.dart';

class CompanyContactAddressSection extends StatelessWidget {

  const CompanyContactAddressSection({
    super.key,
    required this.controller,
  });

  final CreateCompanyContactFormController controller;

  CreateCompanyContactFormService get service => controller.service;

  @override
  Widget build(BuildContext context) {
    return (!service.isLoading) ? AddressForm(
          key: controller.addressFormKey,
          title: 'address'.tr.toUpperCase(),
          onDataChange: controller.onDataChanged,
          address: service.address,
          isDisabled: !service.isFieldEditable(),
        ): const SizedBox.shrink();
  }
}

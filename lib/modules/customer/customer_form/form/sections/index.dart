import 'package:flutter/material.dart';
import 'package:jobprogress/common/services/customer/customer_form/add_customer.dart';
import 'package:jobprogress/modules/customer/customer_form/controller.dart';
import 'section.dart';

class CustomerFormAllSections extends StatelessWidget {
  const CustomerFormAllSections({
    super.key,
    required this.controller,
  });

  final CustomerFormController controller;

  Widget get inputFieldSeparator => SizedBox(
        height: controller.formUiHelper.inputVerticalSeparator,
      );

  CustomerFormService get service => controller.service;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (_, index) {
        final section = service.allSections[index];

        return CustomerFormSection(
          controller: controller,
          section: section,
          isFirstSection: index == 0,
        );
      },
      separatorBuilder: (_, index) => inputFieldSeparator,
      itemCount: service.allSections.length,
    );
  }

}


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/customer/customer_form/add_customer.dart';
import 'package:jobprogress/modules/customer/customer_form/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class CustomerFormTypeSection extends StatelessWidget {

  const CustomerFormTypeSection({
    super.key,
    required this.controller
  });

  final CustomerFormController controller;

  CustomerFormService get service => controller.service;

  Widget get inputFieldSeparator => SizedBox(
    height: controller.formUiHelper.verticalPadding,
    width: controller.formUiHelper.horizontalPadding,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: controller.formUiHelper.verticalPadding
      ),
      child: Row(
          children: [
            ///   Residential
            Flexible(
              child: Row(
                children: [
                Flexible(
                    child: JPRadioBox(
                      groupValue: service.isCommercial,
                      onChanged: service.changeFormType,
                      isTextClickable: true,
                      radioData: [
                        JPRadioData(
                            value: false,
                            label: 'residential'.tr,
                            disabled: controller.isSavingForm
                        ),
                      ],
                    ),
                  ),
                  inputFieldSeparator,
                  ///   Commercial
                  JPRadioBox(
                    groupValue: service.isCommercial,
                    onChanged: service.changeFormType,
                    isTextClickable: true,
                    radioData: [
                      JPRadioData(
                          value: true,
                          label: 'commercial'.tr,
                          disabled: controller.isSavingForm
                      )
                    ],
                  ),
                ],
              ),
            ),
            JPTextButton(
              icon: Icons.person_outline,
              iconSize: 24,
              onPressed: controller.fetchContactFromPhone,
            ),
          ],
        ),
    );
  }
}

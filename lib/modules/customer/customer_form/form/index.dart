
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/customer/customer_form/add_customer.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/form_builder/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jobprogress/modules/customer/customer_form/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import 'sections/index.dart';
import 'shimmer.dart';

class CustomerForm extends StatelessWidget {
  const CustomerForm({
    super.key,
    required this.controller
  });

  final CustomerFormController? controller;

  // parent controller will be null when opened from bottom sheet
  bool get isBottomSheet => controller == null;

  CustomerFormService get service => controller!.service;

  @override
  Widget build(BuildContext context) {

    if(service.isLoading) {
      // returning shimmer if data is loading
      return const CustomerFormShimmer();
    }

    // returning actual widgets once loading done
    return GestureDetector(
      onTap: Helper.hideKeyboard,
      child: GetBuilder<CustomerFormController>(
          init: controller ?? CustomerFormController(),
          global: false,
          builder: (controller) {
            return JPWillPopScope(
              onWillPop: controller.onWillPop,
              child: Material(
                color: JPColor.transparent,
                child: JPFormBuilder(
                  title: controller.pageTitle,
                  onClose: controller.onWillPop,
                  form: Form(
                    key: controller.formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: CustomerFormAllSections(
                            controller: controller,
                          ),
                        ),
                        SizedBox(
                          height: controller.formUiHelper.horizontalPadding,
                        ),
                      ],
                    ),
                  ),
                  footer: Visibility(
                    visible: service.isCustomerFieldNotEmpty,
                    child: JPButton(
                      type: JPButtonType.solid,
                      text: controller.isSavingForm
                          ? ""
                          : controller.saveButtonText.toUpperCase(),
                      size: JPButtonSize.small,
                      disabled: controller.isSavingForm,
                      suffixIconWidget: showJPConfirmationLoader(
                        show: controller.isSavingForm,
                      ),
                      onPressed: controller.createCustomer,
                    ),
                  ),
                  inBottomSheet: isBottomSheet,
                ),
              ),
            );
          }
      ),
    );
  }
}

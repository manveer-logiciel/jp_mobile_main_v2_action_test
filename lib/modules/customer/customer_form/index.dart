
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/modules/customer/customer_form/controller.dart';
import 'package:jobprogress/modules/customer/customer_form/form/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../core/constants/widget_keys.dart';

class CustomerFormView extends StatelessWidget {
  const CustomerFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Helper.hideKeyboard,
      child: GetBuilder<CustomerFormController>(
        init: CustomerFormController(),
        global: false,
        dispose: (state) {
          state.controller?.removeFieldsListener();
        },
        builder: (controller) {
          return AbsorbPointer(
            absorbing: controller.isSavingForm,
            child: JPScaffold(
              backgroundColor: JPAppTheme.themeColors.inverse,
              appBar: JPHeader(
                title: controller.pageTitle,
                backgroundColor: JPColor.transparent,
                titleColor: JPAppTheme.themeColors.text,
                backIconColor: JPAppTheme.themeColors.text,
                titleTextOverflow: TextOverflow.ellipsis,
                onBackPressed: controller.onWillPop,
                actions: [
                  const SizedBox(
                    width: 16,
                  ),
                  Visibility(
                    visible: controller.service.isCustomerFieldNotEmpty,
                    child: Center(
                      child: JPButton(
                        key: const Key(WidgetKeys.appBarSaveButtonKey),
                        disabled: controller.isSavingForm,
                        type: JPButtonType.outline,
                        size: JPButtonSize.extraSmall,
                        text: controller.isSavingForm ? "" : controller.saveButtonText,
                        suffixIconWidget: showJPConfirmationLoader(
                          show: controller.isSavingForm,
                          size: 10,
                        ),
                        onPressed: controller.createCustomer,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  )
                ],
              ),
              body: CustomerForm(
                controller: controller,
              ),
            ),
          );
        },
      ),
    );
  }
}

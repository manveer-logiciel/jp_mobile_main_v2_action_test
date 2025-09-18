import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/forms/create_company_contact/create_company_contact_form_param.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/modules/company_contacts/create_company_contacts/form/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../global_widgets/loader/index.dart';
import 'controller.dart';

class CreateCompanyContactFormView extends StatelessWidget {
  const CreateCompanyContactFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateCompanyContactFormController>(
      init: CreateCompanyContactFormController(),
      global: false,
      builder: (controller) {
        return JPScaffold(
          scaffoldKey: controller.scaffoldKey,
          backgroundColor: JPAppTheme.themeColors.inverse,
          appBar: JPHeader(
            title: controller.pageTitle,
            backgroundColor: JPColor.transparent,
            titleColor: JPAppTheme.themeColors.text,
            backIconColor: JPAppTheme.themeColors.text,
            onBackPressed: controller.onWillPop,
            actions: [
              const SizedBox(
                width: 16,
              ),
              JPTextButton(
                key: const Key(WidgetKeys.selectContactOptionsKey),
                icon: Icons.person_outline,
                iconSize: 24,
                onPressed: controller.openContactQuickBottomSheet,
              ),
              const SizedBox(
                width: 8,
              ),
              Center(
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
                  onPressed: controller.createCompanyContact,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
            ],
          ),
          body: CreateCompanyContactForm(createCompanyContactFormParam: CreateCompanyContactFormParam(controller: controller),)
        );
      },
    );
  }
}

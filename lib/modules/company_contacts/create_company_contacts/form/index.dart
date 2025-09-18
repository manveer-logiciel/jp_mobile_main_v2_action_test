import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/forms/create_company_contact/create_company_contact_form_param.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/form_builder/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jobprogress/modules/company_contacts/create_company_contacts/controller.dart';
import 'package:jobprogress/modules/company_contacts/create_company_contacts/form/sections/additional_option.dart';
import 'package:jobprogress/modules/company_contacts/create_company_contacts/form/sections/address.dart';
import 'package:jobprogress/modules/company_contacts/create_company_contacts/form/sections/details.dart';
import 'package:jobprogress/modules/company_contacts/create_company_contacts/form/sections/job_contact_additional_option.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class CreateCompanyContactForm extends StatelessWidget {
  const CreateCompanyContactForm({
    super.key,
    this.createCompanyContactFormParam,
  });


  final CreateCompanyContactFormParam? createCompanyContactFormParam;

  // parent controller will be null when opened from bottom sheet
  bool get isBottomSheet => createCompanyContactFormParam?.controller == null;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Helper.hideKeyboard,
      child: GetBuilder<CreateCompanyContactFormController>(
        init:createCompanyContactFormParam?.controller
            ?? CreateCompanyContactFormController(),
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

                      CompanyContactDetailsSection(
                        controller: controller,
                      ),

                      SizedBox(
                        height: controller.formUiHelper.sectionSeparator
                      ),

                      CompanyContactAddressSection(controller: controller),

                      SizedBox(
                        height: controller.formUiHelper.sectionSeparator
                      ),

                      controller.service.isJobContactPersonForm
                        ? JobContactAdditionalOptionsSection(controller: controller) 
                        : AdditionalOptionsSection(controller: controller),

                      SizedBox(
                        height: controller.formUiHelper.sectionSeparator
                      ),
                    ],
                  ),
                ),
                footer: JPButton(
                  type: JPButtonType.solid,
                  text: controller.isSavingForm
                      ? ""
                      : controller.saveButtonText,
                  size: JPButtonSize.small,
                  disabled: controller.isSavingForm,
                  suffixIconWidget: showJPConfirmationLoader(
                    show: controller.isSavingForm,
                  ),
                  onPressed: controller.createCompanyContact,
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

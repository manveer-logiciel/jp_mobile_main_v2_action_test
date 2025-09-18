import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/forms/create_appointment/create_appointment_form_param.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/form_builder/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jobprogress/modules/appointments/create_appointment/controller.dart';
import 'package:jobprogress/modules/appointments/create_appointment/widget/additional_options/index.dart';
import 'package:jobprogress/modules/appointments/create_appointment/widget/appointment_details.dart';
import 'package:jobprogress/modules/appointments/create_appointment/widget/attachments.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class CreateAppointmentForm extends StatelessWidget {
  const CreateAppointmentForm({
    super.key,
    this.createAppointmentFormParam,
  });

  final CreateAppointmentFormParam? createAppointmentFormParam;

  // parent controller will be null when opened from bottom sheet
  bool get isBottomSheet => createAppointmentFormParam?.controller == null;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Helper.hideKeyboard,
      child: GetBuilder<CreateAppointmentFormController>(
          init: createAppointmentFormParam?.controller ?? CreateAppointmentFormController(
                  createAppointmentFormParam: createAppointmentFormParam),
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
                        AppointmentDetailsSection(controller:controller),
                        SizedBox(height: controller.formUiHelper.sectionSeparator),
                        AdditionalOptionsSection(controller:controller),
                        SizedBox(height: controller.formUiHelper.sectionSeparator),
                        CreateAppointmentAttachmentSection(controller:controller),
                        SizedBox(height: controller.formUiHelper.sectionSeparator),
                      ],
                    ),
                  ),
                  footer: JPButton(
                    type: JPButtonType.solid,
                    text: controller.isSavingForm ? "" : controller.saveButtonText,
                    size: JPButtonSize.small,
                    disabled: controller.isSavingForm,
                    suffixIconWidget: showJPConfirmationLoader(
                      show: controller.isSavingForm,
                    ),
                    onPressed: controller.createAppointment,
                  ),
                  inBottomSheet: isBottomSheet,
                ),
              ),
            );
          }),
    );
  }
}
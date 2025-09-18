import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/forms/create_appointment/create_appointment_form_param.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/modules/appointments/create_appointment/controller.dart';
import 'package:jobprogress/modules/appointments/create_appointment/form/create_appointment_form.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../global_widgets/loader/index.dart';

class CreateAppointmentFormView extends StatelessWidget {
  const CreateAppointmentFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateAppointmentFormController>(
      init: CreateAppointmentFormController(),
      global: false,
      builder: (controller) {
        return JPScaffold(
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
                  Center(
                    child: JPButton(
                      disabled: controller.isSavingForm,
                      type: JPButtonType.outline,
                      size: JPButtonSize.extraSmall,
                      text: controller.isSavingForm ? "" : controller.saveButtonText,
                      suffixIconWidget: showJPConfirmationLoader(
                        show: controller.isSavingForm,
                        size: 10,
                      ),
                      onPressed: controller.createAppointment,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  )
                ],
          ),
          body: CreateAppointmentForm(createAppointmentFormParam: CreateAppointmentFormParam(controller: controller),),
        );
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../common/models/forms/event/event_form_param.dart';
import '../../../global_widgets/loader/index.dart';
import '../../../global_widgets/scaffold/index.dart';
import 'controller.dart';
import 'form/index.dart';

class EventFormView extends StatelessWidget {
  const EventFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EventFormController>(
      init: EventFormController(),
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
                      onPressed: controller.createEvent,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  )
                ],
          ),
          body: EventForm(
            eventFormParam: EventFormParams(controller: controller),
          ),
        );
    });
  }
}

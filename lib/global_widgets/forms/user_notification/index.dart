import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/reminder.dart';
import 'package:jobprogress/global_widgets/expansion_tile/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import 'controller.dart';
import 'fields/index.dart';

class UserNotificationForm extends StatefulWidget {
  const UserNotificationForm({
    super.key,
    required this.isExpanded,
    required this.onExpansionChanged,
    required this.reminders,
    this.isDisabled = false,
  });

  final bool isExpanded;
  final Function(bool) onExpansionChanged;
  final List<ReminderModel> reminders;
  final bool isDisabled;

  @override
  State<UserNotificationForm> createState() => UserNotificationFormState();
}

class UserNotificationFormState extends State<UserNotificationForm> {

  late UserNotificationFormController controller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserNotificationFormController>(
      global: false,
      init: UserNotificationFormController(widget.reminders, widget.onExpansionChanged),
      didChangeDependencies: (state) {
        controller = state.controller!;
      },
      builder: (_) {
        return Material(
          color: JPAppTheme.themeColors.dimGray.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(8),
          child: JPExpansionTile(
            headerBgColor: JPColor.transparent,
            header: JPText(
              text: 'user_reminder'.tr,
              fontWeight: JPFontWeight.medium,
              textAlign: TextAlign.start,
            ),
            contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            disableRotation: true,
            trailing: (val) => JPToggle(
              value: widget.isExpanded,
              onToggle: controller.onToggle,
              disabled: widget.isDisabled,
            ),
            headerPadding: const EdgeInsets.all(16),
            initialCollapsed: widget.reminders.isEmpty,
            isExpanded: widget.isExpanded,
            children: [

              Form(
                key: controller.formKey,
                child: UserNotificationFormFields(
                  controller: controller,
                  isDisabled: widget.isDisabled,
                ),
              ),

              if(controller.remindersFields.length < 5)... {

                if(controller.remindersFields.isNotEmpty)
                  const SizedBox(
                  height: 10,
                ),

                Row(
                  children: [
                    Transform.translate(
                      offset: const Offset(-4, 0),
                      child: JPTextButton(
                        text: 'add_notification'.tr,
                        padding: 2,
                        color: JPAppTheme.themeColors.primary,
                        textSize: JPTextSize.heading5,
                        icon: Icons.add,
                        iconPosition: JPPosition.start,
                        onPressed: controller.addReminderField,
                        isDisabled: widget.isDisabled,
                        iconSize: 18,
                        isExpanded: false,
                      ),
                    ),
                  ],
                )
              }
            ],
          ),
        );
      }
    );
  }

  bool validate({bool scrollOnValidate = true}) {
    return controller.validateForm(scrollOnValidation: scrollOnValidate);
  }
}

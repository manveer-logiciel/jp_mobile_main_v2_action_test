import 'package:flutter/material.dart';
import 'package:jobprogress/global_widgets/forms/user_notification/controller.dart';
import 'tile.dart';

class UserNotificationFormFields extends StatelessWidget {
  const UserNotificationFormFields({
    super.key,
    required this.controller,
    this.isDisabled = false,
  });

  final UserNotificationFormController controller;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (_, index) {

          final data = controller.remindersFields[index];

          return UserNotificationFormTile(
            key: UniqueKey(),
            data: data,
            onTapRemove: () => controller.removeReminder(index),
            onTapNotificationType: () => controller.selectNotificationType.call(index),
            onTapDurationType: () => controller.selectNotificationPeriod.call(index),
            onDataChanged: () => controller.onValueChanged(index),
            canShowError: controller.canShowError,
            isDisabled: isDisabled,
          );
        },
        separatorBuilder: (_, index) {
          return const SizedBox(
            height: 10,
          );
        },
        itemCount: controller.remindersFields.length,
    );
  }
}

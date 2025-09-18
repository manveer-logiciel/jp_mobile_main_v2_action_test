import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/feature_flag.dart';
import 'package:jobprogress/common/services/task/create_task_form.dart';
import 'package:jobprogress/core/constants/feature_flag_constant.dart';
import 'package:jobprogress/global_widgets/chips_input_box/index.dart';
import 'package:jobprogress/global_widgets/expansion_tile/index.dart';
import 'package:jobprogress/modules/task/create_task/controller.dart';
import 'package:jobprogress/modules/task/create_task/form/sections/additional_options/reminder_notification.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../../../../common/enums/form_field_type.dart';
import '../../../../../../common/enums/form_field_visibility.dart';
import '../../../../../../common/enums/form_toggles.dart';

class AdditionalOptionsSection extends StatelessWidget {

  const AdditionalOptionsSection({
    super.key,
    required this.controller,
  });

  final CreateTaskFormController controller;

  Widget get inputFieldSeparator => SizedBox(
        height: controller.formUiHelper.inputVerticalSeparator,
      );

  CreateTaskFormService get service => controller.service;

  @override
  Widget build(BuildContext context) {
    return JPExpansionTile(
      enableHeaderClick: true,
      initialCollapsed: true,
      borderRadius: controller.formUiHelper.sectionBorderRadius,
      isExpanded: service.isAdditionalDetailsExpanded,
      headerPadding: EdgeInsets.symmetric(
        horizontal: controller.formUiHelper.horizontalPadding,
        vertical: controller.formUiHelper.verticalPadding,
      ),
      header: JPText(
        text: 'additional_options'.tr.toUpperCase(),
        textSize: JPTextSize.heading4,
        fontWeight: JPFontWeight.medium,
        textColor: JPAppTheme.themeColors.secondaryText,
        textAlign: TextAlign.start,
      ),
      trailing: (_) => JPIcon(
        Icons.expand_more,
        color: JPAppTheme.themeColors.secondaryText,
      ),
      contentPadding: EdgeInsets.only(
        left: controller.formUiHelper.horizontalPadding,
        right: controller.formUiHelper.horizontalPadding,
        bottom: controller.formUiHelper.verticalPadding,
      ),
      onExpansionChanged: controller.onAdditionalOptionsExpansionChanged,
      children: [
        /// send a copy (active only in case of add task)
        Visibility(
          visible: service.isFieldEditable(FormFieldVisibility.sendCopy),
          child: Align(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                JPText(
                  text: 'send_a_copy_to_assigned_user'.tr,
                  fontWeight: JPFontWeight.medium,
                  textAlign: TextAlign.start,
                ),
                Row(
                  children: [
                    JPCheckbox(
                      selected: service.emailNotification,
                      onTap: service.toggleEmailNotification,
                      separatorWidth: 2,
                      padding: const EdgeInsets.all(4),
                      disabled: !service.isFieldEditable(FormFieldType.sendCopy),
                      borderColor: JPAppTheme.themeColors.themeGreen,
                      text: 'email'.tr,
                    ),
                    if(FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.userManagement]))
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: JPCheckbox(
                          selected: service.messageNotification,
                          onTap: service.toggleMessageNotification,
                          separatorWidth: 2,
                          padding: const EdgeInsets.all(4),
                          disabled: !service.isFieldEditable(FormFieldType.sendCopy),
                          borderColor: JPAppTheme.themeColors.themeGreen,
                          text: 'message'.tr.capitalizeFirst!,
                        ),
                      ),
                  ],
                )
              ],
            ),
          ),
        ),
        
        Visibility(
            visible: service.isFieldEditable(FormFieldVisibility.sendCopy),
            child: inputFieldSeparator),
        /// notify users
        JPChipsInputBox<CreateTaskFormController>(
          inputBoxController: service.notifyUsersController,
          label: 'notify_users_on_completion'.tr.capitalize,
          controller: controller,
          selectedItems: service.selectedNotifyUsers,
          onTap: service.selectNotifyUsers,
          disabled: !service.isFieldEditable(FormFieldType.notifyUsers),
          onDataChanged: controller.onDataChanged,
        ),

        inputFieldSeparator,

        /// reminder notification
        JPExpansionTile(
          header: JPText(
            text: 'reminder_notification'.tr,
            fontWeight: JPFontWeight.medium,
            textAlign: TextAlign.start,
          ),
          disableRotation: true,
          trailing: (val) => JPToggle(
            value: service.isReminderNotificationSelected,
            disabled: !service.isFieldEditable(FormToggles.remindNotification),
            onToggle: controller.onReminderNotificationExpansionChanged,
          ),
          headerPadding: EdgeInsets.zero,
          initialCollapsed: true,
          isExpanded: service.isReminderNotificationSelected,
          children: [
            ReminderNotificationForm(
              controller: controller,
            )
          ],
        ),
      ],
    );
  }
}

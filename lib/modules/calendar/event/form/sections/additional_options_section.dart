import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/forms/user_notification/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../../../common/enums/form_field_type.dart';
import '../../../../../common/services/calendars/event_form.dart';
import '../../../../../global_widgets/chips_input_box/index.dart';
import '../../controller.dart';

class AdditionalOptionsSection extends StatelessWidget {
  const AdditionalOptionsSection({
    super.key,
    required this.controller,
  });

  final EventFormController controller;

  EventFormService get service => controller.service;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: JPAppTheme.themeColors.base,
      borderRadius:
      BorderRadius.circular(controller.formUiHelper.sectionBorderRadius),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: controller.formUiHelper.horizontalPadding,
          vertical: controller.formUiHelper.verticalPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            JPText(
              text: 'additional_options'.tr.toUpperCase(),
              textSize: JPTextSize.heading4,
              fontWeight: JPFontWeight.medium,
              textColor: JPAppTheme.themeColors.secondaryText,
              textAlign: TextAlign.start,
            ),
            /// company_crew
            Padding(
              padding: EdgeInsets.only(top: controller.formUiHelper.inputVerticalSeparator),
              child: JPChipsInputBox<EventFormController>(
                  inputBoxController: service.companyCrewController,
                  label: 'company_crew'.tr.capitalize,
                  isRequired: false,
                  controller: controller,
                  selectedItems: service.selectedCompanyCrew,
                  onTap: service.selectCompanyCrew,
                  onRemove: (user)=>service.removeSelectedWorkCrew,
                  disabled: !service.isFieldEditable(FormFieldType.companyCrew),
                  disableEditing: !service.isFieldEditable(FormFieldType.companyCrew),
                  onDataChanged: controller.onDataChanged,
                  suffixChild: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: controller.formUiHelper.horizontalPadding),
                    child: JPIcon(
                      Icons.person_add_alt,
                      color: JPAppTheme.themeColors.primary,
                    ),
                  )
              ),
            ),
            /// Labor / Sub Contractors
            Padding(
              padding: EdgeInsets.only(top: controller.formUiHelper.inputVerticalSeparator),
              child: JPChipsInputBox<EventFormController>(
                inputBoxController: service.labourContractorsController,
                label: 'labor_sub_contractors'.tr,
                isRequired: false,
                controller: controller,
                selectedItems: service.selectedLaborContractors,
                onTap: service.selectLabourContractors,
                onRemove: (user) => service.removeSelectedWorkCrew,
                disabled: !service.isFieldEditable(FormFieldType.subContractor),
                disableEditing: !service.isFieldEditable(FormFieldType.subContractor),
                onDataChanged: controller.onDataChanged,
                suffixChild: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: controller.formUiHelper.horizontalPadding),
                  child: JPIcon(
                    Icons.person_add_alt,
                    color: JPAppTheme.themeColors.primary,
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            /// user notification
            if(!service.isLoading)
              UserNotificationForm(
              key: controller.userNotificationFormKey,
              reminders: service.notificationReminders,
              isExpanded: service.isUserNotificationSelected,
              onExpansionChanged: controller.onUserNotificationChanged,
              isDisabled: !service.isFieldEditable(FormFieldType.recurring),
            ),
          ],
        ),
      ),
    );
  }
}

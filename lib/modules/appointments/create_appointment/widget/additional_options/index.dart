import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/appointment/create_appointment_form.dart';
import 'package:jobprogress/global_widgets/expansion_tile/index.dart';
import 'package:jobprogress/global_widgets/forms/user_notification/index.dart';
import 'package:jobprogress/modules/appointments/create_appointment/controller.dart';
import 'package:jobprogress/modules/appointments/create_appointment/widget/additional_options/widget/additional_recipients_tiles.dart';
import 'package:jp_mobile_flutter_ui/ChipsInput/index.dart';
import 'package:jp_mobile_flutter_ui/ToolTip/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:jobprogress/common/services/auth.dart';

class AdditionalOptionsSection extends StatelessWidget {
  const AdditionalOptionsSection({
    super.key,
    required this.controller,
  });

  final CreateAppointmentFormController controller;

  Widget get inputFieldSeparator => SizedBox(
        height: controller.formUiHelper.inputVerticalSeparator,
      );

  CreateAppointmentFormService get service => controller.service;

  @override
  Widget build(BuildContext context) {
    return JPExpansionTile(
      enableHeaderClick: true,
      initialCollapsed: true,
      borderRadius: controller.formUiHelper.sectionBorderRadius,
      isExpanded: controller.isAdditionalDetailsExpanded,
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

        // location 
        JPInputBox(
          inputBoxController: service.locationController,
          label: 'location'.tr,
          type: JPInputBoxType.withLabel,
          fillColor: JPAppTheme.themeColors.base,
          disabled: !service.isFieldEditable(),
          // Display location icon when location type is 'other' to indicate searchable field
          suffixChild: service.isLocationTypeOther ? Padding(
            padding: EdgeInsets.symmetric(horizontal: controller.formUiHelper.horizontalPadding),
            child: JPIcon(
              Icons.location_on_outlined,
              color: JPAppTheme.themeColors.themeBlue,
            ),
          ) : null,
          // Make field read-only when location type is 'other' to prevent direct editing
          readOnly: service.isLocationTypeOther,
          // Open location selector when field is tapped and location type is 'other'
          onPressed: service.isLocationTypeOther ? service.selectLocation : null,
          onChanged: (val) => controller.onDataChanged(val),
        ),

        inputFieldSeparator,

        // location type
        if(controller.service.customerModel != null)...{
          JPInputBox(
            inputBoxController: service.locationTypeController,
            type: JPInputBoxType.withLabel,
            label: 'location_type'.tr.capitalize,
            fillColor: JPAppTheme.themeColors.base,
            disabled: !service.isFieldEditable(),
            readOnly: true,
            onPressed: service.selectLocationType,
            suffixChild: Padding(
              padding: EdgeInsets.symmetric(horizontal: controller.formUiHelper.horizontalPadding),
              child: JPIcon(
                Icons.keyboard_arrow_down_outlined,
                color: JPAppTheme.themeColors.secondaryText,
              ),
            ),
          ),

          inputFieldSeparator,
        },
        
        // additional recipients
        Column(
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top:8),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: JPAppTheme.themeColors.inverse),
                    color: service.isFieldEditable() ? JPAppTheme.themeColors.base : JPAppTheme.themeColors.inverse,
                  ),
                  child: GetBuilder<CreateAppointmentFormController>(
                    init: controller,
                    builder: (context) {
                      return JPChipsInput(
                        selectedChips: service.selectedList,
                        enabled: service.isFieldEditable(),
                        removeOnBackSpace: (dynamic data){
                          service.removeEmailInList(data); 
                        },
                        initialValue: service.initialToValues,
                        key: service.suggestionBuilderKey,
                        suffix: (service.customerModel != null && service.additionalRecipientsList.isNotEmpty && !AuthService.isPrimeSubUser()) ? InkWell(
                      onTap: service.selectAdditionalRecipients,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: controller.formUiHelper.horizontalPadding,vertical: controller.formUiHelper.horizontalPadding),
                        child: JPText(
                                text: 'select'.tr.toUpperCase(),
                                textSize: JPTextSize.heading5,
                                textColor: JPAppTheme.themeColors.primary,
                              ),
                      ),
                ) : const SizedBox.shrink(),

                        textStyle: TextStyle(
                            color: JPAppTheme.themeColors.text, fontSize: 14),
                        decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.only(top: 13, bottom: 10, left: 10),
                            border: InputBorder.none),
                        suggestionBuilder: (context, state, dynamic profile) {
                          return AdditionalRecipientsSuggestionListTile(
                            state: state,
                            profile: profile,
                            actionFrom: 'to',
                            controller: controller, 
                          );
                        },
                        chipBuilder: (context, state, dynamic profile) {
                          return JPToolTip(
                            message: profile.email,
                            child: JPChip(
                              text: profile.name,
                              backgroundColor: JPAppTheme.themeColors.dimGray,  
                              onRemove: () {
                                state.deleteChip(profile);
                                service.removeEmailInList(profile);
                              },
                            )
                          );
                        },
                        onTypedChanged: (value) async {
                          if (value.length > 2) {
                            await service.getSuggestionEmailData(value);
                            service.setSuggestionEmailData(value);
                          }
                        },
                        onChanged: (data) {
                          service.selectedList;
                          service.update();
                        },
                        findSuggestions: (String query) {
                          if (query.isNotEmpty && query.length > 2) {
                            return service.suggestionList!;
                          } else {
                            return [];
                          }
                        },
                      );
                    }
                  ),
                  ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Container(
                    color: JPAppTheme.themeColors.base,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: JPText(
                        textAlign: TextAlign.start,
                        text: 'additional_recipients'.tr.capitalize.toString(),
                        textSize: JPTextSize.heading5,
                        textColor: JPAppTheme.themeColors.text,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),],
        ),

        inputFieldSeparator,

        if(!service.isLoading)
          UserNotificationForm(
          key: controller.userNotificationFormKey,
          reminders: service.notificationReminders,
          isExpanded: service.isUserNotificationSelected,
          onExpansionChanged: controller.onUserNotificationChanged,
          isDisabled: !service.isFieldEditable(),
        ),

      ],
    );
  }
}
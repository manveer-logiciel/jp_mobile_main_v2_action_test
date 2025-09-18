import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/services/job/job_summary/quick_action_helper.dart';
import 'package:jobprogress/core/utils/color_helper.dart';
import 'package:jobprogress/global_widgets/network_image/index.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/FlutterMention/flutter_mentions.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../../common/models/follow_up_note/add_edit_model.dart';
import '../../../../../core/constants/follow_ups_note.dart';
import '../../../../../core/utils/helpers.dart';
import '../../../../../global_widgets/loader/index.dart';
import '../../../../../global_widgets/safearea/safearea.dart';
import 'controller.dart';

class AddEditFollowUpNote extends StatelessWidget {
  const AddEditFollowUpNote({
    super.key,
    required this.onApply,
    this.addEditFollowUpModel,
    this.job,
    this.suggestions = const []
  });

  final AddEditFollowUpModel? addEditFollowUpModel;
  final void Function() onApply;
  final JobModel? job;
  final List<Map<String, dynamic>> suggestions;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddEditFollowUpNoteController(addEditFollowUpModel: addEditFollowUpModel));
    FollowUpsNotesConstants.getFollowupLabels(FollowUpsNotesKey.call);
    return GestureDetector(
      onTap:() => Helper.hideKeyboard(),
        child: JPSafeArea(
          child: GetBuilder<AddEditFollowUpNoteController>(
            builder: (_) => AlertDialog(
              insetPadding: const EdgeInsets.all(10),
              contentPadding: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                content: Builder( builder: (context) => Container(
                  width: double.maxFinite,
                    padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///   header
                      Padding(
                        padding: const EdgeInsets.only(bottom: 17),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: JPText(
                                  text: controller.isEdit ? "edit_follow_up".tr.toUpperCase() : "add_follow_up".tr.toUpperCase(),
                                  textSize: JPTextSize.heading3,
                                  fontWeight: JPFontWeight.medium,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Row(
                                children: [
                                  JPTextButton(
                                    isDisabled: controller.isLoading,
                                    onPressed: () {
                                      JobSummaryQuickActionHelper().openCustomerCallDialog(job!);
                                    },
                                    color: JPAppTheme.themeColors.text,
                                    icon: Icons.phone_rounded,
                                    iconSize: 24,
                                  ),
                                  JPTextButton(
                                    isDisabled: controller.isLoading,
                                    onPressed:() {
                                      Get.toNamed(Routes.snippetsListing);
                                    },
                                    color: JPAppTheme.themeColors.text,
                                    icon: Icons.text_snippet_outlined,
                                    iconSize: 24,
                                  ),
                                  JPTextButton(
                                    isDisabled: controller.isLoading,
                                    onPressed: () => Get.back(),
                                    color: JPAppTheme.themeColors.text,
                                    icon: Icons.clear,
                                    iconSize: 24,
                                  ),
                                ],
                              )
                            ]
                        ),
                      ),
                      ///   body
                      Flexible(
                        child: SingleChildScrollView(
                          child: Form(
                            key: controller.formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ///   Radio Buttons
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  alignment: WrapAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(width: double.infinity),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ///   Follow-up Radio Buttons
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 10),
                                          child: JPRadioBox(
                                            groupValue: controller.radioGroup,
                                            onChanged: (val) => controller.updateRadioValue(val),
                                            radioData: [JPRadioData(
                                              value: FollowUpsNotesKey.call,
                                              label: FollowUpsNotesConstants.getFollowupLabels(FollowUpsNotesKey.call)
                                            )],
                                            activeColor: FollowUpsNotesConstants.getFollowupLabelColors(FollowUpsNotesKey.call),
                                          ),
                                        ),
                                        ///   Lost Job Radio Buttons
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 10),
                                          child: JPRadioBox(
                                            groupValue: controller.radioGroup,
                                            onChanged: (val) => controller.updateRadioValue(val),
                                            radioData: [JPRadioData(
                                                value: FollowUpsNotesKey.lostJob,
                                                label: FollowUpsNotesConstants.getFollowupLabels(FollowUpsNotesKey.lostJob))],
                                            activeColor: FollowUpsNotesConstants.getFollowupLabelColors(FollowUpsNotesKey.lostJob),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ///   Undecided Radio Buttons
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 10),
                                          child: JPRadioBox(
                                            groupValue: controller.radioGroup,
                                            onChanged: (val) => controller.updateRadioValue(val),
                                            radioData: [JPRadioData(
                                              value: FollowUpsNotesKey.undecided,
                                              label: FollowUpsNotesConstants.getFollowupLabels(FollowUpsNotesKey.undecided))],
                                            activeColor: FollowUpsNotesConstants.getFollowupLabelColors(FollowUpsNotesKey.undecided),
                                          ),
                                        ),
                                        ///   No Action Required Radio Buttons
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 10),
                                          child: JPRadioBox(
                                            groupValue: controller.radioGroup,
                                            onChanged: (val) => controller.updateRadioValue(val),
                                            radioData: [JPRadioData(
                                              value: FollowUpsNotesKey.noActionRequired,
                                              label: FollowUpsNotesConstants.getFollowupLabels(FollowUpsNotesKey.noActionRequired))],
                                            activeColor: FollowUpsNotesConstants.getFollowupLabelColors(FollowUpsNotesKey.noActionRequired),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                ///
                                Column(
                                  children: [
                                    ///   note
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 15),
                                      child: JPMention(
                                        defaultText: '',
                                        validator: (value) {
                                          return controller.validateNote(value);
                                        },
                                        onMarkupChanged: (val) {
                                          controller.followUpNote.note = val;
                                        },
                                        onChanged: (val) {
                                          controller.followUpNote.note = val;
                                        },
                                        getController:(val) {
                                          controller.noteController = val;
                                        } ,
                                        label: 'note'.tr,
                                        mentions: [
                                          Mention(
                                              markupBuilder: (trigger, markup, value) {
                                                return '$trigger[u:$markup]';
                                              },
                                              data: suggestions,
                                              matchAll: false,
                                              suggestionBuilder: (data) {
                                                return  Column(
                                                  children: [
                                                    const SizedBox(height: 8),
                                                    Container(
                                                      padding: const EdgeInsets.only(left: 15,right: 15),
                                                      child: Row(
                                                        children: <Widget>[
                                                          JPAvatar(
                                                              size: JPAvatarSize.small,
                                                              borderWidth: data['photo'] != null ? 2 : 1,
                                                              borderColor: data['border_color'] != null ? ColorHelper.getHexColor(data['border_color']): JPAppTheme.themeColors.darkGray,
                                                              backgroundColor: data['border_color'] == null ? JPAppTheme.themeColors.darkGray : ColorHelper.getHexColor(data['border_color']),
                                                              child: data['photo'] != null ? JPNetworkImage(
                                                                src: data['photo'],
                                                              ):
                                                              JPText(
                                                                  text: data['initial'].toString(),
                                                                  textColor: JPAppTheme.themeColors.base,
                                                                  textSize: JPTextSize.heading6
                                                              )
                                                          ),
                                                          const SizedBox(
                                                            width: 10.0,
                                                          ),
                                                          Flexible(child: JPText(text:data['display'], overflow: TextOverflow.ellipsis)),
                                                          const SizedBox(width: 2),
                                                          JPText(text: data['suffix-text'],textSize: JPTextSize.heading5, textColor: JPAppTheme.themeColors.darkGray),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8,),

                                                  ],
                                                );
                                              }
                                          ),
                                        ],
                                        isRequired: true,
                                      ),
                                    ),
                                    ///   Toggle button
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 15),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          JPText(
                                            text: "follow_up_reminder".tr,
                                            textSize: JPTextSize.heading4,
                                          ),
                                          JPToggle(
                                            disabled: controller.isLoading,
                                            value: controller.followUpNote.followUpReminder ?? false,
                                            onToggle: (value) => controller.reminderToggleUpdate(value),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ///   date type
                                    Visibility(
                                      visible: controller.followUpNote.followUpReminder ?? false,
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 15),
                                        child: JPInputBox(
                                          controller: controller.dateTypeTextController,
                                          onPressed: () => controller.openDatePicker(initialDate: controller.followUpNote.taskDueDate,),
                                          fillColor: JPAppTheme.themeColors.base,
                                          type: JPInputBoxType.withLabel,
                                          label: "date".tr.capitalize,
                                          hintText: "select".tr,
                                          isRequired: true,
                                          readOnly: true,
                                          validator: (val) => (val?.isEmpty ?? true) ? "please_select_date".tr : "",
                                          suffixChild: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Icon(Icons.today_outlined, size: 18),
                                          ),
                                        ),
                                      ),
                                    ),
                                    ///   users
                                    Visibility(
                                      visible: controller.followUpNote.followUpReminder ?? false,
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 15),
                                        child: JPInputBox(
                                          controller: controller.usersTextController,
                                          onPressed: controller.openMultiSelect,
                                            type: JPInputBoxType.withLabel,
                                            label: "users".tr.capitalize,
                                            hintText: "select".tr,
                                            isRequired: true,
                                            readOnly: true,
                                            fillColor: JPAppTheme.themeColors.base,
                                            validator: (val) => (val?.isEmpty ?? true) ? "please_select_user".tr : "",
                                            suffixChild: const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Icon(Icons.keyboard_arrow_down, size: 18),
                                            )
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      ///   bottom buttons
                      Padding(
                        padding: const EdgeInsets.only(top: 10,),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: JPResponsiveDesign.popOverButtonFlex,
                                child: JPButton(
                                  text: 'cancel'.tr.toUpperCase(),
                                  onPressed: () {
                                    Helper.hideKeyboard();
                                    Get.back();
                                  },
                                  disabled: controller.isLoading,
                                  fontWeight: JPFontWeight.medium,
                                  size: JPButtonSize.small,
                                  colorType: JPButtonColorType.lightGray,
                                  textColor: JPAppTheme.themeColors.tertiary,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                flex: JPResponsiveDesign.popOverButtonFlex,
                                child: JPButton(
                                  onPressed: () {
                                    FocusManager.instance. primaryFocus?.unfocus();
                                    controller.onSave(onApply);
                                  } ,
                                  text: controller.isLoading ? "" : 'save'.tr.toUpperCase(),
                                  fontWeight: JPFontWeight.medium,
                                  size: JPButtonSize.small,
                                  colorType: JPButtonColorType.primary,
                                  textColor: JPAppTheme.themeColors.base,
                                  iconWidget: showJPConfirmationLoader(show: controller.isLoading),
                                  disabled: controller.isLoading,
                                ),
                              )
                            ]
                        ),
                      ),
                    ])
                  ))
            )
          ),
        )
    );
  }
}


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/forms/reminder/index.dart';
import 'package:jobprogress/common/models/reminder.dart';
import 'package:jobprogress/core/utils/single_select_helper.dart';
import 'package:jobprogress/global_widgets/convert_remainder_time/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class UserNotificationFormController extends GetxController {

  UserNotificationFormController(this.reminders, this.onExpansionChanged);

  List<ReminderModel> reminders;

  List<ReminderFormData> remindersFields = [];

  bool canShowError = false;

  final Function(bool) onExpansionChanged;

  final formKey = GlobalKey<FormState>();

  List<JPSingleSelectModel> reminderType = [
    JPSingleSelectModel(label: 'push'.tr.capitalizeFirst!, id: 'notification'),
    JPSingleSelectModel(label: 'email'.tr.capitalizeFirst!, id: 'email'),
  ];

  List<JPSingleSelectModel> durationType = [
    JPSingleSelectModel(id: 'minute', label: 'minutes'.tr.capitalizeFirst!),
    JPSingleSelectModel(id: 'hour', label: 'hours'.tr.capitalizeFirst!),
    JPSingleSelectModel(id: 'day', label: 'days'.tr.capitalizeFirst!),
    JPSingleSelectModel(id: 'week', label: 'weeks'.tr.capitalizeFirst!),
  ];

  @override
  void onInit() {
    parseReminderToReminderFields();
    super.onInit();
  }

  void addReminderField() {

    if(remindersFields.length >= 5) return;

    remindersFields.add(
        ReminderFormData(
          reminderType: reminderType[0],
          durationType: durationType[0]
        )
    );

    reminders.add(remindersFields.last.toReminderModel());

    update();
  }

  void removeReminder(int index) {
    if(remindersFields.length == 1) onExpansionChanged(false);
    remindersFields.removeAt(index);
    reminders.removeAt(index);
    update();
  }

  void selectNotificationType(int index) {
    SingleSelectHelper.openSingleSelect(reminderType, remindersFields[index].reminderType.id, 'select'.tr , (value) {
      final selectedType = reminderType.firstWhere((reminder) => reminder.id == value);
      remindersFields[index].setType(selectedType);
      reminders[index] = remindersFields[index].toReminderModel();
      Get.back();
    });
  }

  void selectNotificationPeriod(int index) {
    SingleSelectHelper.openSingleSelect(durationType, remindersFields[index].durationType.id, 'select'.tr , (value) {
      final selectedType = durationType.firstWhere((duration) => duration.id == value);
      remindersFields[index].setDuration(selectedType);
      reminders[index] = remindersFields[index].toReminderModel();
      Get.back();
      update();
    });
  }

  bool validateForm({bool scrollOnValidation = true}) {
    final index = remindersFields.indexWhere((fields) => fields.valueController.text.trim().isEmpty);

    bool isValid = index < 0;

    if(!isValid) {
      canShowError = true;
      if(scrollOnValidation) remindersFields[index].valueController.scrollAndFocus();
      update();
    }

    return isValid;
  }

  void parseReminderToReminderFields() {
    
    for (var reminder in reminders) {

      JPSingleSelectModel reminderType = this.reminderType
          .firstWhere((tempReminder) => reminder.type == tempReminder.id);

      int totalMinutes = int.parse(reminder.minutes?.toString() ?? '1');

      String tempDurationType = RemainderTime().getReminderDurationType(totalMinutes);

      JPSingleSelectModel durationType = this.durationType
          .firstWhere((tempDuration) => tempDurationType == tempDuration.id);

      final value = RemainderTime().durationTypeToValue(totalMinutes, tempDurationType).toString();

      remindersFields.add(ReminderFormData(
        reminderType: reminderType,
        durationType: durationType,
        val: value
      ));
    }

    update();
  
  }

  void onToggle(bool val) {
    if(remindersFields.isEmpty && val) {
      addReminderField();
    }
    onExpansionChanged(val);
  }

  void onValueChanged(int index) {
    reminders[index] = remindersFields[index].toReminderModel();
    update();
  }

}

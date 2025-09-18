import 'package:jobprogress/common/models/reminder.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jobprogress/global_widgets/convert_remainder_time/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ReminderFormData {
  JPInputBoxController typeController = JPInputBoxController();
  JPInputBoxController valueController = JPInputBoxController();
  JPInputBoxController durationController = JPInputBoxController();

  late JPSingleSelectModel reminderType;
  late JPSingleSelectModel durationType;

  ReminderFormData({
    required this.reminderType,
    required this.durationType,
    String val = ""
  }) {
    valueController.text = val.trim();
    setType(reminderType);
    setDuration(durationType);
  }

  void setType(JPSingleSelectModel type) {
    reminderType = type;
    typeController.text = reminderType.label;
  }

  void setDuration(JPSingleSelectModel type) {
    durationType = type;
    durationController.text = durationType.label;
    validateAndSetReminderValue();
  }

  void validateAndSetReminderValue() {
    if (valueController.text.isEmpty) {
      valueController.text = '10';
    } else {
      valueController.text =
          FormValidator.setMaxAvailableFrequencyValue(
              durationType.id, valueController.text);
    }
  }

  ReminderModel toReminderModel() {

    final type = reminderType.id;
    final inMinutes = RemainderTime().getTypeToMinutes(valueController.text, durationType.id);

    return ReminderModel(
      minutes: inMinutes.toString(),
      type: type
    );
  }

}

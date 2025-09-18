import 'package:jobprogress/common/models/phone.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class PhoneFormData {
  JPInputBoxController phoneController = JPInputBoxController();
  JPInputBoxController phoneExtController = JPInputBoxController();
  String phoneTypes = '';
  int isPrime = 0;
  int id = 0;

  late JPSingleSelectModel phoneType;

  PhoneFormData({
    int id = 0,
    required this.phoneType,
    String val = "",
    String ext = '',
    int isPrime = 0,
  }) {
    id = id;
    phoneController.text = val.trim();
    phoneExtController.text = ext.trim();
    isPrime = isPrime;
    setType(phoneType);
  }

  void setType(JPSingleSelectModel type) {
    phoneType = type;
    phoneTypes = phoneType.label;
  }

  PhoneModel toPhoneModel() {

    final type = phoneType.label.toLowerCase();

    return PhoneModel(
      id: id,
      number: phoneController.text,
      ext: phoneExtController.text,
      label: type,
      isPrimary: isPrime,
    );
  }
}

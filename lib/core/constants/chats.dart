
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ChatsConstants {

  static double get maxMessageWidth => getMaxMessageWidth();

  static double timeWidth = 50;

  // SMS Type Constants
  static const String smsTypeConversations = 'SMS';
  static const String smsTypeAutomated = 'AUTOMATIVE_SMS';
  static const String smsTypeAll = 'ALL';

  static double getMaxMessageWidth() {
    switch (JPScreen.type) {
      case DeviceType.mobile:
        return JPScreen.width * 0.6;

      case DeviceType.tablet:
        return JPScreen.width * 0.5;

      case DeviceType.desktop:
        return JPScreen.width * 0.4;

    }
  }

}
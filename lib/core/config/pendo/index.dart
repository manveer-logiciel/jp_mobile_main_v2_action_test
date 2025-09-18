import 'package:jobprogress/core/constants/pendo.dart';

class PendoKeyConfig {
  static bool analyticsEnabled = true;

  static String get dev => PendoConstants.key;
  static String get qa => PendoConstants.key;
  static String get qaRc => PendoConstants.key;
  static String get prod => PendoConstants.key;
}
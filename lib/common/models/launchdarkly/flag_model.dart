import 'package:launchdarkly_flutter_client_sdk/launchdarkly_flutter_client_sdk.dart';

class LDFlagModel {
  /// [key] is used to uniquely identify a flag
  String key;

  /// [type] of the data that flag will return. It could be
  /// [BOOLEAN] or [STRING] or [NUMBER] or [ARRAY] or [OBJECT]
  LDValueType type;

  /// [defaultValue] is the default value of the flag when:
  /// - Launch Darkly SDK is not initialized yet
  /// - Flag is not defined in Launch Darkly
  dynamic defaultValue;

  /// [value] holds the actual value of the flag
  /// - It will be null if the flag is not defined in Launch Darkly
  /// - It will be null if Launch Darkly SDK is not initialized
  dynamic value;

  LDFlagModel({
    required this.key,
    required this.type,
    required this.defaultValue,
    this.value,
  });
}
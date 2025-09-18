import 'dart:async';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/launchdarkly/flag_model.dart';
import 'package:jobprogress/common/models/launchdarkly/flags.dart';
import 'package:jobprogress/common/services/launch_darkly/index.dart';

class FromLaunchDarklyController extends GetxController {

  FromLaunchDarklyController(this.flagKey);

  /// [flagKey] holds the key of the flag for listening changes on it
  final String flagKey;

  /// [subscription] is used to listen to flag changes
  StreamSubscription<dynamic>? subscription;

  /// [flagDetails] holds the details of the flag as per key
  LDFlagModel? flagDetails;

  @override
  void onInit() {
    setUpInitialFlagValue();
    super.onInit();
  }

  Future<void> setUpInitialFlagValue() async {
    // Looking for flag data in all flags
    flagDetails = LDFlags.allFlags[flagKey];
    // In case LD is not initialized yet or flag value is not available
    // Retrieving the flag value from LD
    if (LDService.isInitialized && flagDetails?.value == null) {
      flagDetails = await LDService.getFlagDetailsFromKey(flagKey);
    }
    // adding a listener to the flag value to get changes in real time
    addFlagValueListener();
  }

  void addFlagValueListener() {
    // cancelling any previous subscription
    subscription?.cancel();
    // creating a new subscription
    subscription = LDService.ldFlagsStream.stream.listen((event) {
      // filtering events for current flag only
      if (event.key == flagKey) {
        flagDetails = event;
        update();
      }
    });
  }

  /// [onDispose] is used to close the subscription
  void onDispose() {
    subscription?.cancel();
  }
}
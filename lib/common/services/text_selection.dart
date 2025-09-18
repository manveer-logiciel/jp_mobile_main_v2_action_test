import 'dart:async';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/launchdarkly/flag_model.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'launch_darkly/index.dart';

/// Service responsible for managing text selection settings across the application.
///
/// This service handles:
/// - Text selection feature flag integration
/// - Real-time updates when flag changes
/// - Global configuration for UI components
class TextSelectionService {
  /// Subscription to LaunchDarkly flag changes for text selection features
  static StreamSubscription<LDFlagModel>? _flagSubscription;

  /// Checks if text selection is enabled via LaunchDarkly feature flag.
  ///
  /// When disabled, text selection will be unavailable throughout the app.
  static bool get isTextSelectionEnabled {
    return LDService.hasFeatureEnabled(LDFlagKeyConstants.allowTextSelection);
  }

  /// Initializes the text selection service.
  ///
  /// Sets up feature flag listeners and configures the UI kit.
  /// Should be called during app startup after LaunchDarkly initialization.
  static Future<void> initialize() async {
    // Set up the UI kit configuration with callback for real-time updates
    TextSelectionConfig.setSelectionEnabledCallback(() {
      return isTextSelectionEnabled;
    });

    // Set up listener for flag changes
    setupFlagListener();
  }

  /// Sets up a listener for changes to the text selection feature flag.
  ///
  /// When the flag changes, this will automatically force a UI refresh
  /// to apply the new text selection behavior immediately.
  static void setupFlagListener() {
    // Cancel any existing subscription to avoid duplicates
    _flagSubscription?.cancel();

    // Listen for changes to the text selection flag
    _flagSubscription = LDService.ldFlagsStream.stream.listen((LDFlagModel flagModel) {
      if (flagModel.key == LDFlagKeyConstants.allowTextSelection) {
        // Force update the app to reflect the new text selection setting
        Get.forceAppUpdate();
      }
    });
  }

  /// Cleans up resources used by the text selection service.
  ///
  /// Should be called when the app is being terminated.
  static void dispose() {
    _flagSubscription?.cancel();
    _flagSubscription = null;
  }
}

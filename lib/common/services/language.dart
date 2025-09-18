import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:jobprogress/common/models/launchdarkly/flag_model.dart';
import 'package:jobprogress/common/services/pendo/index.dart';
import 'package:jobprogress/common/services/run_mode/index.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/core/constants/locale.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../core/constants/shared_pref_constants.dart';
import 'launch_darkly/index.dart';
import 'shared_pref.dart';

/// Service responsible for managing application language settings.
///
/// This service handles:
/// - Language selection and persistence
/// - Feature flag integration for language support
/// - Locale updates throughout the application
class LanguageService {

  /// Subscription to LaunchDarkly flag changes for language features
  static StreamSubscription<LDFlagModel>? _flagSubscription;

  /// Shared preferences service for persisting language settings
  static final SharedPrefService preferences = SharedPrefService();

  /// Returns the active locale for the application.
  ///
  /// If multiple languages are not enabled via feature flags,
  /// it will always return the USA locale regardless of device settings.
  static Locale get currentLocale => !isMultipleLanguagesEnabled
      ? LocaleConst.usa
      : (Get.locale ?? LocaleConst.usa);

  /// Returns the current language code as a string in format "languageCode_countryCode".
  ///
  /// This is useful for analytics and tracking purposes where a simple string
  /// representation of the locale is needed (e.g., "en_US", "es_US").
  static String get languageCode => "${currentLocale.languageCode}_${currentLocale.countryCode}";

  /// Available language options for the language selector.
  ///
  /// Includes device language and supported explicit language options.
  static List<JPSingleSelectModel> get languageList => [
        JPSingleSelectModel(id: "device", label: "use_device_language".tr),
        JPSingleSelectModel(id: "en_US", label: "English (US)"),
        JPSingleSelectModel(id: "es_US", label: "Spanish (US)"),
      ];

  /// Checks if multiple language support is enabled via LaunchDarkly feature flag.
  ///
  /// When disabled, the app will use only English (US) regardless of user preference.
  static bool get isMultipleLanguagesEnabled {
    return LDService.hasFeatureEnabled(LDFlagKeyConstants.allowMultipleLanguages);
  }

  /// Initializes the language service.
  ///
  /// Sets up feature flag listeners and applies stored language settings.
  /// Should be called during app startup.
  static Future<void> initialize() async {
    // Set up listener for flag changes
    setupFlagListener();

    // Initialize language settings
    await initializeLanguage();
  }

  /// Sets up a listener for changes to the multiple languages feature flag.
  ///
  /// When the flag changes, this will automatically update the app locale
  /// and force a UI refresh.
  static void setupFlagListener() {
    // Cancel any existing subscription to avoid duplicates
    _flagSubscription?.cancel();

    // Listen for changes to the language flag
    _flagSubscription = LDService.ldFlagsStream.stream.listen((LDFlagModel flagModel) {
      if (flagModel.key == LDFlagKeyConstants.allowMultipleLanguages) {
        // If the flag was disabled, make sure we use the default locale
        if (!isMultipleLanguagesEnabled) {
          updateLocale(LocaleConst.usa);
        } else {
          initializeLanguage();
        }

        // Force update the app to reflect the new setting
        Get.forceAppUpdate();
      }
    });
  }

  /// Cleans up resources used by the language service.
  ///
  /// Should be called when the app is being terminated.
  static void dispose() {
    _flagSubscription?.cancel();
    _flagSubscription = null;
  }

  /// Retrieves the currently selected language option.
  ///
  /// Returns null if multiple languages are not enabled.
  /// Otherwise returns the selected language from preferences or null if using device default.
  static Future<JPSingleSelectModel?> getCurrentLanguage() async {
    if (!isMultipleLanguagesEnabled) return null;

    String? savedLanguage = await preferences.read(PrefConstants.deviceLanguage);
    if (savedLanguage != null) {
      return languageList.firstWhereOrNull((element) => element.id == savedLanguage);
    }
    return LanguageService.languageList[0];
  }

  /// Sets the application language based on the provided language ID.
  ///
  /// If "device" is specified, it will use the device's locale.
  /// Otherwise, it will parse the language ID (e.g., "en_US") and apply that locale.
  /// No action is taken if multiple languages are not enabled.
  static Future<void> setLanguage(String languageId) async {
    if (!isMultipleLanguagesEnabled) return;

    if (languageId == languageList[0].id) {
      await preferences.remove(PrefConstants.deviceLanguage);
      await LanguageService.updateLocale(parseLocaleToUpdate(Get.deviceLocale ?? LocaleConst.usa));
    } else {
      await preferences.save(PrefConstants.deviceLanguage, languageId);
      final parts = languageId.split('_');
      await LanguageService.updateLocale(Locale(parts[0], parts[1]));
    }
  }

  /// Initializes the application language based on stored preferences.
  ///
  /// If no preference is stored or "device" is selected, uses the device locale.
  /// Otherwise applies the saved language preference.
  /// No action is taken if multiple languages are not enabled.
  static Future<void> initializeLanguage() async {
    if (!isMultipleLanguagesEnabled) return;

    String? savedLanguage = await preferences.read(PrefConstants.deviceLanguage);
    if (savedLanguage != null && savedLanguage != languageList[0].id) {
      final parts = savedLanguage.split('_');
      await LanguageService.updateLocale(Locale(parts[0], parts[1]));
    } else {
      await LanguageService.updateLocale(parseLocaleToUpdate(Get.deviceLocale ?? LocaleConst.usa));
    }
  }

  /// Updates the application locale and applies it to dependencies.
  ///
  /// Updates both the Jiffy date library locale and the GetX app locale.
  static Future<void> updateLocale(Locale locale) async {
    await Jiffy.setLocale(locale.languageCode);
    await Get.updateLocale(locale);
    if (!RunModeService.isUnitTestMode) {
      // tracking language change on Pendo
      await PendoService.updatedVisitorLanguage();
    }
  }

  static Locale parseLocaleToUpdate(Locale locale) {
    final deviceLocaleId = "${locale.languageCode}_${locale.countryCode}";
    final localeIndex = languageList.indexWhere((locale) => locale.id == deviceLocaleId) ;
    final localeToUpdate = localeIndex > 0 ? locale : LocaleConst.usa;
    return localeToUpdate;
  }
}

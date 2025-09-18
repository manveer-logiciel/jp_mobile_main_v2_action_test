import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/launchdarkly/flags.dart';
import 'package:jobprogress/common/services/language.dart';
import 'package:jobprogress/common/services/launch_darkly/index.dart';
import 'package:jobprogress/core/constants/locale.dart';
import 'package:jobprogress/core/constants/shared_pref_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    // Reset shared preferences for each test
    SharedPreferences.setMockInitialValues({});

    // Initialize Get
    Get.reset();
  });

  tearDown(() {
    // Reset Get
    Get.reset();
  });

  group("When accessing LanguageService static properties", () {
    test('LanguageService@languageList should return the expected list of languages', () {
      final languages = LanguageService.languageList;

      expect(languages.length, equals(3));
      expect(languages[0].id, equals('device'));
      expect(languages[1].id, equals('en_US'));
      expect(languages[2].id, equals('es_US'));
    });
  });

  group("When managing language preferences", () {
    test('LanguageService@getCurrentLanguage should retrieve saved language preference', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(PrefConstants.deviceLanguage, 'en_US');

      final result = await LanguageService.getCurrentLanguage();

      if (LanguageService.isMultipleLanguagesEnabled) {
        expect(result?.id, equals('en_US'));
      }
    });

    test('LanguageService@setLanguage should update preference for device language', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(PrefConstants.deviceLanguage, 'en_US');

      await LanguageService.setLanguage('device');

      if (LanguageService.isMultipleLanguagesEnabled) {
        expect(prefs.getString(PrefConstants.deviceLanguage), isNull);
      }
    });
  });

  group("LanguageService@currentLocale should give the locales conditionally", () {
    test("In case Multiple languages are not enabled, default locale should be [LocaleConst.usa]", () {
      LDService.ldFlagsStream.add(LDFlags.allowMultipleLanguages..value = false);
      expect(LanguageService.currentLocale, equals(LocaleConst.usa));
    });

    test("In case Multiple languages are enabled, default locale should be [Get.locale]", () {
      LDService.ldFlagsStream.add(LDFlags.allowMultipleLanguages..value = true);
      Get.locale = const Locale('es', 'US');
      expect(LanguageService.currentLocale, equals(const Locale('es', 'US')));
    });

    test("In case Multiple languages are enabled, default locale are not set, default locale should be [LocaleConst.usa]", () {
      LDService.ldFlagsStream.add(LDFlags.allowMultipleLanguages..value = true);
      Get.locale = null;
      expect(LanguageService.currentLocale, equals(LocaleConst.usa));
    });
  });

  group("LanguageService@languageCode should return formatted language string", () {
    test("Should return language code in format 'languageCode_countryCode'", () {
      LDService.ldFlagsStream.add(LDFlags.allowMultipleLanguages..value = false);
      expect(LanguageService.languageCode, equals('en_US'));
    });

    test("Should return correct language code when locale is changed", () {
      LDService.ldFlagsStream.add(LDFlags.allowMultipleLanguages..value = true);
      Get.locale = const Locale('es', 'US');
      expect(LanguageService.languageCode, equals('es_US'));
    });
  });

  group("LanguageService@isMultipleLanguagesEnabled should help in deciding if multiple languages are enabled", () {
    test("isMultipleLanguagesEnabled should be [true] if allowMultipleLanguages flag is enabled", () {
      LDService.ldFlagsStream.add(LDFlags.allowMultipleLanguages..value = true);
      expect(LanguageService.isMultipleLanguagesEnabled, isTrue);
    });

    test("isMultipleLanguagesEnabled should be [false] if allowMultipleLanguages flag is disabled", () {
      LDService.ldFlagsStream.add(LDFlags.allowMultipleLanguages..value = false);
      expect(LanguageService.isMultipleLanguagesEnabled, isFalse);
    });
  });

  group("Enhanced device locale handling", () {
    test('Language list should contain supported locales for validation', () {
      final languageList = LanguageService.languageList;

      // Verify that supported locales are in the list
      expect(languageList.any((lang) => lang.id == 'en_US'), isTrue);
      expect(languageList.any((lang) => lang.id == 'es_US'), isTrue);
      expect(languageList.any((lang) => lang.id == 'device'), isTrue);
    });

    test('Should handle language code format validation logic', () {
      // Test the device locale ID format logic used in initializeLanguage
      const testLocale = Locale('es', 'US');
      final deviceLocaleId = "${testLocale.languageCode}_${testLocale.countryCode}";
      expect(deviceLocaleId, equals('es_US'));

      // Test the index finding logic
      final languageList = LanguageService.languageList;
      final localeIndex = languageList.indexWhere((locale) => locale.id == deviceLocaleId);
      expect(localeIndex, greaterThan(0)); // Should find es_US in the list
    });
  });

  group("Pendo integration", () {
    test('Language code getter should provide correct format for Pendo', () {
      // Test that the language code is in the correct format for Pendo tracking
      final languageCode = LanguageService.languageCode;
      expect(languageCode, isA<String>());
      expect(languageCode, matches(RegExp(r'^[a-z]{2}_[A-Z]{2}$')));
    });
  });
}

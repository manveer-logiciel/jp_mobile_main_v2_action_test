
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/run_mode.dart';
import 'package:jobprogress/common/models/launchdarkly/flags.dart';
import 'package:jobprogress/common/services/language.dart';
import 'package:jobprogress/common/services/launch_darkly/index.dart';
import 'package:jobprogress/common/services/run_mode/index.dart';
import 'package:jobprogress/modules/settings/controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SettingController controller = SettingController();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    Get.reset();
    RunModeService.setRunMode(RunMode.unitTesting);
  });

  tearDown(() {
    Get.reset();
  });

  group('SettingController@loadLanguagePreference should set-up selected language', () {
    test("In case language is not set initially", () async {
      LDService.ldFlagsStream.add(LDFlags.allowMultipleLanguages..value = true);
      await LanguageService.setLanguage(LanguageService.languageList[0].id);
      await controller.loadLanguagePreference();
      expect(controller.selectedLanguage, isNotNull);
      expect(controller.selectedLanguage?.id, LanguageService.languageList[0].id);
    });

    test("In case language is set initially", () async {
      LDService.ldFlagsStream.add(LDFlags.allowMultipleLanguages..value = true);
      await LanguageService.setLanguage(LanguageService.languageList[1].id);
      await controller.loadLanguagePreference();
      expect(controller.selectedLanguage, isNotNull);
      expect(controller.selectedLanguage?.id, LanguageService.languageList[1].id);
    });
  });

  group("SettingController@updateLanguage should update the language when selected from dropdown", () {
    test("Selected Language should be updated to one selected from dropdown", () async {
      LDService.ldFlagsStream.add(LDFlags.allowMultipleLanguages..value = true);
      controller.selectedLanguage = LanguageService.languageList[0];
      await controller.updateLanguage(LanguageService.languageList[1].id);
      expect(controller.selectedLanguage?.id, LanguageService.languageList[1].id);
    });

    test("Setting update toggle should be enabled when setting is updated", () async {
      await controller.updateLanguage(LanguageService.languageList[1].id);
      expect(controller.isSettingUpdated, true);
    });

    test("Language update toggle should be disabled when setting is updated", () async {
      await controller.updateLanguage(LanguageService.languageList[1].id);
      expect(controller.isLanguageUpdating, false);
    });
  });
}
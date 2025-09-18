import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/common/services/company_settings.dart';

void main() {
  group('CompanySettingsService Tests', () {
    setUp(() {
      CompanySettingsService.companySettings = {};
    });

    test('setCompanySettings should populate companySettings map', () {
      List<dynamic> settings = [
        {'key': 'setting1', 'value': 'value1'},
        {'key': 'setting2', 'value': 'value2'}
      ];

      CompanySettingsService.setCompanySettings(settings);

      expect(CompanySettingsService.companySettings['setting1']['value'], 'value1');
      expect(CompanySettingsService.companySettings['setting2']['value'], 'value2');
    });

    test('getCompanySettingByKey should return the correct value', () {
      CompanySettingsService.companySettings = {
        'setting1': {'key': 'setting1', 'value': 'value1'}
      };

      var result = CompanySettingsService.getCompanySettingByKey('setting1');
      expect(result, 'value1');
    });

    test('updateCompanySettingByKey should update the value', () {
      CompanySettingsService.companySettings = {
        'setting1': {'key': 'setting1', 'value': 'value1'}
      };

      var result = CompanySettingsService.updateCompanySettingByKey('setting1', 'newValue');
      expect(result, true);
      expect(CompanySettingsService.companySettings['setting1']['value'], 'newValue');
    });

    test('removeSettings should clear the companySettings map', () {
      CompanySettingsService.companySettings = {
        'setting1': {'key': 'setting1', 'value': 'value1'}
      };

      CompanySettingsService.removeSettings();
      expect(CompanySettingsService.companySettings.isEmpty, true);
    });

    test('addOrReplaceCompanySetting should add or replace a setting', () {
      CompanySettingsService.addOrReplaceCompanySetting('setting1', {'key': 'setting1', 'value': 'value1'});
      expect(CompanySettingsService.companySettings['setting1']['value'], 'value1');

      CompanySettingsService.addOrReplaceCompanySetting('setting1', {'key': 'setting1', 'value': 'newValue'});
      expect(CompanySettingsService.companySettings['setting1']['value'], 'newValue');
    });

    test('mapDivisionCompanySettingsWithGlobalSettings should map division settings correctly', () {
      List<dynamic> divisionSettings = [
        {'key': CompanySettingConstants.defaultPaymentOption, 'value': 'Credit Card'},
        {'key': 'otherSetting', 'value': 'value'}
      ];

      CompanySettingsService.mapDivisionCompanySettingsWithGlobalSettings(divisionSettings);

      expect(CompanySettingsService.companySettings[CompanySettingConstants.defaultPaymentOption]['value'], 'Credit Card');
      expect(CompanySettingsService.companySettings.containsKey('otherSetting'), false);
    });
  });
}
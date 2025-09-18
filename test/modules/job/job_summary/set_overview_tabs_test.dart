import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/run_mode.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/common/services/run_mode/index.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/job_overview.dart';
import 'package:jobprogress/core/constants/locale.dart';
import 'package:jobprogress/modules/job/job_summary/controller.dart';
import 'package:jobprogress/translations/index.dart';

void main() {
  group('JobSummaryController@setOverviewTabs should parse data correctly', () {
    late JobSummaryController controller;

    // Initialize GetX and set up test environment
    setUpAll(() {
      WidgetsFlutterBinding.ensureInitialized();
      Get.testMode = true;
      Get.addTranslations(JPTranslations().keys);
      Get.locale = LocaleConst.usa;
      RunModeService.setRunMode(RunMode.unitTesting);
    });

    setUp(() {
      controller = JobSummaryController();
      controller.tabController = TabController(length: 3, vsync: const TestVSync());
    });

    test('should set default sections when there are no company settings', () {
      // Mock the company settings to return null
      CompanySettingsService.setCompanySettings([]);

      // Call the method being tested
      controller.setOverviewTabs();

      // Verify it sets default sections
      expect(controller.sectionItems.length, 3);
      expect(controller.sectionItems[0].key, JobOverviewConstants.job);
      expect(controller.sectionItems[1].key, JobOverviewConstants.customer);
      expect(controller.sectionItems[2].key, JobOverviewConstants.contactPersons);

      // Default tabs should have job selected (first tab)
      expect(controller.tabController.index, 0);
    });

    test('should use settings from company settings when available', () {
      // Create test company settings
      final customSections = [
        {
          'key': JobOverviewConstants.customer,
          'name': 'Customer',
          'selected': true
        },
        {'key': JobOverviewConstants.job, 'name': 'Job', 'selected': false}
      ];

      final companySettings = [
        {
          'key': CompanySettingConstants.userDefaultSettings,
          'value': {
            'job_overview': {
              'customize': {'left_section': customSections}
            }
          }
        }
      ];

      CompanySettingsService.setCompanySettings(companySettings);

      // Call the method being tested
      controller.setOverviewTabs();

      // Verify it uses the custom sections from settings
      expect(controller.sectionItems.length, 3); // 2 from settings + contact person
      expect(controller.sectionItems[0].key, JobOverviewConstants.customer);
      expect(controller.sectionItems[0].selected, true);
      expect(controller.sectionItems[1].key, JobOverviewConstants.job);
      expect(controller.sectionItems[1].selected, false);
      expect(controller.sectionItems[2].key, JobOverviewConstants.contactPersons);

      // Should animate to the selected tab (customer, index 0)
      expect(controller.tabController.index, 0);
    });

    test('should fallback to default sections on error', () {
      // Mock company settings to throw an error when accessed
      CompanySettingsService.setCompanySettings([
        {
          'key': CompanySettingConstants.userDefaultSettings,
          'value': null // will cause an error when accessing nested properties
        }
      ]);

      // Call the method being tested
      controller.setOverviewTabs();

      // Should fall back to default sections
      expect(controller.sectionItems.length, 3);
      expect(controller.sectionItems[0].key, JobOverviewConstants.job);
      expect(controller.sectionItems[1].key, JobOverviewConstants.customer);
      expect(controller.sectionItems[2].key, JobOverviewConstants.contactPersons);
    });

    test('should animate to the first selected tab', () {
      // Create test company settings with job as selected (index 1)
      final customSections = [
        {
          'key': JobOverviewConstants.customer,
          'name': 'Customer',
          'selected': false
        },
        {'key': JobOverviewConstants.job, 'name': 'Job', 'selected': true}
      ];

      final companySettings = [
        {
          'key': CompanySettingConstants.userDefaultSettings,
          'value': {
            'job_overview': {
              'customize': {'left_section': customSections}
            }
          }
        }
      ];

      CompanySettingsService.setCompanySettings(companySettings);

      // Call the method being tested
      controller.setOverviewTabs();

      // Should animate to the job tab (index 1)
      expect(controller.tabController.index, 1);
    });
  });
}

// Test implementation of TickerProvider for TabController
class TestVSync extends TickerProvider {
  const TestVSync();

  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick, debugLabel: 'created by TestVSync');
  }
}

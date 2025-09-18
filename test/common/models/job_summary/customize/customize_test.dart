import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job_summary/customize/customize.dart';
import 'package:jobprogress/common/models/job_summary/customize/section_item.dart';
import 'package:jobprogress/core/constants/job_overview.dart';
import 'package:jobprogress/core/constants/locale.dart';
import 'package:jobprogress/translations/index.dart';

void main() {
  group('JobOverviewCustomize model should handle parsing correctly', () {
    // Initialize translation for tests
    setUpAll(() {
      Get.testMode = true;
      Get.addTranslations(JPTranslations().keys);
      Get.locale = LocaleConst.usa;
    });

    test('should create instance with provided section items', () {
      final leftSection = [
        JobOverviewSectionItem(
          key: 'test_key',
          name: 'Test Name',
          selected: true,
        )
      ];

      final customize = JobOverviewCustomize(leftSection: leftSection);

      expect(customize.leftSection, leftSection);
    });

    test('should have a list of allowed section keys for filtering', () {
      expect(JobOverviewCustomize.allowedSections, [
        JobOverviewConstants.customer,
        JobOverviewConstants.job,
        JobOverviewConstants.contactPersons,
      ]);
    });

    group('JobOverviewCustomize@fromJson factory method', () {
      test('should parse JSON data and create an instance with properly ordered sections', () {
        final json = {
          'left_section': [
            {
              'key': JobOverviewConstants.customer,
              'name': 'Customer',
              'selected': true
            },
            {'key': JobOverviewConstants.job, 'name': 'Job', 'selected': false}
          ]
        };

        final customize = JobOverviewCustomize.fromJson(json);

        // Two items from JSON plus the contact person item that's automatically added
        expect(customize.leftSection.length, 3);

        // First item should be customer from JSON
        expect(customize.leftSection[0].key, JobOverviewConstants.customer);
        expect(customize.leftSection[0].name, 'Customer');
        expect(customize.leftSection[0].selected, true);
        expect(customize.leftSection[0].index, 0);

        // Second item should be job from JSON
        expect(customize.leftSection[1].key, JobOverviewConstants.job);
        expect(customize.leftSection[1].name, 'Job');
        expect(customize.leftSection[1].selected, false);
        expect(customize.leftSection[1].index, 1);

        // Third item should be the auto-added contact person
        expect(customize.leftSection[2].key, JobOverviewConstants.contactPersons);
        expect(customize.leftSection[2].index, 2);
      });

      test('should fall back to default sections when JSON is null', () {
        final customize = JobOverviewCustomize.fromJson(null);

        expect(customize.leftSection.length, 3);
        expect(customize.leftSection[0].key, JobOverviewConstants.job);
        expect(customize.leftSection[1].key, JobOverviewConstants.customer);
        expect(customize.leftSection[2].key, JobOverviewConstants.contactPersons);
      });

      test('should fall back to default sections when JSON is not a Map object', () {
        const nonMapValue = null; // This will fail the json is Map check

        final customize = JobOverviewCustomize.fromJson(nonMapValue);

        expect(customize.leftSection.length, 3);
        expect(customize.leftSection[0].key, JobOverviewConstants.job);
        expect(customize.leftSection[1].key, JobOverviewConstants.customer);
        expect(customize.leftSection[2].key, JobOverviewConstants.contactPersons);
      });

      test('should fall back to default sections when left_section is not a List', () {
        final json = {'left_section': 'not a list'};
        final customize = JobOverviewCustomize.fromJson(json);

        expect(customize.leftSection.length, 3);
        expect(customize.leftSection[0].key, JobOverviewConstants.job);
        expect(customize.leftSection[1].key, JobOverviewConstants.customer);
        expect(customize.leftSection[2].key, JobOverviewConstants.contactPersons);
      });

      test('should filter out non-allowed section keys from the provided JSON', () {
        final json = {
          'left_section': [
            {
              'key': JobOverviewConstants.customer,
              'name': 'Customer',
              'selected': true
            },
            {
              'key': 'invalid_section',
              'name': 'Invalid Section',
              'selected': true
            }
          ]
        };

        final customize = JobOverviewCustomize.fromJson(json);

        // One valid item from JSON plus the contact person item that's automatically added
        expect(customize.leftSection.length, 2);
        expect(customize.leftSection[0].key, JobOverviewConstants.customer);
        expect(customize.leftSection[1].key, JobOverviewConstants.contactPersons);

        // Should not contain the invalid section
        expect(customize.leftSection.any((item) => item.key == 'invalid_section'), false);
      });

      test('should assign sequential indices to all section items', () {
        final json = {
          'left_section': [
            {
              'key': JobOverviewConstants.customer,
              'name': 'Customer',
              'selected': true
            },
            {'key': JobOverviewConstants.job, 'name': 'Job', 'selected': false}
          ]
        };

        final customize = JobOverviewCustomize.fromJson(json);

        for (int i = 0; i < customize.leftSection.length; i++) {
          expect(customize.leftSection[i].index, i);
        }
      });
    });
  });
}

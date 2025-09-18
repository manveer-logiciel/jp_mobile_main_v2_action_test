import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job_summary/customize/customize.dart';
import 'package:jobprogress/common/models/job_summary/customize/section_item.dart';
import 'package:jobprogress/common/models/job_summary/customize/settings.dart';
import 'package:jobprogress/core/constants/job_overview.dart';
import 'package:jobprogress/core/constants/locale.dart';
import 'package:jobprogress/translations/index.dart';

void main() {
  group('JobOverviewCustomizeSettings model should parse data correctly', () {
    // Initialize translation for tests
    setUpAll(() {
      Get.testMode = true;
      Get.addTranslations(JPTranslations().keys);
      Get.locale = LocaleConst.usa;
    });

    test('should create an instance with a provided customize object', () {
      final customize = JobOverviewCustomize(
        leftSection: JobOverviewSectionItem.defaultSections,
      );

      final settings = JobOverviewCustomizeSettings(customize: customize);

      expect(settings.customize, customize);
    });

    test('should accept null customize parameter without error', () {
      final settings = JobOverviewCustomizeSettings(customize: null);

      expect(settings.customize, null);
    });

    group('fromJson factory method', () {
      test('should parse a complete JSON object with nested customize data', () {
        final json = {
          'customize': {
            'left_section': [
              {
                'key': JobOverviewConstants.customer,
                'name': 'Customer',
                'selected': true
              },
              {
                'key': JobOverviewConstants.job,
                'name': 'Job',
                'selected': false
              }
            ]
          }
        };

        final settings = JobOverviewCustomizeSettings.fromJson(json);

        expect(settings.customize, isNotNull);
        expect(settings.customize!.leftSection.length, 3); // 2 items + contact person
        expect(settings.customize!.leftSection[0].key, JobOverviewConstants.customer);
        expect(settings.customize!.leftSection[1].key, JobOverviewConstants.job);
        expect(settings.customize!.leftSection[2].key, JobOverviewConstants.contactPersons);
      });

      test('should create default customize object with standard sections when given null JSON', () {
        final settings = JobOverviewCustomizeSettings.fromJson(null);

        expect(settings.customize, isNotNull);
        expect(settings.customize!.leftSection.length, 3);
        expect(settings.customize!.leftSection[0].key, JobOverviewConstants.job);
        expect(settings.customize!.leftSection[1].key, JobOverviewConstants.customer);
        expect(settings.customize!.leftSection[2].key, JobOverviewConstants.contactPersons);
      });

      test('should create default customize object when JSON is missing the customize field', () {
        final json = {'other_field': 'value'};

        final settings = JobOverviewCustomizeSettings.fromJson(json);

        expect(settings.customize, isNotNull);
        expect(settings.customize!.leftSection.length, 3);
        expect(settings.customize!.leftSection[0].key, JobOverviewConstants.job);
        expect(settings.customize!.leftSection[1].key, JobOverviewConstants.customer);
        expect(settings.customize!.leftSection[2].key, JobOverviewConstants.contactPersons);
      });

      test('should create default customize object when customize field is null in JSON', () {
        final json = {'customize': null};

        final settings = JobOverviewCustomizeSettings.fromJson(json);

        expect(settings.customize, isNotNull);
        expect(settings.customize!.leftSection.length, 3);
        expect(settings.customize!.leftSection[0].key, JobOverviewConstants.job);
        expect(settings.customize!.leftSection[1].key, JobOverviewConstants.customer);
        expect(settings.customize!.leftSection[2].key, JobOverviewConstants.contactPersons);
      });
    });
  });
}

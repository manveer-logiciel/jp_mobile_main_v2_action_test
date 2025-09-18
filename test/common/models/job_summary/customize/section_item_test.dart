import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job_summary/customize/section_item.dart';
import 'package:jobprogress/core/constants/job_overview.dart';
import 'package:jobprogress/core/constants/locale.dart';
import 'package:jobprogress/translations/index.dart';

void main() {
  group('JobOverviewSectionItem model should parse data correctly', () {
    // Initialize translation for tests
    setUpAll(() {
      Get.testMode = true;
      Get.addTranslations(JPTranslations().keys);
      Get.locale = LocaleConst.usa;
    });

    test('should create an instance with all required parameters properly set', () {
      final item = JobOverviewSectionItem(
        key: 'test_key',
        name: 'Test Name',
        selected: true,
        index: 5,
      );

      expect(item.key, 'test_key');
      expect(item.name, 'Test Name');
      expect(item.selected, true);
      expect(item.index, 5);
    });

    test('should default index to 0 when not explicitly provided', () {
      final item = JobOverviewSectionItem(
        key: 'test_key',
        name: 'Test Name',
        selected: true,
      );

      expect(item.index, 0);
    });

    test('JobOverviewSectionItem@should provide a preconfigured Contact Person item with correct default values', () {
      final contactPerson = JobOverviewSectionItem.contactPersonItem;

      expect(contactPerson.key, JobOverviewConstants.contactPersons);
      expect(contactPerson.name, 'contact_person'.tr);
      expect(contactPerson.selected, false);
      expect(contactPerson.index, 2);
    });

    test('should provide defaultSections with Job, Customer, and Contact Person in correct order', () {
      final defaults = JobOverviewSectionItem.defaultSections;

      expect(defaults.length, 3);

      // Job should be first
      expect(defaults[0].key, JobOverviewConstants.job);
      expect(defaults[0].name, 'job'.tr);
      expect(defaults[0].selected, true);
      expect(defaults[0].index, 0);

      // Customer should be second
      expect(defaults[1].key, JobOverviewConstants.customer);
      expect(defaults[1].name, 'customer'.tr);
      expect(defaults[1].selected, false);
      expect(defaults[1].index, 1);

      // Contact Person should be third
      expect(defaults[2].key, JobOverviewConstants.contactPersons);
      expect(defaults[2].name, 'contact_person'.tr);
      expect(defaults[2].selected, false);
      expect(defaults[2].index, 2);
    });

    group('fromJson factory method', () {
      test('should create valid instance when given complete JSON data', () {
        final json = {'key': 'test_key', 'name': 'Test Name', 'selected': true};

        final item = JobOverviewSectionItem.fromJson(json);

        expect(item.key, 'test_key');
        expect(item.name, 'Test Name');
        expect(item.selected, true);
      });

      test('should handle null JSON by providing safe default values', () {
        final item = JobOverviewSectionItem.fromJson(null);

        expect(item.key, '');
        expect(item.name, '');
        expect(item.selected, false);
      });

      test('should handle incomplete JSON objects by providing defaults for missing fields', () {
        final json = {'random_field': 'value'};

        final item = JobOverviewSectionItem.fromJson(json);

        expect(item.key, '');
        expect(item.name, '');
        expect(item.selected, false);
      });
    });
  });
}

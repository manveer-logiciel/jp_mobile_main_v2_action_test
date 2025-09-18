import 'package:get/get.dart';
import 'package:jobprogress/core/constants/job_overview.dart';
import 'package:jobprogress/core/utils/helpers.dart';

/// A class representing a section item in the job overview customization.
///
/// This class defines the structure and properties of individual sections
/// that can be displayed in the job overview screen.
class JobOverviewSectionItem {
  /// Unique identifier for the section item.
  final String key;
  
  /// Display name of the section, often translated.
  final String name;
  
  /// Whether this section is selected for display.
  /// Can be null if selection state is not specified.
  final bool? selected;
  
  /// Position index of this section in the display order.
  int index;

  /// Creates a new instance of [JobOverviewSectionItem].
  ///
  /// [key] Unique identifier for the section.
  /// [name] Display name of the section.
  /// [selected] Optional selection state.
  /// [index] Optional position index, defaults to 0.
  JobOverviewSectionItem({
    required this.key,
    required this.name,
    this.selected,
    this.index = 0,
  });

  /// Pre-configured contact person section item.
  ///
  /// This getter provides a standardized contact person section
  /// with predefined properties.
  static JobOverviewSectionItem get contactPersonItem => JobOverviewSectionItem(
        key: JobOverviewConstants.contactPersons,
        name: 'contact_person'.tr,
        selected: false,
        index: 2,
      );

  /// Default set of section items for the job overview.
  ///
  /// Returns a list containing the standard sections in their
  /// default order: job, customer, and contact persons.
  static List<JobOverviewSectionItem> get defaultSections {
    return [
      JobOverviewSectionItem(
        key: JobOverviewConstants.job,
        name: 'job'.tr,
        selected: true,
        index: 0,
      ),
      JobOverviewSectionItem(
        key: JobOverviewConstants.customer,
        name: 'customer'.tr,
        selected: false,
        index: 1,
      ),
      contactPersonItem,
    ];
  }

  /// Creates a [JobOverviewSectionItem] from JSON data.
  ///
  /// [json] The JSON map containing section item data.
  /// Returns a new [JobOverviewSectionItem] instance.
  /// If JSON is null or missing fields, provides default values.
  factory JobOverviewSectionItem.fromJson(Map<String, dynamic>? json) {
    return JobOverviewSectionItem(
      key: json?['key'] ?? '',
      name: json?['name'] ?? '',
      selected: Helper.isTrue(json?['selected']), // stays nullable
    );
  }
}
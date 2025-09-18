import 'package:jobprogress/common/models/job_summary/customize/section_item.dart';
import 'package:jobprogress/core/constants/job_overview.dart';

/// A class that manages the customization of job overview sections.
/// 
/// This class is responsible for handling the layout and configuration
/// of sections displayed in the job overview screen.
class JobOverviewCustomize {
  /// The list of section items to be displayed in the left section of the job overview.
  final List<JobOverviewSectionItem> leftSection;

  /// Creates a new instance of [JobOverviewCustomize].
  /// 
  /// Requires a list of [JobOverviewSectionItem] for the left section.
  JobOverviewCustomize({required this.leftSection});

  /// List of section keys that are allowed to be displayed in the job overview.
  /// 
  /// This restricts which sections can be included in the customization.
  static const List<String> allowedSections = [
    JobOverviewConstants.customer,
    JobOverviewConstants.job,
    JobOverviewConstants.contactPersons,
  ];

  /// Creates a [JobOverviewCustomize] instance from JSON data.
  /// 
  /// If the provided JSON is null or invalid, default sections will be used.
  /// 
  /// [json] The JSON map containing customization data.
  /// Returns a new [JobOverviewCustomize] instance.
  factory JobOverviewCustomize.fromJson(Map<String, dynamic>? json) {
    return JobOverviewCustomize(
      leftSection: json is Map
          ? filterLeftSection(json!['left_section']) // Extract and process left_section from JSON
          : JobOverviewSectionItem.defaultSections, // Use defaults if JSON is invalid
    );
  }

  /// Filters and processes the left section data from JSON.
  /// 
  /// This method:
  /// 1. Parses the section items from JSON
  /// 2. Filters out any sections not in the allowed list
  /// 3. Adds the contact person item
  /// 4. Assigns index values to each item
  /// 5. Returns default sections if the result is empty
  /// 
  /// [leftSection] The raw left section data from JSON.
  /// Returns a processed list of [JobOverviewSectionItem].
  static List<JobOverviewSectionItem> filterLeftSection(dynamic leftSection) {
    List<JobOverviewSectionItem> parsedLeftSection = [];

    if (leftSection is List) {
      // Process only if leftSection is a List
      parsedLeftSection = leftSection
          .whereType<Map<String, dynamic>>()
          .map(JobOverviewSectionItem.fromJson)
          .where((item) => allowedSections.contains(item.key))
          .toList();

      // Always add contact person item to the sections
      parsedLeftSection.add(JobOverviewSectionItem.contactPersonItem);
    }

    // Assign sequential index values to each section item
    for (int i = 0; i < parsedLeftSection.length; i++) {
      parsedLeftSection[i].index = i;
    }

    // Return default sections if no valid sections were found
    return parsedLeftSection.isEmpty ? JobOverviewSectionItem.defaultSections : parsedLeftSection;
  }
}

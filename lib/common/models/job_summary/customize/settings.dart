import 'customize.dart';

class JobOverviewCustomizeSettings {
  final JobOverviewCustomize? customize;

  JobOverviewCustomizeSettings({required this.customize});

  factory JobOverviewCustomizeSettings.fromJson(Map<String, dynamic>? json) {
    return JobOverviewCustomizeSettings(
      customize: JobOverviewCustomize.fromJson(json?['customize']),
    );
  }
}

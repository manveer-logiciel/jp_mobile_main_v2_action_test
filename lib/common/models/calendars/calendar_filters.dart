import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';

class CalendarFilterModel {
  List<String>? users;
  List<String>? divisionIds;
  List<String>? categoryIds;
  List<String>? jobRepIds;
  List<String>? subIds;
  List<String>? trades;
  List<String>? jobFlagIds;
  List<String>? cities;
  String? view;
  String? showTimelineView;
  late String name;
  late String key;
  late int userId;
  int? companyId;
  late bool isScheduleHidden;
  String? customerName;
  List<String>? workTypeIds;

  CalendarFilterModel(
      {this.name = CompanySettingConstants.stCalOpt,
      this.key = CompanySettingConstants.stCalOpt,
      this.users,
      this.divisionIds,
      this.categoryIds,
      this.jobRepIds,
      this.subIds,
      this.trades,
      this.jobFlagIds,
      this.cities,
      this.view,
      this.showTimelineView,
      this.isScheduleHidden = true,
      this.customerName,
      this.workTypeIds});

  factory CalendarFilterModel.copy(CalendarFilterModel source) {
    return CalendarFilterModel(
      customerName: source.customerName,
      categoryIds: source.categoryIds,
      cities: source.cities,
      divisionIds: source.divisionIds,
      isScheduleHidden: source.isScheduleHidden,
      jobFlagIds: source.jobFlagIds,
      jobRepIds: source.jobRepIds,
      showTimelineView: source.showTimelineView,
      subIds: source.subIds,
      trades: source.trades,
      users: source.users,
      view: source.view,
      workTypeIds: source.workTypeIds,
    );
  }

  CalendarFilterModel.fromJson(dynamic json) {
    userId = AuthService.userDetails!.id;
    companyId = AuthService.userDetails!.companyId;

    if(json is! Map) {
      isScheduleHidden = true;
      return;
    }

    users = parseToStringList(json['users']);
    divisionIds = parseToStringList(json['division_ids']);
    categoryIds = parseToStringList(json['category_ids']);
    jobRepIds = parseToStringList(json['job_rep_ids']);
    subIds = parseToStringList(json['sub_ids']);
    trades = parseToStringList(json['trades']);
    jobFlagIds = parseToStringList(json['job_flag_ids']);
    cities = json['cities']?.cast<String>();
    view = json['view'];
    showTimelineView = json['showTimelineView'];
    dynamic val = CompanySettingsService.getCompanySettingByKey(
        CompanySettingConstants.staffCalendarHideSchedule);
    val = val is Map ? val['hide_schedules'] : <String, dynamic>{};
    isScheduleHidden = int.tryParse((val ?? '0').toString()) == 0;
    customerName = json['customer_name'] ?? "";
    workTypeIds = parseToStringList(json['work_types']);
  }

  Map<String, dynamic> toJson(
      {bool isForSchedules = false, bool isForProductionCalendar = false}) {
    final Map<String, dynamic> data = {};
    
    if (isForSchedules) {
      dynamic val = CompanySettingsService.getCompanySettingByKey(
          CompanySettingConstants.staffCalendarHideSchedule, onlyValue: false);
      data['key'] = CompanySettingConstants.staffCalendarHideSchedule;
      data['name'] = CompanySettingConstants.staffCalendarHideSchedule;
      data['id'] = val is Map ? val['id'] : null;
      data['value[hide_schedules]'] = isScheduleHidden ? 0 : 1;
    } else {
      dynamic localFilters = CompanySettingsService.getCompanySettingByKey(
          isForProductionCalendar
              ? CompanySettingConstants.productionCalendarFilter
              : CompanySettingConstants.stCalOpt,
          onlyValue: false);
      localFilters = localFilters is Map ? localFilters : <String,dynamic>{};
      data['id'] = localFilters['id'];
      if (users != null && users!.isNotEmpty) {
        data['value[users][]'] = users;
      }
      if (divisionIds != null && divisionIds!.isNotEmpty) {
        data['value[division_ids][]'] = divisionIds;
      }
      if (categoryIds != null && categoryIds!.isNotEmpty) {
        data['value[category_ids][]'] = categoryIds;
      }
      if (jobRepIds != null && jobRepIds!.isNotEmpty) {
        data['value[job_rep_ids][]'] = jobRepIds;
      }
      if (subIds != null && subIds!.isNotEmpty) {
        data['value[sub_ids][]'] = subIds;
      }
      if (trades != null && trades!.isNotEmpty) {
        data['value[trades][]'] = trades;
      }
      if (jobFlagIds != null && jobFlagIds!.isNotEmpty) {
        data['value[job_flag_ids][]'] = jobFlagIds;
      }
      if (cities != null && cities!.isNotEmpty) {
        data['value[cities][]'] = cities;
      }
      if (workTypeIds != null && workTypeIds!.isNotEmpty) {
        data['value[work_types][]'] = workTypeIds;
      }
      data['key'] = data['name'] = isForProductionCalendar
          ? CompanySettingConstants.productionCalendarFilter
          : CompanySettingConstants.stCalOpt;
      data['value[view]'] = 'month';
      if (isForProductionCalendar) {
        data['value[customer_name]'] = customerName;
        data['value[apply_on_jobs]'] = localFilters['apply_on_jobs'] ?? '0';
        data['value[stage]'] = localFilters['stage'];
      } else {
        data['value[showTimelineView]'] = '0';
      }
    }
    data['user_id'] = AuthService.userDetails!.id;
    data['company_id'] = AuthService.userDetails!.companyDetails?.id;
    return data;
  }

  List<String> parseToStringList(dynamic json) {
    List<String> list = [];
    if (json is String) {
      json = [json];
    }
    for (var element in json ?? []) {
      list.add(element.toString());
    }
    return list;
  }

  Map<String, dynamic> toColorSchemeJson(
      {required String selectedColorScheme}) {
    final Map<String, dynamic> data = {};

    data['key'] = CompanySettingConstants.productionCalendarColorOrder;
    data['name'] = CompanySettingConstants.productionCalendarColorOrder
        .replaceAll("_", " ");
    data['user_id'] = AuthService.userDetails?.id;
    data['company_id'] = AuthService.userDetails?.companyDetails?.id;
    data['value'] = selectedColorScheme;

    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarFilterModel &&
          runtimeType == other.runtimeType &&
          users == other.users &&
          divisionIds == other.divisionIds &&
          categoryIds == other.categoryIds &&
          jobRepIds == other.jobRepIds &&
          subIds == other.subIds &&
          trades == other.trades &&
          jobFlagIds == other.jobFlagIds &&
          cities == other.cities &&
          view == other.view &&
          showTimelineView == other.showTimelineView &&
          companyId == other.companyId &&
          isScheduleHidden == other.isScheduleHidden &&
          customerName == other.customerName &&
          workTypeIds == other.workTypeIds;

  @override
  int get hashCode =>
      users.hashCode ^
      divisionIds.hashCode ^
      categoryIds.hashCode ^
      jobRepIds.hashCode ^
      subIds.hashCode ^
      trades.hashCode ^
      jobFlagIds.hashCode ^
      cities.hashCode ^
      view.hashCode;
}

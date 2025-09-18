import 'package:flutter/foundation.dart';
import 'package:jobprogress/common/enums/calendars.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import 'calendar_filters.dart';

class CalendarsRequestParams {
  late String duration;
  late String forWhom;
  late int limit;
  late String startDate;
  late String endDate;
  late DateTime date;
  List<JPMultiSelectModel>? users;
  List<JPMultiSelectModel>? tags;
  List<JPMultiSelectModel>? divisions;
  List<JPMultiSelectModel>? category;
  List<JPMultiSelectModel>? companyCrew;
  List<JPMultiSelectModel>? labourSub;
  List<JPMultiSelectModel>? tradeTypes;
  List<JPMultiSelectModel>? jobFlag;
  List<JPMultiSelectModel>? city;
  List<JPMultiSelectModel>? workTypes;
  String? customerName;
  CalendarFilterModel? filter;
  bool? canSelectOtherUsers;
  int? jobId;
  bool areCategoriesLoaded = false;

  CalendarsRequestParams({
    this.duration = "date",
    this.forWhom = "users",
    this.limit = 0,
    this.users,
    this.tags,
    this.divisions,
    this.category,
    this.companyCrew,
    this.labourSub,
    this.tradeTypes,
    this.jobFlag,
    this.city,
    this.filter,
    this.customerName,
    this.workTypes,
    this.canSelectOtherUsers = true,
    this.jobId
  }) {
    final tempDateTime = DateTime.now();
    date = DateTime(tempDateTime.year, tempDateTime.month);
    setStartEndDate(date);
  }

  factory CalendarsRequestParams.copy(CalendarsRequestParams param) {
    return CalendarsRequestParams(
      users: param.users,
      tags: param.tags,
      divisions: param.divisions,
      category: param.category,
      city: param.city,
      companyCrew: param.companyCrew,
      forWhom: param.forWhom,
      jobFlag: param.jobFlag,
      labourSub: param.labourSub,
      limit: param.limit,
      tradeTypes: param.tradeTypes,
      duration: param.duration,
      filter: param.filter,
      customerName: param.customerName,
      workTypes: param.workTypes,
    )
      ..date = param.date
      ..startDate = param.startDate
      ..endDate = param.endDate;
  }

  CalendarsRequestParams.fromJson(Map<String, dynamic> json) {
    duration = json['duration'];
    endDate = json['end_date'];
    forWhom = json['for'];
    limit = json['limit'];
    startDate = json['start_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    final startDateTime = DateTime.tryParse(startDate)?.subtract(const Duration(days: 1)) ?? startDate;
    data['duration'] = duration;
    data['end_date'] = endDate;
    data['end_date_time'] = endDate;
    data['for'] = forWhom;
    data['limit'] = limit;
    data['start_date'] = startDateTime;
    data['start_date_time'] = startDateTime;
    if(jobId != null) data['job_ids'] = jobId;
    data['users[]'] = canSelectOtherUsers!
        ? (Helper.isValueNullOrEmpty(filter?.users) ? [AuthService.userDetails?.id.toString()] : filter?.users)
        : [AuthService.userDetails?.id.toString()];
    if (filter?.divisionIds?.isNotEmpty ?? false) {
      data['division_ids[]'] = filter?.divisionIds;
    }
    if (filter?.categoryIds?.isNotEmpty ?? false) {
      data['category_ids[]'] = filter?.categoryIds;
    }
    if (filter?.cities?.isNotEmpty ?? false) {
      data['cities[]'] = filter?.cities;
    }
    if (filter?.jobFlagIds?.isNotEmpty ?? false) {
      data['job_flag_ids[]'] = filter?.jobFlagIds;
    }
    if (filter?.jobRepIds?.isNotEmpty ?? false) {
      data['job_rep_ids[]'] = filter?.jobRepIds;
    }
    if (filter?.subIds?.isNotEmpty ?? false) {
      data['sub_ids[]'] = filter?.subIds;
    }
    if (filter?.trades?.isNotEmpty ?? false) {
      data['trades[]'] = filter?.trades;
    }
    if (filter?.workTypeIds?.isNotEmpty ?? false) {
      data['work_types[]'] = filter?.workTypeIds;
    }

    if (filter?.customerName?.isNotEmpty ?? false) {
      data['customer_name'] = filter?.customerName;
    }
    return data;
  }

  void setStartEndDate(DateTime date) {
    final datesList = date.datesOfMonths();
    // dates of list consists of 6 weeks month by default
    // but here we are removing a week it its a 5 week month
    // so to save server load time
    if (!date.isSixWeekMonth()) {
      datesList.removeRange(datesList.length - 7, datesList.length);
    }
    startDate = DateTimeHelper.convertSlashIntoHyphen(datesList.first.toString());
    endDate = DateTimeHelper.convertSlashIntoHyphen(datesList.last.add(const Duration(days: 1)).toString());
  }

  void setOtherUsersSelection(bool val) {
    canSelectOtherUsers = val;
  }

  Map<String, dynamic> eventTypeToIncludes(CalendarsEventType type, {bool isForProductionCalendar = false, int? jobId}) {
    switch (type) {
      case CalendarsEventType.appointment:
        return {
          'includes[0]': 'attachments_count',
          'includes[1]': 'attendees',
        };

      case CalendarsEventType.schedules:
        if(isForProductionCalendar) {
          return {
            "includes[0]": "reps",
            "includes[1]": "labours",
            "includes[2]": "sub_contractors",
            "includes[3]": "trades",
            "includes[4]": "work_types",
            "includes[5]": "job_estimators",
            "includes[6]": "job",
            "includes[7]": "job.division",
            "includes[8]": "customer",
            "includes[9]": "customer.rep",
            'includes[10]': "attachments",
            if(jobId != null && !jobId.isNegative)
            'job_id':jobId,
          };
        } else {
          return {
            'includes[0]': 'attachments_count',
          };
        }
    }
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is CalendarsRequestParams &&
            runtimeType == other.runtimeType &&
            duration == other.duration &&
            forWhom == other.forWhom &&
            limit == other.limit &&
            startDate == other.startDate &&
            endDate == other.endDate &&
            date == other.date &&
            users == other.users &&
            customerName == other.customerName &&
            listEquals(workTypes, other.workTypes) &&
            listEquals(divisions, other.divisions) &&
            listEquals(category, other.category) &&
            listEquals(companyCrew, other.companyCrew) &&
            listEquals(labourSub, other.labourSub) &&
            listEquals(tradeTypes, other.tradeTypes) &&
            listEquals(jobFlag, other.jobFlag) &&
            listEquals(city, other.city);
  }

  @override
  int get hashCode =>
      duration.hashCode ^
      forWhom.hashCode ^
      limit.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      date.hashCode ^
      users.hashCode ^
      divisions.hashCode ^
      category.hashCode ^
      companyCrew.hashCode ^
      labourSub.hashCode ^
      tradeTypes.hashCode ^
      jobFlag.hashCode ^
      city.hashCode ^
      workTypes.hashCode ^
      customerName.hashCode ^
      filter.hashCode;
}

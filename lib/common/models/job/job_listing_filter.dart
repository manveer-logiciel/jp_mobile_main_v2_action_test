import 'package:flutter/foundation.dart';

import '../../../core/constants/pagination_constants.dart';

class JobListingFilterModel {

  int? limit;
  late int page;
  String? sortBy;
  String? sortOrder;
  String? dateRangeType;
  String? duration;
  String? startDate;
  String? endDate;
  String? selectedItem;
  double? lat;
  double? long;
  double? distance;
  List<String?>? stages;
  List<int?>? users;
  List<int?>? divisionIds;
  List<int?>? stateIds;
  List<int?>? trades;
  List<int?>? flags;
  List<String?>? followUpMarks;
  String? jobId;
  String? jobAltId;
  String? projectId;
  String? projectAltId;
  String? address;
  String? zip;
  String? customerName;
  bool? withArchived;
  bool? isWithArchived;
  bool? isOnlyArchived;
  late bool insuranceJobsOnly;
  bool? isOptimized;

  JobListingFilterModel({
    this.limit = PaginationConstants.pageLimit,
    this.page = 1,
    this.sortBy = "stage_last_modified",
    this.sortOrder = "desc",
    this.dateRangeType = "job_created_date",
    this.duration = "since_inception",
    this.insuranceJobsOnly = false,
    this.selectedItem,
    this.lat,
    this.long,
    this.distance,
    this.startDate,
    this.endDate,
    this.stages,
    this.users,
    this.divisionIds,
    this.stateIds,
    this.trades,
    this.flags,
    this.jobId,
    this.projectId,
    this.jobAltId,
    this.projectAltId,
    this.address,
    this.zip,
    this.customerName,
    this.withArchived = false,
    this.isWithArchived,
    this.followUpMarks,
    this.isOnlyArchived,
    this.isOptimized = true,
  });

  @override
  bool operator ==(Object other) {
    return (other is JobListingFilterModel)
        && other.limit == limit
        && other.page == page
        && other.sortBy == sortBy
        && other.sortOrder == sortOrder
        && other.dateRangeType == dateRangeType
        && other.duration == duration
        && other.startDate == startDate
        && other.endDate == endDate
        && other.insuranceJobsOnly == insuranceJobsOnly
        && other.selectedItem == selectedItem
        && other.lat == lat
        && other.long == long
        && other.distance == distance
        && listEquals(other.stages, stages)
        && listEquals(other.divisionIds, divisionIds)
        && listEquals(other.users, users)
        && listEquals(other.trades, trades)
        && listEquals(other.flags, flags)
        && listEquals(other.stateIds, stateIds)
        && other.jobId == jobId
        && other.jobAltId == jobAltId
        && other.projectId == projectId
        && other.projectAltId == projectAltId
        && other.address == address
        && other.zip == zip
        && other.customerName == customerName
        && other.withArchived == withArchived
        && other.isWithArchived == isWithArchived
        && other.followUpMarks == followUpMarks
        && other.isOnlyArchived == isOnlyArchived
        && other.isOptimized == isOptimized;
  }

  @override
  int get hashCode => 0;

  factory JobListingFilterModel.copy(JobListingFilterModel params) => JobListingFilterModel(
    limit: params.limit,
    page: params.page,
    sortBy: params.sortBy,
    sortOrder: params.sortOrder,
    dateRangeType: params.dateRangeType,
    duration: params.duration,
    startDate: params.startDate,
    endDate: params.endDate,
    insuranceJobsOnly: params.insuranceJobsOnly,
    selectedItem: params.selectedItem,
    lat: params.lat,
    long: params.long,
    distance: params.distance,
    stages: params.stages,
    users: params.users,
    divisionIds: params.divisionIds,
    stateIds: params.stateIds,
    trades: params.trades,
    flags: params.flags,
    jobId: params.jobId,
    jobAltId: params.jobAltId,
    projectId: params.projectId,
    projectAltId: params.projectAltId,
    address: params.address,
    zip: params.zip,
    customerName: params.customerName,
    withArchived: params.withArchived,
    isWithArchived: params.isWithArchived,
    followUpMarks: params.followUpMarks,
    isOnlyArchived: params.isOnlyArchived,
    isOptimized: params.isOptimized,
  );

  JobListingFilterModel.fromJson(Map<String, dynamic> json) {
    limit = int.tryParse(json['limit']?.toString() ?? '');
    page = int.tryParse(json['page']?.toString() ?? '')!;
    sortBy = json['sort_by']?.toString();
    sortOrder = json['sort_order']?.toString();
    dateRangeType = json['date_range_type']?.toString();
    duration = json['duration']?.toString();
    lat = double.tryParse(json['lat']?.toString() ?? '');
    long = double.tryParse(json['long']?.toString() ?? '');
    distance = double.tryParse(json['distance']?.toString() ?? '');
    startDate = json['start_date']?.toString();
    endDate = json['end_date']?.toString();
    if (json['stages'] != null && (json['stages'] is List)) {
      stages = [];
      json['stages'].forEach((dynamic v) {
        stages!.add(v.toString());
      });
    }
    if (json['users'] != null && (json['users'] is List)) {
      users = [];
      json['users'].forEach((dynamic v) {
        users!.add(int.tryParse(v.toString()));
      });
    }
    if (json['division_ids'] != null && (json['division_ids'] is List)) {
      divisionIds = [];
      json['division_ids'].forEach((dynamic v) {
        divisionIds!.add(int.tryParse(v.toString()));
      });
    }
    if (json['state_id'] != null && (json['state_id'] is List)) {
      stateIds = [];
      json['state_id'].forEach((dynamic v) {
        stateIds!.add(int.tryParse(v.toString()));
      });
    }
    if (json['trades'] != null && (json['trades'] is List)) {
      trades = [];
      json['trades'].forEach((dynamic v) {
        trades!.add(int.tryParse(v.toString()));
      });
    }
    if (json['flags'] != null && (json['flags'] is List)) {
      flags = [];
      json['flags'].forEach((dynamic v) {
        flags!.add(int.tryParse(v.toString()));
      });
    }
    if (json['follow_up_marks'] != null && (json['follow_up_marks'] is List)) {
      followUpMarks = [];
      json['follow_up_marks'].forEach((dynamic v) {
        followUpMarks!.add(v.toString());
      });
    }
    jobId = json['job_number']?.toString();
    jobAltId = json['job_alt_id']?.toString();

    projectId = json['project_number']?.toString();
    projectAltId = json['project_alt_id']?.toString();
    address = json['job_address']?.toString();
    zip = json['job_zip_code']?.toString();
    customerName = json['name']?.toString();
    withArchived = (json['withArchived']?.toString() ?? false) == "1";
    isWithArchived = (json['with_archived']?.toString() ?? false) == "1";
    isOnlyArchived = (json['only_archived']?.toString() ?? false) == "1";
    insuranceJobsOnly = (json['insurance_jobs_only']?.toString() ?? false) == "1";
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['limit'] = limit;
    data['page'] = page;
    data['sort_by'] = sortBy;
    data['sort_order'] = sortOrder;
    data['date_range_type'] = dateRangeType;
    data['duration'] = duration;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['lat'] = lat;
    data['long'] = long;
    data['distance'] = distance;
    data['is_optimized'] = isOptimized ?? true ? 1 : 0;
    if (stages != null) {
      data['stages'] = <dynamic>[];
      for (var v in stages!) {
        data['stages'].add(v);
      }
    }
    if (users != null) {
      data['users'] = <dynamic>[];
      for (var v in users!) {
        data['users'].add(v);
      }
    }
    if (divisionIds != null) {
      data['division_ids'] = <dynamic>[];
      for (var v in divisionIds!) {
        data['division_ids'].add(v);
      }
    }
    if (stateIds != null) {
      data['state_id'] = <dynamic>[];
      for (var v in stateIds!) {
        data['state_id'].add(v);
      }
    }
    if (trades != null) {
      data['trades'] = <dynamic>[];
      for (var v in trades!) {
        data['trades'].add(v);
      }
    }
    if (flags != null) {
      data['flags'] = <dynamic>[];
      for (var v in flags!) {
        data['flags'].add(v);
      }
    }
    if (followUpMarks != null) {
      data['follow_up_marks'] = <dynamic>[];
      for (var v in followUpMarks!) {
        data['follow_up_marks'].add(v);
      }
    }
    data['job_number'] = jobId;
    data['job_alt_id'] = jobAltId;
    data['project_number'] = projectId;
    data['project_alt_id'] = projectAltId;
    data['job_address'] = address;
    data['job_zip_code'] = zip;
    data['name'] = customerName;
    data['withArchived'] = withArchived;
    data['with_archived'] = isWithArchived ?? false ? "1" : "0";
    data['only_archived'] = isOnlyArchived ?? false ? "1" : "0";
    data['insurance_jobs_only'] = insuranceJobsOnly ? "1" : "0";
    return data;
  }
}
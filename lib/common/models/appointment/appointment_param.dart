import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/core/constants/pagination_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';

class AppointmentListingParamModel {
  int limit;
  int page;
  String duration;
  String? sortBy;
  String? sortOrder;
  String? jobAltId;
  String? jobNumber;
  String? location;
  String? title;
  String? startDate;
  String? endDate;
  String? date;
  String? resultFor;
  int? createdBy;
  List<String>? assignedTo;
  List<String>? appointmentResultOption;
  List<String>? dateRangeType;
  bool? canSelectOtherUser;
  bool excludeRecurring;

  AppointmentListingParamModel({
    this.limit = PaginationConstants.pageLimit,
    this.page = 1,
    this.duration = 'upcoming',
    this.sortBy = 'start_date_time',
    this.sortOrder = 'asc',
    this.jobAltId,
    this.jobNumber,
    this.location,
    this.title,
    this.startDate,
    this.endDate,
    this.date,
    this.resultFor,
    this.createdBy,
    this.assignedTo,
    this.appointmentResultOption,
    this.dateRangeType = const ["appointment_duration_date"],
    this.canSelectOtherUser = true,
    this.excludeRecurring = false,
  });

  factory AppointmentListingParamModel.fromJson(Map<String, dynamic> json) {
    return AppointmentListingParamModel(
      duration: json['duration'] ?? 'upcoming',
      jobAltId: Helper.isValueNullOrEmpty(json['job_alt_id']) ? null : json['job_alt_id'],
      jobNumber: Helper.isValueNullOrEmpty(json['job_number']) ? null : json['job_number'],
      location: Helper.isValueNullOrEmpty(json['location']) ? null : json['location'],
      title: Helper.isValueNullOrEmpty(json['title']) ? null : json['title'],
      startDate: json['start_date'],
      sortBy: json['sort_by'] ?? 'start_date_time',
      sortOrder: json['sort_order'] ?? 'asc',
      endDate: json['end_date'],
      createdBy: int.tryParse(json['created_by'].toString()),
      assignedTo: json['users'] is List ? List<String>.from(json['users']) : [AuthService.userDetails!.id.toString()],
      appointmentResultOption: json['result_option_id'] is List ? List<String>.from(json['result_option_id']) : null,
      dateRangeType: json['date_range_type'] is List ? List<String>.from(json['date_range_type']) : const ["appointment_duration_date"],
      excludeRecurring: Helper.isTrue(json['exclude_recurring']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['limit'] = limit;
    data['page'] = page;
    data['duration'] = duration;
    data['sort_by'] = sortBy;
    data['sort_order'] = sortOrder;
    data['job_alt_id'] = jobAltId;
    data['job_number'] = jobNumber;
    data['location'] = location;
    data['title'] = title;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['for']  = resultFor;   
    data['created_by'] = createdBy;
    data['users'] = assignedTo; 
    data['result_option_id'] = appointmentResultOption; 
    data['date_range_type'] = dateRangeType;
    data['exclude_recurring'] = excludeRecurring ? 0 : 1;
    return data;
  }

  Map<String, dynamic> toFilterJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['duration'] = duration;
    data['job_alt_id'] = jobAltId;
    data['job_number'] = jobNumber;
    data['location'] = location;
    data['title'] = title;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['created_by'] = createdBy;
    data['users'] = assignedTo;
    data['sort_by'] = sortBy;
    data['sort_order'] = sortOrder;
    data['result_option_id'] = appointmentResultOption;
    data['date_range_type'] = dateRangeType;
    data['exclude_recurring'] = excludeRecurring;
    return data;
  }

}

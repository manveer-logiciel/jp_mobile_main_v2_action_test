import '../../../core/constants/pagination_constants.dart';

class JobScheduleFilterModel {

  int? limit;
  late int page;
  String? sortBy;
  String? sortOrder;
  String? stages;
  String? keyword;
  bool? isWithoutSchedule;
  int? jobId;
  String? workOrderIds;

  JobScheduleFilterModel({
    this.limit = PaginationConstants.pageLimit,
    this.page = 1,
    this.sortBy = "stage_last_modified",
    this.sortOrder = "desc",
    this.isWithoutSchedule = true,
    this.stages,
    this.keyword,
    this.jobId,
    this.workOrderIds,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['includes[0]'] =  "address";
    data['includes[1]'] = "division";
    data['limit'] = limit;
    data['page'] = page;
    data['sort_by'] = sortBy;
    data['sort_order'] = sortOrder;
    data['without_schedules'] = isWithoutSchedule ?? false ? 1 : 0;
    data['stages'] = stages;
    data['keyword'] = keyword;
    return data;
  }

  /// [toListingJson] returns the params to be sent in request
  /// while fetching schedule listing
  Map<String, dynamic> toListingJson() {
    final data = <String, dynamic>{};

    data['includes[0]'] = 'trades';
    data['includes[1]'] = 'work_types';
    data['includes[2]'] = 'reps';
    data['includes[3]'] = 'sub_contractors';
    data['includes[4]'] = 'notes';
    data['includes[5]'] = 'work_crew_notes';
    data['includes[6]'] = 'attachments_count';
    data['job_id'] = jobId;
    data['limit'] = limit;
    data['page'] = page;
    data['sort_by'] = 'start_date_time';
    data['sort_order'] = 'asc';
    data['work_order_ids'] = workOrderIds;

    return data;
  }
}
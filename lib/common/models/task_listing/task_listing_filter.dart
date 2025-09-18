class TaskListingFilterModel {
  late int limit;
  late int page;
  late bool onlyHighPriorityTask;
  late bool includeLockedTask;
  late bool reminderNotification;
  String? sortBy;
  String? sortOrder;
  String? status;
  String? type;
  String? dateRangeType;
  String? duration;
  String? startDate;
  String? endDate;
  int? userId;
  int? jobId;

  TaskListingFilterModel(
      {this.limit = 20,
      this.page = 1,
      this.sortBy = 'due_date',
      this.sortOrder = 'ASC',
      this.status = 'pending',
      this.type = 'assigned',
      this.onlyHighPriorityTask = false,
      this.includeLockedTask = false,
      this.reminderNotification = false,
      this.dateRangeType,
      this.duration = "none",
      this.startDate,
      this.endDate,
      this.userId,
      this.jobId});

  TaskListingFilterModel.fromJson(Map<String, dynamic> json) {
    limit = json['limit'];
    page = json['page'];
    sortBy = json['sort_by'];
    sortOrder = json['sort_order'];
    status = json['status'];
    type = json['type'];
    onlyHighPriorityTask = json['only_high_priority_tasks'] == 1 ? true : false;
    includeLockedTask = json['include_locked_task'] == 1 ? true : false;
    reminderNotification = json['reminder_notification'] == 1 ? true : false;
    dateRangeType = json['date_range_type'];
    duration = json['duration'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    userId = json['user_id'];
    jobId = json['job_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['limit'] = limit;
    data['page'] = page;
    data['sort_by'] = sortBy;
    data['sort_order'] = sortOrder;
    data['status'] = status;
    data['type'] = type;
    data['only_high_priority_tasks'] = onlyHighPriorityTask ? 1 : 0;
    data['include_locked_task'] = includeLockedTask ? 1 : 0;
    data['reminder_notification'] = reminderNotification ? 1 : 0;
    data['date_range_type'] = dateRangeType;
    data['duration'] = duration;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['user_id'] = userId;
    data['job_id'] = jobId;
    return data;
  }
}

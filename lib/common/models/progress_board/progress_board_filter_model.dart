import 'package:flutter/foundation.dart';

import '../../../core/constants/pagination_constants.dart';

class ProgressBoardFilterModel {
  late int limit;
  late int page;
  String? sortBy;
  String? sortOrder;
  String? selectedPB;
  int? boardId;
  String? jobStatus;
  String? jobId;
  String? jobName;
  String? jobNumber;
  String? customerName;
  String? jobAddress;
  String? zipCode;
  String? tradeId;
  List<int>? trades;
  List<int>? divisionIds;
  List<int>? usersIds;
  String? pbWithArchive;
  List<String>? stages;
  bool? isArchivedJobsVisible;

  ProgressBoardFilterModel({
    this.limit = PaginationConstants.pageLimit,
    this.page = 1,
    this.sortBy = 'order',
    this.sortOrder = 'asc',
    this.boardId,
    this.selectedPB,
    this.jobStatus = "archive",
    this.jobId,
    this.jobName,
    this.jobNumber,
    this.customerName,
    this.jobAddress,
    this.zipCode,
    this.tradeId,
    this.trades,
    this.divisionIds,
    this.usersIds,
    this.pbWithArchive,
    this.stages,
    this.isArchivedJobsVisible = false,
  });

  @override
  bool operator ==(Object other) {
    return (other is ProgressBoardFilterModel)
        && other.limit == limit
        && other.page == page
        && other.sortBy == sortBy
        && other.sortOrder == sortOrder
        && other.boardId == boardId
        && other.selectedPB == selectedPB
        && other.jobStatus == jobStatus
        && other.jobId == jobId
        && other.jobName == jobName
        && other.customerName == customerName
        && other.jobAddress == jobAddress
        && other.zipCode == zipCode
        && other.tradeId == tradeId
        && listEquals(other.trades, trades)
        && listEquals(other.divisionIds, divisionIds)
        && listEquals(other.usersIds, usersIds)
        && listEquals(other.stages, stages)
        && other.pbWithArchive == pbWithArchive
        && other.isArchivedJobsVisible == isArchivedJobsVisible;
  }

  @override
  int get hashCode => 0;

  factory ProgressBoardFilterModel.copy(ProgressBoardFilterModel params) => ProgressBoardFilterModel(
    limit: params.limit,
    page: params.page,
    sortBy: params.sortBy,
    sortOrder: params.sortOrder,
    boardId: params.boardId,
    selectedPB: params.selectedPB,
    jobStatus: params.jobStatus,
    jobId: params.jobId,
    jobName: params.jobName,
    customerName: params.customerName,
    jobAddress: params.jobAddress,
    zipCode: params.zipCode,
    tradeId: params.tradeId,
    trades: params.trades,
    divisionIds: params.divisionIds,
    usersIds: params.usersIds,
    pbWithArchive: params.pbWithArchive,
    stages: params.stages,
    isArchivedJobsVisible: params.isArchivedJobsVisible,
  );



  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["includes[0]"] = "current_stage";
    data["includes[1]"] = "job_meta";
    data["includes[2]"] = "division";
    data["includes[3]"] = "reps";
    data["includes[4]"] = "estimators";
    data["includes[5]"] = "sub_contractors";
    data["includes[6]"] = "pb_entries.task.stage";
    data["includes[7]"] = "pb_entries.task.attachments";
    data["includes[8]"] = "pb_entries.task.notify_users";
    data["limit"] = limit;
    data["page"] = page;
    data["sort_by"] = sortBy;
    data["sort_order"] = sortOrder;
    data["board_id"] = boardId;
    data["job_number"] =  jobNumber;
    data["job_alt_id"] =  jobName;
    data["name"] =  customerName;
    data["job_address"] =  jobAddress;
    data["job_zip_code"] =  zipCode;
    data["trade_id"] =  tradeId;

    switch(jobStatus) {
      case "archive":
        data["archive"] =  1;
        break;
      case "pb_only_archived_jobs":
        data["pb_only_archived_jobs"] =  1;
        data["archive"] =  2;
        break;
      case "pb_with_archived_jobs":
        data["pb_with_archived_jobs"] =  1;
        data["archive"] =  3;
        break;
    }

    for(int i = 0; i < (trades?.length ?? 0) ; i++) {
      data.addEntries({"trades[$i]" : trades![i]}.entries);
    }
    for(int i = 0; i < (divisionIds?.length ?? 0) ; i++) {
      data.addEntries({"division_ids[$i]" : divisionIds![i]}.entries);
    }
    for(int i = 0; i < (usersIds?.length ?? 0) ; i++) {
      data.addEntries({"rep_ids[$i]" : usersIds![i]}.entries);
    }
    for(int i = 0; i < (stages?.length ?? 0) ; i++) {
      data.addEntries({"stages[$i]" : stages![i]}.entries);
    }
    data.removeWhere((dynamic key, dynamic value) => (key == null || value == null));

    return data;
  }

  Map<String, dynamic> progressBardListToJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["limit"] = 0;
    return data;
  }

  Map<String, dynamic> progressBardColumnsToJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["board_id"] = boardId;
    data["limit"] = 0;
    return data;
  }

  Map<String, dynamic> progressBardColorJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["type"] = "progress_board";
    return data;
  }

  Map<String, dynamic> progressBardArchiveJson(int jobId, bool isArchived) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["job_id"] = jobId;
    data["board_id"] = boardId;
    data["archive"] = isArchived ? 1 : 0;
    return data;
  }

  Map<String, dynamic> progressBardDeleteJson(int jobId) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["job_id"] = jobId;
    data["board_id"] = boardId;
    return data;
  }


}
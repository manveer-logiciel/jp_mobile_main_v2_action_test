import 'package:jobprogress/core/constants/pagination_constants.dart';

class NoteListingParamModel {
  int? limit;
  late int page;
  int? jobId;
  String? sortBy;
  String? sortOrder;
  String? stageCode;

  NoteListingParamModel({
    this.limit = PaginationConstants.pageLimit,
    this.page = 1,
    this.jobId,
    this.sortBy,
    this.sortOrder = 'desc',
    this.stageCode,
  });

  NoteListingParamModel.fromJson(Map<String, dynamic> json) {
    limit = json['limit'];
    page = json['page'];
    jobId = json['job_id'];
    sortBy = json['sort_by'];
    sortOrder = json['sort_order'];
    stageCode = json['stage_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['limit'] = limit;
    data['page'] = page;
    data['job_id'] = jobId;
    data['sort_by'] = sortBy;
    data['sort_order'] = sortOrder;
    data['stage_code'] = stageCode;
    return data;
  }
}

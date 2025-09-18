
import 'package:jobprogress/common/models/job/job.dart';

class FileUploaderParams {

  JobModel? job;
  dynamic type;
  int? parentId;
  int? jobId;
  bool onlyShowPhotosOption = false;

  FileUploaderParams({
    this.job,
    required this.type,
    this.parentId,
    this.jobId,
    this.onlyShowPhotosOption = false
  });

  FileUploaderParams.fromJson(Map<String, dynamic> json) {
    parentId = json['parent_id'] is String ? int.tryParse('parent_id') : json['parent_id'];
    jobId = json['job_id'] is String ? int.tryParse('job_id') : json['job_id'];
  }

}
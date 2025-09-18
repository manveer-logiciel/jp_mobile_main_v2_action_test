import 'package:jobprogress/common/models/files_listing/hover/hover_report.dart';

class SmOrder {

  List<ReportFile>? reportFiles;
  String? status;

  SmOrder({
    this.reportFiles,
    this.status
  });

  SmOrder.fromJson(Map<String, dynamic> json) {
    if(json['report_files'] != null && json['report_files']['data'] != null){
      reportFiles = <ReportFile>[];
      json['report_files']['data'].forEach((dynamic file) {
        reportFiles!.add(ReportFile.fromJson(file));
      });
    }
    status = json['status'];
  }
   

}



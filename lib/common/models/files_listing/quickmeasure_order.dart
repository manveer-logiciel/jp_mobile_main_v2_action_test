import 'package:jobprogress/common/models/files_listing/hover/hover_report.dart';

class QuickMeasureOrder {

  List<ReportFile>? reportFiles;

  QuickMeasureOrder({
    this.reportFiles
  });

  QuickMeasureOrder.fromJson(Map<String, dynamic> json) {
    if(json['reports'] != null && json['reports']['data'] != null){
      reportFiles = <ReportFile>[];
      json['reports']['data'].forEach((dynamic file){
        reportFiles!.add(ReportFile.fromJson(file));
      });
    }
  }

}



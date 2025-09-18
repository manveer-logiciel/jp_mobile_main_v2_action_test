
import 'package:jobprogress/common/models/files_listing/hover/hover_report.dart';

import 'status.dart';

class EvOrder {

  List<ReportFile>? reportFiles;
  EagleViewOrderStatus? status;

  EvOrder({
    this.reportFiles,
    this.status
  });

  EvOrder.fromJson(Map<String, dynamic> json) {
    status = EagleViewOrderStatus.fromJson(json['status']);
    if(json['report_files'] != null && json['report_files']['data'] != null){
      reportFiles = <ReportFile>[];
      json['report_files']['data'].forEach((dynamic file){
        reportFiles!.add(ReportFile.fromJson(file));
      });
    }
  }

}



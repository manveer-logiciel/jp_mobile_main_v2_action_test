import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';

class ClockSummaryEntry {
  int? entryId;
  int? jobId;
  int? multiJob;
  String? number;
  String? name;
  int? userId;
  String? userName;
  String? startDateTime;
  String? endDateTime;
  String? duration;
  String? checkInPlatform;
  String? checkOutPlatform;
  String? updatedBy;
  String? date;
  String? time;
  UserModel? user;
  JobModel? jobModel;

  ClockSummaryEntry({
    this.entryId,
    this.jobId,
    this.multiJob,
    this.number,
    this.name,
    this.userId,
    this.userName,
    this.startDateTime,
    this.endDateTime,
    this.duration,
    this.checkInPlatform,
    this.checkOutPlatform,
    this.updatedBy,
    this.date,
    this.time,
    this.user,
    this.jobModel,
  });

  ClockSummaryEntry.fromJson(Map<String, dynamic> json) {
    entryId = json["entry_id"];
    jobId = json["job_id"];
    multiJob = json["multi_job"];
    number = json["number"];
    name = json["name"];
    userId = json["user_id"];
    userName = json["user_name"];
    startDateTime = json["start_date_time"];
    endDateTime = json["end_date_time"];
    duration = json["duration"];
    checkInPlatform = json["check_in_platform"];
    checkOutPlatform = json["check_out_platform"];
    updatedBy = json["updated_by"];
    date = getDate();
    time = getTime();
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null ;
    if(jobId != null) {
      jobModel = JobModel(
        id: jobId!,
        customerId: json["user_id"],
        customer: CustomerModel(
          id: json["user_id"],
          phones: [],
          fullNameMobile: json["customer_name"],
        ),
        name: json['name'],
        number: json['number'],
        altId: json['alt_id'],
      );
    }

  }

  String getDate() {
    final formattedStartDate = DateTimeHelper.formatDate(startDateTime!, DateFormatConstants.dateServerFormat);
    final formattedEndDate = DateTimeHelper.formatDate(endDateTime!, DateFormatConstants.dateServerFormat);

    if (formattedStartDate == formattedEndDate) {
      return DateTimeHelper.convertHyphenIntoSlash(formattedStartDate);
    } else {
      return '${DateTimeHelper.convertHyphenIntoSlash(formattedStartDate)} - ${DateTimeHelper.convertHyphenIntoSlash(formattedEndDate)}';
    }
  }

  String getTime() {
    final startTime =  DateTimeHelper.formatDate(startDateTime!, DateFormatConstants.timeOnlyFormat);
    final endTime = DateTimeHelper.formatDate(endDateTime!, DateFormatConstants.timeOnlyFormat);
    return '($startTime - $endTime)';
  }

}
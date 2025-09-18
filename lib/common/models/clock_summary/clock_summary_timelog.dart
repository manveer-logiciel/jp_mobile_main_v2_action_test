import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/sql/trade_type/trade_type.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';

class ClockSummaryTimeLog {

  int? jobId;
  int? userId;
  int? customerId;
  String? userName;
  String? number;
  String? name;
  int? totalEntries;
  String? date;
  String? duration;
  String? profilePic;
  String? userEmail;
  List<TradeTypeModel>? trades;
  String? allTrades;
  JobModel? jobModel;

  ClockSummaryTimeLog(
      {this.jobId,
        this.userId,
        this.customerId,
        this.userName,
        this.number,
        this.name,
        this.totalEntries,
        this.date,
        this.duration,
        this.profilePic,
        this.userEmail,
        this.trades,
        this.allTrades,
        this.jobModel
      });

  ClockSummaryTimeLog.fromJson(Map<String, dynamic> json) {
    jobId = json['job_id'];
    userId = json['user_id'];
    customerId = json['customer_id'];
    userName = json['user_name'];
    number = json['number'];
    name = json['name'];
    totalEntries = json['total_entires'];
    date = json['date'] != null ? DateTimeHelper.convertHyphenIntoSlash(json['date']) : json['date'];
    duration = json['duration'];
    profilePic = json['profile_pic'];
    userEmail = json['user_email'];
    if(json['trades'] != null && json['trades']['data'] != null){
      trades = [];
      List<String> tempTrades = [];
      json['trades']['data'].forEach((dynamic trade) {
        trades!.add(TradeTypeModel.fromApiJson(trade));
        tempTrades.add(trade['name']);
      });
      allTrades = tempTrades.join(', ');
    }
    if(jobId != null) {
      jobModel = JobModel(
        id: jobId!,
        customerId: json["customer_id"],
        customer: CustomerModel(
          id: json["customer_id"],
          phones: [],
          fullNameMobile: json["customer_name"],
        ),
        name: json['name'],
        number: json['number'],
        altId: json['alt_id'],
      );
    }
  }

}

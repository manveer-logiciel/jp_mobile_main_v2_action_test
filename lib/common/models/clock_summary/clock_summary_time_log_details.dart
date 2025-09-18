import 'package:jobprogress/common/models/address/address.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/sql/trade_type/trade_type.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';

class ClockSummaryTimeLogDetails {
  int? entryId;
  int? jobId;
  int? multiJob;
  String? name;
  int? userId;
  String? userName;
  String? startDateTime;
  String? endDateTime;
  String? duration;
  String? clockInNote;
  String? location;
  String? clockOutNote;
  String? checkInImage;
  String? checkOutImage;
  String? checkInImageThumb;
  String? checkOutImageThumb;
  String? checkOutLocation;
  String? checkInPlatform;
  String? checkOutPlatform;
  String? updatedBy;
  List<TradeTypeModel>? trades;
  String? allTrades;
  AddressModel? address;
  String? startDate;
  String? endDate;
  String? startTime;
  String? endTime;
  String? jobAddress;
  JobModel? jobModel;

  ClockSummaryTimeLogDetails(
      {this.entryId,
        this.jobId,
        this.multiJob,
        this.name,
        this.userId,
        this.userName,
        this.startDateTime,
        this.endDateTime,
        this.duration,
        this.clockInNote,
        this.clockOutNote,
        this.checkInImage,
        this.checkOutImage,
        this.checkInImageThumb,
        this.checkOutImageThumb,
        this.checkOutLocation,
        this.checkInPlatform,
        this.checkOutPlatform,
        this.updatedBy,
        this.trades,
        this.address,
      });

  ClockSummaryTimeLogDetails.fromJson(Map<String, dynamic> json) {
    entryId = json['entry_id'];
    jobId = json['job_id'];
    multiJob = json['multi_job'];
    userId = json['user_id'];
    userName = json['user_name'];
    startDateTime = json['start_date_time'];
    location = json['location'];
    endDateTime = json['end_date_time'];
    duration = json['duration'];
    clockInNote = json['clock_in_note'];
    clockOutNote = json['clock_out_note'];
    checkInImage = json['check_in_image'];
    checkOutImage = json['check_out_image'];
    checkInImageThumb = json['check_in_image_thumb'];
    checkOutImageThumb = json['check_out_image_thumb'];
    checkOutLocation = json['check_out_location'];
    checkInPlatform = json['check_in_platform'];
    checkOutPlatform = json['check_out_platform'];
    updatedBy = json['updated_by'];

    if(json['trades'] != null && json['trades']['data'] != null){
      trades = [];
      List<String> tempTrades = [];
      json['trades']['data'].forEach((dynamic trade) {
        trades!.add(TradeTypeModel.fromApiJson(trade));
        tempTrades.add(trade['name']);
      });
      allTrades = tempTrades.join(', ');
    }

    if(json['job_address'] != null) {
      address = AddressModel.fromJson(json['job_address']);
    }

    startTime = DateTimeHelper.formatDate(startDateTime!, DateFormatConstants.timeOnlyFormat);
    endTime = endDateTime != null
        ? DateTimeHelper.formatDate(endDateTime!, DateFormatConstants.timeOnlyFormat)
        : null;

    startDate = DateTimeHelper.formatDate(startDateTime!, DateFormatConstants.dateOnlyFormat);
    endDate = endDateTime != null
        ? DateTimeHelper.formatDate(endDateTime!, DateFormatConstants.dateOnlyFormat)
        : null;

    jobAddress = Helper.convertAddress(address);
    if(jobId != null) {
      jobModel = JobModel(
        id: jobId!,
        customerId: json["user_id"],
        customer: CustomerModel(
          id: json["user_id"],
          phones: [],
          fullNameMobile: json['customer'] != null ? json['customer']['full_name'] : '',
        ),
        name: json['name'],
        number: json['number'],
        altId: json['alt_id'],
      );
    }

  }

}
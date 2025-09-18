import 'package:jobprogress/common/models/files_listing/hover/hover_image.dart';
import 'package:jobprogress/common/models/files_listing/hover/hover_report.dart';
import 'package:jobprogress/common/models/files_listing/hover/user.dart';
import 'package:jobprogress/common/services/forms/value_selector.dart';
import 'package:jobprogress/core/constants/dropdown_list_constants.dart';

class HoverJob {
  int? id;
  int? jobId;
  int? hoverJobId;
  String? userEmail;
  int? userId;
  int? ownerId;
  int? deliverableId;
  String? customerName;
  String? customerEmail;
  String? customerPhone;
  String? name;
  String? state;
  String? jobCountry;
  int? stateId;
  int? countryId;
  String? createdAt;
  String? updatedAt;
  List<HoverImage>? hoverImages;
  List<ReportFile>? reportFiles;
  int? customerId;
  String? jobAddress;
  String? jobAddressLine2;
  String? jobCity;
  String? jobState;
  String? jobZipCode;
  bool? isCaptureRequest;
  HoverUserModel? hoverUser;
  String? deliverableType;
  String? requestForType;

  HoverJob({
        this.id,
        this.jobId,
        this.hoverJobId,
        this.userEmail,
        this.userId,
        this.ownerId,
        this.deliverableId,
        this.customerName,
        this.customerEmail,
        this.customerPhone,
        this.name,
        this.state,
        this.jobCountry,
        this.stateId,
        this.countryId,
        this.createdAt,
        this.updatedAt,
        this.hoverImages,
        this.customerId,
        this.jobAddress,
        this.jobAddressLine2,
        this.jobCity,
        this.jobState,
        this.jobZipCode,
        this.isCaptureRequest,
        this.hoverUser,
        this.deliverableType,
        this.requestForType
      });

  HoverJob.fromJson(Map<String, dynamic>? json) {

    if(json == null) return;

    id = json['id'];
    jobId = json['job_id'];
    hoverJobId = json['hover_job_id'];
    userEmail = json['user_email'];
    userId = json['user_id'];
    ownerId = json['owner_id'];
    deliverableId = json['deliverable_id'];
    customerName = json['customer_name'];
    customerEmail = json['customer_email'];
    customerPhone = json['customer_phone'];
    name = json['name'];
    state = json['state'];
    jobCountry = json['job_country'];
    stateId = json['state_id'];
    countryId = json['country_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    customerId = json['customer_id'];
    jobAddress = json['job_address'];
    jobAddressLine2 = json['job_address_line_2'];
    jobCity = json['job_city'];
    jobCountry = json['job_country'];
    jobState = json['job_state'];
    jobZipCode = json['job_zip_code'];
    isCaptureRequest = json['is_capture_request'] is bool ? json['is_capture_request'] : json['is_capture_request'] == 1;
    hoverUser = json['hover_user'] != null
        ? HoverUserModel.fromJson(json['hover_user'])
        : null;
    if(json['hover_images'] != null && json['hover_images']['data'] != null){
      hoverImages = <HoverImage>[];
      json['hover_images']['data'].forEach((dynamic hoverImage){
        hoverImages!.add(HoverImage.fromJson(hoverImage));
      });
    }
    if(json['report_files'] != null && json['report_files']['data'] != null){
      reportFiles = <ReportFile>[];
      json['report_files']['data'].forEach((dynamic hoverImage){
        reportFiles!.add(ReportFile.fromJson(hoverImage));
      });
    }

    deliverableType = FormValueSelectorService
        .getSelectedSingleSelectValue(DropdownListConstants.hoverDeliverables, deliverableId.toString());

  }

}

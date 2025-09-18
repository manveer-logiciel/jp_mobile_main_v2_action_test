import 'package:jobprogress/common/models/company_contacts.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';

class CallLogModel {
  int? id;
  int? companyId;
  int? customerId;
  int? jobId;
  int? jobContactId;
  String? phoneNumber;
  UserModel? createdBy;
  String? phoneLabel;
  String? createdAt;
  String? updatedAt;
  CustomerModel? customer;
  JobModel? job;
  CompanyContactListingModel? jobContact;

  CallLogModel({
    this.id,
    this.companyId,
    this.customerId,
    this.jobId,
    this.jobContactId,
    this.phoneNumber,
    this.createdBy,
    this.phoneLabel,
    this.createdAt,
    this.updatedAt,
    this.customer,
    this.job,
    this.jobContact
  });

  CallLogModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    customerId = json['customer_id'];
    jobId = json['job_id'];
    jobContactId = json['job_contact_id'];
    phoneNumber = json['phone_number'];
    createdBy = json['created_by'] != null
        ? UserModel.fromJson(json['created_by'])
        : null;
    phoneLabel = json['phone_label'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    customer = json['customer'] != null
        ? CustomerModel.fromJson(json['customer'])
        : null;
    job = json['job'] != null
        ? JobModel.fromJson(json['job'])
        : null;
    jobContact = json['job_contact'] != null
        ? CompanyContactListingModel.fromApiJson(json['job_contact'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] =id;
    data['company_id'] =companyId;
    data['customer_id'] =customerId;
    data['job_id'] =jobId;
    data['job_contact_id'] =jobContactId;
    data['phone_number'] =phoneNumber;
    if (createdBy != null) {
      data['created_by'] =createdBy!.toJson();
    }
    data['phone_label'] =phoneLabel;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    if (job != null) {
      data['job'] =job!.toJson();
    }
    if (jobContact != null) {
      data['job_contact'] = jobContact!.toJson();
    }
    return data;
  }
}
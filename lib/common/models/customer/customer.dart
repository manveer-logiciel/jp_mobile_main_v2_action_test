import 'package:get/get.dart';
import 'package:jobprogress/common/models/appointment/appointment.dart';
import 'package:jobprogress/common/models/company_contacts.dart';
import 'package:jobprogress/common/models/phone_consents.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';

import '../../../core/utils/helpers.dart';
import '../address/address.dart';
import '../custom_fields/custom_fields.dart';
import '../phone.dart';
import '../sql/flag/flag.dart';
import '../sql/user/user_limited.dart';
import 'appointments.dart';
import 'referred_by/referred_by.dart';

class CustomerModel {

  List<String?>? additionalEmails;
  AddressModel? address;
  String? addressString;
  int? addressId;
  num? unappliedAmount;
  String? intial;
  bool? isAppointmentRequired;
  CustomerAppointments? appointments;
  bool? isBidCustomer;
  int? billingAddressId;
  AddressModel? billingAddress;
  String? billingAddressString;
  UserModel? callCenterRep;
  String? callCenterRepType;
  bool? isCallRequired;
  UserModel? canvasser;
  String? canvasserType;
  String? companyName;
  String? billingName;
  String? createdAt;
  List<CustomFieldsModel?>? customFields;
  String? deletedAt;
  dynamic disableQboFinancialSyncing;
  late bool isDisableQboSync;
  String? distance;
  String? email;
  String? firstName;
  List<FlagModel?>? flags;
  String? fullName;
  String? fullNameMobile;
  int? id;
  late bool isCommercial;
  int? isPrimeContractorCustomer;
  int? jobsCount;
  String? lastName;
  String? managementCompany;
  String? note;
  String? origin;
  String? password;
  List<PhoneModel>? phones;
  List<PhoneModel>? additionalPhone;
  List<PhoneConsentModel>? phoneConsents;
  String? propertyName;
  String? qbDesktopId;
  String? quickbookId;
  String? quickbookSyncStatus;
  CustomerReferredBy? referredBy;
  String? referredByNote;
  String? referredByType;
  UserLimitedModel? rep;
  String? repId;
  String? sourceType;
  Meta? meta;
  List<CompanyContactListingModel>? contacts;
  String? leadSource;
  String? callCenterRepString;
  String? canvasserString;
  String? appointmentDate;

  CustomerModel({
    this.additionalEmails,
    this.address,
    this.addressString,
    this.addressId,
    this.isAppointmentRequired,
    this.appointments,
    this.isBidCustomer,
    this.unappliedAmount,
    this.billingAddressId,
    this.billingAddress,
    this. intial,
    this.billingAddressString,
    this.callCenterRep,
    this.callCenterRepType,
    this.isCallRequired,
    this.canvasser,
    this.canvasserType,
    this.companyName,
    this.createdAt,
    this.customFields,
    this.deletedAt,
    this.disableQboFinancialSyncing,
    this.isDisableQboSync = false,
    this.distance,
    this.email,
    this.firstName,
    this.flags,
    this.fullName,
    this.fullNameMobile,
    this.id,
    this.isCommercial = false,
    this.isPrimeContractorCustomer,
    this.jobsCount,
    this.lastName,
    this.managementCompany,
    this.note,
    this.origin,
    this.password,
    this.phones,
    this.propertyName,
    this.qbDesktopId,
    this.quickbookId,
    this.quickbookSyncStatus,
    this.referredBy,
    this.referredByNote,
    this.referredByType,
    this.rep,
    this.repId,
    this.sourceType,
    this.meta,
    this.contacts,
    this.leadSource,
    this.phoneConsents,
    this.billingName,
    this.appointmentDate
  });

  CustomerModel.fromNotificationJson(Map<String, dynamic> json) {
    companyName = json['customer_company_name'];
    email = json['customer_email'];
    firstName = json['customer_first_name'];
    id = json['customer_id'];
    fullName = json['customer_full_name'];
    lastName = json['customer_last_name'];
  }

  CustomerModel.fromFirestoreJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    fullNameMobile = "${firstName ?? ""} ${lastName ?? ""}";
  }

  CustomerModel.fromJson(Map<String, dynamic> json) {
    if (json['additional_emails'] != null) {
      additionalEmails = [];
      json['additional_emails'].forEach((dynamic v) {
        additionalEmails!.add(v.toString());
      });
    }   
    address = (json['address'] != null && json['address'] is Map<String, dynamic>) ? AddressModel.fromJson(json['address']) : null;
    addressString = Helper.convertAddress(address);
    addressId = json['address_id']?.toInt();
    isAppointmentRequired = Helper.isTrue(json['appointment_required']);
    if(json['appointment_details'] != null) {
      appointments = CustomerAppointments.fromJson(json['appointment_details']);
    } else {
      appointments = (json['appointments'] != null) ? CustomerAppointments.fromJson(json['appointments']) : null;
    }
    isBidCustomer = (json['bid_customer']?.toInt() ?? false)  == 1;
    billingName = json['billing_name']?.toString();
    billingAddressId = json['billing_address_id']?.toInt();
    billingAddress = (json['billing'] != null) ? AddressModel.fromJson(json['billing']) : null;
    billingAddressString = Helper.convertAddress(billingAddress);
    callCenterRep = (json['call_center_rep'] != null && (json['call_center_rep'] is Map)) ? UserModel.fromJson(json['call_center_rep']) : null;
    callCenterRepType = json['call_center_rep_type']?.toString();
    callCenterRepString = (json['call_center_rep'] is String) ? json['call_center_rep'] : null;
    isCallRequired = (json['call_required'] == true || json['call_required'] == 1);
    canvasser = (json['canvasser'] != null && (json['canvasser'] is Map)) ? UserModel.fromJson(json['canvasser']) : null;
    canvasserType = json['canvasser_type']?.toString();
    canvasserString = (json['canvasser'] is String) ? json['canvasser'] : null;
    companyName = json['company_name']?.toString();
    createdAt = json['created_at']?.toString();
    if (json['custom_fields']?['data'] != null) {
      customFields = [];
      json['custom_fields']['data'].forEach((dynamic v) {
        customFields!.add(CustomFieldsModel.fromJson(v));
      });
    }
    deletedAt = json['deleted_at']?.toString();
    disableQboFinancialSyncing = json['disable_qbo_financial_syncing'];
    isDisableQboSync = (json['disable_qbo_sync']?.toInt() ?? false) == 1;
    unappliedAmount = json['unapplied_amount'];
    distance = json['distance']?.toString();
    email = json['email']?.toString();
    firstName = json['first_name']?.toString();
    if (json['flags']?['data'] != null) {
      flags = [];
      json['flags']['data'].forEach((dynamic v) {
        flags!.add(FlagModel.fromApiJson(v));
      });
    }
    fullName = json['full_name']?.toString();
    if(json['phone_consents'] != null) {
      phoneConsents = [];
      json['phone_consents'].forEach((dynamic v) {
        phoneConsents!.add(PhoneConsentModel.fromJson(v));
      }); 
    }
    fullNameMobile = json['full_name_mobile']?.toString();
    id = int.tryParse( (json['id'] ?? json['customer_id'] ?? 0).toString());
    isCommercial = json['is_commercial']?.toInt() == 1;
    isPrimeContractorCustomer = json['is_prime_contractor_customer']?.toInt();
    jobsCount = json['jobs_count']?.toInt();
    lastName = json['last_name']?.toString();
    intial = Helper.isValueNullOrEmpty(firstName) ? '' : firstName![0] + 
      (Helper.isValueNullOrEmpty(lastName) ? '' : lastName![0]);
    managementCompany = json['management_company']?.toString();
    note = json['note']?.toString();
    origin = json['origin']?.toString();
    if (json['phones']?['data'] != null) {
      phones = [];
      if (json['phones']['data'] is List) {
        json['phones']['data'].forEach((dynamic v) {
          phones!.add(PhoneModel.fromJson(v));
        });
      } else {
        phones!.add(PhoneModel.fromJson(json['phones']['data']));
      }
    }
    if (json['additional_phone'] != null) {
      additionalPhone = [];
      json['additional_phone'].forEach((dynamic v) {
        additionalPhone!.add(PhoneModel.fromJson(v));
      });
    }
    propertyName = json['property_name']?.toString();
    qbDesktopId = json['qb_desktop_id']?.toString();
    quickbookId = json['quickbook_id'] != null && json['quickbook_id'] is String ? json['quickbook_id'] : null;
    quickbookSyncStatus = json['quickbook_sync_status']?.toString();
    referredBy = (json['referred_by'] != null && json['referred_by'] is Map<String, dynamic>) ? CustomerReferredBy.fromJson(json['referred_by']) : null;
    referredByNote = json['referred_by_note']?.toString();
    referredByType = json['referred_by_type']?.toString();
    rep = (json['rep'] != null) ? UserLimitedModel.fromJson(json['rep']) : null;
    repId = json['rep_id']?.toString();
    sourceType = json['source_type']?.toString();
    if(json["meta"] != null && json["meta"] is Map) {
      meta =  Meta.fromJson(json["meta"]);
    }
    
    contacts = [];

    if (json['contacts']?['data'] != null) {
      json['contacts']['data'].forEach((dynamic v) {
        contacts!.add(CompanyContactListingModel.fromApiJson(v));
      });
    }

    if((appointments?.today ?? 0) > 0) {
      appointmentDate = 'today'.tr;
    } else if((appointments?.today ?? 0) < 1 && (appointments?.upcoming ?? 0) > 0) {
      appointmentDate = appointments?.upcomingFirst?.startDate;
    } else {
      appointmentDate = '';
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (additionalEmails != null) {
      for (var v in additionalEmails!) {
        data['additional_emails']?.add(v);
      }
    }
    if (address != null) {
      data['address'] = address!.toJson();
    }
    data['address_id'] = addressId;
    data['appointment_required'] = isAppointmentRequired;
    if (appointments != null) {
      data['appointments'] = appointments!.toJson();
      data['appointment_date'] = appointmentDate;
    }
    data['bid_customer'] = isBidCustomer ?? false ? 1 : 0;
    data['billing_address_id'] = billingAddressId;
    if (billingAddress != null) {
      data['billing'] = billingAddress!.toJson();
    }
    data['unapplied_amount'] = unappliedAmount;
    data['call_center_rep'] = callCenterRep;
    data['call_center_rep_type'] = callCenterRepType;
    data['call_required'] = isCallRequired;
    data['canvasser'] = canvasser;
    data['canvasser_type'] = canvasserType;
    data['company_name'] = companyName;
    data['billing_name'] = billingName;
    data['created_at'] = createdAt;
    if (customFields != null) {
      for (var v in customFields!) {
        data['custom_fields']?['data'].add(v!.toJson());
      }
    }
    data['deleted_at'] = deletedAt;
    data['disable_qbo_financial_syncing'] = disableQboFinancialSyncing;
    data['disable_qbo_sync'] = (isDisableQboSync) ? 1 : 0;
    data['distance'] = distance;
    data['email'] = email;
    data['first_name'] = firstName;
    if (flags != null) {
      for (var v in flags!) {
        data['flags']?['data'].add(v!.toJson());
      }
    }
    data['full_name'] = fullName;
    data['full_name_mobile'] = fullNameMobile;
    data['id'] = id;
    data['is_commercial'] = isCommercial ? 1 : 0;
    data['is_prime_contractor_customer'] = isPrimeContractorCustomer;
    data['jobs_count'] = jobsCount;
    data['last_name'] = lastName;
    data['management_company'] = managementCompany;
    data['note'] = note;
    data['origin'] = origin;
    if (phones != null) {
      for (var v in phones!) {
        data['phones']?['data'].add(v.toJson());
      }
    }
    data['property_name'] = propertyName;
    data['qb_desktop_id'] = qbDesktopId;
    data['quickbook_id'] = quickbookId;
    data['quickbook_sync_status'] = quickbookSyncStatus;
    if (referredBy != null) {
      data['referred_by'] = referredBy!.toJson();
    }
    data['referred_by_note'] = referredByNote;
    data['referred_by_type'] = referredByType;
    if (rep != null) {
      data['rep'] = rep!.toJson();
    }
    data['rep_id'] = repId;
    data['source_type'] = sourceType;
    return data;
  }

  /// [getAppointment] prioritizes returning the first appointment scheduled for today.
  ///  If there are no appointments for today, it falls back to returning the
  ///  first upcoming appointment.
  AppointmentModel? getAppointment() {
    return appointments?.todayFirst ?? appointments?.upcomingFirst;
  }
}

class Meta {
  String? resourceId;
  String? defaultPhotoDir;

  Meta({this.resourceId, this.defaultPhotoDir});

  Meta.fromJson(Map<String, dynamic> json) {
    resourceId = json["resource_id"];
    defaultPhotoDir = json["default_photo_dir"];
  }
}

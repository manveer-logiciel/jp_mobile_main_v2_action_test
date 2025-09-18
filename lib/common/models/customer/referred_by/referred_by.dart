import '../../address/address.dart';
import '../../phone.dart';

class CustomerReferredBy {

  AddressModel? address;
  int? addressId;
  bool? isAppointmentRequired;
  int? bidCustomer;
  AddressModel? billing;
  int? billingAddressId;
  String? callCenterRep;
  String? callCenterRepType;
  bool? isCallRequired;
  String? canvasser;
  String? canvasserType;
  String? companyName;
  String? createdAt;
  String? deletedAt;
  bool? isDisableQboFinancialSyncing;
  int? disableQboSync;
  String? distance;
  String? email;
  String? firstName;
  String? fullName;
  String? fullNameMobile;
  int? id;
  int? isCommercial;
  int? isPrimeContractorCustomer;
  String? jobsCount;
  String? lastName;
  String? managementCompany;
  bool? isNewFolderStructure;
  String? note;
  String? origin;
  PhoneModel? phones;
  String? propertyName;
  String? qbDesktopId;
  String? quickbookId;
  String? quickbookSyncStatus;
  String? referredByNote;
  String? referredByType;
  String? repId;
  String? sourceType;
  int? totalJobsCount;
  int? unappliedAmount;

  CustomerReferredBy({
    this.address,
    this.addressId,
    this.isAppointmentRequired,
    this.bidCustomer,
    this.billing,
    this.billingAddressId,
    this.callCenterRep,
    this.callCenterRepType,
    this.isCallRequired,
    this.canvasser,
    this.canvasserType,
    this.companyName,
    this.createdAt,
    this.deletedAt,
    this.isDisableQboFinancialSyncing,
    this.disableQboSync,
    this.distance,
    this.email,
    this.firstName,
    this.fullName,
    this.fullNameMobile,
    this.id,
    this.isCommercial,
    this.isPrimeContractorCustomer,
    this.jobsCount,
    this.lastName,
    this.managementCompany,
    this.isNewFolderStructure,
    this.note,
    this.origin,
    this.phones,
    this.propertyName,
    this.qbDesktopId,
    this.quickbookId,
    this.quickbookSyncStatus,
    this.referredByNote,
    this.referredByType,
    this.repId,
    this.sourceType,
    this.totalJobsCount,
    this.unappliedAmount,
  });

  CustomerReferredBy.fromJson(Map<String, dynamic> json) {
    address = (json['address'] != null) ? AddressModel.fromJson(json['address']) : null;
    addressId = json['address_id']?.toInt();
    isAppointmentRequired = json['appointment_required'];
    bidCustomer = json['bid_customer']?.toInt();
    billing = (json['billing'] != null) ? AddressModel.fromJson(json['billing']) : null;
    billingAddressId = json['billing_address_id']?.toInt();
    callCenterRep = json['call_center_rep']?.toString();
    callCenterRepType = json['call_center_rep_type']?.toString();
    isCallRequired = json['call_required'];
    canvasser = json['canvasser']?.toString();
    canvasserType = json['canvasser_type']?.toString();
    companyName = json['company_name']?.toString();
    createdAt = json['created_at']?.toString();
    deletedAt = json['deleted_at']?.toString();
    isDisableQboFinancialSyncing = json['disable_qbo_financial_syncing'];
    disableQboSync = json['disable_qbo_sync']?.toInt();
    distance = json['distance']?.toString();
    email = json['email']?.toString();
    firstName = json['first_name']?.toString();
    fullName = json['full_name']?.toString() ??  json['name']?.toString();
    fullNameMobile = json['full_name_mobile']?.toString();
    id = json['id']?.toInt();
    isCommercial = json['is_commercial']?.toInt();
    isPrimeContractorCustomer = json['is_prime_contractor_customer']?.toInt();
    jobsCount = json['jobs_count']?.toString();
    lastName = json['last_name']?.toString();
    managementCompany = json['management_company']?.toString();
    isNewFolderStructure = json['new_folder_structure'];
    note = json['note']?.toString();
    origin = json['origin']?.toString();
    phones = (json['phones'] != null) ? PhoneModel.fromJson(json['phones']) : null;
    propertyName = json['property_name']?.toString();
    qbDesktopId = json['qb_desktop_id']?.toString();
    quickbookId = json['quickbook_id']?.toString();
    quickbookSyncStatus = json['quickbook_sync_status']?.toString();
    referredByNote = json['referred_by_note']?.toString();
    referredByType = json['referred_by_type']?.toString();
    repId = json['rep_id']?.toString();
    sourceType = json['source_type']?.toString();
    totalJobsCount = json['total_jobs_count']?.toInt();
    unappliedAmount = json['unapplied_amount']?.toInt();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (address != null) {
      data['address'] = address!.toJson();
    }
    data['address_id'] = addressId;
    data['appointment_required'] = isAppointmentRequired;
    data['bid_customer'] = bidCustomer;
    if (billing != null) {
      data['billing'] = billing!.toJson();
    }
    data['billing_address_id'] = billingAddressId;
    data['call_center_rep'] = callCenterRep;
    data['call_center_rep_type'] = callCenterRepType;
    data['call_required'] = isCallRequired;
    data['canvasser'] = canvasser;
    data['canvasser_type'] = canvasserType;
    data['company_name'] = companyName;
    data['created_at'] = createdAt;
    data['deleted_at'] = deletedAt;
    data['disable_qbo_financial_syncing'] = isDisableQboFinancialSyncing;
    data['disable_qbo_sync'] = disableQboSync;
    data['distance'] = distance;
    data['email'] = email;
    data['first_name'] = firstName;
    data['full_name'] = fullName;
    data['full_name_mobile'] = fullNameMobile;
    data['id'] = id;
    data['is_commercial'] = isCommercial;
    data['is_prime_contractor_customer'] = isPrimeContractorCustomer;
    data['jobs_count'] = jobsCount;
    data['last_name'] = lastName;
    data['management_company'] = managementCompany;
    data['new_folder_structure'] = isNewFolderStructure;
    data['note'] = note;
    data['origin'] = origin;
    if (phones != null) {
      data['phones'] = phones!.toJson();
    }
    data['property_name'] = propertyName;
    data['qb_desktop_id'] = qbDesktopId;
    data['quickbook_id'] = quickbookId;
    data['quickbook_sync_status'] = quickbookSyncStatus;
    data['referred_by_note'] = referredByNote;
    data['referred_by_type'] = referredByType;
    data['rep_id'] = repId;
    data['source_type'] = sourceType;
    data['total_jobs_count'] = totalJobsCount;
    data['unapplied_amount'] = unappliedAmount;
    return data;
  }
}
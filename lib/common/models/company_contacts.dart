import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/address/address.dart';
import 'package:jobprogress/common/models/email.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/common/models/sql/tag/tag.dart';

import '../../core/utils/helpers.dart';

class CompanyContactListingModel {
  int? id;
  String? firstName;
  String? lastName;
  String? fullName;
  String? fullNameMobile;
  String? companyName;
  String? intial;
  String? createdAt;
  String? updatedAt;
  late bool isPrimary;
  int? isPrimeContractor;
  AddressModel? address;
  String? addressString;
  List<PhoneModel>? phones;
  List<EmailModel>? emails;
  List<TagModel>? tags;
  Color? color;
  late bool checked;
  bool? isCompanyContact;

  CompanyContactListingModel({
    this.id,
    this.firstName,
    this.lastName,
    this.fullName,
    this.fullNameMobile,
    this.companyName,
    this.createdAt,
    this.updatedAt,
    this.intial,
    this.isPrimary = false,
    this.isPrimeContractor,
    this.address,
    this.addressString,
    this.phones,
    this.emails,
    this.tags,
    this.checked = false,
    this.color,
    this.isCompanyContact,
  });

  CompanyContactListingModel.fromApiJson(Map<String, dynamic> json) {
    checked = false;
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    fullName = json['full_name'];
    fullNameMobile = json['full_name_mobile'];
    companyName = json['company_name'];
    createdAt = json['created_at'];
    intial = Helper.isValueNullOrEmpty(firstName) ? '' : firstName![0] + 
      (Helper.isValueNullOrEmpty(lastName) ? '' : lastName![0]);
    updatedAt = json['updated_at'];
    isPrimary = (json['is_primary']?.toInt() ?? false) == 1;
    isPrimeContractor = json['is_prime_contractor'];
    color = null;
    address = json['address'] != null ? AddressModel.fromJson(json['address']) : null;
    isCompanyContact =  (json['is_company_contact']?.toInt() ?? false) == 1;
    addressString = Helper.convertAddress(address);
    if (json['phones'] != null) {
      phones = <PhoneModel>[];
      json['phones']['data'].forEach((dynamic v) {
        phones!.add(PhoneModel.fromJson(v));
      });
    }
    emails = <EmailModel>[];
    if (json['emails'] != null) {
      json['emails']['data'].forEach((dynamic v) {
        emails!.add(EmailModel.fromJson(v));
      });
    }
    if ((emails?.isEmpty ?? false) && (json['email']?.toString().isNotEmpty ?? false)) {
      emails!.add(EmailModel(email: json['email']));
    }
    if (json['tags'] != null) {
      tags = <TagModel>[];
      json['tags']['data'].forEach((dynamic v) {
        tags!.add(TagModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['full_name'] = fullName;
    data['full_name_mobile'] = fullNameMobile;
    data['company_name'] = companyName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['is_primary'] = isPrimary ? 1 : 0;
    data['is_prime_contractor'] = isPrimeContractor;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    if (phones != null) {
      data['phones'] = phones!.map((v) => v.toJson()).toList();
    }
    if (emails != null) {
      data['emails'] = emails!.map((v) => v.toJson()).toList();
    }
    if (tags != null) {
      data['tags'] = tags!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  CompanyContactListingModel.fromJobFormContactJson(Map<String, dynamic> json) {
    checked = false;
    id = int.tryParse(json['id'].toString());
    firstName = json['first_name'];
    lastName = json['last_name'];
    fullName = json['full_name'];
    fullNameMobile = json['full_name_mobile'];
    companyName = json['company_name'];
    createdAt = json['created_at'];
    intial = Helper.isValueNullOrEmpty(firstName) ? '' : firstName![0] + 
      (Helper.isValueNullOrEmpty(lastName) ? '' : lastName![0]);
    updatedAt = json['updated_at'];
    isPrimary = Helper.isTrue(json['is_primary']);
    isPrimeContractor = json['is_prime_contractor'];
    color = null;
    address = AddressModel.fromJson(json);
    addressString = Helper.convertAddress(address);
    isCompanyContact = Helper.isTrue(json['is_company_contact']);

    phones = <PhoneModel>[];
    json['phones']?.forEach((dynamic phoneJson) {
      if (phoneJson != null) {
        phones!.add(PhoneModel.fromJson(phoneJson));
      }
    });
    
    emails = <EmailModel>[];
    json['emails']?.forEach((dynamic emailJson) {
      if (emailJson != null) {
        emails!.add(EmailModel.fromJson(emailJson));
      }
    });
    
    if ((emails?.isEmpty ?? false) && (json['email']?.toString().isNotEmpty ?? false)) {
      emails!.add(EmailModel(email: json['email']));
    }
  }

  Map<String, dynamic> toJobContactJson() {
    final Map<String, dynamic> data = {};
    firstName ??= '';
    lastName ??= '';

    data['id'] = id ?? '';
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['full_name'] = '${firstName!} ${lastName!}';
    data['company_name'] = companyName ?? '';
    data['address'] = address?.address ?? '';
    data['address_line_1'] = address?.addressLine1 ?? '';
    data['city'] = address?.city ?? '';
    data['state_id'] = address?.stateId ?? address?.state?.id;
    data['country_id'] = address?.countryId ?? address?.country?.id;
    data['zip'] = address?.zip ?? '';
    data['is_primary'] = isPrimary ? 1 : 0;

    if (isCompanyContact != null) {
      data['type'] = isCompanyContact ?? false ? 'company' : 'job';
    }
    
    if (!Helper.isValueNullOrEmpty(emails)) {
      emails!.first.isPrimary = 1;
      List<Map<String, dynamic>> emailJsonList = [];
      for (EmailModel emailModel in emails!) {
        if (emailModel.email.trim().isNotEmpty) {
          emailJsonList.add(emailModel.toJson());
        }
      }
      data['emails'] = emailJsonList;
    }

    if (!Helper.isValueNullOrEmpty(phones)) {
      phones!.first.isPrimary = 1;
      data['phones'] = phones!.map((phone) => phone.toJson(withUnmaskNumber: true)).toList();
    }

    return data;
  }
}

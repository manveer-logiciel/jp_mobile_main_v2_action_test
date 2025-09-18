import 'dart:convert';

import 'package:jobprogress/common/models/address/address.dart';
import 'package:jobprogress/common/models/sql/state/state.dart';
import 'package:jobprogress/core/utils/helpers.dart';

class CompanyModel {
  late int id;
  int? stateId;
  int? countryId;
  late String companyName;
  String? logo;
  String? email;
  List<String>? additionalEmail;
  String? phone;
  List<String>? additionalPhone;
  String? address;
  String? addressLine1;
  String? fax;
  String? street;
  String? city;
  String? zip;
  String? stateName;
  String? stateCode;
  String? countryName;
  String? countryCode;
  String? phoneCode;
  String? currencySymbol;
  String? phoneFormat;
  String? licenseNumber;
  String? intial;
  int? resourceId;
  List<String>? allPhones;
  List<String>? allEmails;
  String? convertedAddress;
  String? createdAt;

  CompanyModel({
    required this.companyName,
    required this.id,
    this.logo,
    this.email,
    this.additionalEmail,
    this.phone,
    this.additionalPhone,
    this.address,
    this.addressLine1,
    this.fax,
    this.street,
    this.city,
    this.zip,
    this.stateId,
    this.stateName,
    this.stateCode,
    this.countryId,
    this.countryName,
    this.countryCode,
    this.phoneCode,
    this.currencySymbol,
    this.phoneFormat,
    this.intial,
    this.resourceId,
    this.licenseNumber,
    this.allPhones,
    this.allEmails,
    this.convertedAddress,
    this.createdAt
  });

  CompanyModel.fromApiJson(Map<String, dynamic> json) {
    id = json['id'];
    companyName = json['company_name'];
    logo = json['logo'];
    email = json['office_email'];
    phone = json['office_phone'];
    additionalPhone = json['office_additional_phone']?.cast<String>();
    additionalEmail = json['office_additional_email']?.cast<String>();
    address = json['office_address'];
    addressLine1 = json['office_address_line_1'];
    fax = json['office_fax'];
    street = json['office_street'];
    city = json['office_city'];
    zip = json['office_zip'];
    stateId = json['office_state_id'];
    stateName = json['office_state']?['name'];
    stateCode = json['office_state']?['code'];
    countryId = json['office_country_id'];
    countryName = json['office_country']?['name'];
    countryCode = json['office_country']?['code'];
    phoneCode = json['office_country']?['phone_code'];
    currencySymbol = json['office_country']?['currency_symbol'];
    phoneFormat = json['phone_format'];
    resourceId = json['subscriber_resource_id'];
    licenseNumber = json['license_number'];

    allPhones = [];

    if(phone != null && phone!.isNotEmpty) {
      allPhones!.add(phone!);
    }

    if(additionalPhone != null && additionalPhone!.isNotEmpty) {
      allPhones!.addAll(additionalPhone!);
    }

    allEmails = [];

    if(email != null && email!.isNotEmpty) {
      allEmails!.add(email!);
    }

    if(additionalEmail != null && additionalEmail!.isNotEmpty) {
      allEmails!.addAll(additionalEmail!);
    }

    AddressModel addressModel = AddressModel(
      id: -1,
      address: address,
      addressLine1: addressLine1,
      city: city,
      state: StateModel(id: stateId ?? -1, name: stateName ?? "",  code: stateCode ?? "", countryId: countryId ?? -1),
      zip: zip,
    );
    convertedAddress = Helper.convertAddress(addressModel);
    createdAt = json['created_at'];
  }

  CompanyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyName = json['company_name'];
    intial = Helper.isValueNullOrEmpty(companyName)? '' : companyName[0];
    logo = json['logo'];
    email = json['email'];
    phone = json['phone'];
    additionalPhone = json['office_additional_phone']?.cast<String>();
    additionalEmail = json['office_additional_email']?.cast<String>();
    address = json['address'];
    addressLine1 = json['address_line_1'];
    fax = json['fax'];
    street = json['street'];
    city = json['city'];
    zip = json['zip'];
    stateId = json['state_id'];
    stateName = json['state_name'];
    stateCode = json['state_code'];
    countryId = json['country_id'];
    countryName = json['country_name'];
    countryCode = json['country_code'];
    phoneCode = json['phone_code'];
    currencySymbol = json['currency_symbol'];
    phoneFormat = json['phone_format'];
    resourceId = json['subscriber_resource_id'];
    licenseNumber = json['license_number'];
    createdAt = json['created_at'];
  }
  
  CompanyModel.fromSqlToJson(Map<String, dynamic> json) {
    id = json['id'];
    companyName = json['company_name'];
    intial = Helper.isValueNullOrEmpty(companyName) ? '': companyName[0];
    logo = json['logo'];
    email = json['email'];
    phone = json['phone'];
    additionalPhone = jsonDecode(json['additional_phone']);
    additionalEmail = jsonDecode(json['additional_email']);
    address = json['address'];
    addressLine1 = json['address_line_1'];
    fax = json['fax'];
    street = json['street'];
    city = json['city'];
    zip = json['zip'];
    stateId = json['state_id'];
    stateName = json['state_name'];
    stateCode = json['state_code'];
    countryId = json['country_id'];
    countryName = json['country_name'];
    countryCode = json['country_code'];
    phoneCode = json['phone_code'];
    currencySymbol = json['currency_symbol'];
    phoneFormat = json['phone_format'];
    resourceId = json['subscriber_resource_id'];
    licenseNumber = json['license_number'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['company_name'] = companyName;
    data['logo'] = logo;
    data['email'] = email;
    data['phone'] = phone;
    data['address'] = address;
    data['address_line_1'] = addressLine1;
    data['additional_phone'] = jsonEncode(additionalPhone);
    data['additional_email'] = jsonEncode(additionalEmail);
    data['fax'] = fax;
    data['street'] = street;
    data['city'] = city;
    data['zip'] = zip;
    data['state_id'] = stateId;
    data['state_name'] = stateName;
    data['state_code'] = stateCode;
    data['country_id'] = countryId;
    data['country_name'] = countryName;
    data['country_code'] = countryCode;
    data['phone_code'] = phoneCode;
    data['currency_symbol'] = currencySymbol;
    data['phone_format'] = phoneFormat;
    data['license_number'] = licenseNumber;
    return data;
  }
}

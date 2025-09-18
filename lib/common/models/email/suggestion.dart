import 'package:jobprogress/common/models/company_contacts.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';

class EmailSuggestionModel{
List<UserModel>? users;
List<UserModel>? labour;
List<CompanyContactListingModel>? contacts;
List<CustomerModel>? customer;

EmailSuggestionModel(
  this.contacts,
  this.customer,
  this.labour,
  this.users
);

EmailSuggestionModel.fromJson(Map<dynamic, dynamic> json){
  if(json['users'] != null) {
    users = <UserModel>[];
    json['users'].forEach((dynamic v) {
      users!.add(UserModel.fromJson(v));
    });
  }
  if(json['company_contacts'] != null) {
    contacts = [];
    json['company_contacts'].forEach((dynamic v) {
      contacts!.add(CompanyContactListingModel.fromApiJson(v));
    });
  }
  if(json['labors'] != null) {
    labour = [];
    json['labors'].forEach((dynamic v) {
      labour!.add(UserModel.fromJson(v));
    });
  }
  if(json['customers'] != null) {
    customer = [];
    json['customers'].forEach((dynamic attendee) {
      customer!.add(CustomerModel.fromJson(attendee));
    });
  } 
}
}
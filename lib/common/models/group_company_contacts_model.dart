import 'package:jobprogress/common/models/company_contacts.dart';

class GroupCompanyContactListingModel {
  String groupName;
  List<CompanyContactListingModel> groupValues;

  GroupCompanyContactListingModel({
    required this.groupName,
    required this.groupValues
  });
}

import 'email.dart';

class GroupEmailListingModel {
  String groupName;
  List<EmailListingModel> groupValues;
  GroupEmailListingModel({
    required this.groupName,
    required this.groupValues
  });
}

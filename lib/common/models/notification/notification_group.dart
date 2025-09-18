import 'package:jobprogress/common/models/notification/notification.dart';

class GroupNotificationListingModel {
  String groupName;
  List<NotificationListingModel> groupValues;
  GroupNotificationListingModel({
    required this.groupName,
    required this.groupValues
  });
}

import 'package:jobprogress/core/constants/pagination_constants.dart';

class NotificationListingParamModel {
  late int limit;
  late int page;
  late bool unreadOnly;
  late bool readOnly;

  NotificationListingParamModel({
    this.limit = PaginationConstants.pageLimit,
    this.page = 1,
    this.unreadOnly = false,
    this.readOnly = false,
  });

  NotificationListingParamModel.fromJson(Map<String, dynamic> json) {
    limit = json['limit'];
    page = json['page'];
    unreadOnly = json['unread_only'];
    readOnly = json['read_only'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['limit'] = limit;
    data['page'] = page;
    data['unread_only'] = unreadOnly ? 1:0;
    data['read_only'] = readOnly ? 1:0;
    return data;
  }
}

import 'package:jobprogress/core/constants/pagination_constants.dart';

class JobSwitcherParamModel {
  int? limit;
  late int page;
  int? customerId;
  int? optimized;
  int? parentId;
  String? sortBy;
  String? sortOrder;

  JobSwitcherParamModel({
    this.limit = PaginationConstants.pageLimit,
    this.page = 1,
    this.parentId,
    this.sortBy,
    this.sortOrder,
    this.customerId,
    this.optimized
  });

  JobSwitcherParamModel.fromJson(Map<String, dynamic> json) {
    limit = json['limit'];
    page = json['page'];
    customerId = json['customer_id'];
    optimized = json['optimized'];
    parentId = json['parent_id'];
    sortBy = json['sort_by'];
    sortOrder = json['sort_order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['limit'] = limit;
    data['page'] = page;
    data['customer_id'] = customerId;
    data['optimized'] = optimized;
    data['parent_id'] = parentId;
    if(parentId != null) {
      data['sort_by'] = "display_order";
      data['sort_order'] = "asc";
    } else {
      data['sort_by'] = sortBy;
      data['sort_order'] = sortOrder;
    }
    return data;
  }
}

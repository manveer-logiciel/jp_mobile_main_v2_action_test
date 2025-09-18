import 'package:jobprogress/core/constants/pagination_constants.dart';

class ThirdPartyToolsParamModel {
  late int limit;
  late int page;

  ThirdPartyToolsParamModel({
    this.limit = PaginationConstants.pageLimit,
    this.page = 1});

  ThirdPartyToolsParamModel.fromJson(Map<String, dynamic> json) {
    limit = int.tryParse(json['limit']?.toString() ?? '')!;
    page = int.tryParse(json['page']?.toString() ?? '')!;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['limit'] = limit;
    data['page'] = page;
    return data;
  }
}
import 'package:jobprogress/core/constants/pagination_constants.dart';

class SnippetListingParamModel {
  String? limit;
  late int page;
  String? title;

  SnippetListingParamModel({
    this.limit = '${PaginationConstants.pageLimit}',
    this.page = 1,
    this.title = ''
  });

  SnippetListingParamModel.fromJson(Map<String, dynamic> json) {
    limit = json['limit'];
    page = json['page'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['limit'] = limit;
    data['page'] = page;
    data['title'] = title;
    return data;
  }
}
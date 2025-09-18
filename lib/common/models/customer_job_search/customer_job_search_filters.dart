import '../../../core/constants/pagination_constants.dart';

class CustomerJobSearchFilterModel {
  late int limit;
  late int page;
  late bool isWithJob;
  String? keyword;

  CustomerJobSearchFilterModel({
    this.limit = PaginationConstants.pageLimit,
    this.page = 1,
    this.keyword,
    this.isWithJob = true});

  CustomerJobSearchFilterModel.fromJson(Map<String, dynamic> json) {
    limit = int.tryParse(json['limit']?.toString() ?? '')!;
    page = int.tryParse(json['page']?.toString() ?? '')!;
    keyword = json['keyword']?.toString();
    isWithJob = (json['with_job'] ?? 0) == 1;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['limit'] = limit;
    data['page'] = page;
    data['keyword'] = keyword;
    data['with_job'] = isWithJob ? 1 : 0;
    return data;
  }
}
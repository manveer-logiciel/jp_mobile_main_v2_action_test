
class PaginationModel {
  int? total;
  int? count;
  int? perPage;
  int? currentPage;
  int? totalPages;

  PaginationModel({this.total, this.count, this.perPage, this.currentPage, this.totalPages});

  PaginationModel.fromJson(Map<String, dynamic> json) {
    total = json["total"] ?? 0;
    count = json["count"] ?? 0;

    if(count == 0) total = 0;

    perPage = json["per_page"];
    currentPage = json["current_page"] != null ? int.parse(json["current_page"].toString()) : null;
    totalPages = json["total_pages"];
  }

  PaginationModel.fromCompanyCamJson(Map<String, dynamic> json) {
    currentPage = json["page"] != null ? int.parse(json["page"].toString()) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data["total"] = total;
    data["count"] = count;
    data["per_page"] = perPage;
    data["current_page"] = currentPage;
    data["total_pages"] = totalPages;
    return data;
  }
}
import '../../../core/constants/pagination_constants.dart';

class CustomerListingFilterModel {
  late int limit;
  late int page;
  String? selectedItem;
  String? sortBy;
  String? sortOrder;
  double? distance;
  double? lat;
  double? long;
  bool? isOptimized;

  String? name;
  String? nameFilterType;
  String? phone;
  String? email;
  String? address;
  String? zipCode;
  String? customerNote;
  List<int>? repIds = [];
  List<int>? stateIds = [];
  List<int?>? flags;


  CustomerListingFilterModel({
    this.limit = PaginationConstants.pageLimit,
    this.page = 1,
    this.sortBy = 'created_at',
    this.selectedItem = 'created_at',
    this.sortOrder = 'desc',
    this.isOptimized = true,
    this.repIds,
    this.name,
    this.nameFilterType = "name",
    this.phone,
    this.email,
    this.address,
    this.stateIds,
    this.zipCode,
    this.customerNote,
    this.flags
  });

  factory CustomerListingFilterModel.copy(CustomerListingFilterModel data) {
    return CustomerListingFilterModel(
      repIds:  data.repIds,
      stateIds: data.stateIds
    );
  }

  CustomerListingFilterModel.fromJson(Map<String, dynamic> json) {
    limit = json['limit'];
    page = json['page'];
    selectedItem = json['selected_item'];
    sortBy = json['sort_by'];
    sortOrder = json['sort_order'];
    distance = json['distance'];
    lat = json['lat'];
    long = json['long'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    address = json['address'];
    zipCode = json['zip_code'];
    customerNote = json['customer_note'];
    if (json['rep_ids'] != null) {
      repIds = [];
      json['rep_ids'].forEach((dynamic v) {
        repIds!.add(v.toInt());
      });
    }
    if (json['state_id'] != null) {
      stateIds = [];
      json['state_id'].forEach((dynamic v) {
        stateIds!.add(v.toInt());
      });
    }
    if (json['flags'] != null && (json['flags'] is List)) {
      flags = [];
      json['flags'].forEach((dynamic v) {
        flags!.add(int.tryParse(v.toString()));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['limit'] = limit;
    data['page'] = page;
    data['sort_by'] = sortBy;
    data['sort_order'] = sortOrder;
    data['distance'] = distance;
    data['lat'] = lat;
    data['long'] = long;
    data['$nameFilterType'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['address'] = address;
    data['zip_code'] = zipCode;
    data['customer_note'] = customerNote;
    data['is_optimized'] = sortBy!.contains("distance") ? null : isOptimized ?? true ? 1 : 0;
    if (repIds != null) {
      data['rep_ids'] = <dynamic>[];
      for (var v in repIds!) {
        data['rep_ids'].add(v);
      }
    }
    if (stateIds != null) {
      data['state_id'] = <dynamic>[];
      for (var v in stateIds!) {
        data['state_id'].add(v);
      }
    }
    if (flags != null) {
      data['flags'] = <dynamic>[];
      for (var v in flags!) {
        data['flags'].add(v);
      }
    }
    return data;
  }
}

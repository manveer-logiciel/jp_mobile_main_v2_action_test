import 'dart:async';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/network_multiselect.dart';
import 'package:jobprogress/common/models/network_multiselect/network_multiselect_request_params.dart';
import 'package:jobprogress/common/models/pagination_model.dart';
import 'package:jobprogress/common/services/network_multiselet/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';

class JPLoadMoreMultiSelectController extends GetxController {

  JPLoadMoreMultiSelectController(this.type, this.additionalParams);

  final JPNetworkMultiSelectType type;

  final Map<String, dynamic>? additionalParams;

  List<JPMultiSelectModel> mainList = [];

  bool isLoading = true;
  bool isLoadMore = false;
  bool isSearching = false;
  bool canShowLoadMore = false;

  int? totalCount;

  JPNetworkMultiSelectParams requestParams = JPNetworkMultiSelectParams();

  @override
  void onInit() {
    fetchList();
    super.onInit();
  }

  Future<void> fetchList() async {
    try {

      Map<String, dynamic> params = {
        'limit' : requestParams.limit,
        'page' : requestParams.page,
        'keyword' : requestParams.keyword,
      };

      if(additionalParams != null)  params.addAll(additionalParams!);

      final response = await JPNetworkMultiSelectService.typeToApi(type, params);

      List<dynamic> dataList = response['list'];
      PaginationModel pagination = PaginationModel.fromJson(response['pagination']);

      if(isLoading) {
        mainList.clear();
      }

      mainList.addAll(JPNetworkMultiSelectService.parseToMultiSelect(type, dataList));

      canShowLoadMore = mainList.length < pagination.total!;
      totalCount ??= pagination.total!;

    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      isLoadMore = false;
      isSearching = false;
      update();
    }
  }

  void onLoadMore() {
    isLoadMore = true;
    isSearching = true;
    requestParams.page += 1;
    update();
    fetchList();
  }

  void onSearch(String val) {
    requestParams.keyword = val;
    requestParams.page = 1;
    isLoading = true;
    isSearching = true;
    update();
    fetchList();
  }

}
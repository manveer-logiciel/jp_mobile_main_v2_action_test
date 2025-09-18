import 'package:get/get.dart';
import 'package:jobprogress/common/enums/network_singleselect.dart';
import 'package:jobprogress/common/models/network_singleselect/params.dart';
import 'package:jobprogress/common/models/pagination_model.dart';
import 'package:jobprogress/common/services/network_singleselect/index.dart';
import 'package:jobprogress/core/constants/pagination_constants.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JPNetworkSingleSelectController extends GetxController {

  JPNetworkSingleSelectController({
    required this.type,
    this.requestParams,
    this.mainList = const []
  });

  final JPNetworkSingleSelectType type;
  final List<JPSingleSelectModel> mainList;// used to hold options to select from

  bool isLoading = true; // helps in displaying shimmer
  bool isLoadMore = false; // helps in managing load more state
  bool isSearching = false; // helps in managing search state
  bool? canSearch; // helps in managing search state

  JPSingleSelectParams? requestParams;

  bool get canShowLoadMore => requestParams?.canShowLoadMore ?? false;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  void init() async {
    // In case list is to be fetched again and again on every time network single select is opens
    // we'll not set the request params.
    // If want working like 'a part of list is to be pre-loaded' then we can set request params
    // outside the controller and can then pass in while loading the list, so that
    // previously loaded data should persists and not be fetched again.
    if (requestParams == null) {
      requestParams ??= JPSingleSelectParams();
      fetchList();
    } else {
      setUpList();
    }
  }

  void setUpList() {
    requestParams?..page = 1
      ..keyword = ''
      ..canShowLoadMore = mainList.length < requestParams!.total;
    isLoading = false;
    isLoadMore = false;
    isSearching = false;
    toggleSearch(mainList.length >= PaginationConstants.pageLimit);
    update();
  }

  Future<void> fetchList() async {
    try {

      final response = await JPNetworkSingleSelectService.typeToApi(type, requestParams!);

      List<dynamic> dataList = response['list'];
      PaginationModel pagination = PaginationModel.fromJson(response['pagination']);

      if(isLoading) {
        mainList.clear();
      }

      mainList.addAll(JPNetworkSingleSelectService.parseToMultiSelect(type, dataList));

      requestParams?.canShowLoadMore = mainList.length < pagination.total!;

      toggleSearch(mainList.length >= PaginationConstants.pageLimit);

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
    requestParams?.page += 1;
    update();
    fetchList();
  }

  Future<void> onSearch(String val) async {
    requestParams?.keyword = val;
    requestParams?.page = 1;
    isLoading = true;
    isSearching = true;
    update();
    await fetchList();
  }

  void toggleSearch(bool val) {
    canSearch ??= val;
    update();
  }

  JPSingleSelectModel? getSelectedItem(String selectedId) {
    return mainList.firstWhereOrNull((element) => element.id == selectedId);
  }

}
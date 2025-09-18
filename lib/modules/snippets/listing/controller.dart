import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/snippet_trade_script.dart';
import 'package:jobprogress/common/models/pagination_model.dart';
import 'package:jobprogress/common/models/snippet_listing/snippet_list_param.dart';
import 'package:jobprogress/common/models/snippet_listing/snippet_listing.dart';
import 'package:jobprogress/common/models/trade_script_listing/trade_script_listing.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/common/repositories/company_trades.dart';
import 'package:jobprogress/common/repositories/snippet_listing.dart';
import 'package:jobprogress/common/repositories/trade_script_listing.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/modules/snippets/detail_dialog/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../core/constants/navigation_parms_constants.dart';

class SnippetsListingController extends GetxController {
  bool isLoading = true;
  String copiedDescription = "";
  bool isLoadingMore = false;
  bool canShowMore = false;
  final scaffoldKey =
      GlobalKey<ScaffoldState>(debugLabel: 'snippet_controller_scaffold_key');
  TextEditingController searchController = TextEditingController();

  List<JPSingleSelectModel> filterByList = [];
  String? selectedFilterByOptions;

  List<SnippetListModel> snippetList = [];
  SnippetListingParamModel snippetListingParam = SnippetListingParamModel();

  STArg type = Get.arguments != null ? Get.arguments[NavigationParams.type] : STArg.snippet;
  STArgType? pageCallType = Get.arguments?[NavigationParams.pageType];

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  Future<void> fetchData() async {
    try {
      switch (type) {
        case STArg.snippet:
          await fetchSnippets();
          break;
        case STArg.tradeScript:
          await fetchTradeScripts().whenComplete(() {
            if (filterByList.isEmpty) {
              fetchCompanyTrades();
            }
          });
          break;
      }
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      isLoadingMore = false;
      update();
    }
  }

  Future<void> fetchSnippets() async {
    Map<String, dynamic> response = await SnippetListingRepository()
        .fetchSnippetList(snippetListingParam.toJson());

    List<SnippetListModel> list = response['list'];
    PaginationModel pagination = response['pagination'];

    if (!isLoadingMore) {
      snippetList = [];
    }

    snippetList.addAll(list);
    canShowMore = snippetList.length < pagination.total!;
  }

  Future<void> fetchTradeScripts() async {
    Map<String, dynamic> param = {
      if (selectedFilterByOptions != null)
        'trade_ids[]': selectedFilterByOptions,
      ...snippetListingParam.toJson()
    };

    Map<String, dynamic> response =
        await TradeScriptListingRepository().fetchSnippetList(param);

    List<TradeScriptListModel> list = response['list'];
    PaginationModel pagination = response['pagination'];

    if (!isLoadingMore) {
      snippetList = [];
    }

    for (TradeScriptListModel s in list) {
      snippetList.add(s.snippetListModel!);
    }

    canShowMore = snippetList.length < pagination.total!;
  }

  Future<void> fetchCompanyTrades() async {
    try {
      List<JPSingleSelectModel> response = await CompanyTradesRepository().fetchTradeList({});
      filterByList.clear();
      filterByList.addAll(response);
    } catch (e) {
      Helper.handleError(e);
    } finally {
      update();
    }
  }

  Future<void> loadMore() async {
    snippetListingParam.page += 1;
    isLoadingMore = true;
    await fetchData();
  }

  Future<void> refreshList({bool? showLoading}) async {
    snippetListingParam.page = 1;
    isLoading = showLoading ?? false;
    update();
    await fetchData();
  }

  onSearchTextChanged(String text) {
    snippetListingParam.page = 1;
    snippetListingParam.title = text;
    isLoading = true;
    update();
    fetchData();
  }

  openDetailsDialog(SnippetListModel snippetListModel) async {
    dynamic callback = await showJPGeneralDialog(
      child: (_) => SnippetDetailsDialog(
        type: type,
        data: snippetListModel,
      ),
    );
    if(callback != null && callback) {
      if(pageCallType == STArgType.copyDescription) {
        copiedDescription = copiedDescription
            + (copiedDescription.isNotEmpty  ? "\n" : "")
            + (snippetListModel.description ?? "");
      }
    }
  }

  copyText(String text) async {
    String htmlFreeText = Helper.parseHtmlToText(text);
    Helper.copyToClipBoard(htmlFreeText).whenComplete(() {
      Helper.showToastMessage('description_copied'.tr);
      if(pageCallType == STArgType.copyDescription) {
        copiedDescription = copiedDescription
            + (copiedDescription.isNotEmpty ? "\n" : "")
            + text;
      }
    });
  }

  onSelectingFilter(String value) {
    selectedFilterByOptions = value;
    isLoading = true;
    update();
    fetchData();
  }

  openFilters() {
    showJPBottomSheet(
      child: (_) => JPSingleSelect(
        mainList: filterByList,
        selectedItemId: selectedFilterByOptions,
        title: 'select_trade'.tr.toUpperCase(),
        isFilterSheet: true,
        onItemSelect: (value) {
          Get.back();
          onSelectingFilter(value);
        },
      ),
      enableDrag: false,
      isScrollControlled: true,
    );
  }

  void cancelOnGoingRequest() {
    cancelToken?.cancel();
  }

  @override
  void dispose() {
    cancelOnGoingRequest();
    super.dispose();
  }

}

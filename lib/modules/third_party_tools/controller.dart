import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/company_trades/company_trades_model.dart';
import 'package:jobprogress/common/models/pagination_model.dart';
import 'package:jobprogress/common/models/third_party_tools/all_trades.dart';
import 'package:jobprogress/common/models/third_party_tools/third_party_tools_param.dart';
import 'package:jobprogress/common/repositories/third_party_tools.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jp_mobile_flutter_ui/SingleSelect/index.dart';
import 'package:jp_mobile_flutter_ui/SingleSelect/model.dart';

class ThirdPartyToolsController extends GetxController {
  late GlobalKey<ScaffoldState> scaffoldKey;

  ThirdPartyToolsParamModel paramKeys = ThirdPartyToolsParamModel();
  bool isLoading = true;
  String trade = 'all'.tr;
  List<ThirdPartyToolsModel> allTools = [];
  List<JPSingleSelectModel> tradeListWithCount = [];
  bool isLoadMore = false;
  bool canShowLoadMore = false;
  String selectedId = '0';
  int allTradeCount = 0;

  ////////// selected trade tool param
  Map<String, dynamic> filterToolsParams({String? tradeId}) {
    return <String, dynamic>{'trades[0]': tradeId, ...paramKeys.toJson()};
  }

  ////////// all tools list param
  Map<String, dynamic> allToolsParams() {
    return <String, dynamic>{...paramKeys.toJson()};
  }

////////// fetch all trades list
  Future<void> fetchAllTrades() async {
    Map<String, dynamic> allCountParams = {
      'includes[0]': 'third_party_tools_count'
    };

    try {
      tradeListWithCount.clear();
      final response = await ThirdPartyToolsRepository().fetchCount(allCountParams);
      tradeListWithCount.add(JPSingleSelectModel(label: '${'all'.tr} ($allTradeCount)', id: '0'));
      for (CompanyTradesModel trade in response['list']) {
        tradeListWithCount.add(JPSingleSelectModel(
          label: '${trade.name.toString().capitalize} (${trade.thirdPartyToolsCount})',
          id: trade.id.toString(),
        ));
      }
    } catch (e) {
      rethrow;
    }
  }

////////// fetch all tools list of any trade
  Future<void> fetchAllTools({String? selectedTradeId}) async {
    try {
      Map<String, dynamic> params = (selectedTradeId == '0' || selectedTradeId == null) ? allToolsParams() : filterToolsParams(tradeId: selectedTradeId);

      final response = await ThirdPartyToolsRepository().fetchAllToolsList(params);

      PaginationModel pagination = response['pagination'];

      if(!isLoadMore){
        allTools = [];
      }
      if (selectedTradeId == '0' || selectedTradeId == null) {
        allTradeCount = pagination.total!;
      }

      await fetchAllTrades();
      allTools.addAll(response['list']);
      trade = (trade == 'all'.tr) ? '$trade ($allTradeCount)' : trade;
      canShowLoadMore = pagination.total! > allTools.length;
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      isLoadMore = false;
      update();
    }
  }

////////// Tools loadMore
  Future<void> loadMore() async {
    paramKeys.page += 1;
    isLoadMore = true;
    update();
    await fetchAllTools(selectedTradeId: selectedId);
  }

////////// Refresh allTools list
  Future<void> refreshList({bool? showLoading}) async {
    paramKeys.page = 1;
    ///   show shimmer if showLoading = true
    isLoading = showLoading ?? false;
    update();
    fetchAllTools(selectedTradeId: selectedId);
  }

////////// Open Trades Bootom sheet
  void selectTrade() {
    showJPBottomSheet(
        isScrollControlled: true,
        child: ((controller) {
          return JPSingleSelect(
            mainList: tradeListWithCount,
            inputHintText: 'search_trade'.tr,
            title: 'select_trade'.tr,
            selectedItemId: selectedId,
            onItemSelect: (value) {
              if(value == selectedId) {
                Get.back();
                return;
              }

              trade = tradeListWithCount.firstWhere((element) => element.id == value).label;
              selectedId = value;

              allTools.clear();
              paramKeys.page = 1;

              isLoading = true;
              update();

              fetchAllTools(selectedTradeId: selectedId);
              Get.back();
            },
          );
        }));
  }

  ThirdPartyToolsController() {
    scaffoldKey = GlobalKey<ScaffoldState>();
    fetchAllTools();
  }

  void navigateToDetailScreen(int currentIndex) {
    Helper.launchUrl(allTools[currentIndex].url?.contains("http") ?? false
        ? allTools[currentIndex].url ?? ""
        : "https://www.jobprogress.com/${allTools[currentIndex].url ?? ""}"
    );
  }
}

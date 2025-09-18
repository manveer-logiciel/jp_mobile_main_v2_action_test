import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/third_party_tools/all_trades.dart';
import 'package:jobprogress/modules/third_party_tools/controller.dart';
import 'package:jp_mobile_flutter_ui/SingleSelect/model.dart';

void main() {
  final controller = ThirdPartyToolsController();
  List<ThirdPartyToolsModel> allTools = [];
  List<JPSingleSelectModel> filterList = [];

  test("Third party tools listing should be constructed with default values", () {
    expect(controller.allTools, allTools);
    expect(controller.isLoading, true);
    expect(controller.isLoadMore, true);
    expect(controller.canShowLoadMore, false);
    expect(controller.tradeListWithCount, filterList);
    expect(controller.selectedId, '0');
    expect(controller.trade, 'all'.tr);
    expect(controller.allTradeCount, 0);
  });

  group('Third party tools listing loadMore function should set values', () {
    
    controller.loadMore();  
    test('Third party tools listing loadMore function should set page to 1', () {
      expect(controller.paramKeys.page, 2);
    });
    test('Third party tools listing loadmore function should set isLoading to true', () {
      expect(controller.isLoading, true);
    });
  });
  
  test('Third party tools listing params values should set like',() {
    Map<String, dynamic> testData = {
      ...controller.paramKeys.toJson()
    };

    Map<String, dynamic> test = controller.allToolsParams();
    
    expect(test, testData);
  });

    test('Third party tools listing params values should set as', () {
      String trade = '104';
      Map<String, dynamic> testData = {
        'trades[0]': trade,
        ...controller.paramKeys.toJson()
      };
      Map<String, dynamic> test = controller.filterToolsParams(tradeId: trade);
      expect(test, testData);
    });
  }



import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/enums/run_mode.dart';
import 'package:jobprogress/common/services/run_mode/index.dart';
import 'package:jobprogress/modules/dev_console/controller.dart';

void main() {

  final controller = DevConsoleController();

  setUpAll(() {
    RunModeService.setRunMode(RunMode.unitTesting);
  });

  test('DevConsoleController should be initialized properly', () {
    expect(controller.isLoadingMore, isFalse);
    expect(controller.allLogs, isEmpty);
    expect(controller.currentPage, 1);
    expect(controller.canShowMore, isFalse);
  });

  group("DevConsoleController@onLoadMore should load more logs", () {
    test("Load More should not be performed if there are no more items to load", () {
      controller.canShowMore = false;
      controller.onLoadMore();
      expect(controller.currentPage, 1);
    });

    test('Next set of logs should be loaded, when available', () {
      controller.canShowMore = true;
      controller.onLoadMore();
      expect(controller.currentPage, 2);
      expect(controller.isLoadingMore, isTrue);
    });

    test('Load More should not be performed if already in progress', () {
      controller.onLoadMore();
      expect(controller.currentPage, 2);
    });
  });

  test("DevConsoleController@onRefresh should load items from first page", () {
    controller.onRefresh();
    expect(controller.currentPage, 1);
  });
}
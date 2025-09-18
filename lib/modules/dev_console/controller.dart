import 'package:get/get.dart';
import 'package:jobprogress/common/models/sql/dev_console.dart';
import 'package:jobprogress/common/repositories/sql/dev_console.dart';
import 'package:jobprogress/common/services/run_mode/index.dart';
import 'package:jobprogress/core/constants/pagination_constants.dart';

class DevConsoleController extends GetxController {

  bool isLoadingMore = false; // helps in performing load more
  bool canShowMore = false; // decides whether there are items left to load

  int currentPage = 1; // keeps track of current page

  List<DevConsoleModel> allLogs = <DevConsoleModel>[]; // stores the list of logs

  @override
  void onInit() {
    fetchDevLogs();
    super.onInit();
  }

  /// [fetchDevLogs] loads the list of logs from local DB
  Future<void> fetchDevLogs() async {
    try {
      final logs = await SqlDevConsoleRepository.getLogs(currentPage);
      if (!isLoadingMore) allLogs = [];
      allLogs.addAll(logs);
      canShowMore = allLogs.length >= PaginationConstants.pageLimit && logs.isNotEmpty;
    } catch (e) {
      rethrow;
    } finally {
      isLoadingMore = false;
      update();
    }
  }

  /// [onLoadMore] helps in performing load more
  Future<void> onLoadMore() async {
    if (isLoadingMore || !canShowMore) return;
    currentPage++;
    isLoadingMore = true;
    if (!RunModeService.isUnitTestMode) {
      await fetchDevLogs();
    }
  }

  /// [onRefresh] helps in refreshing
  Future<void> onRefresh() async {
    currentPage = 1;
    allLogs.clear();
    if (!RunModeService.isUnitTestMode) {
      await fetchDevLogs();
    }
  }
}
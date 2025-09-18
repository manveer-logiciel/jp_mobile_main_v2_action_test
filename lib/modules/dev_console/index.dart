import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/modules/dev_console/cache_management/page.dart';
import 'package:jobprogress/modules/dev_console/widgets/error_logs_tab.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'controller.dart';

class DevConsolePage extends StatefulWidget {
  const DevConsolePage({super.key});

  @override
  State<DevConsolePage> createState() => _DevConsolePageState();
}

class _DevConsolePageState extends State<DevConsolePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      global: false,
      init: DevConsoleController(),
      builder: (controller) {
        return JPScaffold(
          appBar: JPHeader(
            title: "dev_console".tr,
            onBackPressed: Get.back<void>,
          ),
          body: Column(
            children: [
              TabBar(
                controller: _tabController,
                labelColor: JPAppTheme.themeColors.primary,
                unselectedLabelColor: JPAppTheme.themeColors.tertiary,
                indicatorColor: JPAppTheme.themeColors.primary,
                indicatorWeight: 2,
                labelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
                tabs: [
                  Tab(
                    icon: const Icon(Icons.bug_report_outlined),
                    text: "error_logs".tr,
                  ),
                  Tab(
                    icon: const Icon(Icons.storage_outlined),
                    text: "storage_distribution".tr, // Updated tab name
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Error Logs Tab - using separate widget
                    ErrorLogsTab(controller: controller),

                    // Storage Distribution Tab
                    const CacheManagementPage(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/main_drawer/index.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'controller.dart';
import 'widgets/page_body.dart';
import 'widgets/shimmer.dart';

class JobProfitLossSummaryView extends StatelessWidget {
  const JobProfitLossSummaryView({super.key,});

  @override
  Widget build(BuildContext context) {

    return GetBuilder<JobProfitLossSummaryController>(
        global: false,
        init: JobProfitLossSummaryController(),
        builder: (JobProfitLossSummaryController controller) {
      return JPScaffold(
        backgroundColor: JPAppTheme.themeColors.inverse,
        appBar: JPHeader(
          title: 'profit_loss_summary'.tr.capitalize!,
          onBackPressed: () => Get.back(),
          actions: [
            IconButton(
                padding: EdgeInsets.zero,
                splashRadius: 20,
                onPressed: () => controller.scaffoldKey.currentState!.openEndDrawer(),
                icon: JPIcon(
                  Icons.menu,
                  color: JPAppTheme.themeColors.base,
                )
            ),
          ],
        ),
        scaffoldKey: controller.scaffoldKey,
        endDrawer: JPMainDrawer(
          selectedRoute: 'job_manager',
          onRefreshTap: controller.refreshPage,
        ),
        body:  (controller.worksheetModel != null)
          ? ProfitLossSummaryViewBody(controller: controller,)
          : const ProfitLossSummaryViewShimmer()
      );
    });
  }
}
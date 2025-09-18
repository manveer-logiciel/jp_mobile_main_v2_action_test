import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../global_widgets/main_drawer/index.dart';
import '../../global_widgets/no_data_found/index.dart';
import '../../global_widgets/scaffold/index.dart';
import 'controller.dart';
import 'widget/list_view.dart';
import 'widget/secondary_header.dart';
import 'widget/shimmer.dart';

class ProgressBoardView extends StatelessWidget {
  const ProgressBoardView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProgressBoardController>(
      global: false,
      init: ProgressBoardController(),
      builder: (controller) {
        return JPScaffold(
          scaffoldKey: controller.scaffoldKey,
          appBar: JPHeader(
            title: 'progress_board'.tr,
            onBackPressed: () => Get.back(),
            actions: controller.getActionButtons(),
          ),
          endDrawer: JPMainDrawer(
            selectedRoute: 'progress_board',
            onRefreshTap: () => controller.refreshList(showShimmer: true)),
          body: JPSafeArea(
            top: false,
            containerDecoration: BoxDecoration(color: JPAppTheme.themeColors.base),
            child: Column(
              children: [
                ProgressBoardSecondaryHeader(pbController: controller),
                controller.isLoading
                  ? ProgressBoardShimmer(controller : controller)
                  : controller.boardList.isEmpty
                    ? Expanded(
                        child: NoDataFound(
                          icon: Icons.assignment_outlined,
                          title: 'no_job_found'.tr.capitalize,
                        ),
                      )
                    : ProgressBoardList(controller: controller),
              ],
            ),
          ),
        );
    });
  }
}

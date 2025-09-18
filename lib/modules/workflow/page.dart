import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/global_widgets/listview/index.dart';
import 'package:jobprogress/global_widgets/main_drawer/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jobprogress/modules/workflow/widgets/shimmer.dart';
import 'package:jobprogress/modules/workflow/widgets/stage_tile.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'controller.dart';

class WorkflowList extends StatelessWidget {
  const WorkflowList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WorkflowListController>(
      global: false,
      init: WorkflowListController(),
      builder: (controller) {
        return JPWillPopScope(
          onWillPop: controller.onWillPopup,
          child: JPScaffold(
            backgroundColor: JPAppTheme.themeColors.inverse,
            endDrawer: JPMainDrawer(
              selectedRoute: 'workflow',
              onRefreshTap: () {
                controller.initPage();
              },
            ),
            scaffoldKey: controller.scaffoldKey,
            appBar: JPHeader(
              onBackPressed: controller.onWillPopup,
              title: 'workflow'.tr,
              actions: [
                IconButton(
                    splashRadius: 20,
                    onPressed: () {
                      controller.scaffoldKey.currentState!.openEndDrawer();
                    },
                    icon: JPIcon(
                      Icons.menu,
                      color: JPAppTheme.themeColors.base,
                    ))
              ],
            ),
            body: JPSafeArea(
              child: controller.isLoading ? const WorkflowShimmer() : Column(
                children: [
                  JPListView(
                    padding: const EdgeInsets.only(top: 16),
                    onRefresh: controller.loadStages,
                    listCount: controller.stages.length-1,
                    itemBuilder: (BuildContext context, int index) {
                      return WorkFlowStageTile(stage: controller.stages[index], onTileTap: () {
                        Get.toNamed(
                          Routes.jobListing,
                          arguments: {
                            NavigationParams.stageId: controller.stages[index].code,
                            NavigationParams.filterParams: controller.filterKeys,
                          }
                        );
                      },);
                    }
                  )
                ],
              )
            ),
          ),
        );
    });
  }
}

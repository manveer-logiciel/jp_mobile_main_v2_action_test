import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/main_drawer/index.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jobprogress/modules/chats/groups_listing/controller.dart';
import 'package:jobprogress/modules/chats/groups_listing/widgets/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class GroupsListingPage extends StatelessWidget {
  const GroupsListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GroupsListingController>(
      global: false,
      init: GroupsListingController(),
      dispose: (state) async {
        await state.controller!.groupsService.closeStreams(clearDataAlso: false);
      },
      builder: (controller) {
        return JPWillPopScope(
          onWillPop: controller.onWillPop,
          child: JPScaffold(
            scaffoldKey: controller.scaffoldKey,
            backgroundColor: JPAppTheme.themeColors.base,
            endDrawer: controller.canDrawerOpen ? JPMainDrawer(
              selectedRoute: controller.jobId == null ? 'messages_text' : '',
              onRefreshTap: () {},
            ) : null,
            body: GroupsResponsiveView(
              header: JPHeader(
                title: controller.getTitle(),
                onBackPressed: Get.back<void>,
                actions: [

                  /// filter icon
                  if(controller.groupsService.canShowFilterIcon && !JPScreen.isDesktop)
                    Center(
                      child: JPFilterIcon(
                        type: JPFilterIconType.headerAction,
                        onTap: controller.showFilterSheet,
                        isFilterActive: controller.filterUserIds.isNotEmpty,
                      ),
                    ),

                  /// menu icon
                  Center(
                    child: JPTextButton(
                      icon: Icons.menu,
                      color: JPAppTheme.themeColors.base,
                      iconSize: 24,
                      onPressed: () {
                        controller.scaffoldKey.currentState?.openEndDrawer();
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                ],
              ),
              controller: controller,
            ),
            floatingActionButton: controller.groupsService.selectedGroupData == null ? JPButton(
              size: JPButtonSize.floatingButton,
              iconWidget: JPIcon(
                Icons.add,
                color: JPAppTheme.themeColors.base,
              ),
              onPressed: controller.onAddMessage,
            ) : null,
          ),
        );
      },
    );
  }
}

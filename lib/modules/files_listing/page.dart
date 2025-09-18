import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_upload.dart';
import 'package:jobprogress/common/services/files_listing/quick_actions.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/global_widgets/main_drawer/index.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/global_widgets/secondary_drawer/index.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jobprogress/modules/files_listing/controller.dart';
import 'package:jobprogress/modules/files_listing/widgets/index.dart';
import 'package:jobprogress/modules/job/job_summary/secondary_drawer/job_drawer_item_lists.dart';
import 'package:jp_mobile_flutter_ui/animations/scale_and_rotate.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import 'widgets/header_actions.dart';

class FilesListingView extends StatelessWidget {
  const FilesListingView({
    super.key,
    this.refTag,
  });

  final String? refTag;

  String get moduleToUploadType => FilesListingService.moduleTypeToUploadType(Get.arguments?['type']);

  String get controllerTag => refTag ?? moduleToUploadType;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FilesListingController>(
      init: FilesListingController(),
      tag: controllerTag,
      didChangeDependencies: (state) {
        state.controller?.setUpDrawerKeys();
      },
      builder: (FilesListingController controller) {
        return JPWillPopScope(
          onWillPop: () async {
            controller.cancelOnGoingRequest();
            return true;
          },
          child: JPScaffold(
            resizeToAvoidBottomInset: !controller.isPlaceHolderFixed,
            backgroundColor: JPAppTheme.themeColors.base,
            scaffoldKey: controller.scaffoldKey,
            appBar: JPHeader(
            title: controller.getTitle(),
            canShowBackButton: true,
            backIcon: backIcon(controller),
            actions: [
              FilesListingHeaderActions(controller: controller),
              const SizedBox(
                width: 12,
              ),
            ]),
            endDrawer: controller.doShowDrawer ? JPMainDrawer(
              selectedRoute: controller.getSelectedRoute(),
              currentJob: controller.jobModel,
              onRefreshTap: () {
                controller.onRefresh(showLoading: true);
              },
            ): null,
            drawer: controller.doShowSecondaryHeader()
                ? JPSecondaryDrawer(
                    title: 'job_menu'.tr.toUpperCase(),
                    itemList: JobDrawerItemLists().jobSummaryItemList,
                    selectedItemSlug: moduleToUploadType,
                    job: controller.jobModel,
                    tag: controller.jobId.toString(),
                    headerActions: [
                      JPTextButton(
                        icon: Icons.file_upload_outlined,
                        iconSize: 24,
                        onPressed: () {
                          Get.back();
                          controller.uploadFile();
                        },
                      ),
                      JPTextButton(
                        icon: Icons.flip,
                        iconSize: 24,
                        onPressed: () {
                          controller.uploadFile(from: UploadFileFrom.scanner);
                        },
                      )
                    ],
                  )
                : null,
            body: FilesView(
                controller: controller,
                tag: controllerTag,
            ),
            floatingActionButton: addOrUploadButton(controller)
          ),
        );
      },
    );
  }

  Widget backIcon(FilesListingController controller) =>
    JPScaleAndRotateAnim(
     firstChildKey: 'icon1',
     secondChildKey: 'icon2',
     firstChild: IconButton(
      tooltip: 'Back',
      icon: const JPIcon(Icons.arrow_back),
      iconSize: 22,
      splashRadius: 20,
      color: JPAppTheme.themeColors.base,
      onPressed: () {
       controller.cancelOnGoingRequest();
       Get.back();
      },
     ),
     secondChild: IconButton(
      icon: const JPIcon(Icons.close),
      iconSize: 22,
      splashRadius: 20,
      color: JPAppTheme.themeColors.base,
      onPressed: controller.onCancelSelection,
     ),
     forward: !controller.isInSelectionMode,
    );

  Widget? addOrUploadButton(FilesListingController controller) {
   if(controller.isAddOrUploadButtonEnable(controllerTag) || !controller.hasPermissionToManage()) {
    return null;
   } else {
     return JPButton(
      key: const Key(WidgetKeys.addButtonKey),
       onPressed: controller.doShowAddEditButton(controller.type) ? controller.openAddMoreQuickAction : controller.uploadFile,
       iconWidget: JPIcon(
         controller.doShowAddEditButton(controller.type) ? Icons.add : Icons.file_upload_outlined,
         color: JPAppTheme.themeColors.base,
       ),
       disabled: controller.isLoading,
       size: JPButtonSize.floatingButton,
     );
   }
  }
}

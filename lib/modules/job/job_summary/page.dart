import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_upload.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/observer_builder/index.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/global_widgets/secondary_header/index.dart';
import 'package:jobprogress/modules/job/job_summary/secondary_drawer/job_drawer_item_lists.dart';
import 'package:jobprogress/modules/job/job_summary/widgets/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../global_widgets/job_overview_placeholders/header_placeholder.dart';
import '../../../global_widgets/main_drawer/index.dart';
import '../../../global_widgets/safearea/safearea.dart';
import '../../../global_widgets/secondary_drawer/index.dart';
import 'controller.dart';

class JobSummaryView extends StatelessWidget {
  const JobSummaryView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetObserverBuilder<JobSummaryController>(
        global: false,
        init: JobSummaryController(),
        onResume: (controller) {
          controller.refreshPage();
        },
        builder: (controller) {
          return JPScaffold(
            scaffoldKey: controller.scaffoldKey,
            backgroundColor: JPAppTheme.themeColors.inverse,
            appBar: JPHeader(
              onBackPressed: () async {
                Get.back();
            },
            title: controller.job != null ? controller.job!.customer!.fullName! : '',
            titleWidget: controller.job == null && controller.isLoading
                ? const JobOverViewHeaderPlaceHolder()
                : null,
            actions: [
              Center(
                child: JPTextButton(
                  key: const Key(WidgetKeys.mainDrawerMenuKey),
                  icon: Icons.menu,
                  onPressed: () {
                    controller.scaffoldKey.currentState!.openEndDrawer();
                  },
                  color: JPAppTheme.themeColors.base,
                  iconSize: 25,
                ),
                ),
                const SizedBox(
                  width: 8,
                )
              ],
            ),
            endDrawer: JPMainDrawer(
                currentJob: controller.job,
                onRefreshTap: () {
                  controller.refreshPage(showLoading: true);
                }),
            drawer: controller.isLoading ? null : JPSecondaryDrawer(
              title: 'job_menu'.tr.toUpperCase(),
              itemList: JobDrawerItemLists().jobSummaryItemList,
              selectedItemSlug: controller.selectedSlug,
              job: controller.job,
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
            ),
            body: 
            GestureDetector(
              onTap: () => Helper.hideKeyboard(),
              child: JPSafeArea(
                top: false,
                child: Column(
                  children: [

                    if(!controller.isLoading && controller.job == null) ...{
                      const SizedBox(),
                    } else ...{
                      JPSecondaryHeader(
                          customerId: controller.customerId,
                          currentJob: controller.job,
                          onJobPressed: controller.handleChangeJob,
                          onTap: () {
                            controller.scaffoldKey.currentState!.openDrawer();
                          }),
                    },

                    Expanded(
                      child: JobOverView(
                        controller: controller,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: JPButton(
              key: const Key(WidgetKeys.addButtonKey),
              size: JPButtonSize.floatingButton,
              disabled: controller.isLoading,
              iconWidget: JPIcon(
                Icons.add,
                color: JPAppTheme.themeColors.base,
              ),
              onPressed: controller.openAddQuickAction,
            ),
          );
        },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_upload.dart';
import 'package:jobprogress/global_widgets/job_overview_placeholders/header_placeholder.dart';
import 'package:jobprogress/global_widgets/main_drawer/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/global_widgets/secondary_drawer/index.dart';
import 'package:jobprogress/modules/job/job_summary/secondary_drawer/job_drawer_item_lists.dart';
import 'package:jobprogress/modules/work_crew_notes/list_tile/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'controller.dart';

class WorkCrewNotesListingView  extends StatelessWidget{
  const WorkCrewNotesListingView ({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WorkCrewNotesListingController()); 
    return GetBuilder<WorkCrewNotesListingController>(
      tag: controller.controllerTag,
      init: controller,
      builder: (controller) => JPScaffold(
        scaffoldKey: controller.scaffoldKey,
        backgroundColor: JPAppTheme.themeColors.base,
        appBar: JPHeader(
          title: controller.job != null ? controller.job!.customer!.fullName! : '',
          onBackPressed: () {
            Get.back();
          },
          titleWidget: controller.job == null ? const JobOverViewHeaderPlaceHolder() : null,
          actions: [
            controller.isInSelectMode
              ? Center(
                  child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: JPButton(
                    onPressed: controller.onSelectComplete,
                    text: 'done'.tr.toUpperCase(),
                    type: JPButtonType.outline,
                    size: JPButtonSize.extraSmall,
                    textSize: JPTextSize.heading6,
                    textColor: JPAppTheme.themeColors.base,
                    colorType: JPButtonColorType.lightGray,
                  ),
                ))
              : IconButton(
                  splashRadius: 20,
                  onPressed: () {
                    controller.scaffoldKey.currentState!.openEndDrawer();
                  },
                  icon: JPIcon(
                    Icons.menu,
                    color: JPAppTheme.themeColors.base,
                  ),
                )
          ],
        ),
        floatingActionButton:  Visibility(
          visible: controller.doShowFloatingActionButton,
          child: JPButton(
            size: JPButtonSize.floatingButton,
            iconWidget: JPIcon(Icons.add,color: JPAppTheme.themeColors.base,),
            onPressed: (){
              controller.openAddEditNoteDialogBox();
            },
          ),
        ),
        endDrawer: JPMainDrawer(
          selectedRoute: '',
          currentJob: controller.job,
          onRefreshTap: () {
            controller.refreshList(showLoading: true);
          },
        ),
        drawer: JPSecondaryDrawer(
          title: 'job_menu'.tr.toUpperCase(),
          itemList: JobDrawerItemLists().jobSummaryItemList,
          selectedItemSlug: 'work_crew_notes',
          job: controller.job,
          selectedSlugCount: controller.workCrewListOfTotalLength,
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
                  controller.uploadFile(
                      from: UploadFileFrom.scanner
                  );
                },
              )
          ]
        ),
        body: JPSafeArea(
        child: WorkCrewNoteList(
          controller: controller
        ),
       )
      ),
    );
  }
}

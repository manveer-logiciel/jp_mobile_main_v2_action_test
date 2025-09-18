import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/main_drawer/index.dart';
import 'package:jobprogress/global_widgets/no_data_found/index.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jobprogress/modules/uploads/controller.dart';
import 'package:jobprogress/modules/uploads/widgets/list_tile.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../global_widgets/loader/index.dart';

class UploadsListingView extends GetView<UploadsListingController> {
  const UploadsListingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UploadsListingController>(initState: (controllerState) {
      controller.setUpScaffoldKey();
      controller.removeUploadedFiles(isInitialLoad: true);
      },
     builder: (_) {

      final progressCount = controller.getProgressCount();

      return JPWillPopScope(
        onWillPop: controller.removeUploadedFiles,
        child: JPScaffold(
          scaffoldKey: controller.scaffoldKey,
          appBar: JPHeader(
            title: progressCount.isEmpty ? 'uploads'.tr.capitalizeFirst! : '${'uploading'.tr.capitalizeFirst!} ($progressCount)',
            onBackPressed: controller.removeUploadedFiles,
            actions: [
              /// pause all / Resume all
              if (controller.doShowResumePauseBtn)
                Center(
                  child: JPButton(
                    text: controller.isUpdatingAllFilesStatus ?
                    ''  : controller.isAllItemsPaused
                        ? 'resume_all'.tr
                        : 'pause_all'.tr,
                    type: JPButtonType.outline,
                    size: JPButtonSize.extraSmall,
                    colorType: JPButtonColorType.lightGray,
                    onPressed: controller.isAllItemsPaused
                        ? controller.resumeAll
                        : controller.pauseAll,
                    iconWidget: showJPConfirmationLoader(
                        show: controller.isUpdatingAllFilesStatus),
                    disabled: controller.isUpdatingAllFilesStatus,
                  ),
                ),

              const SizedBox(
                width: 14,
              ),
            ],
          ),
          endDrawer: JPMainDrawer(
            selectedRoute: 'uploads',
          ),
          body: controller.filesList.isEmpty
              ? NoDataFound(
                  icon: Icons.file_upload_outlined,
                  title: 'no_file_to_upload'.tr.capitalize,
                )
              : ListView.builder(
                itemCount: controller.filesList.length,
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemBuilder: (_, index) {
                  return AbsorbPointer(
                    absorbing: controller.isUpdatingAllFilesStatus,
                    child: UploadsListTile(
                      data: controller.filesList[index],
                      onTapCancel: () {
                        controller.cancelUpload(index);
                      },
                      onTapFile: () {
                        controller.onTapFile(index);
                      },
                      onChangeFileStatus: () {
                        controller.onChangeFileStatus(index);
                      },
                    ),
                  );
                },
              ),
        ),
      );
    });
  }
}

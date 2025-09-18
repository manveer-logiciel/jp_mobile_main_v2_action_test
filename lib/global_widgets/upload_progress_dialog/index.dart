import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/upload_progress_dialog/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class UploadProgressDialog<T> extends StatelessWidget {

  const UploadProgressDialog({
    super.key,
    required this.paths,
    required this.onAllFilesUploaded,
    this.uploadType
  });

  /// paths is the list of selected items path from local storage
  final List<String> paths;

  /// onAllFilesUploaded is a callback which occurs when all files are uploaded
  final Function(List<T> files) onAllFilesUploaded;

  /// uploadType decides the type of upload dialog is going to perform
  final String? uploadType;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UploadProgressDialogController<T>>(
        init: UploadProgressDialogController(paths, onAllFilesUploaded, uploadType: uploadType),
        global: false,
        builder: (controller) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                borderRadius: BorderRadius.circular(18),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // header
                      Row(
                        children: [
                          JPText(
                            text: 'uploading_files'.tr,
                            fontWeight: JPFontWeight.medium,
                            textSize: JPTextSize.heading3,
                          ),
                          const Spacer(),
                          JPText(
                            text: '${controller.fileNumber} / ${controller.filePaths.length}',
                            fontWeight: JPFontWeight.medium,
                            textSize: JPTextSize.heading4,
                            textColor: JPAppTheme.themeColors.primary,
                          )
                        ],
                      ),
                      // progress bar
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 25,
                            bottom: 20
                        ),
                        child: LinearProgressIndicator(
                          color: JPAppTheme.themeColors.primary,
                          backgroundColor: JPAppTheme.themeColors.lightBlue,
                          value: controller.isFileUploaded ? null : controller.progress,
                        ),
                      ),
                      // cancel button
                      JPButton(
                        text: 'cancel'.tr,
                        size: JPButtonSize.small,
                        colorType: JPButtonColorType.lightGray,
                        onPressed: controller.onCancellingUpload,
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
    );
  }
}

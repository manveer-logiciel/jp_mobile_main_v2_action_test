import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/sql/uploader/file_uploader_params.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../core/constants/file_uploder.dart';
import 'controller.dart';

class UploadFilePopUp extends StatelessWidget {

  const UploadFilePopUp({super.key, required this.params});

  final FileUploaderParams params;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UploadFilePopUpController>(
      init: UploadFilePopUpController(params),
      builder: (controller) {
        return JPSafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8
              ),
              child: Material(
                borderRadius: BorderRadius.circular(18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            JPText(
                              text: "choose_from".tr.toUpperCase(),
                              textSize: JPTextSize.heading3,
                              fontWeight: JPFontWeight.medium,
                            ),
                            JPTextButton(
                              onPressed: () {
                                Get.back();
                              },
                              color: JPAppTheme.themeColors.text,
                              icon: Icons.clear,
                              iconSize: 24,
                            )
                          ]),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    if(controller.params.type == FileUploadType.companyFiles
                        || controller.params.type == FileUploadType.photosAndDocs)
                      getTile(
                          icon: Icons.camera_alt_outlined,
                          description: 'take_a_picture_to_upload'.tr,
                          title: 'camera'.tr,
                          onTap: controller.takePictureAndAddToQueue
                      ),
                    getTile(
                      icon: Icons.photo_outlined,
                      description: 'select_from_jpeg_png_files_to_upload'.tr,
                      title: 'photos'.tr,
                      onTap: controller.pickPhotosAndAddToQueue
                    ),
                    if(!params.onlyShowPhotosOption)
                    getTile(
                        icon: Icons.picture_as_pdf,
                        description: 'select_from_pdf_word_excel_etc_files_to_upload'.tr,
                        title: 'files'.tr.capitalize!,
                        onTap: controller.pickDocsAndAddToQueue
                    ),
                    if(!params.onlyShowPhotosOption)
                    getTile(
                        icon: Icons.document_scanner_outlined,
                        description: 'scan_edit_and_upload_document_on_the_go'.tr,
                        title: 'scan'.tr,
                        onTap: controller.scanDocAndAddToQueue
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              ),
            ),
        );
      }
    );
  }

  Widget getTile({
    required IconData icon,
    required String title,
    required String description,
    VoidCallback? onTap
}) {

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8
        ),
        child: Row(
          children: [
            /// tile icon
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: JPAppTheme.themeColors.lightBlue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: JPIcon(
                icon,
                color: JPAppTheme.themeColors.primary,
              ),
            ),

            const SizedBox(
              width: 16,
            ),

            /// title & subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  JPText(
                    text: title,
                    fontFamily: JPFontFamily.montserrat,
                    fontWeight: JPFontWeight.medium,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  JPText(
                    text: description,
                    textColor: JPAppTheme.themeColors.tertiary,
                    textSize: JPTextSize.heading5,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}

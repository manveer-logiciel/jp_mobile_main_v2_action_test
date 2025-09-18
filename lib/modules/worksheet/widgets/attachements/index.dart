import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/files_listing/forms/worksheet_form/add_worksheet.dart';
import 'package:jobprogress/global_widgets/attachments_detail/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../controller.dart';

class WorksheetAttachments extends StatelessWidget {
  const WorksheetAttachments({
    super.key,
    required this.controller,
  });

  final WorksheetFormController controller;

  WorksheetFormService get service => controller.service;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WorksheetFormController>(
        init: controller,
        global: false,
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 10
            ),
            child: Material(
              color: JPAppTheme.themeColors.base,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 18,
                    ),
                    child: Row(
                      children: [
                        Expanded(child: JPText(
                          text: 'attachments'.tr,
                          fontWeight: JPFontWeight.medium,
                          textAlign: TextAlign.start,
                        )),
                        JPTextButton(
                          icon: Icons.close,
                          iconSize: 24,
                          onPressed: Get.back<void>,
                        ),
                      ],
                    ),
                  ),

                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(
                          bottom: 10
                      ),
                      child: JPAttachmentDetail(
                        titleTextColor: JPAppTheme.themeColors.darkGray,
                        attachments: service.attachments,
                        disabled: false,
                        onTapCancelIcon: service.removeAttachedItem,
                        isEdit: true,
                        openImageInJPPreview: true,
                        removeTitle: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}
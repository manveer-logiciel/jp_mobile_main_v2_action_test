
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/templates/form_proposal/index.dart';
import 'package:jobprogress/global_widgets/attachments_detail/index.dart';
import 'package:jobprogress/modules/files_listing/templates/form_proposal/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class FormProposalAttachments extends StatelessWidget {
  const FormProposalAttachments({
    super.key,
    required this.controller,
  });

  final FormProposalTemplateController controller;

  FormProposalTemplateService? get service => controller.service;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FormProposalTemplateController>(
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
                      attachments: service?.params.attachments ?? [],
                      disabled: false,
                      onTapCancelIcon: service?.removeAttachedItem,
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

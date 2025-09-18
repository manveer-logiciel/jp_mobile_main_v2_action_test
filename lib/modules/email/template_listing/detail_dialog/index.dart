import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/email/template_list.dart';
import 'package:jobprogress/global_widgets/attachments_detail/index.dart';
import 'package:jobprogress/global_widgets/in_app_web_view/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/modules/email/template_listing/detail_dialog/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class EmailTemplateViewDialog extends StatelessWidget {
  final EmailTemplateListingModel data;
  final Function() onSelect;
  final bool showSelectButton;

  const EmailTemplateViewDialog({super.key, required this.data, required this.onSelect, this.showSelectButton = true});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(EmailTemplateViewDialogController());

    return Wrap(
      children: [
        GetBuilder<EmailTemplateViewDialogController>(builder: (_) {
          return Container(
            decoration: BoxDecoration(
              color: JPAppTheme.themeColors.base,
              borderRadius: JPResponsiveDesign.bottomSheetRadius
            ),
            constraints: BoxConstraints(
              maxHeight: JPResponsiveDesign.maxPopOverHeight
            ),
            padding: const EdgeInsets.only(top: 6),
            child: JPSafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20,),
                    child: Column(
                      children: [
                        JPResponsiveBuilder(
                          mobile: Container(
                            height: 4,
                            alignment: Alignment.center,
                            width: 30,
                            color: JPAppTheme.themeColors.inverse,
                          ),
                          tablet: const SizedBox(),
                        ),
                        const SizedBox(height: 10),
                        getHeader(),
                        const SizedBox(height: 15),
                      ],
                    )
                  ),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 10),
                      constraints: BoxConstraints(
                        maxHeight: Get.height * 0.75,
                      ),
                      child: ListView(
                        padding: const EdgeInsets.only(bottom: 15),
                        shrinkWrap: true,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20, right: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if(data.title != null)...{
                                        JPText(text: "title".tr.capitalize!),
                                      const SizedBox(height: 5),
                                      JPText(
                                        text: data.title!,
                                        textColor: JPAppTheme.themeColors.tertiary,
                                        textSize: JPTextSize.heading5,
                                        textAlign: TextAlign.left,
                                      ),
                                      },
                                      if(data.subject?.isNotEmpty ?? false)
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 15),
                                          JPText(text: "subject".tr.capitalize!),
                                          const SizedBox(height: 5),
                                          JPText(
                                            text: data.subject!,
                                            textColor: JPAppTheme.themeColors.tertiary,
                                            textSize: JPTextSize.heading5,
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                      if(data.to?.isNotEmpty ?? false)
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 15),
                                          JPText(text: "to".tr.capitalize!),
                                          const SizedBox(height: 5),
                                          Wrap(
                                            spacing: 0.45,
                                            runSpacing: 5,
                                            children: [
                                              for(int i=0; i<data.to!.length;i++)
                                              JPText(
                                                text:i<data.to!.length-1 ? '${data.to![i]}, ':data.to![i],
                                                textColor: JPAppTheme.themeColors.tertiary,
                                                textSize: JPTextSize.heading5,
                                                textAlign: TextAlign.left,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      if(data.cc?.isNotEmpty ?? false)
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 15),
                                          JPText(text: "cc".tr.capitalize!),
                                          const SizedBox(height: 5),
                                          Wrap(
                                            spacing: 0.45,
                                            runSpacing: 5,
                                            children: [
                                              for(int i=0; i<data.cc!.length;i++)
                                              JPText(
                                                text:i<data.cc!.length-1 ? '${data.cc![i]}, ':data.cc![i],
                                                textColor: JPAppTheme.themeColors.tertiary,
                                                textSize: JPTextSize.heading5,
                                                textAlign: TextAlign.left,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      if(data.bcc?.isNotEmpty ?? false)
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 15),
                                          JPText(text: "bcc".tr.capitalize!),
                                          const SizedBox(height: 5),
                                          Wrap(
                                            spacing: 0.45,
                                            runSpacing: 5,
                                            children: [
                                              for(int i=0; i<data.bcc!.length;i++)
                                              JPText(
                                                text:i<data.bcc!.length-1 ? '${data.bcc![i]}, ':data.bcc![i],
                                                textColor: JPAppTheme.themeColors.tertiary,
                                                textSize: JPTextSize.heading5,
                                                textAlign: TextAlign.left,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 15),
                                      JPText(text: "content".tr.capitalize!),
                                      const SizedBox(height: 5),
                                      AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        height: controller.height,
                                        child: JPInAppWebView(
                                          height: controller.height,
                                          content: data.template!,
                                          callBackForHeight: (htmlHeightFixed) {
                                            controller.height = htmlHeightFixed;
                                            controller.update();
                                          },
                                        )
                                      ),
                                      const SizedBox(height: 15),
                                    ],
                                  ),
                                ),

                                if (data.attachments != null && data.attachments!.isNotEmpty)
                                  JPAttachmentDetail(attachments: data.attachments!, titleText: 'attachments'.tr.capitalize,titleFontWeight: JPFontWeight.regular),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                  getFooter(),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget getFooter() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: JPResponsiveDesign.popOverButtonFlex,
            child: JPButton(
              colorType: JPButtonColorType.lightGray,
                text: "close".tr.toUpperCase(),
              onPressed: () {
                Get.back();
              },
              size: JPButtonSize.small,
            )
          ),
          if(showSelectButton)
            Expanded(
              flex: JPResponsiveDesign.popOverButtonFlex,
              child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: JPButton(
                  text: "select".tr.toUpperCase(),
                onPressed: () {
                  onSelect();
                },
                size: JPButtonSize.small,
              ),
          ),
            )
        ],
      ),
    );
  }

  Widget getHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: JPText(
            text: 'email_template_preview'.tr.toUpperCase(),
            fontWeight: JPFontWeight.medium,
            textSize: JPTextSize.heading3,
            textAlign: TextAlign.left,
          ),
        ),
        Material(
          shape: const CircleBorder(),
          color: JPAppTheme.themeColors.base,
          clipBehavior: Clip.hardEdge,
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints:
                const BoxConstraints(minHeight: 30, minWidth: 30),
            icon: const JPIcon(
              Icons.close,
            ),
            onPressed: () {
              Get.back();
            },
          ),
        )
      ],
    );
  }
}


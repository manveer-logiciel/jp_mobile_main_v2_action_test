import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/templates/form_proposal/template.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class MergeTemplateUnVisitDialog extends StatelessWidget {
  const MergeTemplateUnVisitDialog({
    super.key,
    required this.unVisitedTemplates,
    required this.onTap,
  });

  final List<FormProposalTemplateModel> unVisitedTemplates;
  final Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AlertDialog(
        insetPadding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        contentPadding: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
        content: Builder(
          builder: (context) {
            return Container(
              width: double.maxFinite,
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///   title & cancel button
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        JPText(
                          text: "${"alert".tr.toUpperCase()}!",
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
                        ),
                      ],
                    ),
                  ),

                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        JPText(
                          text: 'unvisited_merge_template_desc'.tr,
                          textAlign: TextAlign.start,
                          height: 1.4,
                          textColor: JPAppTheme.themeColors.tertiary,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Flexible(
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (_, index) {
                              final data = unVisitedTemplates[index];

                              return InkWell(
                                onTap: () {
                                  onTap.call(data.uniqueId);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: JPAppTheme.themeColors.lightBlue,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          child: JPText(
                                            text: (index + 1).toString(),
                                            textColor: JPAppTheme.themeColors.primary,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      Expanded(
                                        child: JPText(
                                          text: data.title ?? "-",
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      JPIcon(
                                        Icons.remove_red_eye_outlined,
                                        color: JPAppTheme.themeColors.darkGray,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (_, index) {
                              return const Divider(
                                thickness: 1,
                                height: 1,
                              );
                            },
                            itemCount: unVisitedTemplates.length,
                          ),
                        ),
                      ],
                    ),
                  ),

                  ///   footer buttons
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: JPResponsiveDesign.popOverButtonFlex,
                            child: JPButton(
                              text: 'cancel'.tr.toUpperCase(),
                              onPressed: Get.back<void>,
                              fontWeight: JPFontWeight.medium,
                              size: JPButtonSize.small,
                              colorType: JPButtonColorType.lightGray,
                              textColor: JPAppTheme.themeColors.tertiary,
                            ),
                          ),
                        ]),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

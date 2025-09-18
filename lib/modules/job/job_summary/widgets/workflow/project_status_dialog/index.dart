
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import 'controller.dart';

class JobOverViewProjectStatusDialog extends StatelessWidget {

  const JobOverViewProjectStatusDialog({
    super.key,
    required this.users,
    required this.onDone,
    required this.parentId,
    required this.stageId
  });

  final List<JPMultiSelectModel> users;

  final Function(bool doRefresh) onDone;

  final int parentId;

  final String stageId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: JPSafeArea(
        child: GetBuilder<JobOverViewProjectStatusDialogController>(
            init: JobOverViewProjectStatusDialogController(users, parentId, stageId),
            global: false,
            builder: (controller) => AlertDialog(
              insetPadding: const EdgeInsets.only(left: 10, right: 10),
              contentPadding: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              content: Builder(
                builder: (context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                          const EdgeInsets.only(bottom: 10),
                          child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                JPText(
                                  text: "update_project_status".tr.toUpperCase(),
                                  textSize: JPTextSize.heading3,
                                  fontWeight: JPFontWeight.medium,
                                ),
                                JPTextButton(
                                  onPressed: () {
                                    Helper.cancelApiRequest();
                                    Get.back();
                                  },
                                  color: JPAppTheme.themeColors.text,
                                  icon: Icons.clear,
                                  iconSize: 24,
                                )
                              ]),
                        ),

                        Flexible(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                /// users filter
                                JPInputBox(
                                  label: "notify_users".tr,
                                  type: JPInputBoxType.withLabel,
                                  fillColor: JPAppTheme.themeColors.base,
                                  readOnly: true,
                                  hintText: 'select'.tr,
                                  controller: controller.usersController,
                                  onPressed: () {
                                    controller.showSelectionSheet();
                                  },
                                  suffixChild: const Padding(
                                    padding: EdgeInsets.only(right: 9),
                                    child: JPIcon(Icons.keyboard_arrow_down),
                                  ),
                                ),

                                const SizedBox(
                                  height: 15,
                                ),

                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    JPText(
                                      text: 'mode'.tr,
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Row(
                                  children: [
                                    JPCheckbox(
                                      text: 'by_email'.tr,
                                      padding: EdgeInsets.zero,
                                      selected: controller.byEmail,
                                      onTap: controller.toggleByEmail,
                                      borderColor: JPAppTheme.themeColors.themeGreen,
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    JPCheckbox(
                                      text: 'by_text'.tr,
                                      padding: EdgeInsets.zero,
                                      selected: controller.byText,
                                      onTap: controller.toggleByText,
                                      borderColor: JPAppTheme.themeColors.themeGreen,
                                    )
                                  ],
                                ),

                                const SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                        ),

                        Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 1,
                                child: JPButton(
                                  text: 'cancel'.toUpperCase(),
                                  onPressed: () {
                                    Get.back();
                                  },
                                  fontWeight: JPFontWeight.medium,
                                  size: JPButtonSize.small,
                                  colorType:
                                  JPButtonColorType.lightGray,
                                  textColor:
                                  JPAppTheme.themeColors.tertiary,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                flex: 1,
                                child: JPButton(
                                  onPressed: () {
                                    controller.updateProjectStatus(onDone);
                                  },
                                  disabled: controller.isLoading,
                                  text: controller.isLoading ? '' : 'move'.tr.toUpperCase(),
                                  fontWeight: JPFontWeight.medium,
                                  size: JPButtonSize.small,
                                  colorType: JPButtonColorType.tertiary,
                                  textColor: JPAppTheme.themeColors.base,
                                  iconWidget: showJPConfirmationLoader(
                                    show: controller.isLoading
                                  ),
                                ),
                              )
                            ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ),
      ),
    );
  }
}

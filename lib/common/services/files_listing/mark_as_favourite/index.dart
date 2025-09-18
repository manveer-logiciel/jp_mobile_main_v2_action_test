import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_quick_action_params.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import 'controller.dart';

class MarkAsFavouriteDialog extends StatelessWidget {

  const MarkAsFavouriteDialog({super.key, required this.fileParams});

  final FilesListingQuickActionParams fileParams;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: JPSafeArea(
        child: GetBuilder<MarkAsFavouriteController>(
            init: MarkAsFavouriteController(fileParams),
            global: false,
            builder: (MarkAsFavouriteController controller) => AlertDialog(
                  scrollable: true,
                  insetPadding: const EdgeInsets.only(left: 10, right: 10),
                  contentPadding: EdgeInsets.zero,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  content: Builder(
                    builder: (context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(
                            right: 16, top: 12, bottom: 16),
                        child: Form(
                          key: controller.formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 20, left: 16),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      JPText(
                                        text: "mark_as_favourite".tr.toUpperCase(),
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
                              if(controller.fileParams.fileList.first.createdBy == AuthService.userDetails?.id)
                                Padding(
                                  padding: const EdgeInsets.only(left: 16, bottom: 10),
                                  child: Row(
                                    children: [
                                      JPText(
                                        text: 'mark_for'.tr,
                                        fontWeight: JPFontWeight.medium,
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        flex: 1,
                                        child: JPRadioBox(
                                          groupValue: !controller.isMarkedByMe,
                                          onChanged: controller.toggleMarkedByMe,
                                          isTextClickable: true,
                                          radioData: [
                                            JPRadioData(
                                                value: false,
                                                label: 'me'.tr,
                                                disabled: controller.isMarkingAsFavourite
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: JPRadioBox(
                                          groupValue: controller.isMarkedByMe,
                                          onChanged: controller.toggleMarkedByMe,
                                          isTextClickable: true,
                                          radioData: [
                                            JPRadioData(
                                                value: false,
                                                label: 'all'.tr,
                                                disabled: controller.isMarkingAsFavourite
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: JPInputBox(
                                  label: 'name'.tr,
                                  isRequired: true,
                                  type: JPInputBoxType.withLabel,
                                  fillColor: JPAppTheme.themeColors.base,
                                  maxLength: 50,
                                  controller: controller.nameController,
                                  onPressed: () {},
                                  validator: (val) =>
                                      controller.validateName(val),
                                  onChanged: (val) {
                                    controller.validateForm();
                                  },
                                ),
                              ),
                              Visibility(
                                visible: !controller.isAllTradesSelected,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 15, left: 16),
                                  child: JPInputBox(
                                    label: "trade_type".tr,
                                    hintText: "select_trade_type".tr,
                                    type: JPInputBoxType.withLabel,
                                    isRequired: true,
                                    fillColor: JPAppTheme.themeColors.base,
                                    controller: controller.tradeTypeController,
                                    readOnly: true,
                                    onPressed: () {
                                      controller.showTradeType();
                                    },
                                    suffixChild: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: JPIcon(
                                        Icons.keyboard_arrow_down_outlined
                                      ),
                                    ),
                                    validator: (val) => controller.validateTradeType(val),
                                    onChanged: (val){ controller.validateForm(); },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 2),
                                child: JPCheckbox(
                                  onTap: (value) {
                                    controller.toggleIsAllTradesSelected();
                                  },
                                  text: 'for_all_trades'.tr,
                                  borderColor: JPAppTheme.themeColors.themeGreen,
                                  selected: controller.isAllTradesSelected,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, left: 16),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: JPResponsiveDesign.popOverButtonFlex,
                                        child: JPButton(
                                          text: 'cancel'.tr.toUpperCase(),
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
                                        flex: JPResponsiveDesign.popOverButtonFlex,
                                        child: JPButton(
                                          onPressed: () {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                            controller.markAsFavourite();
                                          },
                                          text: controller.isMarkingAsFavourite ? '' : 'Save'.tr.toUpperCase(),
                                          fontWeight: JPFontWeight.medium,
                                          size: JPButtonSize.small,
                                          colorType: JPButtonColorType.tertiary,
                                          disabled: controller.isMarkingAsFavourite,
                                          textColor:
                                              JPAppTheme.themeColors.base,
                                          iconWidget: showJPConfirmationLoader(
                                            show: controller.isMarkingAsFavourite
                                          ),
                                        ),
                                      )
                                    ]),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )),
      ),
    );
  }
}

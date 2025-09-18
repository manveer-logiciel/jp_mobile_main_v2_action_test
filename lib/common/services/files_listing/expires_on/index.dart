import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_quick_action_params.dart';
import 'package:jobprogress/common/services/files_listing/expires_on/controller.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ExpireOnDialog extends StatelessWidget {

  const ExpireOnDialog({super.key, required this.fileParams});

  final FilesListingQuickActionParams fileParams;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: JPSafeArea(
        child: GetBuilder<ExpiresOnController>(
            init: ExpiresOnController(fileParams),
            global: false,
            builder: (ExpiresOnController controller) => AlertDialog(
              insetPadding: const EdgeInsets.only(left: 10, right: 10),
              contentPadding: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
              content: Builder(
                builder: (context) {
                  return Container(
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
                            const EdgeInsets.only(bottom: 10, left: 16),
                            child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  JPText(
                                    text: "expires_on".tr.toUpperCase(),
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
                                    Padding(
                                      padding: const EdgeInsets.only(left: 16),
                                      child: JPInputBox(
                                        isRequired: true,
                                        label: 'select_date'.tr,
                                        maxLength: 50,
                                        hintText: 'MM/DD/YYYY',
                                        type: JPInputBoxType.withLabel,
                                        fillColor: JPAppTheme.themeColors.base,
                                        readOnly: true,
                                        controller: controller.expiresOnController,
                                        onPressed: () {
                                          controller.pickDate();
                                        },
                                        validator: (val) =>
                                            controller.validateExpiresOn(val),
                                        onChanged: (val) {
                                          controller.validateForm();
                                        },
                                        suffixChild: controller.doShowResetButton() ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: JPButton(
                                                text: controller.isResettingExpireOn ? "" : 'Reset',
                                                size: JPButtonSize.extraSmall,
                                                onPressed: (){
                                                  controller.reset();
                                                },
                                                disabled: controller.isResettingExpireOn || controller.isUpdatingExpireOnStatus,
                                                iconWidget: showJPConfirmationLoader(
                                                    show: controller.isResettingExpireOn
                                                ),
                                              ),
                                            ),
                                          ],
                                        ) : null,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 16),
                                      child: JPInputBox(
                                        maxLines: 4,
                                        type: JPInputBoxType.withLabel,
                                        fillColor: JPAppTheme.themeColors.base,
                                        label: 'description'.tr,
                                        maxLength: 500,
                                        hintText: 'please_enter_description_here'.tr,
                                        controller: controller.descriptionController,
                                        validator: (val){
                                          return '';
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16
                                      ),
                                      child: JPText(
                                        text: 'expire_on_note'.tr,
                                        textAlign: TextAlign.start,
                                        height: 1.3,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                ),
                              ),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.only(top: 8, left: 16),
                            child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: JPResponsiveDesign.popOverButtonFlex,
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
                                    flex: JPResponsiveDesign.popOverButtonFlex,
                                    child: JPButton(
                                      onPressed: () {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        controller.updateExpiresOn();
                                      },
                                      text: controller.isUpdatingExpireOnStatus ? '' : 'Save'.toUpperCase(),
                                      fontWeight: JPFontWeight.medium,
                                      size: JPButtonSize.small,
                                      colorType: JPButtonColorType.tertiary,
                                      disabled: controller.isResettingExpireOn || controller.isUpdatingExpireOnStatus,
                                      textColor:
                                      JPAppTheme.themeColors.base,
                                      iconWidget: showJPConfirmationLoader(
                                          show: controller.isUpdatingExpireOnStatus
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

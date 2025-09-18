
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'controller.dart';

class SendMessageForm extends StatelessWidget {
  const SendMessageForm({
    super.key,
    this.jobData,
    this.onMessageSent
  });

  final VoidCallback? onMessageSent;
  final JobModel? jobData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Helper.hideKeyboard,
      child: GetBuilder<SendMessageFormController>(
        init: SendMessageFormController(jobData: jobData, onMessageSent: onMessageSent),
        global: false,
        builder: (controller) {
          return JPWillPopScope(
            onWillPop: controller.onWillPop,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10
              ),
              child: Material(
                color: JPAppTheme.themeColors.base,
                borderRadius: JPResponsiveDesign.bottomSheetRadius,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12
                  ),
                  child: JPSafeArea(
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                JPText(
                                  text: "new_message".tr.toUpperCase(),
                                  textSize: JPTextSize.heading3,
                                  fontWeight: JPFontWeight.medium,
                                ),

                                Transform.translate(
                                  offset: const Offset(10, 0),
                                  child: JPTextButton(
                                    isDisabled: controller.isLoading,
                                    onPressed: () {
                                      Get.back();
                                    },
                                    color: JPAppTheme.themeColors.text,
                                    icon: Icons.clear,
                                    iconSize: 24,
                                  ),
                                ),

                              ],
                            ),
                          ),

                          Flexible(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(
                                    height: 5,
                                  ),

                                  JPInputBox(
                                    isRequired: true,
                                    controller: controller.participantsController,
                                    label: 'participants'.tr.capitalizeFirst,
                                    type: JPInputBoxType.withLabel,
                                    disabled: controller.isLoading,
                                    fillColor: JPAppTheme.themeColors.base,
                                    validator: (val) {
                                      return controller.validateParticipants(val);
                                    },
                                    readOnly: true,
                                    suffixChild: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: JPIcon(Icons.person_add_alt, color: JPAppTheme.themeColors.primary, size: 22,),
                                    ),
                                    onPressed: controller.selectParticipants,
                                  ),

                                  const SizedBox(
                                    height: 20,
                                  ),

                                  JPInputBox(
                                    controller: controller.jobController,
                                    label: 'job/project'.tr,
                                    type: JPInputBoxType.withLabelAndClearIcon,
                                    disabled: controller.isLoading,
                                    fillColor: JPAppTheme.themeColors.base,
                                    hintText: 'link_to_job/project'.tr,
                                    readOnly: true,
                                    onChanged: (_) {},
                                    onPressed: controller.selectJob,
                                    onTapSuffix: controller.removeJob,
                                    validator: (_) => null,
                                  ),

                                  const SizedBox(
                                    height: 20,
                                  ),

                                  JPInputBox(
                                    isRequired: true,
                                    controller: controller.messageController,
                                    label: 'message'.tr.capitalizeFirst,
                                    type: JPInputBoxType.withLabel,
                                    disabled: controller.isLoading,
                                    fillColor: JPAppTheme.themeColors.base,
                                    maxLines: 4,
                                    maxLength: 1500,
                                    validator: (val) {
                                      return controller.validateMessage(val);
                                    },
                                  ),

                                  const SizedBox(
                                    height: 10,
                                  ),

                                  Transform.translate(
                                    offset: const Offset(-6, 0),
                                    child: JPCheckbox(
                                      selected: controller.sendAsEmail,
                                      onTap: controller.toggleSendAsEmail,
                                      disabled: controller.isLoading,
                                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                                      text: 'send_a_copy_as_email'.tr,
                                      separatorWidth: 0,
                                      textSize: JPTextSize.heading5,
                                      borderColor: JPAppTheme.themeColors.themeGreen,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ),
                            ),
                          ),


                          const SizedBox(
                            height: 10,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              JPButton(
                                size: JPButtonSize.medium,
                                text: controller.isLoading ? '' : 'send'.tr.toUpperCase(),
                                suffixIconWidget: showJPConfirmationLoader(
                                    show: controller.isLoading
                                ),
                                disabled: controller.isLoading,
                                onPressed: controller.validateFormAndSendMessage,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}

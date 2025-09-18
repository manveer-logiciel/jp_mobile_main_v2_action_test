import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/form_builder/index.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jobprogress/modules/support/controller.dart';
import 'package:jobprogress/modules/support/form/support_attachment.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class SupportForm extends StatelessWidget {
  const SupportForm({super.key, required this.controller});

  final SupportFormController? controller;

  Widget get inputFieldSeparator => SizedBox(height: controller?.formUiHelper.inputVerticalSeparator);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Helper.hideKeyboard,
      child: GetBuilder<SupportFormController>(
        init: controller ?? SupportFormController(),
        global: false,
        builder: (controller){
          return JPWillPopScope(
            onWillPop: controller.onWillPop,
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: controller.formUiHelper.horizontalPadding,
                      vertical: 10,
                    ),
                    child: SizedBox(
                      width: double.maxFinite,
                      child: InkWell(
                        onTap: () => Helper.launchCall('844-562-7764'),
                        child: Row(
                          children: [
                            const JPIcon(Icons.call,size: 16,),
                            const SizedBox(width: 2,),
                            JPText(
                              text: "call_toll_free".tr,
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: JPFormBuilder(
                      title: 'support'.tr.toUpperCase(),
                      onClose: controller.onWillPop,
                      form: Material(
                        color:JPAppTheme.themeColors.base,
                        borderRadius: BorderRadius.circular(controller.formUiHelper.sectionBorderRadius),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: controller.formUiHelper.horizontalPadding,
                            vertical: controller.formUiHelper.verticalPadding,
                          ),
                          child: Form(
                            key: controller.formKey,
                            child: Column(
                              children: [
                                JPInputBox(
                                  inputBoxController: controller.subjectController,
                                  label: 'subject'.tr.capitalize,
                                  type: JPInputBoxType.withLabel,
                                  validator: (value) => controller.validateSubject(value),
                                  fillColor: JPAppTheme.themeColors.base,
                                  onChanged: (val)=>controller.onDataChanged(val),
                                  disabled: controller.isSavingForm,
                                  isRequired: true,
                                ),
                                inputFieldSeparator,
                                JPInputBox(
                                  inputBoxController: controller.messageController,
                                  label: 'your_message'.tr,
                                  maxLines: 5,
                                  maxLength: 31000,
                                  isRequired: true,
                                  type: JPInputBoxType.withLabel,
                                  validator: (value) => controller.validateMessage(value),
                                  onChanged: (val)=>controller.onDataChanged(val),
                                  disabled: controller.isSavingForm,
                                  fillColor: JPAppTheme.themeColors.base,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      footer: controller.attachments.isEmpty ? Container() : SupportAttachmentSection(controller: controller),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: controller.formUiHelper.horizontalPadding,
                      vertical: 10,
                    ),
                    child: SizedBox(
                      width: double.maxFinite,
                      child: JPText(
                        text: "feel_free_to_send_suggestions".tr,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
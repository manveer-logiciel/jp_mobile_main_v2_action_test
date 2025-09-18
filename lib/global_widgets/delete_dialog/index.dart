import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../global_widgets/loader/index.dart';
import '../../../global_widgets/safearea/safearea.dart';
import '../../core/utils/helpers.dart';
import 'controller.dart';

class DeleteDialogWithPassword extends StatelessWidget {
  const   DeleteDialogWithPassword({
    super.key, 
    required this.title,
    required this.actionFrom,
    this.deleteCallback,  
    this.model,
    this.passwordFieldLabel,
    this.noteFieldLabel,
    });

  final dynamic model;
  final String actionFrom;
  final String title;
  final String? passwordFieldLabel;
  final String? noteFieldLabel;
  final void Function(dynamic modal, String action)? deleteCallback;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DeleteDialogController());

    return GestureDetector(
      onTap: () => Helper.hideKeyboard(),
      child: JPSafeArea(
        child: GetBuilder<DeleteDialogController>(
          builder: (_) => AlertDialog(
            scrollable: true,
            insetPadding: const EdgeInsets.all(10),
            contentPadding: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: Builder(builder: (context) {
              return Container(
                width: double.maxFinite,
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///   header
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20,),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            JPText(
                              text: title,
                              textSize: JPTextSize.heading3,
                              fontWeight: JPFontWeight.medium,
                            ),
                            JPTextButton(
                              isDisabled: controller.isDeleteButtonDisabled,
                              onPressed: () => Get.back(),
                              color: JPAppTheme.themeColors.text,
                              icon: Icons.clear,
                              iconSize: 24,
                            )
                          ]
                      ),
                    ),

                    Form(
                      key: controller.deleteFormKey,
                      child: Column(
                        children: [
                          ///   password
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: JPInputBox(
                              key: const Key(WidgetKeys.deleteDialogPassword),
                              isRequired: true,
                              fillColor: JPColor.white,
                              type: JPInputBoxType.withLabel,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: controller.isPasswordVisible,
                              label: passwordFieldLabel ?? "password".tr,
                              readOnly: false,
                              textCapitalization: TextCapitalization.none,
                              onSaved: (val) => controller.password = val,
                              validator: (val) => (val?.isEmpty ?? true) ? "enter_password".tr : "",
                            ),
                          ),
                          ///   note
                          Padding(
                            padding: const EdgeInsets.only(bottom: 25),
                            child: JPInputBox(
                              key: const Key(WidgetKeys.deleteDialogNote),
                              isRequired: true,
                              fillColor: JPColor.white,
                              type: JPInputBoxType.withLabel,
                              label: noteFieldLabel ?? "reason".tr.capitalize,
                              readOnly: false,
                              maxLines: 5,
                              validator: (val) => (val?.trim().isEmpty ?? true) ? "${"please_enter".tr} ${noteFieldLabel?.toLowerCase() ?? "reason".tr}" : "",
                              onSaved: (val) => controller.note = val,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ///   bottom buttons
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: JPResponsiveDesign.popOverButtonFlex,
                            child: JPButton(
                              text: 'cancel'.tr.toUpperCase(),
                              onPressed: () => Get.back(),
                              fontWeight: JPFontWeight.medium,
                              size: JPButtonSize.small,
                              colorType: JPButtonColorType.lightGray,
                              textColor: JPAppTheme.themeColors.tertiary,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            flex: JPResponsiveDesign.popOverButtonFlex,
                            child: JPButton(
                              key: const Key(WidgetKeys.deleteDialogDeleteButton),
                              onPressed: (){
                                controller.delete(
                                  model: model,
                                  deleteCallback: deleteCallback,
                                  actionFrom: actionFrom,
                                  );
                              },
                              text: controller.isDeleteButtonDisabled ? "" : 'delete'.tr.toUpperCase(),
                              fontWeight: JPFontWeight.medium,
                              size: JPButtonSize.small,
                              iconWidget: showJPConfirmationLoader(show: controller.isDeleteButtonDisabled),
                              disabled: controller.isDeleteButtonDisabled,
                              colorType: JPButtonColorType.primary,
                              textColor: JPAppTheme.themeColors.base,
                            ),
                          )
                        ]
                    )
                  ],
                )
              );}
            )
          )
        )
      )
    );
  }
}


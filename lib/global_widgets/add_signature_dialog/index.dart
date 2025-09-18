import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jp_mobile_flutter_ui/DrawingTool/dotted_decoration/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'controller.dart';

class AddViewSignatureDialog extends StatelessWidget {
  const AddViewSignatureDialog({
    super.key,
    required this.viewOnly,
    this.signatureImage,
    this.onAddSignature
  });

  /// viewOnly is to differentiate between view/edit dialog
  final bool viewOnly;

  /// signatureImage is the image to be loaded on view
  final Uint8List? signatureImage;

  /// onAddSignature will returns base64string
  final Function(String)? onAddSignature;

  @override
  Widget build(BuildContext context) {
    return JPSafeArea(
      child: GetBuilder<AddViewSignatureDialogController>(
        init: AddViewSignatureDialogController(onAddSignature),
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
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          JPText(
                            text: viewOnly
                                ? "your_signature".tr.toUpperCase()
                                : "signature".tr.toUpperCase(),
                            textSize: JPTextSize.heading3,
                            fontWeight: JPFontWeight.medium,
                          ),
                          Container(
                            transform: Matrix4.translationValues(6, 0, 0),
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
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      decoration: DottedDecoration(
                          color: JPAppTheme.themeColors.secondaryText,
                          shape: Shape.box,
                          dash: const <int>[4, 5],
                          strokeWidth: 1.5,
                      ),
                      child: viewOnly
                          ? Image.memory(signatureImage!)
                          : RotatedBox(
                              quarterTurns: (Get.height / Get.width) > 1.6 ? 1 : 0,
                              child: AspectRatio(
                                aspectRatio: 1.4,
                                child: Listener(
                                  onPointerDown: (_) {
                                    if (controller.showHint) {
                                      controller.toggleShowHint(false);
                                    }
                                  },
                                  child: Stack(
                                    children: [
                                      JpDrawingTool(
                                        backgroundAspectRatio: 1.4,
                                        controller:
                                            controller.drawingToolController,
                                        onItemTap: (_, __) {},
                                        onTextDrawableCreated: (_) {},
                                        objectWidgetKey: UniqueKey(),
                                      ),
                                      if (controller.showHint)
                                        Center(
                                          child: JPText(
                                            text: 'sign_here'.tr,
                                            textSize: JPTextSize.heading3,
                                            textColor: JPAppTheme
                                                .themeColors.secondaryText,
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    ),

                    if(viewOnly)...{
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: JPResponsiveDesign.popOverButtonFlex,
                                child: JPButton(
                                  text: 'close'.tr.toUpperCase(),
                                  onPressed: Get.back<void>,
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
                                  onPressed: controller.onEdit,
                                  text: 'edit'.tr.toUpperCase(),
                                  fontWeight: JPFontWeight.medium,
                                  size: JPButtonSize.small,
                                  disabled: controller.isLoading,
                                  colorType: JPButtonColorType.primary,
                                  textColor: JPAppTheme.themeColors.base,
                                ),
                              )
                            ]),
                      ),
                    } else...{
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: JPResponsiveDesign.popOverButtonFlex,
                                child: JPButton(
                                  text: 'clear'.tr.toUpperCase(),
                                  onPressed: controller.onClear,
                                  fontWeight: JPFontWeight.medium,
                                  size: JPButtonSize.small,
                                  colorType: JPButtonColorType.lightGray,
                                  textColor: JPAppTheme.themeColors.tertiary,
                                  disabled: controller.isLoading ||
                                      controller.drawingToolController.drawables
                                          .isEmpty,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                flex: JPResponsiveDesign.popOverButtonFlex,
                                child: JPButton(
                                  onPressed: controller.onDone,
                                  text: controller.isLoading
                                      ? ""
                                      : 'done'.tr.toUpperCase(),
                                  fontWeight: JPFontWeight.medium,
                                  size: JPButtonSize.small,
                                  disabled: controller.isLoading,
                                  colorType: JPButtonColorType.primary,
                                  textColor: JPAppTheme.themeColors.base,
                                  iconWidget: showJPConfirmationLoader(
                                      show: controller.isLoading),
                                ),
                              )
                            ]),
                      ),
                    }
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

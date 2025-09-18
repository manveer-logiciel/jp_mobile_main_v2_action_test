import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/extensions/scroll/no_scroll_physics.dart';
import 'package:jobprogress/common/models/address/address.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../search_location/index.dart';
import 'controller.dart';

/// JPFormBuilder helps in building form for screen & bottom sheet
class JPFormBuilder extends StatelessWidget {
  const JPFormBuilder({
    super.key,
    required this.title,
    required this.footer,
    required this.form,
    this.inBottomSheet = false,
    this.isWithMap = false,
    this.isCancelIconVisible = true,
    this.onClose,
    this.initialAddress,
    this.onAddressUpdate, 
    this.backgroundColor,
    this.isClearIconVisible = false,
    this.onClear,
    this.subTitle,
    this.controller, 
    this.titlePadding, 
    this.footerPadding
  });

  /// inBottomSheet helps in differentiating between screen & bottom-sheet ui
  final bool inBottomSheet;

  /// isWithMap helps in differentiating between screen & bottom-sheet ui
  final bool isWithMap;

  /// title is used to display form title
  final String title;

  /// subTitle is used to display form sub title
  final String? subTitle;

  /// isCancelIconVisible is used to hide or show cancel icon
  final bool isCancelIconVisible;

  /// isClearIconVisible is used to hide or show cancel icon
  final bool isClearIconVisible;

  /// footer used to display form submit buttons
  final Widget footer;

  /// form is used to display form itself
  final Widget form;

  /// onClose can be used to override working of close button
  final VoidCallback? onClose;

  /// onClear can be used to override working of clear button
  final VoidCallback? onClear;

  /// initialAddress can be used to initialize map location
  final AddressModel? initialAddress;

  /// onAddressUpdate can be used to get updated map location
  final void Function(AddressModel params, {bool? canUpdateMarker, bool? isPinUpdated})? onAddressUpdate;

  final Color? backgroundColor;

  final JPFormBuilderController? controller;

  final EdgeInsets? titlePadding;

  final EdgeInsets? footerPadding;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JPFormBuilderController>(
      init: controller ?? JPFormBuilderController(initialAddress: initialAddress),
      global: false,
      builder: (controller) {
        return Container(
          constraints: BoxConstraints(maxHeight: inBottomSheet ? Get.height * 0.85 : double.maxFinite,),
          margin: inBottomSheet
              ? EdgeInsets.only(top: Get.mediaQuery.viewPadding.top) : null,
          child: Material(
            color: backgroundColor ?? JPAppTheme.themeColors.inverse,
            borderRadius: JPResponsiveDesign.bottomSheetRadius,
            child: JPSafeArea(
              top: !inBottomSheet,
              bottom: inBottomSheet,
              child: inBottomSheet ? bottomSheetForm : isWithMap
                ? screenFormWithMap(controller)
                : screenForm(controller),
            ),
          ),
        );
      });
  }

  Widget get bottomSheetForm => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          header,
          Flexible(child: SingleChildScrollView(child: form)),
          Padding(
            padding: footerPadding ?? const EdgeInsets.fromLTRB(0, 10, 0, 16),
            child: footer,
          ),
        ],
      );

  Widget screenForm (JPFormBuilderController controller) => ScrollConfiguration(
    behavior: NoScrollPhysics().copyWith(overscroll: false),
    child: SingleChildScrollView(
      physics: isWithMap ? const ClampingScrollPhysics() : const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          form,
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: footer,
          ),
          SizedBox(
            height: Get.mediaQuery.viewPadding.bottom,
          )
        ],
      ),
    ),
  );

  Widget screenFormWithMap(JPFormBuilderController controller) => NestedScrollView(
    physics: const ClampingScrollPhysics(),
    headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => [
      JPCollapsibleMapView(
        initialAddress: initialAddress,
        controller: controller.collapsibleMapController,
        onAddressUpdate: onAddressUpdate,
        mapDragDetector: controller.mapDragDetector,
        isMapScrolling: controller.isListScrolling,
      ),
    ],
    body: screenForm(controller)
  );

  Widget get header => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          JPResponsiveBuilder(
            mobile: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 3,
                  width: 30,
                  margin: const EdgeInsets.only(top: 6),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: JPAppTheme.themeColors.secondaryText),
                )
              ],
            ),
            tablet: const SizedBox(),
          ),
          Padding(
            padding: titlePadding ?? const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: JPText(
                        text: title,
                        textSize: JPTextSize.heading3,
                        fontWeight: JPFontWeight.medium,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Visibility(
                      visible: isClearIconVisible,
                      child: JPButton(
                        onPressed: onClear,
                        type: JPButtonType.outline,
                        colorType: JPButtonColorType.primary,
                        text: 'clear'.tr.toUpperCase(),
                        size: JPButtonSize.extraSmall,
                      ),
                    ),
                    if (isCancelIconVisible)
                      Visibility(
                      visible: isCancelIconVisible,
                      child: JPTextButton(
                        onPressed: onClose ?? () => Get.back(),
                        color: JPAppTheme.themeColors.text,
                        icon: Icons.clear,
                        iconSize: 24,
                      ),
                    ),
                  ],
                ),
                if(subTitle != null) ...{
                  const SizedBox(height: 5,),
                  Align(
                    alignment: Alignment.topLeft,
                    child: JPText(
                      text: subTitle!,
                      textSize: JPTextSize.heading4,
                      textAlign: TextAlign.left,
                      textColor: JPAppTheme.themeColors.tertiary,
                      fontWeight: JPFontWeight.medium,
                      height: 1.3,
                    ),
                  )
                }
              ],
            ),
          ),
        ],
      );
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/filter_dialog_text_type.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../../common/models/home/filter_model.dart';
import '../../../../global_widgets/safearea/safearea.dart';
import '../../home/widgets/filter_dialog/controller.dart';

class FavouriteFilterDialogView extends StatelessWidget {
  const FavouriteFilterDialogView({
    super.key,
    required this.selectedFilters,
    required this.defaultFilters,
    required this.onApply,
  });

  final HomeFilterModel selectedFilters;
  final HomeFilterModel defaultFilters;
  final void Function(HomeFilterModel params) onApply;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: JPSafeArea(
        child: GetBuilder<HomeFilterDialogController>(
            init: HomeFilterDialogController(selectedFilters, defaultFilters),
            global: false,
            builder: (controller) => AlertDialog(
              insetPadding: const EdgeInsets.all(10),
              contentPadding: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
              content: Builder(
                builder: (context) {
                  return Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.zero,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ///   header
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                JPText(
                                  text: "filters".tr.toUpperCase(),
                                  textSize: JPTextSize.heading3,
                                  fontWeight: JPFontWeight.medium,
                                ),
                                JPTextButton(
                                  onPressed: () => Get.back(),
                                  color: JPAppTheme.themeColors.text,
                                  icon: Icons.clear,
                                  iconSize: 24,
                                )
                              ]
                          ),
                        ),
                        ///   body
                        Flexible(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    children: [
                                      ///   trades
                                      Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: JPInputBox(
                                            controller: controller.tradeTextController,
                                            onPressed: () => controller.openMultiSelect(FilterDialogTextType.trades),
                                            type: JPInputBoxType.withLabel,
                                            label: "trades".tr.capitalize,
                                            hintText: "select".tr,
                                            readOnly: true,
                                            fillColor: JPAppTheme.themeColors.base,
                                            suffixChild: const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: JPIcon(Icons.keyboard_arrow_down, size: 18),
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20,),
                              ],
                            ),
                          ),
                        ),
                        ///   bottom buttons
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: JPResponsiveDesign.popOverButtonFlex,
                                  child: JPButton(
                                    text: 'reset'.tr,
                                    onPressed: () {
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      controller.cleanFilterKeys(defaultFilters: defaultFilters);
                                    },
                                    disabled: controller.isResetButtonDisable,
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
                                    onPressed: () => controller.applyFilter(onApply),
                                    text: 'apply'.tr,
                                    fontWeight: JPFontWeight.medium,
                                    size: JPButtonSize.small,
                                    colorType: JPButtonColorType.tertiary,
                                    textColor: JPAppTheme.themeColors.base,
                                  ),
                                )
                              ]
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
        ),
      ),
    );
  }
}

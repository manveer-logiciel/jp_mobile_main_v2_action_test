import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/Label/type.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../common/models/macros/index.dart';
import '../listing/controller.dart';

class MacroListTile extends StatelessWidget {
  final MacroListingModel data;
  final int index;
  final MacroListingController controller;

  const MacroListTile({
    super.key,
    required this.data,
    required this.controller,
    required this.index,
  });

  bool get doShowFixedPrice => data.fixedPrice != null;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        controller.toggleIsChecked(data.isChecked, index);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 0, 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: JPAppTheme.themeColors.lightBlue.withValues(alpha: 0.8),
                ),
                child: Center(
                  child: JPText(
                    textColor: JPAppTheme.themeColors.primary,
                    text: (index + 1).toString(),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 5, bottom: 7),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        width: 1,
                        color: JPAppTheme.themeColors.dimGray,
                        style: BorderStyle.solid),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          JPText(
                            text: data.macroName.toString(),
                            fontWeight: JPFontWeight.medium,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          JPText(
                            text: data.tradeName.toString(),
                            textAlign: TextAlign.left,
                            textSize: JPTextSize.heading5,
                            textColor: JPAppTheme.themeColors.tertiary,
                            overflow: TextOverflow.ellipsis,
                            maxLine: 1,
                          ),
                          if (!Helper.isValueNullOrEmpty(data.branch?.name)) ...{
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                JPText(
                                  text: '${'branch'.tr.capitalize!}: ',
                                  textAlign: TextAlign.left,
                                  textSize: JPTextSize.heading5,
                                  fontWeight: JPFontWeight.medium,
                                  textColor: JPAppTheme.themeColors.tertiary,
                                  overflow: TextOverflow.ellipsis,
                                  maxLine: 1,
                                ),
                                Expanded(
                                  child: JPText(
                                    text: data.branch!.name!,
                                    textAlign: TextAlign.left,
                                    textSize: JPTextSize.heading5,
                                    textColor: JPAppTheme.themeColors.tertiary,
                                    overflow: TextOverflow.ellipsis,
                                    maxLine: 1,
                                  ),
                                ),
                              ],
                            )
                          },
                          const SizedBox(height: 5),
                          if (doShowFixedPrice)
                            JPLabel(
                              text: 'fixed_price'.tr,
                              type: JPLabelType.darkGray,
                              textSize: JPTextSize.heading5,
                            ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        JPCheckbox(
                          key: ValueKey('${WidgetKeys.checkBoxKey}_${data.macroName}'),
                          selected: data.isChecked,
                          separatorWidth: 2,
                          padding: const EdgeInsets.all(4),
                          borderColor: JPAppTheme.themeColors.themeGreen,
                          onTap: (value) {
                            controller.toggleIsChecked(value, index);
                          },
                        ),
                        JPTextButton(
                          icon: Icons.remove_red_eye_outlined,
                          color: JPAppTheme.themeColors.tertiary,
                          highlightColor: JPAppTheme.themeColors.dimGray,
                          iconSize: 22,
                          onPressed:() => controller.navigateToMacroDetails(macroId: data.macroId),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

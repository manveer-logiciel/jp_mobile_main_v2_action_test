import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/worksheet.dart';
import 'package:jobprogress/common/models/worksheet/settings/index.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import 'controller.dart';
import 'sections/percent_amount.dart';

class WorksheetPercentAmountDialog extends StatelessWidget {

  const WorksheetPercentAmountDialog({
    super.key,
    this.subTitle = "",
    this.onUpdate,
    required this.type,
    required this.settingModel,
  });

  final String subTitle;
  final WorksheetSettingModel settingModel;
  final WorksheetPercentAmountDialogType type;
  final VoidCallback? onUpdate;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Helper.hideKeyboard,
      child: JPSafeArea(
        child: GetBuilder<WorksheetPercentAmountController>(
            init: WorksheetPercentAmountController(settingModel, type),
            global: false,
            builder: (WorksheetPercentAmountController controller) => AlertDialog(
              insetPadding: const EdgeInsets.only(left: 10, right: 10),
              contentPadding: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              content: Builder(
                builder: (context) {
                  return Container(
                    padding: const EdgeInsets.only(right: 16, top: 12, bottom: 16),
                    width: double.maxFinite,
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
                                    text: controller.title.toUpperCase(),
                                    textSize: JPTextSize.heading3,
                                    fontWeight: JPFontWeight.medium,
                                  ),
                                  JPTextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    color: JPAppTheme.themeColors.text,
                                    icon: Icons.clear,
                                    iconSize: 24,
                                  )
                                ]),
                          ),

                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 8
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  WorksheetPercentAmountProfitSection(
                                    subTitle: subTitle,
                                    type: type,
                                    controller: controller,
                                  )
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
                                        controller.onUpdate();
                                        if(controller.formKey.currentState?.validate() ?? false) {
                                          onUpdate?.call();
                                        }
                                      },
                                      text: 'update'.toUpperCase(),
                                      fontWeight: JPFontWeight.medium,
                                      size: JPButtonSize.small,
                                      colorType: JPButtonColorType.tertiary,
                                      textColor: JPAppTheme.themeColors.base,
                                    ),
                                  )
                                ],
                            ),
                          )
                        ],
                      ),
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

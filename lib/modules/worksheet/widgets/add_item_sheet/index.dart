import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/forms/worksheet/add_item_params.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/form_builder/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'controller.dart';
import 'widgets/index.dart';

class WorksheetAddItemView extends StatelessWidget {
  const WorksheetAddItemView({
    super.key,
    required this.onSave,
    required this.params
  });

  /// [params] hold the data coming from parent widget
  final WorksheetAddItemParams params;

  /// [onSave] a callback to parent when data item is saved
  final Function(SheetLineItemModel) onSave;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Helper.hideKeyboard,
      child: GetBuilder<WorksheetAddItemController>(
          init: WorksheetAddItemController(params, onSave),
          global: false,
          builder: (controller) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: JPFormBuilder(
              backgroundColor: JPAppTheme.themeColors.base,
              title: controller.title.toUpperCase(),
              inBottomSheet: true,
              isCancelIconVisible: false,
              isClearIconVisible: true,
              onClear: controller.service.clearForm,
              form : Form(
                key: controller.formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: controller.formUiHelper.horizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// fields
                      WorksheetTypeToFields(
                        controller: controller,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              footer: Padding(
                padding: EdgeInsets.symmetric(horizontal: controller.formUiHelper.horizontalPadding),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// cancel button
                      Expanded(
                        flex: JPResponsiveDesign.popOverButtonFlex,
                        child: JPButton(
                          text: 'cancel'.toUpperCase(),
                          onPressed: () => Get.back(),
                          fontWeight: JPFontWeight.medium,
                          size: JPButtonSize.small,
                          colorType: JPButtonColorType.lightGray,
                          textColor: JPAppTheme.themeColors.tertiary,
                        ),
                      ),
                      const SizedBox(width: 15),
                      /// save button
                      Expanded(
                        flex: JPResponsiveDesign.popOverButtonFlex,
                        child: JPButton(
                          onPressed: controller.onTapSave,
                          text: controller.saveButtonText.toUpperCase(),
                          fontWeight: JPFontWeight.medium,
                          size: JPButtonSize.small,
                          colorType: JPButtonColorType.primary,
                          textColor: JPAppTheme.themeColors.base,
                        ),
                      )
                    ]),
              ),
            ),
          )
      ),
    );
  }

}

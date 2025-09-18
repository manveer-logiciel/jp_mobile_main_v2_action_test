import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/templates/table/data.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'controller.dart';
import 'widgets/editor.dart';
import 'widgets/index.dart';

/// [TemplateTableView] displays Template table to update data
/// along with editor for performing individual cell editing
class TemplateTableView extends StatelessWidget {

  const TemplateTableView({
    super.key,
    required this.table,
    required this.onSave,
  });

  /// [table] holds the table data including head, body and foot
  final TemplateFormTableModel table;

  /// [onSave] is a call back which returns HTML data
  final Function(String) onSave;

  @override
  Widget build(BuildContext context) {
    return JPSafeArea(
      child: GetBuilder<TemplateTableController>(
        init: TemplateTableController(table),
        global: false,
        builder: (controller) => GestureDetector(
          onTap: controller.onTapOutside,
          child: AlertDialog(
            insetPadding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            contentPadding: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: Builder(
              builder: (context) {
                return Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///   title & cancel button
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            JPText(
                              text: "update_table".tr.toUpperCase(),
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
                            ),
                          ],
                        ),
                      ),

                      ///   cell editor
                      TemplateTableCellEditor(
                        cell: controller.selectedCell,
                        hiddenVal: controller.hiddenColumnName,
                        onTapTextAlign: controller.selectAlignment,
                        onTapVerticalAlign: controller.selectVerticalAlignment,
                        onTapHide: controller.selectHideColumn,
                      ),

                      ///   table view
                      Flexible(
                        child: TemplateFormTableView(
                          table: table,
                          controller: controller,
                        ),
                      ),

                      ///   footer buttons
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: JPResponsiveDesign.popOverButtonFlex,
                                child: JPButton(
                                  text: 'cancel'.tr.toUpperCase(),
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
                                  onPressed: () {
                                    onSave(controller.getHtml());
                                    Get.back();
                                  },
                                  text: 'update'.tr.toUpperCase(),
                                  fontWeight: JPFontWeight.medium,
                                  size: JPButtonSize.small,
                                  colorType: JPButtonColorType.primary,
                                  textColor: JPAppTheme.themeColors.base,
                                ),
                              )
                            ]),
                      )
                    ],
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

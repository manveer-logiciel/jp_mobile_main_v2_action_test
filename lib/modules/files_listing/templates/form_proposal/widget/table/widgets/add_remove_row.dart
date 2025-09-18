
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/modules/files_listing/templates/form_proposal/widget/table/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class TemplateTableAddRemoveRow extends StatelessWidget {
  const TemplateTableAddRemoveRow({
    super.key,
    required this.controller
  });

  final TemplateTableController controller;

  // remove icon will be displayed only when table body rows are more than one
  bool get canShowRemoveIcon => controller.table.body.length > 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
            left: const BorderSide(),
            right: const BorderSide(),
            bottom: controller.table.foot.isNotEmpty
                ? BorderSide.none
                : const BorderSide(),
          )
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 10
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          JPButton(
            text: 'add_row'.tr,
            fontWeight: JPFontWeight.medium,
            size: JPButtonSize.extraSmall,
            textSize: JPTextSize.heading4,
            onPressed: controller.addRow,
          ),

          if (canShowRemoveIcon) ...{
            const SizedBox(
              width: 8,
            ),
            JPButton(
              text: 'remove_last_row'.tr,
              fontWeight: JPFontWeight.medium,
              size: JPButtonSize.extraSmall,
              colorType: JPButtonColorType.secondary,
              textSize: JPTextSize.heading4,
              onPressed: controller.removeRow,
            ),
          }
        ],
      ),
    );
  }
}

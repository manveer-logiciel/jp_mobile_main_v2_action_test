import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/srs_smart_template/branch_order_history_templates_model.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/expansion_tile/index.dart';
import 'package:jobprogress/modules/srs_smart_template/widgets/list_tile/srs_template_product_tile.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class SRSSmartTemplateTile extends StatelessWidget {
  final BranchOrderHistoryTemplatesModel model;
  final VoidCallback onSelect;
  const SRSSmartTemplateTile({
    super.key,
    required this.model,
    required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return JPExpansionTile(
        spaceBetweenHeaderAndTrailing: 10,
        borderRadius: 10,
        headerPadding: const EdgeInsets.all(10),
        contentPadding: const EdgeInsets.all(10),
        isExpanded: false,
        preserveWidgetOnCollapsed: true,
        header: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: JPText(
                text: model.templateName!.toUpperCase(),
                textAlign: TextAlign.start,
                fontWeight: JPFontWeight.medium,
              ),
            ),
            JPButton(
              text: 'select'.tr,
              onPressed: onSelect,
              size: JPButtonSize.extraSmall,
            ),
          ],
        ),
      trailing: (_) => JPIcon(
        Icons.expand_more,
        color: JPAppTheme.themeColors.secondaryText,
      ),
      children: !Helper.isValueNullOrEmpty(model.templateProducts) ?
      model.templateProducts!.map((model) => SRSTemplateProductTile(model: model)).toList()
          : null
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/sheet_line_item_type.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class SheetLineItemTitle extends StatelessWidget {
  const SheetLineItemTitle({
    super.key,
    required this.itemModel,
  });

  final SheetLineItemModel itemModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 2,left: 7),
      child: JPText(
        text: itemModel.pageType == AddLineItemFormType.billForm 
      ? itemModel.title?.isEmpty ?? true
          ? 'tap_here_to_add_description'.tr
          : (itemModel.title ?? "")
      : Helper.isTrue(itemModel.canShowName)
          ? (itemModel.name ?? "")
          : (itemModel.title ?? ""),
        textSize: JPTextSize.heading5,
        textColor: itemModel.title?.isEmpty ?? true ? JPAppTheme.themeColors.text.withValues(alpha: 0.3) : JPAppTheme.themeColors.text,
        maxLine: 2,
        textAlign: TextAlign.start,
      ),
    );
  }
}
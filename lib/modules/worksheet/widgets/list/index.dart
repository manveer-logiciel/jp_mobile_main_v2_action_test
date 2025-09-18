import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/common/services/files_listing/forms/worksheet_form/add_worksheet.dart';
import 'package:jobprogress/modules/worksheet/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'tier.dart';

class WorksheetItemsList extends StatelessWidget {
  const WorksheetItemsList({
    super.key,
    required this.controller,
    this.lineItems,
    this.bgColor,
    this.parentIndex,
  });

  final WorksheetFormController controller;
  final List<SheetLineItemModel>? lineItems;

  final Color? bgColor;

  final int? parentIndex;

  WorksheetFormService get service => controller.service;

  bool get showTierColor => service.settings?.showTierColor ?? true;

  List<SheetLineItemModel> get lineItemsToUse => lineItems ?? service.lineItems;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Opacity(
        opacity: service.isSavingForm ? 0.6 : 1,
        child: Container(
          color: showTierColor ? (bgColor ?? JPAppTheme.themeColors.primary.withValues(alpha: 0.9)) : null,
          child: ListView.separated(
              shrinkWrap: true,
              primary: false,
              itemBuilder: (_, index) {
                final data = lineItemsToUse[index];
                return WorksheetTierItem(
                  item: data,
                  isFirstItem: index == 0,
                  isLastItem: index == lineItemsToUse.length - 1,
                  service: service,
                  index: parentIndex ?? index,
                  controller: controller,
                );
              },
              separatorBuilder: (_, index) {
                return const SizedBox(
                  height: 5,
                );
              },
              itemCount: lineItemsToUse.length,
          ),
        ),
      ),
    );
  }
}

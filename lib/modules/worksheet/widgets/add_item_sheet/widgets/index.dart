import 'package:flutter/material.dart';
import 'package:jobprogress/common/services/files_listing/forms/worksheet_form/add_item.dart';
import '../controller.dart';
import 'fields/note/index.dart';
import 'fields/description.dart';
import 'fields/name.dart';
import 'fields/price_quantity.dart';
import 'fields/profit.dart';
import 'fields/properties.dart';
import 'fields/supplier.dart';
import 'fields/tax.dart';
import 'fields/total_price.dart';
import 'fields/trade_work_type.dart';
import 'fields/type.dart';

class WorksheetTypeToFields extends StatelessWidget {

  const WorksheetTypeToFields({
    super.key,
    required this.controller
  });

  final WorksheetAddItemController controller;

  WorksheetAddItemService get service => controller.service;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Type field
        if (service.conditionsService.showCategoryField)
          WorksheetAddItemTypeField(controller: controller),
        /// Name field
        WorksheetAddItemNameField(controller: controller),
        /// Supplier field
        if (service.conditionsService.showSupplier)
          WorksheetAddItemSupplierField(controller: controller),
        /// Trade type & work type fields
        WorksheetAddItemTradeField(controller: controller),
        /// Properties field (size, color, style, variant and unit)
        WorksheetAddItemPropertiesField(controller: controller),
        /// Price quantity fields
        WorksheetAddItemPriceQtyField(controller: controller),
        /// Profit percent & Profit amount fields
        if (service.conditionsService.showProfit)
          WorksheetAddItemProfitField(controller: controller),
        /// Ta percent & Tax Amount fields
        if (service.conditionsService.showTax)
          WorksheetAddItemTaxField(controller: controller),
        /// Description field
        WorksheetAddItemDescriptionField(controller: controller),
        /// Add Note field
        if(service.conditionsService.hasProductSupplierBeaconId)
          WorksheetAddItemAddNoteField(controller: controller),
        /// Total price
        WorksheetAddItemTotalPrice(controller: controller),
      ],
    );
  }

}

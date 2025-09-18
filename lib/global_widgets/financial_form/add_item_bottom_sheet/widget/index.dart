import 'package:flutter/material.dart';
import 'package:jobprogress/global_widgets/financial_form/add_item_bottom_sheet/widget/tax_deprec_field.dart';
import 'package:jobprogress/global_widgets/financial_form/add_item_bottom_sheet/widget/unit_field.dart';

import '../../../../common/enums/sheet_line_item_type.dart';
import '../controller.dart';
import 'title_field.dart';
import 'price_qty_field.dart';
import 'taxable_toggle_field.dart';
import 'total_price_field.dart';
import 'trade_field.dart';
import 'work_type_field.dart';

class AddItemBottomSheetFormFields extends StatelessWidget {
  const AddItemBottomSheetFormFields({
    super.key,
    required this.controller,
  });

  final AddItemBottomSheetController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children : getFormFields()
    );
  }

  List<Widget> getFormFields() {
    switch(controller.pageType) {
      case AddLineItemFormType.changeOrderForm:
        return [
          AddItemTitleField(controller: controller),
          AddItemTradeField(controller: controller),
          AddItemWorkTypeField(controller: controller),
          AddItemPriceQtyField(controller: controller),
          if(controller.service.isDefaultTaxable)
           AddItemTaxableToggleField(controller: controller),
          AddItemTotalPriceField(controller: controller)
        ];
      case AddLineItemFormType.insuranceForm:
        return [
          AddItemTitleField(controller: controller),
          AddItemTradeField(controller: controller),
          AddItemPriceQtyField(
            controller: controller, 
            isPriceRequired: false, 
            isQuantityRequired: false
          ),
          AddItemUnitField(controller: controller,),
          AddItemTaxDepreciationField(controller: controller),
        ];
      default:
        return [
          AddItemTitleField(controller: controller),
          AddItemPriceQtyField(controller: controller),
          AddItemTotalPriceField(controller: controller)
        ];
    }
  }
}

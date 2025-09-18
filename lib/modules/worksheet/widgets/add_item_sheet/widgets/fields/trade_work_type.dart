
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/files_listing/forms/worksheet_form/add_item.dart';
import '../../controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class WorksheetAddItemTradeField extends StatelessWidget {

  const WorksheetAddItemTradeField({
    super.key,
    required this.controller
  });

  final WorksheetAddItemController controller;

  WorksheetAddItemService get service => controller.service;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Trades
        Padding(
          padding: EdgeInsets.only(top: controller.formUiHelper.inputVerticalSeparator),
          child: JPInputBox(
              inputBoxController: service.tradeTypeController,
              onPressed: service.selectTrade,
              type: JPInputBoxType.withLabel,
              label: "trade_type".tr.capitalize,
              hintText: "select".tr,
              readOnly: true,
              fillColor: JPAppTheme.themeColors.base,
              disabled: service.conditionsService.disableTradeType,
              suffixChild: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.keyboard_arrow_down, color: JPAppTheme.themeColors.text,),
              )
          ),
        ),

        /// Work types
        if (service.workTypes.isNotEmpty)
          Padding(
          padding: EdgeInsets.only(top: controller.formUiHelper.inputVerticalSeparator),
          child: JPInputBox(
              inputBoxController: service.workTypeController,
              onPressed: service.selectWorkType,
              type: JPInputBoxType.withLabel,
              label: "work_type".tr.capitalize,
              hintText: "select".tr,
              readOnly: true,
              fillColor: JPAppTheme.themeColors.base,
              suffixChild: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.keyboard_arrow_down, color: JPAppTheme.themeColors.text,),
              )
          ),
        )
      ],
    );
  }
}

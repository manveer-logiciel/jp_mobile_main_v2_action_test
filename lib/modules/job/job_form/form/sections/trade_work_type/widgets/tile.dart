
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/forms/job/trades.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jobprogress/global_widgets/add_remove_icon/index.dart';
import 'package:jobprogress/global_widgets/chips_input_box/index.dart';
import 'package:jobprogress/modules/job/job_form/form/sections/trade_work_type/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JobFormTradeWorkTypeTile extends StatelessWidget {
  const JobFormTradeWorkTypeTile({
    super.key,
    required this.data,
    this.isDisabled = false,
    required this.index,
    required this.controller,
    this.hideAddButton = false,
    this.isTradeTypeDisabled = false
  });

  /// [data] holds data of trade fields
  final JobFormTradeWorkTypeData data;

  /// [isDisabled] helps in disabling fields and buttons
  final bool isDisabled;

  /// [index] helps in accessing index
  final int index;

  /// [controller] for interacting with controller functions
  final JobTradeWorkTypeInputsController controller;

  /// [hideAddButton] helps in removing add button
  final bool hideAddButton;

  /// [isTradeTypeDisabled] helps in disabling trade type field
  final bool isTradeTypeDisabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: JPAppTheme.themeColors.dimGray,
          width: 1
        ),
        color: JPAppTheme.themeColors.base
      ),
      child: Column(
        children: [

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///   Trade Type Single select
              Expanded(
                child: JPInputBox(
                  key: Key(data.hashCode.toString()),
                  inputBoxController: data.tradeController,
                  type: JPInputBoxType.withLabel,
                  label: 'trade_type'.tr,
                  fillColor: JPAppTheme.themeColors.base,
                  disabled: isTradeTypeDisabled || isDisabled,
                  isRequired: true,
                  readOnly: true,
                  onPressed: () => controller.selectTrade(data),
                  validator: (val) => FormValidator.requiredFieldValidator(val),
                  onChanged: controller.onDataChanged,
                  suffixChild: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: JPIcon(
                      Icons.keyboard_arrow_down_outlined,
                      color: JPAppTheme.themeColors.text,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 2,
              ),
              ///   Add/Remove Icon
              Padding(
                padding: const EdgeInsets.only(
                  top: 8
                ),
                child: getSuffixIcon(index),
              )
            ],
          ),

          SizedBox(
            height: controller.uiHelper.horizontalPadding,
          ),

          ///   Work Type Multiselect
          JPChipsInputBox(
            controller: controller,
            selectedItems: data.selectedWorkTypes,
            inputBoxController: data.workTypeController,
            label: 'work_type'.tr,
            disabled: isDisabled || data.selectedTradeId.isEmpty,
            readOnly: true,
            onTap: () => controller.selectWorkType(data),
            onDataChanged: controller.onDataChanged,
            onRemove: controller.removeWorkType,
            suffixChild: isDisabled || data.selectedTradeId.isEmpty ? null : Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: controller.uiHelper.horizontalPadding
              ),
              child: JPText(
                text: 'select'.tr.toUpperCase(),
                fontWeight: JPFontWeight.medium,
                textColor: JPAppTheme.themeColors.primary,
                textSize: JPTextSize.heading5,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget getSuffixIcon(int index) {

    final addBtn = FormAddRemoveButton(onTap: controller.addTradeWorkTypeField, isDisabled: isDisabled,);
    final removeBtn = FormAddRemoveButton(
      onTap: () => controller.removeTradeWorkTypeField(index), isDisabled: isDisabled, isAddBtn: false,);

    bool doShowAddBtn = index == controller.tradeWorkTypeList.length - 1 && !hideAddButton;
    bool doShowRemoveBtn = index != 0 && !isTradeTypeDisabled;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if(doShowRemoveBtn) removeBtn,
        if(doShowAddBtn)  addBtn
      ],
    );
  }

}
